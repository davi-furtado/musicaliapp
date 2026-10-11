-- =====================================================================
-- MusicaliAPP - DDL (PostgreSQL 13 ou superior)
--
-- PARTE 1: tabelas, chaves primárias, estrangeiras e únicas.
--          É a parte mais simples e a mais segura para visualizadores.
-- PARTE 2: CHECKs e índices (inclusive de expressão e de busca).
-- PARTE 3: views (dashboard, execuções e rankings).
-- PARTE 4: dados iniciais (instrumentos).
--          Se o visualizador reclamar, apague tudo a partir da
--          linha "PARTE 2".
--
-- Convenções
--  * ids são UUID gerados pelo banco (gen_random_uuid()).
--  * As únicas colunas de data/hora são eventos.data_evento e
--    convites_acesso.expira_em e redefinicoes_senha.expira_em.
--    Não há colunas de criação ou edição.
--  * "versao" é um contador inteiro: a API só grava se a versão que o
--    cliente leu ainda for a atual, e incrementa a cada gravação.
--  * "ordem" é DOUBLE PRECISION: o drag-and-drop grava a média entre
--    os vizinhos e só atualiza uma linha.
--  * Cifras são guardadas em GRAUS do campo harmônico (Nashville
--    Number System: 1 2m 3m 4 5 6m ...). A música não tem tom: o tom só
--    existe em colecao_musicas (setlists e listas).
--  * Valores de enum são VARCHAR validados na PARTE 2:
--      papel:   COORDENADOR | MINISTERIADO | CONVIDADO
--      tipo:    SETLIST | LISTA
--      status:  NAO_OUVI | OUVI | TOQUEI
--  * slugs: minúsculas, números e hífens (ex.: "violao",
--    "missa-de-domingo-2026-10-12").
-- =====================================================================


-- ---------------------------------------------------------------------
-- PARTE 1 - TABELAS
-- ---------------------------------------------------------------------

-- Pessoas. O papel CONVIDADO é de quem entrou por convite de evento:
-- só acessa os eventos listados em eventos_convidados e não tem o campo
-- "ativo" (NULL). Nos demais papéis, ativo = false tira a pessoa da escala
-- dos eventos futuros (feito pela aplicação).
-- is_admin dá acesso à documentação da API (Swagger).
CREATE TABLE usuarios (
    id           UUID         NOT NULL DEFAULT gen_random_uuid(),
    nome         TEXT         NOT NULL,                -- nome completo
    slug         TEXT         NOT NULL,                -- página pública
    senha_hash   TEXT         NOT NULL,
    foto_url     TEXT,                                 -- arquivo no Storage
    papel        VARCHAR(20)  NOT NULL DEFAULT 'MINISTERIADO',
    is_admin     BOOLEAN      NOT NULL DEFAULT FALSE,
    ativo        BOOLEAN      DEFAULT TRUE,            -- NULL só para CONVIDADO
    CONSTRAINT pk_usuarios PRIMARY KEY (id),
    CONSTRAINT uq_usuarios_slug UNIQUE (slug)
);

-- E-mails da conta. Todos têm o mesmo peso (não há e-mail principal).
-- Um e-mail pertence a uma única conta; só serve para entrar ou recuperar
-- a senha depois de verificado.
CREATE TABLE emails_usuario (
    id          UUID     NOT NULL DEFAULT gen_random_uuid(),
    usuario_id  UUID     NOT NULL,
    email       TEXT     NOT NULL,                     -- sempre em minúsculas
    verificado  BOOLEAN  NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_emails_usuario PRIMARY KEY (id),
    CONSTRAINT uq_emails_email UNIQUE (email),
    CONSTRAINT fk_emails_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Pedidos de "esqueci a senha". Só o hash do token é guardado.
-- Vale 30 minutos e serve uma única vez.
CREATE TABLE redefinicoes_senha (
    id          UUID       NOT NULL DEFAULT gen_random_uuid(),
    email_id    UUID       NOT NULL,
    token_hash  TEXT       NOT NULL,
    expira_em   TIMESTAMP  NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '30 minutes'),
    usado       BOOLEAN    NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_redefinicoes_senha PRIMARY KEY (id),
    CONSTRAINT uq_redefinicoes_token UNIQUE (token_hash),
    CONSTRAINT fk_redefinicoes_email FOREIGN KEY (email_id)
        REFERENCES emails_usuario (id) ON DELETE CASCADE
);

