# URLs, busca e API

## Esquema de URLs

### Regras gerais

- Todas as rotas exigem sessão, exceto as de `/auth/*`, o `/primeiro-acesso` (só enquanto não há contas) e o `GET /api/publico/ministerio` e o `GET /api/saude`. Sem sessão, a pessoa vai para `/auth/login?voltar=<caminho>` e, depois de entrar, retorna ao caminho pedido. O parâmetro `voltar` só aceita caminho interno do app.
- `/` redireciona: sem sessão, para o login; com sessão, para `/inicio`.
- Cada item tem uma URL própria, `/<tipo>/<slug>`, em português e no plural. O `slug` é amigável e acompanha o nome (RN03, RN13); a chave interna continua sendo o UUID, que não aparece nas URLs de páginas.
- Quem não tem permissão para um item recebe **404**, igual a quando o item não existe, para não revelar o que existe. Isso vale, por exemplo, para quem abre a página de um convidado sem poder vê-la (RN59).
- Quando o nome muda e o slug muda com ele, a URL antiga redireciona (308) para a nova (RN13).
- Os `slug`s nunca coincidem com os trechos fixos das rotas (RN15): `nova`, `novo`, `editar`, `foto`, `parecidas`.
- O link de convite leva o token na URL. As páginas enviam `Referrer-Policy: no-referrer` para que o token não vaze por links externos.
- O caminho das rotas é em minúsculas. Um caminho com outra caixa (`/API/docs`) não é uma rota do app.

### Páginas

| Rota | Quem acessa | O que mostra |
|---|---|---|
| `/` | todos | Só redireciona (veja acima). |
| `/auth/login` | sem sessão | Login, com "Lembrar de mim", o botão **Entrar com Google** e o link "esqueci a senha". Com o segundo fator ligado, abre a segunda etapa (código do app ou de backup). |
| `/primeiro-acesso` | sem sessão, só se não há contas | Cria o primeiro coordenador com o `SETUP_TOKEN` (RN106). Com qualquer conta existente, responde `404`. |
| `/auth/esqueci-senha` | sem sessão | Pedido do código por e-mail (ou uso de um código de recuperação) e definição da senha nova. |
| `/auth/convite/[token]` | sem sessão, ou convidado logado | Cadastro pelo convite (de ministério ou de evento): dados, código do e-mail e entrada logado. Abaixo do botão de cadastro, a frase "Ao se registrar você concorda com nossos termos e condições de uso", com links para os documentos. |
| `/inicio` | todos logados | Dashboard. |
| `/busca` | todos logados | Busca geral em todos os tipos, com filtro por tipo. |
| `/ajuda/acordes` | todos logados | Tutorial do padrão de escrita dos acordes (RF68). |
| `/musicas` | todos logados | Listagem de músicas. |
| `/musicas/nova` | membros ativos | Cadastro de música. |
| `/musicas/[slug]` | todos logados | Tela da cifra (tom, transpose, letra, fonte e rolagem), revisão, status de escuta, exportação, histórico e datas de criação e atualização. |
| `/musicas/[slug]/editar` | membros ativos | Edição da música. |
| `/musicas/[slug]/historico` | todos logados | Histórico da cifra: versões, comparação com a atual e volta a uma versão. |
| `/artistas` | todos logados | Listagem de artistas. Cadastrar um artista é um diálogo nesta página ou no formulário da música. |
| `/artistas/[slug]` | todos logados | O artista e as músicas dele. Botão **Exportar PDF** para o lote (RF62). |
| `/instrumentos` | todos logados | Todos os instrumentos. Criar um instrumento é um diálogo nesta página. |
| `/instrumentos/[slug]` | todos logados | O total de contas ativas que tocam o instrumento e a lista delas. |
| `/usuarios` | todos logados | Listagem de usuários. |
| `/usuarios/[slug]` | todos logados | Perfil: foto, instrumentos e listas. Os e-mails só aparecem para a própria pessoa. Coordenadores veem aqui o controle de cargo e de ativação. |
| `/listas` | todos logados | Listagem de listas. |
| `/listas/nova` | membros ativos | Criação de lista. |
| `/listas/[slug]` | todos logados | A lista, com seções e músicas. Botão **Exportar PDF** para o lote (RF62). |
| `/listas/[slug]/musicas/[musica]` | todos logados | Uma música dentro da lista (tom tocado e cifra local). `[musica]` é o `slug` da música. |
| `/eventos` | todos logados | Listagem de eventos. |
| `/eventos/novo` | coordenadores | Criação de evento. |
| `/eventos/[slug]` | todos logados | O evento: setlist, seções, escala, presença e convidados. Botão **Exportar PDF** para o lote (RF62). Coordenadores geram aqui o convite de convidado. |
| `/eventos/[slug]/editar` | coordenadores | Nome, data e hora, presença exigida e cancelamento. |
| `/eventos/[slug]/musicas/[musica]` | todos logados | Uma música dentro do setlist: cifra e tom tocado. |
| `/configuracoes/conta` | todos logados | Nome, sexo, foto e instrumentos. |
| `/configuracoes` | todos logados | Padrões de visualização e de exportação (RN91), notificações (RF73), data do aceite dos termos, links para os documentos e para as outras partes, e os downloads deste aparelho, com **Apagar todos os downloads** (RF81). |
| `/configuracoes/seguranca` | todos logados | E-mails, senha, Google, códigos de recuperação, desativação e exclusão da própria conta. |
| `/documentos/termos-de-uso` | todos | Termos de Uso, com download em Markdown ou PDF. |
| `/documentos/politica-privacidade` | todos | Política de Privacidade, com download em Markdown ou PDF. |
| `/documentos/politica-de-cookies` | todos | Política de Cookies, com download em Markdown ou PDF. |
| `/coordenacao` | coordenadores | Convites, ativação e desativação de contas, redefinição do segundo fator de outra pessoa e nome e logo do ministério. |
| `/api/docs` | público | Swagger UI. |
| `/api/openapi.json` | público | Especificação OpenAPI. |

