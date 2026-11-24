# Desenvolvimento, qualidade e deploy

## Estrutura de pastas

```
.
├─ DDL.sql                   # modelo de dados em SQL (PostgreSQL)
├─ db/
│  └─ migracoes/             # scripts numerados, aplicados depois do primeiro deploy
├─ .github/
│  ├─ workflows/
│  │  ├─ ci.yml              # tipos, lint, testes e DDL em Postgres limpo
│  │  └─ backup.yml          # backup semanal do banco
│  └─ dependabot.yml         # atualização semanal das dependências
├─ .editorconfig             # indentação, fim de linha e espaços no fim das linhas
├─ .prettierrc               # formatação do Prettier (sem vírgula final)
├─ eslint.config.mjs         # regras do ESLint (`next/core-web-vitals` e `typescript-eslint`)
├─ vercel.json               # agenda da rotina diária (Vercel Cron) e região das funções
├─ Dockerfile                # imagem do app para rodar em contêiner (opcional)
├─ .dockerignore             # o que não entra na imagem
├─ docker-compose.yml        # app, banco e rotina diária em contêineres (opcional)
├─ prisma/
│  └─ schema.prisma          # gerado do banco com `prisma db pull`
├─ public/
│  ├─ manifest.json          # manifesto do PWA
│  └─ sw.js                  # service worker
├─ src/
│  ├─ app/
│  │  ├─ layout.tsx          # layout raiz (registra o service worker)
│  │  ├─ page.tsx            # `/`: redireciona conforme a sessão
│  │  ├─ documentos/         # públicos: Termos de Uso e Política de Privacidade
│  │  │  ├─ termos-de-uso/
│  │  │  └─ politica-privacidade/
│  │  ├─ primeiro-acesso/    # cria o primeiro coordenador (só sem contas, com SETUP_TOKEN)
│  │  ├─ auth/               # fora da área autenticada
│  │  │  ├─ login/
│  │  │  ├─ esqueci-senha/
│  │  │  └─ convite/[token]/ # cadastro pelo convite
│  │  ├─ (app)/              # área autenticada (o grupo não entra na URL)
│  │  │  ├─ inicio/          # dashboard
│  │  │  ├─ busca/           # busca geral
│  │  │  ├─ ajuda/
│  │  │  │  └─ acordes/      # tutorial do padrão de escrita (RF68)
│  │  │  ├─ musicas/         # listagem
│  │  │  │  ├─ nova/
│  │  │  │  └─ [slug]/       # tela da cifra
│  │  │  │     ├─ editar/
│  │  │  │     └─ historico/  # versões da cifra
│  │  │  ├─ artistas/        # listagem
│  │  │  │  └─ [slug]/
│  │  │  ├─ instrumentos/    # todos os instrumentos
│  │  │  │  └─ [slug]/
│  │  │  ├─ usuarios/        # listagem
│  │  │  │  └─ [slug]/
│  │  │  ├─ listas/          # listagem
│  │  │  │  ├─ nova/
│  │  │  │  └─ [slug]/       # uma lista (slug dono-nome)
│  │  │  │     └─ musicas/[musica]/
│  │  │  ├─ eventos/         # listagem
│  │  │  │  ├─ novo/
│  │  │  │  └─ [slug]/       # evento, setlist, escala e presença
│  │  │  │     ├─ editar/
│  │  │  │     └─ musicas/[musica]/
│  │  │  ├─ configuracoes/   # visualização e exportação (padrões)
│  │  │  │  ├─ conta/        # nome, foto e instrumentos
│  │  │  │  └─ seguranca/    # e-mails, senha, Google, códigos, desativação e exclusão
│  │  │  └─ coordenacao/     # convites e gestão de contas
│  │  └─ api/                # Route Handlers
│  │     └─ docs/            # Swagger UI (público)
│  ├─ components/            # componentes React (ui, forms, setlist, cifra, dashboard)
│  ├─ lib/
│  │  ├─ db.ts               # cliente Prisma (singleton)
│  │  ├─ auth.ts             # JWT e leitura da sessão
│  │  ├─ autorizar.ts        # função central de permissão (cargo, ativo, convidado, lista)
│  │  ├─ email.ts            # envio de e-mail (Resend), trocável
│  │  ├─ exportar.ts         # Markdown e PDF da cifra, da letra e das políticas
│  │  ├─ google.ts           # login com Google (OpenID Connect)
│  │  ├─ senha.ts            # hash scrypt e conferência em tempo constante
│  │  ├─ totp.ts             # segundo fator: TOTP (RFC 6238), criptografia do segredo, códigos de backup
│  │  ├─ config.ts           # lê e valida o ambiente; em produção recusa configuração insegura (RNF21)
│  │  ├─ marca.ts            # nome e logo do ministério: valor do ambiente na primeira subida, depois o do banco (RN104)
│  │  ├─ busca.ts            # filtros de busca e ordenação (SQL parametrizado)
│  │  ├─ cifra/              # padrão de escrita, tabela do tutorial, conversão de tom para graus e de graus para tom
│  │  └─ ...                 # validadores Zod, slugs, etc.
│  └─ hooks/
├─ tests/
│  ├─ unit/                  # cifra, slugs, busca, autorizar
│  ├─ integration/           # rotas com PostgreSQL real, criado do DDL.sql
│  └─ e2e/                   # Playwright
└─ .env.example
```