-- Catálogo de instrumentos. Cada instrumento tem uma tela própria
-- (/instrumentos/<slug>) com os músicos que o tocam.
CREATE TABLE instrumentos (
    id    UUID  NOT NULL DEFAULT gen_random_uuid(),
    nome  TEXT  NOT NULL,
    slug  TEXT  NOT NULL,   -- nome em minúsculas, sem acento, hífen no lugar de espaço
    CONSTRAINT pk_instrumentos PRIMARY KEY (id),
    CONSTRAINT uq_instrumentos_nome UNIQUE (nome),
    CONSTRAINT uq_instrumentos_slug UNIQUE (slug)
);

-- Quais instrumentos cada pessoa toca (0 ou mais).
-- RESTRICT: instrumento que alguém toca não pode ser apagado.
CREATE TABLE usuarios_instrumentos (
    usuario_id      UUID NOT NULL,
    instrumento_id  UUID NOT NULL,
    CONSTRAINT pk_usuarios_instrumentos PRIMARY KEY (usuario_id, instrumento_id),
    CONSTRAINT fk_ui_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_ui_instrumento FOREIGN KEY (instrumento_id)
        REFERENCES instrumentos (id) ON DELETE RESTRICT
);

CREATE TABLE autores (
    id    UUID  NOT NULL DEFAULT gen_random_uuid(),
    nome  TEXT  NOT NULL,
    slug  TEXT  NOT NULL,   -- página pública
    CONSTRAINT pk_autores PRIMARY KEY (id),
    CONSTRAINT uq_autores_slug UNIQUE (slug)
);

-- A biblioteca de músicas. A cifra fica em graus; a música não guarda
-- tom nem músicos (isso existe só em colecao_musicas e
-- colecao_musicas_musicos).
-- arquivada: some da busca, mas preserva o histórico dos eventos.
CREATE TABLE musicas (
    id                    UUID     NOT NULL DEFAULT gen_random_uuid(),
    titulo                TEXT     NOT NULL,
    autor_id              UUID,
    cifra                 TEXT,                      -- em graus
    link_youtube          TEXT,                      -- opcional
    marcada_para_revisao  BOOLEAN  NOT NULL DEFAULT FALSE,
    arquivada             BOOLEAN  NOT NULL DEFAULT FALSE,
    versao                INTEGER  NOT NULL DEFAULT 1,
    CONSTRAINT pk_musicas PRIMARY KEY (id),
    CONSTRAINT fk_musicas_autor FOREIGN KEY (autor_id)
        REFERENCES autores (id) ON DELETE SET NULL
);

-- "Não ouvi" / "Ouvi" / "Toquei", por pessoa e música.
CREATE TABLE status_escuta (
    id          UUID         NOT NULL DEFAULT gen_random_uuid(),
    usuario_id  UUID         NOT NULL,
    musica_id   UUID         NOT NULL,
    status      VARCHAR(10)  NOT NULL DEFAULT 'NAO_OUVI',
    CONSTRAINT pk_status_escuta PRIMARY KEY (id),
    CONSTRAINT uq_status_usuario_musica UNIQUE (usuario_id, musica_id),
    CONSTRAINT fk_status_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_status_musica FOREIGN KEY (musica_id)
        REFERENCES musicas (id) ON DELETE CASCADE
);

-- Cultos, ensaios, retiros. slug = nome + data (ex.: missa-de-domingo-2026-10-12).
CREATE TABLE eventos (
    id                 UUID       NOT NULL DEFAULT gen_random_uuid(),
    nome               TEXT       NOT NULL,
    slug               TEXT       NOT NULL,
    data_evento        TIMESTAMP  NOT NULL,
    requerir_presenca  BOOLEAN    NOT NULL DEFAULT FALSE,
    cancelado          BOOLEAN    NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_eventos PRIMARY KEY (id),
    CONSTRAINT uq_eventos_slug UNIQUE (slug)
);