O convidado acessa todas as páginas de leitura, `/configuracoes`, `/configuracoes/conta`, `/configuracoes/seguranca`, `/documentos/termos-de-uso`, `/documentos/politica-privacidade` e `/documentos/politica-de-cookies`. As rotas de edição (`/nova`, `/novo`, `/editar`) e `/coordenacao` não abrem para ele.

A conta desativada acessa as páginas normalmente, mas as rotas de edição (`/nova`, `/novo`, `/editar`) e os botões de gravação ficam bloqueados (RN06).

### Compartilhar

Toda página de música, artista, instrumento, usuário, lista e evento (e de música dentro de um setlist ou lista) tem o botão **Compartilhar** no cabeçalho.

- No celular, abre o menu de compartilhamento do aparelho (Web Share API) com o título da página e o link. Onde esse menu não existir, o botão copia o link e avisa "Link copiado".
- O link é o endereço da própria página (`/<tipo>/<slug>`). Quem o abre precisa estar logado e ter permissão; senão vê 404 (RN82).
- Na página de uma **lista**, o botão **Compartilhar** tem a seção **Donos e acesso**, para os donos: incluir ou retirar donos e dar ou retirar acesso de edição. Editores veem a lista, mas não essa seção (RN79).

### Parâmetros das listagens

As listagens guardam o estado na URL (a pessoa pode compartilhar o link e o botão voltar funciona). Ao mudar a busca ou um filtro, `pagina` volta a 1.

