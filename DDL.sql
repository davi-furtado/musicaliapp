-- =====================================================================
-- musicaliapp - DDL (PostgreSQL 13 ou superior)
--
-- PARTE 1: tabelas, chaves primárias, estrangeiras e únicas.
--          É a parte mais simples e a mais segura para visualizadores.
-- PARTE 2: CHECKs e índices (inclusive de expressão e de busca).
-- PARTE 3: views (execuções).
-- PARTE 4: dados iniciais (instrumentos).
--          Se o visualizador reclamar, apague tudo a partir da
--          linha "PARTE 2".
--
-- Convenções
--  * ids são UUID gerados pelo banco (gen_random_uuid()).
--  * Datas: criado_em e atualizado_em nos itens principais (usuários,
--    instrumentos, artistas, músicas, eventos e coleções); atualizado_em é
--    mantido por trigger. Também há eventos.data_evento,
--    usuarios.termos_aceitos_em (aceite dos termos),
--    musica_versoes.criado_em (autor e data de cada versão), convites_acesso.expira_em,
--    codigos_email.expira_em e limites_tentativas.janela_fim.
--    Todas são TIMESTAMPTZ (com fuso); a aplicação calcula dia, mês e ano
--    em America/Sao_Paulo.
--  * "versao" é um contador inteiro: a API só grava se a versão que o
--    cliente leu ainda for a atual, e incrementa a cada gravação.
--  * "ordem" é DOUBLE PRECISION: o drag-and-drop grava a média entre
--    os vizinhos e só atualiza uma linha.
--  * Cifras são guardadas em GRAUS do campo harmônico (Nashville
--    Number System: 1 2m 3m 4 5 6m ...). A música tem tom original opcional, só
--    informativo; o tom tocado existe só em colecao_musicas (setlists e listas).
--  * Valores de enum são VARCHAR validados na PARTE 2:
--      papel:   COORDENADOR | MINISTERIADO | CONVIDADO
--      tipo:    SETLIST | LISTA
--      status:  NAO_OUVI | OUVI | TOQUEI
--  * slugs: minúsculas, números e hífens (ex.: "violao",
--    "2026-10-12-missa-de-domingo"). Acompanham o nome; os anteriores ficam
--    em slugs_antigos para o redirecionamento.
-- =====================================================================


-- ---------------------------------------------------------------------
-- PARTE 1 - TABELAS
-- ---------------------------------------------------------------------

-- Pessoas. O papel CONVIDADO é de quem entrou por convite de evento:
-- vê tudo, mas não edita (só a própria conta, os instrumentos e a presença),
-- e não tem o campo "ativo" (NULL). O acesso do convidado dura enquanto ele
-- estiver em ao menos um evento de eventos_convidados. Nos demais papéis,
-- ativo = false impede a pessoa de editar (feito pela aplicação).
-- A documentação da API (Swagger) é pública, sem login. Coordenadores
-- têm os poderes de coordenação, exceto apagar contas, ver e-mails e mudar nome,
-- foto ou instrumentos de outras pessoas (regras da aplicação).
-- token_versao entra no JWT da sessão: trocar ou redefinir a senha, ou o reset
-- do segundo fator por um coordenador, o incrementa e invalida as sessões
-- anteriores. A senha é guardada como hash scrypt (RN73).
-- Lembrar de mim: o JWT tem exp de 30 dias, renovado a cada acesso (sem tabela de sessões).
CREATE TABLE usuarios (
    id           UUID         NOT NULL DEFAULT gen_random_uuid(),
    nome         TEXT         NOT NULL,                -- nome completo
    slug         TEXT         NOT NULL,                -- página própria
    senha_hash   TEXT         NOT NULL,
    token_versao INTEGER      NOT NULL DEFAULT 1,
    papel        VARCHAR(20)  NOT NULL DEFAULT 'MINISTERIADO',
    ativo        BOOLEAN      DEFAULT TRUE,            -- NULL só para CONVIDADO
    criado_em     TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    termos_versao     TEXT         NOT NULL,                -- versão dos Termos e da Política aceita no cadastro (RN84)
    termos_aceitos_em TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    totp_segredo      TEXT,                                 -- segredo do app autenticador, criptografado (RN103)
    totp_ativo        BOOLEAN      NOT NULL DEFAULT FALSE,  -- segundo fator ligado
    totp_ultimo_passo BIGINT,                               -- último passo de 30 s aceito: um código vale uma vez
    CONSTRAINT pk_usuarios PRIMARY KEY (id),
    CONSTRAINT uq_usuarios_slug UNIQUE (slug)
);