-- Eventos a que um CONVIDADO tem acesso.
CREATE TABLE eventos_convidados (
    evento_id   UUID NOT NULL,
    usuario_id  UUID NOT NULL,
    CONSTRAINT pk_eventos_convidados PRIMARY KEY (evento_id, usuario_id),
    CONSTRAINT fk_ec_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE,
    CONSTRAINT fk_ec_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Convites de uso único, válidos por 30 minutos (valor fixo, não
-- personalizável). O papel é o cargo que a pessoa terá ao entrar.
-- Convite de papel CONVIDADO é sempre de um evento (evento_id).
-- Não há e-mail do convidado: o convite é um link.
CREATE TABLE convites_acesso (
    id             UUID         NOT NULL DEFAULT gen_random_uuid(),
    token          TEXT         NOT NULL,
    criado_por_id  UUID         NOT NULL,
    papel          VARCHAR(20)  NOT NULL DEFAULT 'MINISTERIADO',
    evento_id      UUID,
    usado          BOOLEAN      NOT NULL DEFAULT FALSE,
    usado_por_id   UUID,
    expira_em      TIMESTAMP    NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '30 minutes'),
    CONSTRAINT pk_convites_acesso PRIMARY KEY (id),
    CONSTRAINT uq_convites_token UNIQUE (token),
    CONSTRAINT fk_convites_criado_por FOREIGN KEY (criado_por_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_convites_usado_por FOREIGN KEY (usado_por_id)
        REFERENCES usuarios (id) ON DELETE SET NULL,
    CONSTRAINT fk_convites_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE
);

-- Presença por evento x pessoa. confirmou: NULL = ainda não respondeu,
-- TRUE = vou, FALSE = não vou. Pode ser trocada a qualquer momento.
CREATE TABLE confirmacoes_presenca (
    id          UUID     NOT NULL DEFAULT gen_random_uuid(),
    evento_id   UUID     NOT NULL,
    usuario_id  UUID     NOT NULL,
    confirmou   BOOLEAN,
    CONSTRAINT pk_confirmacoes_presenca PRIMARY KEY (id),
    CONSTRAINT uq_confirmacoes_evento_usuario UNIQUE (evento_id, usuario_id),
    CONSTRAINT fk_confirmacoes_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE,
    CONSTRAINT fk_confirmacoes_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Coleção = setlist de evento (tipo SETLIST) ou lista genérica (tipo LISTA).
-- As duas têm seções. publicado = TRUE dispara a notificação push
-- (só SETLIST).
CREATE TABLE colecoes (
    id          UUID         NOT NULL DEFAULT gen_random_uuid(),
    tipo        VARCHAR(10)  NOT NULL,
    evento_id   UUID,                   -- SETLIST
    usuario_id  UUID,                   -- LISTA
    nome        TEXT,                   -- LISTA
    publicado   BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_colecoes PRIMARY KEY (id),
    CONSTRAINT uq_colecoes_evento UNIQUE (evento_id),
    CONSTRAINT fk_colecoes_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE,
    CONSTRAINT fk_colecoes_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

CREATE TABLE secoes (
    id          UUID              NOT NULL DEFAULT gen_random_uuid(),
    colecao_id  UUID              NOT NULL,
    nome        TEXT              NOT NULL,
    ordem       DOUBLE PRECISION  NOT NULL,
    CONSTRAINT pk_secoes PRIMARY KEY (id),
    CONSTRAINT fk_secoes_colecao FOREIGN KEY (colecao_id)
        REFERENCES colecoes (id) ON DELETE CASCADE
);

-- Música dentro da coleção. tom é o tom que será tocado (opcional).
-- cifra NULL = usa a cifra da música; preenchida = cifra só deste setlist
-- ("Salvar só neste setlist"), também em graus.
-- RESTRICT: música usada em setlist ou lista não é apagada (arquive).
CREATE TABLE colecao_musicas (
    id          UUID              NOT NULL DEFAULT gen_random_uuid(),
    colecao_id  UUID              NOT NULL,
    musica_id   UUID              NOT NULL,
    secao_id    UUID,
    tom         TEXT,
    cifra       TEXT,
    ordem       DOUBLE PRECISION  NOT NULL,
    versao      INTEGER           NOT NULL DEFAULT 1,
    CONSTRAINT pk_colecao_musicas PRIMARY KEY (id),
    CONSTRAINT uq_colecao_musicas UNIQUE (colecao_id, musica_id),
    CONSTRAINT fk_cm_colecao FOREIGN KEY (colecao_id)
        REFERENCES colecoes (id) ON DELETE CASCADE,
    CONSTRAINT fk_cm_musica FOREIGN KEY (musica_id)
        REFERENCES musicas (id) ON DELETE RESTRICT,
    CONSTRAINT fk_cm_secao FOREIGN KEY (secao_id)
        REFERENCES secoes (id) ON DELETE SET NULL
);

-- Escala: quem toca cada música. Só existe para coleções SETLIST
-- (regra validada pela API). A escala de uma seção inteira é uma ação em
-- massa que grava aqui, música a música.
CREATE TABLE colecao_musicas_musicos (
    id                 UUID  NOT NULL DEFAULT gen_random_uuid(),
    colecao_musica_id  UUID  NOT NULL,
    usuario_id         UUID  NOT NULL,
    instrumento_id     UUID  NOT NULL,
    CONSTRAINT pk_colecao_musicas_musicos PRIMARY KEY (id),
    CONSTRAINT uq_cmm UNIQUE (colecao_musica_id, usuario_id, instrumento_id),
    CONSTRAINT fk_cmm_colecao_musica FOREIGN KEY (colecao_musica_id)
        REFERENCES colecao_musicas (id) ON DELETE CASCADE,
    CONSTRAINT fk_cmm_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_cmm_instrumento FOREIGN KEY (instrumento_id)
        REFERENCES instrumentos (id) ON DELETE RESTRICT
);

-- Inscrições de Web Push (VAPID).
CREATE TABLE device_tokens (
    id          UUID  NOT NULL DEFAULT gen_random_uuid(),
    usuario_id  UUID  NOT NULL,
    endpoint    TEXT  NOT NULL,
    p256dh      TEXT  NOT NULL,
    auth        TEXT  NOT NULL,
    CONSTRAINT pk_device_tokens PRIMARY KEY (id),
    CONSTRAINT uq_device_tokens_endpoint UNIQUE (endpoint),
    CONSTRAINT fk_device_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);


-- ---------------------------------------------------------------------
-- PARTE 2 - CHECKs E ÍNDICES  (apague daqui para baixo se o visualizador falhar)
-- ---------------------------------------------------------------------

-- Valores permitidos (no lugar de enums).
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_papel
    CHECK (papel IN ('COORDENADOR', 'MINISTERIADO', 'CONVIDADO'));
ALTER TABLE convites_acesso ADD CONSTRAINT ck_convites_papel
    CHECK (papel IN ('COORDENADOR', 'MINISTERIADO', 'CONVIDADO'));
ALTER TABLE status_escuta ADD CONSTRAINT ck_status_escuta
    CHECK (status IN ('NAO_OUVI', 'OUVI', 'TOQUEI'));

-- CONVIDADO não tem "ativo" (NULL) nem é admin; os demais papéis têm "ativo".
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_convidado CHECK (
    (papel = 'CONVIDADO' AND ativo IS NULL AND is_admin = FALSE)
    OR
    (papel <> 'CONVIDADO' AND ativo IS NOT NULL)
);

-- Convite de CONVIDADO exige evento; os outros convites não têm evento.
ALTER TABLE convites_acesso ADD CONSTRAINT ck_convites_evento CHECK (
    (papel = 'CONVIDADO') = (evento_id IS NOT NULL)
);

-- SETLIST exige evento e não tem dono nem nome;
-- LISTA exige dono e nome e não tem evento nem publicação.
ALTER TABLE colecoes ADD CONSTRAINT ck_colecoes_tipo_consistente CHECK (
    (tipo = 'SETLIST' AND evento_id IS NOT NULL AND usuario_id IS NULL AND nome IS NULL)
    OR
    (tipo = 'LISTA' AND evento_id IS NULL AND usuario_id IS NOT NULL AND nome IS NOT NULL
        AND publicado = FALSE)
);

-- E-mail em minúsculas e com formato mínimo (algo@algo).
ALTER TABLE emails_usuario ADD CONSTRAINT ck_emails_formato
    CHECK (email = lower(email) AND email LIKE '%_@_%');

-- Slugs: minúsculas, números e hífens.
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE instrumentos ADD CONSTRAINT ck_instrumentos_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE autores ADD CONSTRAINT ck_autores_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE eventos ADD CONSTRAINT ck_eventos_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');

-- Tom tocado: nota A-G, # ou b opcionais, "m" para menor (D, F#m, Bb).
ALTER TABLE colecao_musicas ADD CONSTRAINT ck_cm_tom
    CHECK (tom IS NULL OR tom ~ '^[A-G][#b]?m?$');

-- Contadores de versão começam em 1.
ALTER TABLE musicas ADD CONSTRAINT ck_musicas_versao CHECK (versao >= 1);
ALTER TABLE colecao_musicas ADD CONSTRAINT ck_cm_versao CHECK (versao >= 1);

-- Instrumento e autor não repetem com outra caixa ("Violão" x "violão").
CREATE UNIQUE INDEX uq_instrumentos_nome_ci ON instrumentos (lower(nome));
CREATE UNIQUE INDEX uq_autores_nome_ci ON autores (lower(nome));

-- Mesma música (título + autor) não é cadastrada duas vezes.
-- Sem autor, o título sozinho é a identidade.
CREATE UNIQUE INDEX uq_musicas_titulo_autor ON musicas (
    lower(titulo),
    COALESCE(autor_id, '00000000-0000-0000-0000-000000000000'::UUID)
);

-- Índices nas chaves estrangeiras (as únicas já cobrem algumas).
CREATE INDEX ix_ui_instrumento ON usuarios_instrumentos (instrumento_id);
CREATE INDEX ix_musicas_autor ON musicas (autor_id);
CREATE INDEX ix_status_musica ON status_escuta (musica_id);
CREATE INDEX ix_eventos_data ON eventos (data_evento);
CREATE INDEX ix_ec_usuario ON eventos_convidados (usuario_id);
CREATE INDEX ix_convites_criado_por ON convites_acesso (criado_por_id);
CREATE INDEX ix_convites_evento ON convites_acesso (evento_id);
CREATE INDEX ix_confirmacoes_usuario ON confirmacoes_presenca (usuario_id);
CREATE INDEX ix_colecoes_usuario ON colecoes (usuario_id);
CREATE INDEX ix_secoes_colecao ON secoes (colecao_id, ordem);
CREATE INDEX ix_cm_colecao_ordem ON colecao_musicas (colecao_id, ordem);
CREATE INDEX ix_cm_musica ON colecao_musicas (musica_id);
CREATE INDEX ix_cm_secao ON colecao_musicas (secao_id);
CREATE INDEX ix_cmm_usuario ON colecao_musicas_musicos (usuario_id);
CREATE INDEX ix_cmm_instrumento ON colecao_musicas_musicos (instrumento_id);
CREATE INDEX ix_device_usuario ON device_tokens (usuario_id);
CREATE INDEX ix_emails_usuario ON emails_usuario (usuario_id);
CREATE INDEX ix_redefinicoes_email ON redefinicoes_senha (email_id);

-- Busca por título aproximado (aviso de música parecida ao cadastrar).
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX ix_musicas_titulo_trgm ON musicas USING gin (titulo gin_trgm_ops);


-- ---------------------------------------------------------------------
-- PARTE 3 - VIEWS
-- ---------------------------------------------------------------------

-- Totais do dashboard. músicos = contas ativas (CONVIDADO não conta);
-- músicas = não arquivadas.
CREATE VIEW vw_dashboard_resumo AS
SELECT
    (SELECT COUNT(*) FROM usuarios WHERE ativo)::INTEGER                       AS total_musicos,
    (SELECT COUNT(*) FROM musicas WHERE NOT arquivada)::INTEGER                AS total_musicas,
    (SELECT COUNT(*) FROM musicas
      WHERE NOT arquivada AND marcada_para_revisao)::INTEGER                   AS total_para_revisao;

-- Músicos ativos por instrumento. Quem toca mais de um instrumento
-- aparece em cada um; instrumentos sem músicos aparecem com 0.
CREATE VIEW vw_dashboard_musicos_por_instrumento AS
SELECT
    i.id                      AS instrumento_id,
    i.nome                    AS instrumento,
    i.slug                    AS instrumento_slug,
    COUNT(u.id)::INTEGER      AS total_musicos
FROM instrumentos i
LEFT JOIN usuarios_instrumentos ui ON ui.instrumento_id = i.id
LEFT JOIN usuarios u ON u.id = ui.usuario_id AND u.ativo
GROUP BY i.id, i.nome, i.slug;

-- Eventos que ainda vão acontecer (a API ordena por data e limita).
CREATE VIEW vw_dashboard_proximos_eventos AS
SELECT id AS evento_id, nome, slug, data_evento
FROM eventos
WHERE NOT cancelado AND data_evento >= CURRENT_TIMESTAMP;

-- Execuções: uma linha por música em setlist publicado de evento que já
-- aconteceu e não foi cancelado. É a base de todos os rankings.
CREATE VIEW vw_execucoes AS
SELECT
    cm.musica_id,
    m.autor_id,
    e.id           AS evento_id,
    e.data_evento
FROM colecao_musicas cm
JOIN colecoes c  ON c.id = cm.colecao_id AND c.tipo = 'SETLIST' AND c.publicado
JOIN eventos e   ON e.id = c.evento_id
                AND NOT e.cancelado
                AND e.data_evento <= CURRENT_TIMESTAMP
JOIN musicas m   ON m.id = cm.musica_id;

-- Última vez que cada música foi tocada.
CREATE VIEW vw_ultima_execucao AS
SELECT musica_id, MAX(data_evento) AS ultima_execucao
FROM vw_execucoes
GROUP BY musica_id;

-- Ranking geral (todos os períodos) de músicas, com 0 para as nunca tocadas.
-- Para mês/ano, a API repete esta consulta filtrando data_evento
-- (ver README).
CREATE VIEW vw_ranking_musicas_geral AS
SELECT
    m.id            AS musica_id,
    m.titulo,
    a.id            AS autor_id,
    a.nome          AS autor,
    COUNT(x.evento_id)::INTEGER AS execucoes
FROM musicas m
LEFT JOIN autores a     ON a.id = m.autor_id
LEFT JOIN vw_execucoes x ON x.musica_id = m.id
WHERE NOT m.arquivada
GROUP BY m.id, m.titulo, a.id, a.nome;

-- Ranking geral de autores: soma das execuções das músicas do autor.
CREATE VIEW vw_ranking_autores_geral AS
SELECT
    a.id    AS autor_id,
    a.nome  AS autor,
    a.slug  AS autor_slug,
    COUNT(x.evento_id)::INTEGER AS execucoes
FROM autores a
LEFT JOIN musicas m      ON m.autor_id = a.id AND NOT m.arquivada
LEFT JOIN vw_execucoes x ON x.musica_id = m.id
GROUP BY a.id, a.nome, a.slug;


-- ---------------------------------------------------------------------
-- PARTE 4 - DADOS INICIAIS
-- ---------------------------------------------------------------------

INSERT INTO instrumentos (nome, slug) VALUES
    ('Voz',        'voz'),
    ('Violão',     'violao'),
    ('Guitarra',   'guitarra'),
    ('Baixo',      'baixo'),
    ('Teclado',    'teclado'),
    ('Bateria',    'bateria'),
    ('Percussão',  'percussao');