| Parâmetro | Valores | Onde |
|---|---|---|
| `busca` | texto (até 100 caracteres) | músicas, artistas, usuários, listas e eventos |
| `ordem` | `az` (padrão) ou `za` | todas |
| `ordem` | `mais` ou `menos` | músicas e artistas |
| `ordem` | `data` (mais antiga primeiro) ou `data-desc` (mais recente primeiro; padrão em eventos) | eventos |
| `pagina` | 1, 2, 3… (30 itens por página) | todas |
| `tipo` | `todos` (padrão), `musicas`, `artistas`, `listas`, `eventos`, `usuarios` ou `instrumentos` | só na busca geral (`/busca`) |
| `periodo` | `mes`, `ano` ou `geral` (padrão) | músicas e artistas, com `ordem=mais` ou `menos` |
| `ano`, `mes` | número | com `periodo`: `periodo=mes&ano=2026&mes=10` é outubro de 2026; `periodo=ano&ano=2025` é o ano de 2025. Sem eles, vale o mês ou o ano atual. |
| `artista` | `slug` do artista | músicas |
| `revisao` | `sim` | músicas (o cartão "Para revisão" do dashboard leva a `/musicas?revisao=sim`) |
| `de`, `ate` | data ISO (`2026-10-01`) | eventos |

Exemplos: `/musicas?ordem=mais&periodo=mes`, `/musicas?busca=coracao&artista=padre-zezinho&pagina=2`, `/eventos?de=2026-10-01&ate=2026-10-31&ordem=data`. Os destaques do dashboard apontam para URLs assim.

### URLs da API

- O prefixo é `/api`, com recursos em português e no plural, e as mesmas palavras de `busca`, `ordem`, `pagina` e filtros das listagens.
- **Leitura de um item pelo `slug`** (`GET /api/musicas/{slug}`), para que a página e a API usem a mesma chave. **Gravação pelo `id`** (`PATCH /api/musicas/{id}`), que o front já recebeu na leitura.
- Ações que não são só um campo viram um verbo no fim do caminho: `/publicar`, `/copiar-setlist`, `/ativo`, `/presenca`, `/desativar`.
- A resposta de cada item traz `id` e `slug`.

### Formato das respostas e dos erros

- JSON em UTF-8. As datas seguem o ISO 8601 com fuso (`2026-10-18T19:00:00-03:00`), e os ids são UUID.
- As listagens devolvem `{ "itens": [...], "total": 412, "pagina": 1, "porPagina": 30 }`.
- Os erros devolvem `{ "erro": { "codigo": "VALIDACAO", "mensagem": "...", "campos": [{ "campo": "titulo", "mensagem": "..." }] } }`, com `campos` só nos erros de validação. A `mensagem` é em português e pode ser mostrada à pessoa. Nenhum erro revela detalhes internos (consulta, caminho de arquivo ou pilha de chamadas).

| Status | `codigo` | Quando |
|---|---|---|
| 401 | `NAO_AUTENTICADO` | Sem sessão, ou com sessão inválida ou encerrada (`token_versao`). |
| 403 | `PROIBIDO` | A pessoa vê o item, mas não pode fazer a ação (por exemplo, um convidado gravando). |
| 404 | `NAO_ENCONTRADO` | O item não existe ou a pessoa não pode vê-lo (RN82). |
| 409 | `CONFLITO_VERSAO` | A `versao` enviada não é mais a atual (RN38). |
| 409 | `DUPLICADO` | Outra unicidade violada: nome de artista ou instrumento, título com os mesmos artistas, e-mail em outra conta. |
| 422 | `VALIDACAO` | O corpo ou os parâmetros não passam pelo schema Zod. |
| 429 | `LIMITE_TENTATIVAS` | Passou do limite de tentativas (RNF15), com `Retry-After` em segundos. |
| 500 | `ERRO_INTERNO` | Falha inesperada. O detalhe vai só para o log. |

A API é usada só pelo front do próprio app, por isso as rotas não têm número de versão (`/api/v1`).

## Busca e ordenação

### Onde há busca