-- Preferências de visualização e exportação de cada pessoa (página de
-- configurações). Valem em qualquer aparelho. Uma linha por usuário, criada
-- na primeira gravação; sem linha, valem os padrões abaixo. Os botões da tela
-- não gravam nada aqui.
CREATE TABLE preferencias_usuario (
    usuario_id             UUID         NOT NULL,
    visualizacao_padrao    VARCHAR(6)   NOT NULL DEFAULT 'CIFRA',   -- CIFRA | LETRA
    letra_com_secoes       BOOLEAN      NOT NULL DEFAULT FALSE,     -- só vale na letra
    fonte_cifra            VARCHAR(8)   NOT NULL DEFAULT 'MEDIA',   -- PEQUENA | MEDIA | GRANDE
    exportacao_padrao      VARCHAR(6)   NOT NULL DEFAULT 'CIFRA',   -- CIFRA | LETRA
    exportacao_com_secoes  BOOLEAN      NOT NULL DEFAULT FALSE,     -- só vale na letra
    graus_formato          VARCHAR(8)   NOT NULL DEFAULT 'NUMEROS', -- NUMEROS | ROMANOS
    modo_reduzido          BOOLEAN      NOT NULL DEFAULT FALSE,     -- modo Reduzido ligado por padrão
    tema                   VARCHAR(10)  NOT NULL DEFAULT 'AUTOMATICO', -- CLARO | ESCURO | AUTOMATICO
    avisar_nao_vou         BOOLEAN      NOT NULL DEFAULT TRUE,      -- só coordenadores recebem o aviso
    CONSTRAINT pk_preferencias_usuario PRIMARY KEY (usuario_id),
    CONSTRAINT fk_pref_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- E-mails de cada pessoa: um principal (obrigatório), onde ela recebe e-mails
-- e códigos, e um de recuperação (opcional), usado se perder o principal.
-- Os dois são únicos no sistema e confirmados por código antes de entrar aqui.
-- Um de cada tipo por conta (uq_emails_usuario_tipo). A aplicação garante que
-- o principal sempre existe, e a integração testa isso.
CREATE TABLE emails_usuario (
    id          UUID     NOT NULL DEFAULT gen_random_uuid(),
    usuario_id  UUID     NOT NULL,
    email       TEXT     NOT NULL,
    tipo        VARCHAR(12) NOT NULL,
    CONSTRAINT pk_emails_usuario PRIMARY KEY (id),
    CONSTRAINT uq_emails_email UNIQUE (email),
    CONSTRAINT uq_emails_usuario_tipo UNIQUE (usuario_id, tipo),
    CONSTRAINT fk_emails_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Vínculo com uma conta Google (login com Google). Uma conta Google liga a
-- uma só conta. google_sub é o identificador estável do Google, não o e-mail.
CREATE TABLE contas_google (
    usuario_id  UUID  NOT NULL,
    google_sub  TEXT  NOT NULL,
    CONSTRAINT pk_contas_google PRIMARY KEY (usuario_id),
    CONSTRAINT uq_contas_google_sub UNIQUE (google_sub),
    CONSTRAINT fk_cg_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Foto de perfil, redimensionada pelo servidor antes de gravar.
-- Fica numa tabela própria para não pesar nas consultas de usuarios.
CREATE TABLE fotos_perfil (
    usuario_id  UUID     NOT NULL,
    conteudo    BYTEA    NOT NULL,
    tipo_mime   VARCHAR(20) NOT NULL,
    CONSTRAINT pk_fotos_perfil PRIMARY KEY (usuario_id),
    CONSTRAINT fk_fotos_perfil_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Códigos de 6 dígitos enviados por e-mail. Só o hash é guardado.
-- CADASTRO: antes de a conta existir (usuario_id NULL); vale também para o
--   primeiro acesso do sistema (RN106).
-- REDEFINICAO: "esqueci a senha".
-- TROCA_EMAIL: a própria pessoa troca o e-mail (o código vai ao novo endereço).
-- EXCLUSAO_CONTA: confirma a exclusão da própria conta (RN104).
-- Valem 15 minutos, contados a partir do envio, e têm contador de tentativas. Servem uma única vez: a
-- linha é apagada ao usar, e a rotina diária apaga as expiradas.
CREATE TABLE codigos_email (
    id           UUID         NOT NULL DEFAULT gen_random_uuid(),
    usuario_id   UUID,
    email        TEXT         NOT NULL,
    finalidade   VARCHAR(16)  NOT NULL,
    codigo_hash  TEXT         NOT NULL,
    expira_em    TIMESTAMPTZ  NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '15 minutes'),
    tentativas   INTEGER      NOT NULL DEFAULT 0,
    CONSTRAINT pk_codigos_email PRIMARY KEY (id),
    CONSTRAINT fk_codigos_email_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Códigos de recuperação, gerados pela própria pessoa e mostrados uma vez.
-- Só o hash é guardado. Cada código serve uma única vez.
CREATE TABLE codigos_recuperacao (
    id           UUID     NOT NULL DEFAULT gen_random_uuid(),
    usuario_id   UUID     NOT NULL,
    codigo_hash  TEXT     NOT NULL,
    usado        BOOLEAN  NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_codigos_recuperacao PRIMARY KEY (id),
    CONSTRAINT fk_codigos_rec_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Códigos de backup do segundo fator (app autenticador): 10 por pessoa,
-- mostrados uma vez, só o hash é guardado, cada um serve uma única vez (RN103).
CREATE TABLE codigos_backup_totp (
    id           UUID     NOT NULL DEFAULT gen_random_uuid(),
    usuario_id   UUID     NOT NULL,
    codigo_hash  TEXT     NOT NULL,
    usado        BOOLEAN  NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_codigos_backup_totp PRIMARY KEY (id),
    CONSTRAINT fk_cbt_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Configurações editáveis em tempo de execução (chave e valor). Hoje guarda a
-- identidade do ministério: ministerio_nome, ministerio_logo (imagem em base64)
-- e ministerio_logo_mime. Na primeira subida, o app grava NOME_MINISTERIO e
-- LOGO_MINISTERIO_PATH do ambiente; depois vale o que os coordenadores salvarem (RN105).
CREATE TABLE configuracoes_app (
    chave  VARCHAR(60)  NOT NULL,
    valor  TEXT         NOT NULL,
    CONSTRAINT pk_configuracoes_app PRIMARY KEY (chave)
);

-- Catálogo de instrumentos. Cada instrumento tem uma tela própria
-- (/instrumentos/<slug>) com os músicos que o tocam.
CREATE TABLE instrumentos (
    id    UUID  NOT NULL DEFAULT gen_random_uuid(),
    nome  TEXT  NOT NULL,
    slug  TEXT  NOT NULL,   -- nome em minúsculas, sem acento, hífen no lugar de espaço
    criado_em     TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
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

-- Artistas: compositores e intérpretes. Cada música tem pelo menos um.
CREATE TABLE artistas (
    id    UUID  NOT NULL DEFAULT gen_random_uuid(),
    nome  TEXT  NOT NULL,
    slug  TEXT  NOT NULL,   -- página própria
    criado_em     TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_artistas PRIMARY KEY (id),
    CONSTRAINT uq_artistas_slug UNIQUE (slug)
);

-- A biblioteca de músicas. A cifra fica em graus. tom_original é opcional
-- e só informativo: não altera a cifra. O tom tocado fica em colecao_musicas.
CREATE TABLE musicas (
    id                    UUID     NOT NULL DEFAULT gen_random_uuid(),
    titulo                TEXT     NOT NULL,
    slug                  TEXT     NOT NULL,          -- artista-titulo, com o 1º artista
    cifra                 TEXT,                      -- em graus
    tom_original          TEXT,                      -- opcional, só informativo
    link_youtube          TEXT,                      -- opcional
    marcada_para_revisao  BOOLEAN  NOT NULL DEFAULT FALSE,
    versao                INTEGER  NOT NULL DEFAULT 1,
    criado_em     TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_musicas PRIMARY KEY (id),
    CONSTRAINT uq_musicas_slug UNIQUE (slug)
);

-- Artistas de cada música. A ordem (posicao) define o 1º artista,
-- que é usado no slug. Uma música tem pelo menos um artista (validado pela API).
CREATE TABLE musica_artistas (
    musica_id   UUID     NOT NULL,
    artista_id  UUID     NOT NULL,
    posicao     INTEGER  NOT NULL,
    CONSTRAINT pk_musica_artistas PRIMARY KEY (musica_id, artista_id),
    CONSTRAINT uq_musica_artistas_posicao UNIQUE (musica_id, posicao),
    CONSTRAINT fk_ma_musica FOREIGN KEY (musica_id)
        REFERENCES musicas (id) ON DELETE CASCADE,
    CONSTRAINT fk_ma_artista FOREIGN KEY (artista_id)
        REFERENCES artistas (id) ON DELETE RESTRICT
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

-- Missas, ensaios, retiros. slug = data ISO + nome (ex.: 2026-10-12-missa-de-domingo).
CREATE TABLE eventos (
    id                 UUID       NOT NULL DEFAULT gen_random_uuid(),
    nome               TEXT       NOT NULL,
    slug               TEXT       NOT NULL,
    data_evento        TIMESTAMPTZ  NOT NULL,
    requerir_presenca  BOOLEAN    NOT NULL DEFAULT FALSE,
    cancelado          BOOLEAN    NOT NULL DEFAULT FALSE,
    criado_em     TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_eventos PRIMARY KEY (id),
    CONSTRAINT uq_eventos_slug UNIQUE (slug)
);

-- Eventos a que um CONVIDADO foi convidado. Ele pode responder à presença
-- só nesses eventos, e o acesso dele ao app dura
-- enquanto houver ao menos um.
CREATE TABLE eventos_convidados (
    evento_id   UUID NOT NULL,
    usuario_id  UUID NOT NULL,
    CONSTRAINT pk_eventos_convidados PRIMARY KEY (evento_id, usuario_id),
    CONSTRAINT fk_ec_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE,
    CONSTRAINT fk_ec_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Convites de uso único, válidos por 7 dias (valor fixo, não
-- personalizável). O papel é o cargo que a pessoa terá ao entrar.
-- Convite de papel CONVIDADO é sempre de um evento (evento_id).
-- Não há e-mail do convidado: o convite é um link.
-- Uso único: a linha é apagada quando o convite é usado (DELETE ... RETURNING,
-- atômico) e a rotina diária apaga as expiradas.
CREATE TABLE convites_acesso (
    id             UUID         NOT NULL DEFAULT gen_random_uuid(),
    token          TEXT         NOT NULL,
    criado_por_id  UUID         NOT NULL,
    papel          VARCHAR(20)  NOT NULL DEFAULT 'MINISTERIADO',
    evento_id      UUID,
    expira_em      TIMESTAMPTZ  NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '7 days'),
    CONSTRAINT pk_convites_acesso PRIMARY KEY (id),
    CONSTRAINT uq_convites_token UNIQUE (token),
    CONSTRAINT fk_convites_criado_por FOREIGN KEY (criado_por_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_convites_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE
);

-- Presença por evento x pessoa. confirmou: NULL = ainda não respondeu,
-- TRUE = vou, FALSE = não vou. Pode ser trocada a qualquer momento.
CREATE TABLE confirmacoes_presenca (
    id          UUID     NOT NULL DEFAULT gen_random_uuid(),
    evento_id   UUID     NOT NULL,
    usuario_id  UUID,                   -- vazio: pessoa removida (RN83)
    confirmou   BOOLEAN,
    CONSTRAINT pk_confirmacoes_presenca PRIMARY KEY (id),
    CONSTRAINT uq_confirmacoes_evento_usuario UNIQUE (evento_id, usuario_id),
    CONSTRAINT fk_confirmacoes_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE,
    CONSTRAINT fk_confirmacoes_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE SET NULL
);

-- Coleção = setlist de evento (tipo SETLIST) ou lista genérica (tipo LISTA).
-- As duas têm seções. publicado = TRUE dispara a notificação push (só SETLIST).
-- Os donos ficam em listas_donos.
CREATE TABLE colecoes (
    id           UUID         NOT NULL DEFAULT gen_random_uuid(),
    tipo         VARCHAR(10)  NOT NULL,
    evento_id    UUID,                   -- SETLIST
    slug         TEXT,                   -- LISTA: primeiro-dono-nome
    nome         TEXT,                   -- LISTA
    publicado    BOOLEAN      NOT NULL DEFAULT FALSE,
    edicao_publica BOOLEAN    NOT NULL DEFAULT FALSE,  -- LISTA: todo usuário ativo edita (RN79)
    criado_em     TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_colecoes PRIMARY KEY (id),
    CONSTRAINT uq_colecoes_evento UNIQUE (evento_id),
    CONSTRAINT uq_colecoes_slug UNIQUE (slug),
    CONSTRAINT ck_colecoes_edicao_publica CHECK (tipo = 'LISTA' OR edicao_publica = FALSE),
    CONSTRAINT fk_colecoes_evento FOREIGN KEY (evento_id)
        REFERENCES eventos (id) ON DELETE CASCADE
);

-- Donos de uma LISTA (zero ou mais). posicao = 1 é o primeiro dono, usado no
-- slug. Lista sem donos é pública (RN79).
CREATE TABLE listas_donos (
    colecao_id  UUID     NOT NULL,
    usuario_id  UUID     NOT NULL,
    posicao     INTEGER  NOT NULL,
    CONSTRAINT pk_listas_donos PRIMARY KEY (colecao_id, usuario_id),
    CONSTRAINT uq_listas_donos_posicao UNIQUE (colecao_id, posicao),
    CONSTRAINT fk_ld_colecao FOREIGN KEY (colecao_id)
        REFERENCES colecoes (id) ON DELETE CASCADE,
    CONSTRAINT fk_ld_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
);

-- Slugs que deixaram de ser usados (por renomeação). A API redireciona a URL
-- antiga para o item atual. Sem FK, porque aponta para tabelas diferentes.
CREATE TABLE slugs_antigos (
    entidade     VARCHAR(12)  NOT NULL,  -- USUARIO, INSTRUMENTO, ARTISTA, EVENTO, MUSICA, LISTA
    slug         TEXT         NOT NULL,
    entidade_id  UUID         NOT NULL,
    CONSTRAINT pk_slugs_antigos PRIMARY KEY (entidade, slug)
);

-- Editores de uma LISTA: pessoas a quem os donos (listas_donos) deram acesso
-- de edição. Os donos editam sem precisar estar aqui.
-- Só vale para coleções do tipo LISTA (validado pela API).
CREATE TABLE listas_acessos (
    colecao_id  UUID NOT NULL,
    usuario_id  UUID NOT NULL,
    CONSTRAINT pk_listas_acessos PRIMARY KEY (colecao_id, usuario_id),
    CONSTRAINT fk_la_colecao FOREIGN KEY (colecao_id)
        REFERENCES colecoes (id) ON DELETE CASCADE,
    CONSTRAINT fk_la_usuario FOREIGN KEY (usuario_id)
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
-- RESTRICT: música usada em setlist ou lista não pode ser apagada.
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

-- Escala por seção: quem toca cada seção do setlist, com o instrumento. Só existe
-- para seções de coleções SETLIST (validado pela API). Não há escala por música.
-- Quem é escalado precisa tocar o instrumento: validado pela API (RN46).
CREATE TABLE secao_musicos (
    id             UUID  NOT NULL DEFAULT gen_random_uuid(),
    secao_id       UUID  NOT NULL,
    usuario_id     UUID,                -- vazio: pessoa removida (RN83)
    instrumento_id UUID  NOT NULL,
    CONSTRAINT pk_secao_musicos PRIMARY KEY (id),
    CONSTRAINT uq_secao_musicos UNIQUE (secao_id, usuario_id, instrumento_id),
    CONSTRAINT fk_secao_musicos_secao FOREIGN KEY (secao_id)
        REFERENCES secoes (id) ON DELETE CASCADE,
    CONSTRAINT fk_secao_musicos_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE SET NULL,
    CONSTRAINT fk_secao_musicos_instrumento FOREIGN KEY (instrumento_id)
        REFERENCES instrumentos (id) ON DELETE RESTRICT
);

-- Escala do evento: as pessoas escaladas para o evento inteiro, com os
-- instrumentos que cada uma toca (sem instrumento próprio). Pode incluir quem
-- não tem instrumento cadastrado. Não preenche as seções. Ao escalar alguém
-- numa seção, a API inclui a pessoa aqui (RN92).
-- Só existe para coleções SETLIST (validado pela API).
CREATE TABLE colecao_musicos (
    id          UUID  NOT NULL DEFAULT gen_random_uuid(),
    colecao_id  UUID  NOT NULL,
    usuario_id  UUID,                -- vazio: pessoa removida (RN83)
    CONSTRAINT pk_colecao_musicos PRIMARY KEY (id),
    CONSTRAINT uq_colecao_musicos UNIQUE (colecao_id, usuario_id),
    CONSTRAINT fk_colecao_musicos_colecao FOREIGN KEY (colecao_id)
        REFERENCES colecoes (id) ON DELETE CASCADE,
    CONSTRAINT fk_colecao_musicos_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE SET NULL
);

-- Histórico da música, como commits. Cada alteração de cifra, tom original,
-- lista de artistas ou tom tocado gera uma versão com título obrigatório, autor
-- e data. Nada é apagado. Restaurar uma versão cria outra no fim do histórico.
--   tipo MUSICA: instantâneo da música (cifra, tom original e artistas em
--     musica_versoes_artistas).
--   tipo TOM_TOCADO: tom tocado de um item de setlist ou lista (colecao_id).
--     tom_tocado NULL significa que o tom tocado foi removido.
-- usuario_id vazio: conta apagada (exibido como "Pessoa removida").
-- restaurada_de: número da versão de origem, quando foi criada por restauração.
-- Fica depois de colecoes, por causa da FK de colecao_id.
CREATE TABLE musica_versoes (
    id             UUID         NOT NULL DEFAULT gen_random_uuid(),
    musica_id      UUID         NOT NULL,
    numero         INTEGER      NOT NULL,
    titulo         TEXT         NOT NULL,
    tipo           VARCHAR(12)  NOT NULL DEFAULT 'MUSICA',
    cifra          TEXT,
    tom_original   TEXT,
    colecao_id     UUID,
    tom_tocado     TEXT,
    usuario_id     UUID,
    restaurada_de  INTEGER,
    criado_em      TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_musica_versoes PRIMARY KEY (id),
    CONSTRAINT uq_musica_versoes_numero UNIQUE (musica_id, numero),
    CONSTRAINT fk_mv_musica FOREIGN KEY (musica_id)
        REFERENCES musicas (id) ON DELETE CASCADE,
    CONSTRAINT fk_mv_colecao FOREIGN KEY (colecao_id)
        REFERENCES colecoes (id) ON DELETE CASCADE,
    CONSTRAINT fk_mv_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE SET NULL
);

-- Artistas da música em cada versão do tipo MUSICA. Guarda a referência ao
-- artista, não o nome: renomear um artista não gera versão.
CREATE TABLE musica_versoes_artistas (
    versao_id   UUID     NOT NULL,
    artista_id  UUID     NOT NULL,
    posicao     INTEGER  NOT NULL,
    CONSTRAINT pk_musica_versoes_artistas PRIMARY KEY (versao_id, artista_id),
    CONSTRAINT uq_mva_posicao UNIQUE (versao_id, posicao),
    CONSTRAINT fk_mva_versao FOREIGN KEY (versao_id)
        REFERENCES musica_versoes (id) ON DELETE CASCADE,
    CONSTRAINT fk_mva_artista FOREIGN KEY (artista_id)
        REFERENCES artistas (id) ON DELETE RESTRICT
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

-- Contador do limite de tentativas (login, convite, códigos). A Vercel não
-- guarda memória entre as requisições, então o contador fica no banco.
-- chave: tipo e HMAC-SHA-256 do IP ou do e-mail, com um segredo do servidor
-- (RATE_LIMIT_SECRET), ex. 'login:ip:9f86d081...' ou 'codigo:email:60303ae2...'.
-- Nunca o IP ou o e-mail puros, nem um hash simples.
-- Se janela_fim já passou, a API recomeça a contagem. A rotina diária apaga
-- as linhas vencidas.
CREATE TABLE limites_tentativas (
    chave       TEXT         NOT NULL,
    tentativas  INTEGER      NOT NULL DEFAULT 1,
    janela_fim  TIMESTAMPTZ  NOT NULL,
    CONSTRAINT pk_limites_tentativas PRIMARY KEY (chave)
);


-- ---------------------------------------------------------------------
-- PARTE 2 - CHECKs E ÍNDICES  (apague daqui para baixo se o visualizador falhar)
-- ---------------------------------------------------------------------

-- Normalização para busca, ordem A-Z e unicidade de nomes: minúsculas e
-- sem acentos ("Coração" vira "coracao"). A API usa esta mesma função nas
-- consultas, para que os índices abaixo sejam aproveitados.
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE FUNCTION busca_norm(texto TEXT) RETURNS TEXT
    LANGUAGE sql IMMUTABLE PARALLEL SAFE STRICT
    AS $$ SELECT lower(unaccent('unaccent', texto)) $$;

-- Histórico: número positivo, título preenchido, tipo coerente e tons válidos.
ALTER TABLE musica_versoes ADD CONSTRAINT ck_mv_numero CHECK (numero >= 1);
ALTER TABLE musica_versoes ADD CONSTRAINT ck_mv_titulo CHECK (length(trim(titulo)) > 0);
ALTER TABLE musica_versoes ADD CONSTRAINT ck_mv_tipo CHECK (
    tipo IN ('MUSICA', 'TOM_TOCADO')
    AND (
        (tipo = 'MUSICA' AND colecao_id IS NULL AND tom_tocado IS NULL)
        OR
        (tipo = 'TOM_TOCADO' AND colecao_id IS NOT NULL AND cifra IS NULL AND tom_original IS NULL)
    )
);
ALTER TABLE musica_versoes ADD CONSTRAINT ck_mv_tom_tocado
    CHECK (tom_tocado IS NULL OR tom_tocado ~ '^[A-G][#b]?m?$');
ALTER TABLE musica_versoes ADD CONSTRAINT ck_mv_tom_original
    CHECK (tom_original IS NULL OR tom_original ~ '^[A-G][#b]?m?$');
ALTER TABLE musica_versoes_artistas ADD CONSTRAINT ck_mva_posicao CHECK (posicao >= 1);
CREATE INDEX ix_mv_usuario ON musica_versoes (usuario_id);
CREATE INDEX ix_mv_colecao ON musica_versoes (colecao_id);
CREATE INDEX ix_mva_artista ON musica_versoes_artistas (artista_id);

-- Preferências: valores permitidos.
ALTER TABLE preferencias_usuario ADD CONSTRAINT ck_pref_visualizacao
    CHECK (visualizacao_padrao IN ('CIFRA', 'LETRA'));
ALTER TABLE preferencias_usuario ADD CONSTRAINT ck_pref_exportacao
    CHECK (exportacao_padrao IN ('CIFRA', 'LETRA'));
ALTER TABLE preferencias_usuario ADD CONSTRAINT ck_pref_fonte
    CHECK (fonte_cifra IN ('PEQUENA', 'MEDIA', 'GRANDE'));
ALTER TABLE preferencias_usuario ADD CONSTRAINT ck_pref_graus_formato
    CHECK (graus_formato IN ('NUMEROS', 'ROMANOS'));
ALTER TABLE preferencias_usuario ADD CONSTRAINT ck_pref_tema
    CHECK (tema IN ('CLARO', 'ESCURO', 'AUTOMATICO'));

-- Tamanho máximo da cifra: 20.000 caracteres (RN102).
ALTER TABLE musicas ADD CONSTRAINT ck_musicas_cifra_tamanho
    CHECK (cifra IS NULL OR char_length(cifra) <= 20000);
ALTER TABLE colecao_musicas ADD CONSTRAINT ck_cm_cifra_tamanho
    CHECK (cifra IS NULL OR char_length(cifra) <= 20000);
ALTER TABLE musica_versoes ADD CONSTRAINT ck_mv_cifra_tamanho
    CHECK (cifra IS NULL OR char_length(cifra) <= 20000);

-- atualizado_em sempre é a data da última gravação.
CREATE FUNCTION set_atualizado_em() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.atualizado_em := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_usuarios_atualizado BEFORE UPDATE ON usuarios FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();

-- ativo: convidado nunca tem o campo (NULL); os demais começam ativos,
-- salvo quando a inserção informa o contrário.
CREATE FUNCTION usuarios_define_ativo() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.papel = 'CONVIDADO' THEN
        NEW.ativo := NULL;
    ELSIF NEW.ativo IS NULL THEN
        NEW.ativo := TRUE;
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_usuarios_define_ativo BEFORE INSERT OR UPDATE OF papel, ativo ON usuarios
    FOR EACH ROW EXECUTE FUNCTION usuarios_define_ativo();
CREATE TRIGGER trg_instrumentos_atualizado BEFORE UPDATE ON instrumentos FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();
CREATE TRIGGER trg_artistas_atualizado BEFORE UPDATE ON artistas FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();
CREATE TRIGGER trg_musicas_atualizado BEFORE UPDATE ON musicas FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();
CREATE TRIGGER trg_eventos_atualizado BEFORE UPDATE ON eventos FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();
CREATE TRIGGER trg_colecoes_atualizado BEFORE UPDATE ON colecoes FOR EACH ROW EXECUTE FUNCTION set_atualizado_em();

-- Música repetida (RN34): mesmo título, sem diferenciar maiúsculas nem acentos,
-- e mesmo conjunto de artistas. Conferida no fim da transação, porque os
-- artistas são gravados depois da música.
CREATE FUNCTION fn_checar_musica_duplicada() RETURNS trigger
    LANGUAGE plpgsql AS $$
DECLARE
    v_musica UUID;
BEGIN
    IF TG_TABLE_NAME = 'musicas' THEN
        v_musica := NEW.id;
    ELSIF TG_OP = 'DELETE' THEN
        v_musica := OLD.musica_id;
    ELSE
        v_musica := NEW.musica_id;
    END IF;
    IF EXISTS (
        SELECT 1
          FROM musicas a
          JOIN musicas b ON b.id <> a.id AND busca_norm(b.titulo) = busca_norm(a.titulo)
         WHERE a.id = v_musica
           AND ARRAY(SELECT artista_id FROM musica_artistas WHERE musica_id = a.id ORDER BY artista_id)
             = ARRAY(SELECT artista_id FROM musica_artistas WHERE musica_id = b.id ORDER BY artista_id)
    ) THEN
        RAISE EXCEPTION 'Já existe uma música com este título e estes artistas'
            USING ERRCODE = 'unique_violation';
    END IF;
    RETURN NULL;
END;
$$;
CREATE CONSTRAINT TRIGGER trg_musicas_duplicada
    AFTER INSERT OR UPDATE OF titulo ON musicas
    DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION fn_checar_musica_duplicada();
CREATE CONSTRAINT TRIGGER trg_musica_artistas_duplicada
    AFTER INSERT OR UPDATE OR DELETE ON musica_artistas
    DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION fn_checar_musica_duplicada();

-- Uma lista com donos não perde o último dono por exclusão direta (RN79).
-- A exclusão em cascata (conta apagada ou lista apagada) é permitida: a lista
-- sem donos passa a ser pública (RN85). pg_trigger_depth() = 1 identifica a
-- exclusão direta.
CREATE FUNCTION fn_manter_um_dono() RETURNS trigger
    LANGUAGE plpgsql AS $$
BEGIN
    IF pg_trigger_depth() = 1
       AND EXISTS (SELECT 1 FROM colecoes WHERE id = OLD.colecao_id)
       AND NOT EXISTS (SELECT 1 FROM listas_donos
                        WHERE colecao_id = OLD.colecao_id AND usuario_id <> OLD.usuario_id) THEN
        RAISE EXCEPTION 'A lista precisa manter ao menos um dono'
            USING ERRCODE = 'check_violation';
    END IF;
    RETURN OLD;
END;
$$;
CREATE TRIGGER trg_listas_donos_ultimo BEFORE DELETE ON listas_donos
    FOR EACH ROW EXECUTE FUNCTION fn_manter_um_dono();

-- Valores permitidos (no lugar de enums).
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_papel
    CHECK (papel IN ('COORDENADOR', 'MINISTERIADO', 'CONVIDADO'));
ALTER TABLE convites_acesso ADD CONSTRAINT ck_convites_papel
    CHECK (papel IN ('COORDENADOR', 'MINISTERIADO', 'CONVIDADO'));
ALTER TABLE status_escuta ADD CONSTRAINT ck_status_escuta
    CHECK (status IN ('NAO_OUVI', 'OUVI', 'TOQUEI'));

-- CONVIDADO não tem "ativo" (NULL); os demais papéis têm "ativo".
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_convidado CHECK (
    (papel = 'CONVIDADO' AND ativo IS NULL)
    OR
    (papel <> 'CONVIDADO' AND ativo IS NOT NULL)
);

-- Convite de CONVIDADO exige evento; os outros convites não têm evento.
ALTER TABLE convites_acesso ADD CONSTRAINT ck_convites_evento CHECK (
    (papel = 'CONVIDADO') = (evento_id IS NOT NULL)
);

-- SETLIST exige evento e não tem nome; LISTA exige nome e não tem evento nem publicação.
ALTER TABLE colecoes ADD CONSTRAINT ck_colecoes_tipo_consistente CHECK (
    (tipo = 'SETLIST' AND evento_id IS NOT NULL AND nome IS NULL)
    OR
    (tipo = 'LISTA' AND evento_id IS NULL AND nome IS NOT NULL AND publicado = FALSE)
);
ALTER TABLE listas_donos ADD CONSTRAINT ck_ld_posicao CHECK (posicao >= 1);
ALTER TABLE slugs_antigos ADD CONSTRAINT ck_slugs_antigos_entidade CHECK (
    entidade IN ('USUARIO', 'INSTRUMENTO', 'ARTISTA', 'EVENTO', 'MUSICA', 'LISTA'));

-- E-mail em minúsculas e com formato mínimo (algo@algo).
ALTER TABLE emails_usuario ADD CONSTRAINT ck_emails_formato
    CHECK (email = lower(email) AND email LIKE '%_@_%');
ALTER TABLE emails_usuario ADD CONSTRAINT ck_emails_tipo
    CHECK (tipo IN ('PRINCIPAL', 'RECUPERACAO'));
ALTER TABLE fotos_perfil ADD CONSTRAINT ck_fotos_tipo
    CHECK (tipo_mime IN ('image/webp', 'image/jpeg'));
ALTER TABLE codigos_email ADD CONSTRAINT ck_codigos_email_formato
    CHECK (email = lower(email) AND email LIKE '%_@_%');
ALTER TABLE codigos_email ADD CONSTRAINT ck_codigos_finalidade CHECK (
    (finalidade = 'CADASTRO' AND usuario_id IS NULL)
    OR
    (finalidade IN ('REDEFINICAO', 'TROCA_EMAIL', 'EXCLUSAO_CONTA') AND usuario_id IS NOT NULL)
);
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_token_versao CHECK (token_versao >= 1);
-- Segundo fator ligado exige segredo; os termos têm versão preenchida.
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_totp CHECK (NOT totp_ativo OR totp_segredo IS NOT NULL);
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_termos_versao CHECK (length(trim(termos_versao)) > 0);
ALTER TABLE configuracoes_app ADD CONSTRAINT ck_configuracoes_chave CHECK (chave ~ '^[a-z0-9_]+$');
CREATE INDEX ix_cbt_usuario ON codigos_backup_totp (usuario_id);

-- Slugs: minúsculas, números e hífens.
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE instrumentos ADD CONSTRAINT ck_instrumentos_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE artistas ADD CONSTRAINT ck_artistas_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE musica_artistas ADD CONSTRAINT ck_ma_posicao CHECK (posicao >= 1);
-- Slugs de música e de lista: minúsculas, números e hífens. Lista tem slug; setlist não.
ALTER TABLE musicas ADD CONSTRAINT ck_musicas_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE colecoes ADD CONSTRAINT ck_colecoes_slug CHECK (
    (tipo = 'LISTA' AND slug IS NOT NULL AND slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$')
    OR
    (tipo = 'SETLIST' AND slug IS NULL)
);
ALTER TABLE eventos ADD CONSTRAINT ck_eventos_slug
    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$');

-- Nomes e títulos não podem ser vazios nem só espaços.
ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_nome CHECK (length(trim(nome)) > 0);
ALTER TABLE instrumentos ADD CONSTRAINT ck_instrumentos_nome CHECK (length(trim(nome)) > 0);
ALTER TABLE artistas ADD CONSTRAINT ck_artistas_nome CHECK (length(trim(nome)) > 0);
ALTER TABLE musicas ADD CONSTRAINT ck_musicas_titulo CHECK (length(trim(titulo)) > 0);
ALTER TABLE eventos ADD CONSTRAINT ck_eventos_nome CHECK (length(trim(nome)) > 0);
ALTER TABLE colecoes ADD CONSTRAINT ck_colecoes_nome CHECK (nome IS NULL OR length(trim(nome)) > 0);
ALTER TABLE secoes ADD CONSTRAINT ck_secoes_nome CHECK (length(trim(nome)) > 0);

-- Link do YouTube: endereço web, quando preenchido.
ALTER TABLE musicas ADD CONSTRAINT ck_musicas_link_youtube
    CHECK (link_youtube IS NULL OR link_youtube ~ '^https?://');

-- Tom tocado: nota A-G, # ou b opcionais, "m" para menor (D, F#m, Bb).
ALTER TABLE colecao_musicas ADD CONSTRAINT ck_cm_tom
    CHECK (tom IS NULL OR tom ~ '^[A-G][#b]?m?$');
ALTER TABLE musicas ADD CONSTRAINT ck_musicas_tom_original
    CHECK (tom_original IS NULL OR tom_original ~ '^[A-G][#b]?m?$');

-- Contadores de versão começam em 1.
ALTER TABLE musicas ADD CONSTRAINT ck_musicas_versao CHECK (versao >= 1);
ALTER TABLE colecao_musicas ADD CONSTRAINT ck_cm_versao CHECK (versao >= 1);

-- Instrumento e artista não repetem com outra caixa ou outro acento
-- ("Violão" x "violao", "José" x "jose").
CREATE UNIQUE INDEX uq_instrumentos_nome_ci ON instrumentos (busca_norm(nome));
CREATE UNIQUE INDEX uq_artistas_nome_ci ON artistas (busca_norm(nome));

-- Índices nas chaves estrangeiras (as únicas já cobrem algumas).
CREATE INDEX ix_ui_instrumento ON usuarios_instrumentos (instrumento_id);
CREATE INDEX ix_ma_artista ON musica_artistas (artista_id);
CREATE INDEX ix_status_musica ON status_escuta (musica_id);
CREATE INDEX ix_eventos_data ON eventos (data_evento);
CREATE INDEX ix_ec_usuario ON eventos_convidados (usuario_id);
CREATE INDEX ix_convites_criado_por ON convites_acesso (criado_por_id);
CREATE INDEX ix_convites_evento ON convites_acesso (evento_id);
CREATE INDEX ix_confirmacoes_usuario ON confirmacoes_presenca (usuario_id);
CREATE INDEX ix_ld_usuario ON listas_donos (usuario_id);
CREATE INDEX ix_la_usuario ON listas_acessos (usuario_id);
CREATE INDEX ix_secoes_colecao ON secoes (colecao_id, ordem);
CREATE INDEX ix_cm_colecao_ordem ON colecao_musicas (colecao_id, ordem);
CREATE INDEX ix_cm_musica ON colecao_musicas (musica_id);
CREATE INDEX ix_cm_secao ON colecao_musicas (secao_id);
CREATE INDEX ix_secao_musicos_usuario ON secao_musicos (usuario_id);
CREATE INDEX ix_secao_musicos_instrumento ON secao_musicos (instrumento_id);
CREATE INDEX ix_colecao_musicos_usuario ON colecao_musicos (usuario_id);
CREATE INDEX ix_device_usuario ON device_tokens (usuario_id);
CREATE INDEX ix_codigos_email_usuario ON codigos_email (usuario_id);
CREATE INDEX ix_codigos_email_email ON codigos_email (email);
CREATE INDEX ix_codigos_rec_usuario ON codigos_recuperacao (usuario_id);

-- Busca por trechos do título e do nome do artista, sem acento e sem
-- diferenciar maiúsculas, e aviso de música parecida ao cadastrar.
CREATE INDEX ix_musicas_titulo_trgm ON musicas USING gin (busca_norm(titulo) gin_trgm_ops);
CREATE INDEX ix_artistas_nome_trgm ON artistas USING gin (busca_norm(nome) gin_trgm_ops);


-- ---------------------------------------------------------------------
-- PARTE 3 - VIEWS
-- ---------------------------------------------------------------------

-- Os números do dashboard (músicos, músicas, para revisão, músicos por
-- instrumento e próximos eventos) são consultas simples feitas pela API.
-- Aqui ficam só as views usadas por mais de uma consulta.

-- Execuções: uma linha por música em setlist publicado de evento que já
-- aconteceu e não foi cancelado. É a base de todas as contagens de
-- músicas e artistas tocados.
CREATE VIEW vw_execucoes AS
SELECT
    cm.musica_id,
    e.id           AS evento_id,
    e.data_evento
FROM colecao_musicas cm
JOIN colecoes c  ON c.id = cm.colecao_id AND c.tipo = 'SETLIST' AND c.publicado
JOIN eventos e   ON e.id = c.evento_id
                AND NOT e.cancelado
                AND e.data_evento <= CURRENT_TIMESTAMP;

-- Última vez que cada música foi tocada.
CREATE VIEW vw_ultima_execucao AS
SELECT musica_id, MAX(data_evento) AS ultima_execucao
FROM vw_execucoes
GROUP BY musica_id;


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
    ('Cajón',      'cajon');