## Rodando localmente

Pré-requisitos: Node.js 20+ e Docker (usado para o banco; o app também pode rodar em contêiner, veja [Rodando em contêiner](#rodando-em-contêiner-opcional)).

```bash
# 1. Postgres local
docker run --name musicaliapp-db -e POSTGRES_PASSWORD=dev -e POSTGRES_DB=musicaliapp \
  -p 5432:5432 -d postgres:16

# 2. Projeto Next com TypeScript e App Router
npx create-next-app@15 musicaliapp && cd musicaliapp

# 3. Dependências
npm i prisma@6 @prisma/client@6 zod jose qrcode openid-client web-push resend \
      sharp pdf-lib @dnd-kit/core @dnd-kit/sortable @dnd-kit/utilities \
      @asteasolutions/zod-to-openapi swagger-ui-react @serwist/next serwist
npm i -D @types/qrcode @types/web-push @types/swagger-ui-react vitest @playwright/test prettier eslint

# 4. Variáveis de ambiente
cp .env.example .env.local
#   DATABASE_URL="postgresql://postgres:dev@localhost:5432/musicaliapp"
#   DIRECT_URL="postgresql://postgres:dev@localhost:5432/musicaliapp"
#   APP_URL="http://localhost:3000"
#   JWT_SECRET="..."          # 32 caracteres ou mais (ex.: openssl rand -base64 48)
#   TOTP_ENCRYPTION_KEY="..." # 32 bytes em base64 (ex.: openssl rand -base64 32)
#   SETUP_TOKEN="..."         # cria o primeiro coordenador em /primeiro-acesso
#   NOME_MINISTERIO="Ministério de Música São José"

# 5. Banco: aplicar o DDL e gerar o schema do Prisma a partir dele
psql "postgresql://postgres:dev@localhost:5432/musicaliapp" -f DDL.sql
npx prisma init --datasource-provider postgresql
# O CLI do Prisma lê o `.env`, não o `.env.local`: copie DATABASE_URL e DIRECT_URL para o `.env`
# (ele está no .gitignore) e acrescente `directUrl = env("DIRECT_URL")` ao datasource do schema.
npx prisma db pull
npx prisma generate

# 6. Rodar
npm run dev
```

### Rodando em contêiner (opcional)

A hospedagem principal é a Vercel com o Supabase (RNF08), e o desenvolvimento do dia a dia não precisa de Docker para o app. Mesmo assim, o app tem uma **opção de rodar em contêiner**, com as mesmas funções, para quem prefere uma VPS (por exemplo, com Coolify), um servidor próprio ou um ambiente igual em qualquer máquina (RNF22).

O app não grava nada em disco: fotos, logo, cifras e sessões ficam no banco. O contêiner do app não guarda estado e pode ser recriado a qualquer momento.

**O que o repositório traz**

| Arquivo | Para quê |
| --- | --- |
| `Dockerfile` | Imagem em três estágios (dependências, build e execução). Usa `node:20-bookworm-slim`, `output: "standalone"` do Next, gera o cliente do Prisma e roda com um usuário sem privilégios. |
| `.dockerignore` | Deixa de fora `node_modules`, `.next`, `.env*` (exceto o `.env.example`) e `.git`. |
| `docker-compose.yml` | Sobe o `app`, o `db` (PostgreSQL 16, com o `DDL.sql` aplicado na primeira subida) e o `cron` (a rotina diária). |
| `GET /api/saude` | Rota pública que devolve `200` quando o app e o banco respondem. Serve ao `HEALTHCHECK` e ao proxy. |

O `standalone` só vale no contêiner: o `next.config.ts` o liga quando `NEXT_OUTPUT=standalone`, que o `Dockerfile` define. O build da Vercel não muda.

**Subir tudo**

```bash
cp .env.example .env          # preencha as variáveis (veja abaixo)
docker compose up -d --build
docker compose logs -f app
```

O app abre em `http://localhost:3000`. Crie o primeiro coordenador em `/primeiro-acesso` (RN105).

**Variáveis específicas do contêiner**

- `DATABASE_URL` e `DIRECT_URL` apontam para o serviço `db` do compose: `postgresql://postgres:<senha>@db:5432/musicaliapp`, **sem** `?pgbouncer=true` (não há pooler).
- `POSTGRES_PASSWORD` define a senha do `db`. Use a mesma em `DATABASE_URL`.
- `APP_URL` é o endereço público. Em `http://localhost:3000` o cookie `secure` e o app funcionam, porque o navegador trata `localhost` como origem segura; qualquer outro endereço precisa de HTTPS (RNF21).
- `LOGO_MINISTERIO_PATH`, se usada, aponta para um arquivo montado no contêiner por um volume (`./logo.png:/app/logo.png:ro`).
- Todas as demais variáveis da seção [Variáveis de ambiente](#variáveis-de-ambiente) valem do mesmo jeito.

**Em produção, fora da Vercel**

- **HTTPS:** o contêiner fala HTTP na porta 3000. Coloque na frente um proxy que termine o TLS (Coolify, Caddy ou Traefik). O PWA, o service worker, o push e o cookie `secure` exigem HTTPS. Mande o proxy repassar `Host` e `X-Forwarded-Proto`, para o cabeçalho `Origin` bater com `APP_URL`.
- **Rotina diária:** sem o Vercel Cron, o serviço `cron` do compose chama `GET /api/cron/diario` uma vez por dia, com `Authorization: Bearer $CRON_SECRET`. Se você usar outro agendador (o do Coolify, por exemplo), basta a mesma chamada.
- **Banco:** pode ser o `db` do compose (com volume nomeado e backup) ou um PostgreSQL externo, inclusive o Supabase. Neste caso, remova o serviço `db` e aponte `DATABASE_URL` para ele.
- **Migrações:** o `DDL.sql` só roda quando o volume do banco está vazio. Depois, aplique os scripts de `db/migracoes/` em ordem, por exemplo `docker compose exec -T db psql -U postgres musicaliapp < db/migracoes/0001_descricao.sql`.
- **Backup:** `docker compose exec -T db pg_dump -U postgres musicaliapp | age -r <chave> > backup.sql.age`, guardado fora do servidor (RNF17). O workflow `backup.yml` continua valendo para o Supabase.
- **Atualizar:** `git pull && docker compose up -d --build`. As sessões continuam válidas, porque o estado está no banco e o `JWT_SECRET` não muda.

**Só o banco em Docker**

O fluxo da seção anterior (`docker run` do Postgres e `npm run dev` no seu computador) continua o jeito mais rápido de desenvolver, com recarga automática. O contêiner do app serve para conferir o build de produção e para hospedar.

### Primeiro acesso

Como o acesso é por convite, o primeiro coordenador é criado pelo próprio app, sem conta nem senha padrão (RN105):

1. Defina `SETUP_TOKEN` (32 caracteres ou mais) no `.env.local` e suba o app.
2. Abra `/primeiro-acesso`, informe o token, seu nome completo, e-mail, senha e o nome do ministério (já preenchido com `NOME_MINISTERIO`), e aceite os termos. Sem `RESEND_API_KEY`, o código do e-mail aparece no terminal.
3. Depois da criação, a rota responde `404` e o token não serve mais. Em produção, o app pede para ligar o segundo fator no primeiro login (RN102).

Sem `SETUP_TOKEN`, a rota fica desligada e a conta pode ser criada direto no banco:

```bash
HASH=$(node -e 'const c=require("crypto");const s=c.randomBytes(16);const h=c.scryptSync(process.argv[1],s,32,{N:16384,r:8,p:1});const b=x=>x.toString("base64url");console.log(["scrypt",16384,8,1,b(s),b(h)].join("$"))' 'SUA_SENHA')
psql "postgresql://postgres:dev@localhost:5432/musicaliapp" -c \
  "WITH u AS (
     INSERT INTO usuarios (nome, slug, senha_hash, papel, termos_versao)
     VALUES ('Seu Nome Completo', 'seu-nome', '$HASH', 'COORDENADOR', '1.0')
     RETURNING id)
   INSERT INTO emails_usuario (usuario_id, email) SELECT id, 'voce@exemplo.com' FROM u;"
```

### Comandos úteis

| Comando | Para quê |
| --- | --- |
| `npm run dev` | Servidor de desenvolvimento. |
| `npm run typecheck` | `tsc --noEmit`: checa os tipos. |
| `npm run lint` | ESLint e checagem do Prettier. |
| `npm test` | Testes unitários e de integração (Vitest). Os de integração precisam do Postgres local. |
| `npm run test:e2e` | Testes ponta a ponta (Playwright). |
| `npx prisma validate` | Checa o schema do Prisma. |
| `npx prisma db pull` | Atualiza o `schema.prisma` a partir do banco. |
| `npx prisma studio` | Mostra os dados. |

## Variáveis de ambiente

| Variável | Para quê |
| --- | --- |
| `DATABASE_URL` | Conexão do Prisma. Em produção, a string do pooler do Supabase. |
| `DIRECT_URL` | Conexão direta, sem pooler, usada pelo `prisma db pull`, pelas migrações e pelo backup. No schema: `directUrl = env("DIRECT_URL")`. |
| `APP_URL` | Endereço público do app. Serve para conferir o cabeçalho `Origin` das gravações e para montar links. Ex.: `https://musicaliapp.exemplo.com`. |
| `JWT_SECRET` | Segredo para assinar o token de sessão. Longo e aleatório, com 32 caracteres ou mais. Em produção, o app não sobe com o valor do exemplo nem com um segredo curto (RNF21). |
| `TOTP_ENCRYPTION_KEY` | Chave de 32 bytes em base64 que criptografa os segredos do app autenticador (AES-256-GCM). Obrigatória em produção. **Só no servidor.** Trocá-la invalida todos os segundos fatores ligados. |
| `EXIGIR_TOTP_COORDENADOR` | `true` ou `false`: coordenadores precisam ligar o segundo fator (RN102). Padrão: `true` em produção e `false` em desenvolvimento. |
| `SESSAO_MINUTOS` | Duração da sessão sem "Lembrar de mim" (RN107). Padrão: 480. |
| `SESSAO_LEMBRAR_DIAS` | Duração do cookie com "Lembrar de mim", renovado a cada acesso. Padrão: 30. |
| `SETUP_TOKEN` | Segredo que libera `/primeiro-acesso` enquanto não há contas (RN105). Opcional; depois do primeiro coordenador, pode ser removido. |
| `NOME_MINISTERIO` | Nome inicial do ministério. Gravado na primeira subida; depois os coordenadores o alteram no app (RN104). |
| `LOGO_MINISTERIO_PATH` | Caminho de uma imagem PNG ou JPEG (até 512 KB) usada como logo inicial. Mesma regra de `NOME_MINISTERIO`. |
| `NEXT_PUBLIC_VAPID_PUBLIC_KEY` | Chave pública VAPID, enviada ao navegador. |
| `VAPID_PRIVATE_KEY` | Chave privada VAPID. **Só no servidor.** |
| `VAPID_SUBJECT` | `mailto:` de contato exigido pelo VAPID. |
| `CRON_SECRET` | Segredo que o Vercel Cron envia à rota da rotina diária. |
| `RESEND_API_KEY` | Chave da API do Resend, para enviar os códigos. Sem ela, em desenvolvimento, o código é impresso no terminal. |
| `EMAIL_FROM` | Remetente dos e-mails, em um domínio verificado no Resend (ex.: `musicaliapp <nao-responda@seudominio.com>`). |
| `GOOGLE_CLIENT_ID` | Identificador do cliente OAuth no Google Cloud. |
| `GOOGLE_CLIENT_SECRET` | Segredo do cliente OAuth. **Só no servidor.** |
| `GOOGLE_REDIRECT_URI` | Endereço de retorno do login, ex.: `https://seu-app/api/auth/google/callback`. |
| `NODE_ENV` | `development` ou `production`. Em `production`, o cookie é `secure` e o app valida o ambiente na subida (RNF21). |

## Qualidade e testes

### Convenções de código

- TypeScript em modo `strict` (RNF05). ESLint (`next/core-web-vitals` e `typescript-eslint`) e Prettier, com `npm run lint` e `npm run typecheck` sem erros.
- Nomes do domínio em português, como no banco e nas URLs (`musicas`, `autorizar`, `colecao`), e termos técnicos em inglês (`handler`, `cache`). Os textos mostrados à pessoa são em português do Brasil.
- Toda entrada de rota passa por um schema Zod, e nenhuma rota lê ou grava no banco antes de chamar `autorizar` (RNF10).
- Commits no padrão **Conventional Commits** (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`). A `main` é protegida: o trabalho entra por pull request com a CI aprovada, e cada pull request ganha um deploy de prévia na Vercel.
- Segredos só em variáveis de ambiente. O repositório traz apenas o `.env.example`.

### Testes

| Nível | Ferramenta | O que cobre |
| --- | --- | --- |
| Unitário | Vitest | Conversão de graus e tons e gramática de acordes; quebra da cifra em pares; slugs (RN03, RN13, RN15); filtro de busca e escape; datas em `America/Sao_Paulo`; `autorizar` (papel × ação). |
| Integração | Vitest, com PostgreSQL 16 real (Docker local e *service container* na CI; o `docker compose build` também roda na CI, para o `Dockerfile` não quebrar sem aviso) | Cada rota por papel (coordenador, ministeriado, convidado, conta desativada e sem sessão); `versao` e `409 CONFLITO_VERSAO`; histórico (gravar e restaurar); convite consumido uma só vez em requisições simultâneas; exclusão de conta (RN83); limite de tentativas; as regras do `DDL.sql`. |
| Ponta a ponta | Playwright (Chromium, em tela de celular e de computador) | Convite, cadastro com código e login; montar o setlist, reordenar e escalar; confirmar presença; exportar PDF; abrir offline. |

Os testes de integração usam um banco criado a partir do `DDL.sql`, o que também valida o próprio DDL. Neles, a camada de e-mail é trocada por um *stub* que guarda o código enviado.

### Critério de pronto

Um requisito está pronto quando:

1. a regra está implementada e tem teste;
2. a autorização foi testada para cada papel;
3. `typecheck`, `lint` e os testes passam na CI;
4. a tela funciona no celular e pelo teclado;
5. o `DDL.sql`, a migração e este README foram atualizados, quando mudaram;
6. não há segredo, e-mail real nem dado pessoal no código, nos testes ou nos logs.

### Integração contínua

Um workflow do GitHub Actions (`.github/workflows/ci.yml`) roda a cada push e pull request: `npm ci`, `tsc --noEmit`, lint, `prisma validate`, criação de um PostgreSQL 16 limpo com o `DDL.sql` e os testes unitários e de integração. Os testes ponta a ponta rodam nos pull requests para a `main`. O Dependabot (`.github/dependabot.yml`) abre atualizações toda semana, e o `npm audit` reprova a CI diante de vulnerabilidade alta ou crítica.

### Acessibilidade e idioma

O app segue o nível AA do WCAG 2.1: contraste suficiente, tudo operável pelo teclado, rótulos nos campos, foco visível e alvos de toque de pelo menos 44 px (o uso no palco é com pouca luz e pressa). A interface, as mensagens e os formatos são em português do Brasil: datas como `18/10/2026 19:00`, em `America/Sao_Paulo` (RNF16).

## Deploy

- **Supabase:** crie o projeto na região de São Paulo e execute o `DDL.sql` no *SQL Editor* (as extensões `pg_trgm` e `unaccent` estão disponíveis).
- **Vercel:** projeto único, com deploy automático a cada push no GitHub. Cadastre as variáveis acima em *Settings → Environment Variables*. O `vercel.json` agenda a rota `/api/cron/diario` uma vez por dia.
- **Contêiner (alternativa):** o mesmo app roda em uma VPS com Docker Compose ou Coolify, com proxy HTTPS, rotina diária própria e banco do compose ou externo. Veja [Rodando em contêiner](#rodando-em-contêiner-opcional).
- **Conexão serverless:** em `DATABASE_URL`, use a conexão do **pooler** do Supabase com `?pgbouncer=true`.
- **Primeiro acesso:** cadastre `SETUP_TOKEN` no ambiente, abra `/primeiro-acesso` logo depois do primeiro deploy e crie o coordenador (RN105). Não deixe o sistema sem contas e sem o token à vista: quem o tiver pode criar o primeiro coordenador. Ligue o segundo fator em seguida.
- **Termos e privacidade:** antes do deploy, escreva `/documentos/termos-de-uso` e `/documentos/politica-privacidade` e revise com um advogado. Sem o aceite, o cadastro não conclui (RN84).
- **Google:** no Google Cloud, configure a tela de consentimento com os escopos `openid`, `email` e `profile` e publique o app, saindo do modo Teste. O modo Teste limita a 100 usuários e faz os tokens de atualização expirarem em 7 dias. Esses escopos não exigem verificação do Google.
- **E-mail:** crie a conta no Resend, verifique o domínio de envio nos registros DNS e cadastre `RESEND_API_KEY` e `EMAIL_FROM`. O plano gratuito envia a qualquer destinatário, mas só a partir de um domínio verificado.
- **Backup:** um workflow agendado do GitHub Actions (semanal) roda `pg_dump` com a conexão direta do Supabase (`DIRECT_URL`, não o pooler), cifra o arquivo (por exemplo, com `age`) e o guarda como artefato do workflow, com prazo de retenção definido. Teste a restauração em um banco vazio antes do uso real e depois de tempos em tempos: um backup que nunca foi restaurado não é garantia.
- **Ambientes:** desenvolvimento (Docker) e produção (Supabase). Os deploys de prévia da Vercel usam um segundo projeto do Supabase, nunca o banco de produção.
- **Região:** as funções da Vercel rodam em `gru1` (São Paulo), perto do banco, o que se configura no `vercel.json`.
- **Verificação depois do deploy:** entrar, abrir um setlist, exportar um PDF, instalar o app e receber um push. Se algo falhar, a Vercel permite voltar para o deploy anterior.