| Onde | O que a busca compara |
|---|---|
| Listagem de **músicas** | Título e nome dos artistas. |
| Listagem de **artistas**, **usuários**, **listas** e **eventos** | O nome. |
| Listagem de **instrumentos** | A listagem não tem caixa de busca (RF49), mas os instrumentos aparecem na busca geral. |
| **Busca geral** (`/busca`) | Todos os tipos acima ao mesmo tempo, pelo nome (e, nas músicas, pelo título e pelos artistas). |
| Campo de **artista** no formulário da música | O nome do artista (autocompletar). |
| **Aviso de música parecida** ao cadastrar | O título, por semelhança. |

### Técnicas

1. **Normalização.** O texto é comparado em minúsculas e sem acentos: "Coração", "CORACAO" e "coração" são iguais. É feita no banco pela função `busca_norm` (`lower` + `unaccent`), aplicada ao termo e à coluna, de modo que os dois sempre passam pela mesma regra.
2. **Trecho do texto, não só o início.** A busca é por `LIKE '%termo%'` sobre o texto normalizado (`cora` encontra "Coração de Jesus"). Os índices **GIN de trigramas** (`pg_trgm`) em título e nome de artista deixam isso rápido mesmo com milhares de músicas. Para títulos curtos, esse é o comportamento que a pessoa espera, e por isso não usamos a busca de texto completo (`tsvector`), que trabalha com palavras inteiras e raízes.
3. **Várias palavras.** O termo é dividido pelos espaços e **todas** as palavras precisam aparecer, em qualquer ordem, no título ou no nome de algum artista. `coracao zezi` encontra "Coração de Jesus", do Padre Zezinho.
4. **Entrada segura.** O termo é aparado nas pontas, limitado a 100 caracteres e enviado como parâmetro da consulta, nunca concatenado. Os caracteres `%`, `_` e `\` são escapados, para que valham como letras. Busca vazia significa sem filtro.
5. **Ordem A–Z e Z–A.** Ordena por `busca_norm(nome)` e desempata pelo `id`. Assim a ordem ignora acentos e caixa ("Álvaro" fica entre "Alice" e "Bruno"), não depende do idioma configurado no banco e o desempate mantém as páginas estáveis. Em `mais` e `menos` tocadas, ordena pelas execuções e depois pelo nome (RN27).
6. **Paginação.** `LIMIT 30 OFFSET (pagina - 1) * 30`, com o total para montar os números das páginas.
7. **Música parecida.** Usa `similarity()` do `pg_trgm` entre os títulos normalizados, com limite de **0,4** (ajustável), mostrando as 5 mais parecidas em ordem decrescente. A pontuação não conta ("Segura na mão de Deus!" é igual a "Segura na mao de Deus"). É um aviso: quem bloqueia é só a duplicata exata de título e conjunto de artistas (RN34), validada pela API e garantida pelo banco.
8. **No front.** A caixa de busca espera cerca de 300 ms sem digitação antes de consultar, cancela a consulta anterior se uma nova começa e grava o termo na URL (`?busca=`). O autocompletar de artista começa com 2 caracteres e mostra até 8 resultados.
9. **Offline.** Sem conexão, as listagens mostram só os itens baixados (RN110), e a busca nova precisa de conexão (RNF02).
10. **Busca geral.** Usa as mesmas regras de normalização, palavras e escape. Com `tipo=todos`, a página roda uma consulta por tipo, em paralelo, e mostra cada tipo em um bloco com **até 5 resultados**, o total encontrado e o link "ver todos", que leva à listagem do tipo já com `busca=` aplicada. Em cada bloco, quem começa com o termo vem primeiro, depois a ordem A–Z. Os filtros de tipo mostram a contagem ("Músicas (12)"). Com um `tipo` específico, a página mostra a própria listagem daquele tipo (30 por página, com `ordem` e `pagina`), sem lógica duplicada. O termo precisa de pelo menos 2 caracteres. Usuários convidados só aparecem para quem a RN59 permite. O campo no topo do app abre `/busca?busca=termo` ao enviar.

Exemplo de consulta (músicas, termo `coracao zezi`; cada palavra repete o bloco):

```sql
SELECT m.id, m.titulo, m.slug
FROM musicas m
WHERE (busca_norm(m.titulo) LIKE '%coracao%' ESCAPE '\'
       OR EXISTS (SELECT 1 FROM musica_artistas ma JOIN artistas a ON a.id = ma.artista_id
                  WHERE ma.musica_id = m.id AND busca_norm(a.nome) LIKE '%coracao%' ESCAPE '\'))
  AND (busca_norm(m.titulo) LIKE '%zezi%' ESCAPE '\'
       OR EXISTS (SELECT 1 FROM musica_artistas ma JOIN artistas a ON a.id = ma.artista_id
                  WHERE ma.musica_id = m.id AND busca_norm(a.nome) LIKE '%zezi%' ESCAPE '\'))
ORDER BY busca_norm(m.titulo), m.id
LIMIT 30 OFFSET 0;
```

O Prisma não expressa essas funções, então as buscas e as listagens usam consultas SQL parametrizadas (`$queryRaw`), concentradas em `src/lib/busca.ts`, que monta o filtro de palavras e escapa o termo. O restante do app usa o Prisma normalmente. Usuários, listas e eventos têm poucas linhas, por isso a busca por nome neles não precisa de índice.

## API e Swagger

A API é composta por Route Handlers em `src/app/api`. A documentação é em **OpenAPI 3** com interface **Swagger UI**, **pública, sem login**.

A especificação é gerada a partir dos **schemas Zod** que já validam as requisições (por exemplo com `@asteasolutions/zod-to-openapi`), de modo que o contrato e a documentação saem da mesma fonte. Ela é servida em `/api/openapi.json` e a interface em `/api/docs`; ambas são públicas. Os endpoints que a documentação descreve continuam validando sessão e permissão. A autenticação é por cookie, declarada como esquema de segurança `cookieAuth`.

### Endpoints

| Recurso | Endpoints |
|---|---|
| Autenticação | `POST /api/auth/login` (com o segundo fator ligado, devolve `mfa_required` e o token temporário), `POST /api/auth/login/totp` (segunda etapa), `POST /api/auth/logout`, `GET /api/auth/me` (renova o cookie de "lembrar de mim"), `GET /api/auth/google` (inicia o login com Google), `GET /api/auth/google/callback` |
| Saúde | `GET /api/saude` (público; `200` quando o app e o banco respondem, usado pelo `HEALTHCHECK` do contêiner) |
| Primeiro acesso e ministério | `POST /api/primeiro-acesso/codigo` (envia o código ao e-mail), `POST /api/primeiro-acesso` (token, nome, sexo, e-mail, senha, nome do ministério, aceite dos termos e código; cria o primeiro coordenador; `404` se já há contas), `GET /api/publico/ministerio` (nome e logo, sem sessão), `GET, PUT /api/ministerio` (nome; coordenadores gravam), `GET /api/ministerio/logo` (público; `?tamanho=192` ou `512` devolve o ícone do PWA), `PUT, DELETE /api/ministerio/logo` (coordenadores) |
| Cadastro e senha | `GET /api/convites/{token}` (confere se o convite vale e mostra o cargo e o evento), `POST /api/auth/cadastro/codigo` (envia o código ao e-mail), `POST /api/auth/cadastro` (nome, sexo, e-mail, senha, aceite dos termos e código; confirma o código, cria a conta e consome o convite), `POST /api/auth/esqueci-senha` (envia o código), `POST /api/auth/redefinir-senha` (código do e-mail ou de recuperação, mais a senha nova) |
| Conta | `GET, PATCH /api/conta` (nome e sexo), `PUT /api/conta/senha`, `PUT /api/conta/instrumentos`, `GET, POST /api/conta/emails` (lista; envia o código ao novo e-mail), `PUT /api/conta/emails/{id}` (confirma o código), `DELETE /api/conta/emails/{id}`, `POST /api/conta/excluir-codigo` (envia o código de exclusão ao e-mail escolhido), `DELETE /api/conta` (apaga a própria conta, com a senha e um código: app, backup ou e-mail), `GET /api/conta/google` (inicia o vínculo), `DELETE /api/conta/google` (desvincula, com a senha), `POST /api/conta/codigos-recuperacao`, `POST /api/conta/totp` (gera o segredo e o QR code), `PUT /api/conta/totp` (liga, com a senha e o primeiro código, e devolve os códigos de backup), `DELETE /api/conta/totp` (desliga, com a senha e um código), `POST /api/conta/desativar`, `PUT, DELETE /api/conta/foto`, `GET, PUT /api/conta/preferencias` (padrões de visualização e de exportação, RN91) |
| Downloads | `GET /api/downloads/musicas/{slug}`, `GET /api/downloads/eventos/{slug}` e `GET /api/downloads/listas/{slug}` (pacote completo do item para guardar no aparelho, com a `versao` de cada parte; RN110), `POST /api/downloads/verificar` (recebe os ids e as versões dos itens baixados e devolve o que mudou, o que foi apagado e o que deixou de estar acessível) |
| Dashboard | `GET /api/dashboard?periodo=mes\|ano` (usuários logados) |
| Listagens | `GET /api/musicas`, `GET /api/artistas`, `GET /api/instrumentos`, `GET /api/usuarios`, `GET /api/listas`, `GET /api/eventos`. Os parâmetros são os da seção [Parâmetros das listagens](#parâmetros-das-listagens): `busca`, `ordem`, `pagina`, `periodo`, `ano`, `mes`, `artista`, `revisao`, `de`, `ate`. |
| Usuários | `GET /api/usuarios/{slug}`, `GET /api/usuarios/{slug}/foto` (com `Cache-Control` e `ETag`), `PATCH /api/usuarios/{id}` (cargo), `PATCH /api/usuarios/{id}/ativo` (desativar e reativar), `POST /api/usuarios/{id}/totp/redefinir` (coordenadores; apaga o segundo fator de outra pessoa) |
| Convites | `POST /api/convites` (com `papel` e, para convidados, `evento_id`) |
| Instrumentos | `POST /api/instrumentos`, `GET /api/instrumentos/{slug}` (com o total e os músicos), `PATCH, DELETE /api/instrumentos/{id}` |
| Artistas | `POST /api/artistas`, `GET /api/artistas/{slug}`, `PATCH /api/artistas/{id}` (renomear) |
| Músicas | `POST /api/musicas`, `GET /api/musicas/parecidas?titulo=`, `GET /api/musicas/{slug}`, `GET /api/musicas/{slug}/exportar?formato=md\|pdf&modo=cifra\|letra&tom=&secoes=0\|1&link=0\|1`, `PATCH, DELETE /api/musicas/{id}`, `PUT /api/musicas/{id}/revisao`, `PUT /api/musicas/{id}/status-escuta` |
| Eventos | `POST /api/eventos`, `GET /api/eventos/{slug}` (com o setlist), `PATCH /api/eventos/{id}` (inclui cancelar), `POST /api/eventos/{id}/publicar`, `POST /api/eventos/{id}/copiar-setlist` |
| Listas | `GET /api/listas/{slug}` (com seções e músicas; donos e editores também recebem a lista de donos e acessos) |
| Documentos | `GET /api/documentos/{nome}?formato=md\|pdf`, com `nome` = `termos-de-uso`, `politica-privacidade` ou `politica-de-cookies`. Público. |
| Exportação em lote | `POST /api/exportar/lote`, com corpo `{ origem: {tipo: artista\|evento\|lista, slug}, modo, secoes, link, tom }`, com `tom` opcional (um tom para todas; sem ele, o tocado de cada item, ou graus). Devolve um PDF. |
| Histórico de cifras | `GET /api/musicas/{slug}/versoes`, `GET /api/musicas/{slug}/versoes/{numero}` e `POST /api/musicas/{id}/versoes/{numero}/restaurar` (corpo: `titulo`, `versao`). `PATCH /api/musicas/{id}` exige `tituloVersao` quando muda a cifra, o tom original ou os artistas. Mudar o tom tocado de um item é `PATCH /api/colecoes/{id}/musicas/{id}`, que também exige `tituloVersao` e gera uma versão `TOM_TOCADO`. |
| Busca geral | `GET /api/busca?busca=` devolve, para cada tipo, o total e até 5 resultados. Para um tipo específico, a página usa a listagem do próprio tipo (`GET /api/musicas?busca=` etc.). |
| Convidados do evento | `GET /api/eventos/{id}/convidados`, `DELETE /api/eventos/{id}/convidados/{usuarioId}` |
| Presença | `PUT /api/eventos/{id}/presenca` |
| Coleções (setlist e lista) | `POST /api/colecoes`, `PATCH /api/colecoes/{id}` (nome, só donos), `DELETE /api/colecoes/{id}` (só listas, só donos), `POST /api/colecoes/{id}/donos` e `DELETE /api/colecoes/{id}/donos/{usuarioId}` (só donos, sempre resta um), `POST /api/colecoes/{id}/acessos` e `DELETE /api/colecoes/{id}/acessos/{usuarioId}` (só donos), `POST /api/colecoes/{id}/secoes`, `PATCH /api/colecoes/{id}/secoes/{id}` (renomear, mover), `POST /api/colecoes/{id}/musicas`, `PATCH /api/colecoes/{id}/musicas/{id}` (mover, tom, cifra; `salvar_em=musica\|colecao`) |
| Escala da seção | `PUT /api/colecoes/{id}/secoes/{id}/musicos` (`modo=sobrescrever\|completar`) |
| Escala do evento | `GET /api/colecoes/{id}/musicos` (lista), `POST /api/colecoes/{id}/musicos` (adiciona), `DELETE /api/colecoes/{id}/musicos/{id}` (remove) |
| Escalar todos | `POST /api/colecoes/{id}/musicos/lote` (`instrumento_id` opcional: sem ele, todos os membros ativos; com ele, só quem toca o instrumento) |
| Push e rotina diária | `POST, DELETE /api/push/subscribe`, `GET /api/cron/diario` (só o Vercel Cron, com `CRON_SECRET`: lembretes de presença e limpeza de convites, códigos e contadores vencidos) |

Resposta de `GET /api/dashboard?periodo=mes`:

```json
{
  "totalMusicos": 18,
  "totalMusicas": 412,
  "totalParaRevisao": 9,
  "musicosPorInstrumento": [
    { "instrumento": "Violão", "slug": "violao", "totalMusicos": 7 },
    { "instrumento": "Voz", "slug": "voz", "totalMusicos": 6 },
    { "instrumento": "Bateria", "slug": "bateria", "totalMusicos": 0 }
  ],
  "proximosEventos": [
    { "nome": "Missa de domingo", "slug": "2026-10-18-missa-de-domingo",
      "dataEvento": "2026-10-18T19:00:00-03:00", "minhaResposta": null }
  ],
  "tocados": {
    "periodo": "mes",
    "musicas": {
      "maisTocadas": [ { "titulo": "Segura na Mão de Deus", "artistas": ["Artista Um"], "execucoes": 4 } ],
      "menosTocadas": [ { "titulo": "Música D", "artistas": ["Artista Três"], "execucoes": 0 } ]
    },
    "artistas": {
      "maisTocados": [ { "artista": "Artista Um", "slug": "artista-um", "execucoes": 7 } ],
      "menosTocados": [ { "artista": "Artista Três", "slug": "artista-tres", "execucoes": 0 } ]
    }
  }
}
```

(`minhaResposta` é `true` para "Vou", `false` para "Não vou" e `null` para pendente. As listas de mais e menos tocados têm até 5 itens.)

