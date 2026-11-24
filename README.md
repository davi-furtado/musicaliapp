# MusicaliAPP

PWA para organizar a biblioteca de músicas, os eventos e os setlists de um ministério de música. Funciona no celular como um aplicativo instalável, atualiza ao ser aberto e pode ser consultado offline.

## Documentação

| Documento | Conteúdo |
| --- | --- |
| [docs/requisitos.md](docs/requisitos.md) | Requisitos funcionais e não funcionais (RF, RNF) e regras de negócio (RN). |
| [docs/funcionalidades.md](docs/funcionalidades.md) | Papéis, convites, dashboard, músicas, eventos, setlists, escala, presença, push, PWA e exclusão de contas. |
| [docs/cifra.md](docs/cifra.md) | Cifra em graus, padrão de escrita, tons e tutorial de acordes. |
| [docs/arquitetura.md](docs/arquitetura.md) | Stack, decisões de arquitetura e modelo de dados. |
| [docs/api.md](docs/api.md) | Esquema de URLs, busca e ordenação, API e Swagger. |
| [docs/desenvolvimento.md](docs/desenvolvimento.md) | Estrutura de pastas, execução local, variáveis de ambiente, testes e deploy. |
| [docs/seguranca-e-privacidade.md](docs/seguranca-e-privacidade.md) | Segurança e LGPD. |
| [docs/sprints.md](docs/sprints.md) | Sprints e milestones. |
| [DDL.sql](DDL.sql) | Modelo de dados em SQL (PostgreSQL 13+), a fonte da verdade do banco. |

## Visão geral

- Mantém uma **biblioteca de músicas** com a cifra escrita em **graus do campo harmônico**, que o app mostra em qualquer tom.
- Organiza **eventos** (missas, ensaios, retiros) e **setlists**, com seções, escala de músicos e tom tocado em cada evento.
- Mostra um **dashboard** com os números do ministério, os próximos eventos e os mais e menos tocados de músicas e artistas, visível a todos os membros.
- Permite **convidar pessoas de fora** para participarem de um evento. Elas veem tudo no app, mas não editam nada.
- Atualiza os dados quando o app é aberto ou a página é recarregada.
- Funciona offline **somente para leitura**, com cache do que já foi carregado.
- Avisa por notificação push quando um setlist é **publicado** e lembra de confirmar presença na véspera.
- Cada usuário, artista, instrumento, evento, música e lista tem uma página própria, acessada por um `slug` amigável, com um botão **Compartilhar**.
- Cada conta tem de um a três e-mails, confirmados por código. A pessoa pode também entrar com Google e apagar a própria conta. A senha pode ser recuperada por código enviado ao e-mail ou por códigos de recuperação guardados pela própria pessoa.


Os requisitos têm identificadores estáveis: **RF** (funcional), **RNF** (não funcional) e **RN** (regra de negócio). Tudo no app está em português do Brasil.

## Stack

Next.js 15 (App Router) + React 19 + TypeScript, PostgreSQL (Supabase em produção) com Prisma 6, autenticação própria com JWT, Vitest e Playwright, deploy na Vercel. Detalhes em [docs/arquitetura.md](docs/arquitetura.md).

## Rodando localmente

Pré-requisitos: Node.js 20+ e Docker. O passo a passo completo (Postgres, dependências, `.env`, DDL, Prisma e primeiro acesso) está em [docs/desenvolvimento.md](docs/desenvolvimento.md#rodando-localmente).

```bash
docker run --name musicaliapp-db -e POSTGRES_PASSWORD=dev -e POSTGRES_DB=musicaliapp \
  -p 5432:5432 -d postgres:16
psql "postgresql://postgres:dev@localhost:5432/musicaliapp" -f DDL.sql
npm run dev
```

O app também roda em **contêiner** (`docker compose up -d --build`), sem a Vercel. Veja [Rodando em contêiner](docs/desenvolvimento.md#rodando-em-contêiner-opcional).

## Glossário

| Termo | Significado |
| --- | --- |
| Cifra | A música escrita com acordes sobre a letra. Fica guardada em graus. |
| Grau | O acorde pela posição no campo harmônico (`1`, `4`, `5`, `6m`…). Não depende do tom. |
| Tom original | O tom em que a música costuma ser tocada ou foi escrita. Opcional e só informativo. |
| Tom tocado | O tom escolhido para uma música em um setlist ou lista. Vale só ali. |
| Evento | Missa, ensaio ou retiro, com data e hora. |
| Setlist | O repertório de um evento, no máximo um por evento. |
| Lista | Um repertório avulso, sem evento, com um ou mais donos. Com **Edição pública**, todo membro ativo a edita. |
| Coleção | O que o setlist e a lista têm em comum: seções e músicas em ordem. |
| Seção | Agrupamento dentro de uma coleção ("Animação", "Adoração"). |
| Marcador de seção | A linha `[Refrão]` ou `[Verso 1]` dentro da cifra. Não é a seção da coleção. |
| Execução | Uma música tocada no setlist publicado de um evento que já aconteceu (RN24). |
| Ministeriado e coordenador | Cargos de membro. O coordenador convida e gerencia eventos e contas (RN05). |
| Convidado | Pessoa de fora, convidada para eventos. Vê tudo e não edita (RN55). |
| Slug | Parte legível da URL (`/musicas/<slug>`). Acompanha o nome (RN13). |
| Versão do histórico | Um ponto do histórico da música, com título, autor e data (RN90). |
| `versao` (contador) | Número que detecta edições simultâneas (RN38). Não é o histórico. |
