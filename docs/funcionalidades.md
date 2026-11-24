# Funcionalidades

## Usuários, papéis e permissões

| Papel | O que pode |
|---|---|
| **Coordenador** | Convida pessoas (inclusive convidados de evento), altera o cargo de qualquer usuário, cria e cancela eventos, desativa e reativa contas. Não apaga contas, não vê e-mails e não altera nome, foto ou instrumentos de outras pessoas (RN05). |
| **Ministeriado** | Usa o app como músico, dentro das permissões de qualquer membro ativo (abaixo). |
| **Convidado** | Vê tudo o que um membro vê, mas não edita nada (veja [Convidados de evento](#convidados-de-evento)). |

**Qualquer membro ativo** pode:

- cadastrar e editar músicas e cifras, e definir o tom de uma música no setlist;
- marcar e desmarcar músicas para revisão;
- publicar setlists de eventos;
- criar listas, editar as que são suas ou que foram compartilhadas com elas, e compartilhá-las;
- criar e editar instrumentos, e cadastrar e renomear artistas;
- alterar nome, e-mails, senha, foto e os instrumentos que toca, e apagar a própria conta;
- marcar seu status de escuta e confirmar presença.

**Qualquer usuário logado**, ativo, desativado ou convidado, vê o dashboard e os dados do app. Os membros, ativos ou não, confirmam presença; o convidado confirma nos eventos a que foi convidado.

## Convites e primeiro acesso

Coordenadores geram um **link de convite** e o enviam à pessoa. O link tem o cargo que a pessoa terá (ministeriado ou coordenador), é de uso único e vale 7 dias. Não há e-mail do convidado, e quem convida só escolhe o cargo. Logo após gerar o link, quem o criou vê a contagem do tempo restante até a expiração.

1. A pessoa abre o link, informa nome completo, e-mail e senha e pede o código. O código de 6 dígitos chega ao e-mail; ela o digita e a conta é criada com o cargo do convite, já logada. O convite só é consumido nesse momento.
2. Se o e-mail já tem conta, a resposta é a mesma de um pedido novo ("código enviado"), para não revelar quais e-mails estão cadastrados (RN71). No lugar do código, o dono da conta recebe um aviso de que alguém tentou usar o e-mail, com a orientação de entrar e abrir o link de novo, se foi ele.
3. No primeiro login, a pessoa escolhe os instrumentos que toca (zero ou mais) e pode alterá-los depois.

O **primeiro coordenador** não vem de convite, porque ainda não há quem convide: é criado em `/primeiro-acesso`, que só existe enquanto o sistema não tem nenhuma conta e exige o `SETUP_TOKEN` do ambiente (RN106). A pessoa informa o token, nome completo, e-mail (confirmado por código), senha e o nome do ministério, e aceita os termos. Não há conta nem senha padrão, e depois da criação a rota deixa de existir.

## Identidade do ministério

O app leva o **nome** e a **logo** do ministério. O nome aparece na tela de login, no título das páginas, no manifesto do PWA e nos e-mails; a logo, no login e no cabeçalho.

- O valor inicial vem do ambiente (`NOME_MINISTERIO` e `LOGO_MINISTERIO_PATH`) e é gravado em `configuracoes_app` na primeira subida.
- Depois, os coordenadores alteram o nome e enviam, trocam ou removem a logo em `/coordenacao`. Valem as regras de RN105, e o ambiente não sobrescreve o que foi salvo.
- `GET /api/publico/ministerio` devolve o nome e o endereço da logo, sem sessão, para a tela de login.

## Convidados de evento

Permite que alguém de fora do ministério participe de um evento.

1. Um coordenador gera o **link de convite do evento**. Ele vale 7 dias e é de uso único.
2. A pessoa abre o link e cria a conta (ou, se já é convidada, entra e abre o link). Ela é registrada como convidada do evento, em `eventos_convidados`.
3. A conta tem papel `CONVIDADO` e fica depois do evento. Pode ser convidada para outros eventos e, se virar ministeriada, passa ao papel de ministeriado.

| O convidado | |
|---|---|
| Vê | Tudo o que um membro vê: dashboard, biblioteca, listagens, busca, usuários, eventos, setlists, cifras e presença. |
| Faz | Cuida da própria conta, escolhe seus instrumentos nas configurações de perfil, confirma a própria presença nos eventos a que foi convidado e ativa as notificações. |
| Não faz | **Editar qualquer coisa**: músicas, cifras, tons, listas, eventos, artistas e instrumentos, marcar revisão e criar listas. |

Cada rota de gravação da API confere o papel e recusa o convidado, exceto nas ações da própria conta, nos instrumentos e na presença. O convidado não conta nos números do dashboard. O acesso dele dura enquanto estiver em ao menos um evento, e o coordenador o encerra removendo-o dos eventos (RN10). A página do convidado só é vista por quem a RN59 permite.

## Dashboard e listagens

Página inicial do app para **todos os usuários logados**, inclusive convidados (que só leem).

### Indicadores

| Indicador | O que mostra |
|---|---|
| **Músicos** | Contas ativas. |
| **Músicas** | Todas as músicas cadastradas. |
| **Para revisão** | Músicas marcadas para revisão. |
| **Músicos por instrumento** | Contas ativas que tocam cada instrumento. Quem toca dois instrumentos entra nos dois, e instrumentos sem músicos aparecem com zero. Cada barra leva à página do instrumento. |
| **Próximos eventos** | Nome, data e hora, e os botões **Vou** e **Não vou** (a resposta pode ser trocada). Cada item leva à página do evento. |
| **Mais tocadas** | As 5 músicas e os 5 artistas com mais execuções no período. |
| **Menos tocadas** | As 5 músicas e os 5 artistas com menos execuções no período, incluindo as nunca tocadas. |

Os números em destaque aparecem como cartões, os músicos por instrumento como um gráfico de barras horizontais e os mais e menos tocados como listas curtas, que levam às listagens completas. Um seletor troca o período entre **este mês** e **este ano**.

### Listagens

Cada tipo de item tem uma página de listagem, com **30 itens por página** e paginação. Os destaques do dashboard levam a essas listagens, já com a ordenação aplicada.

| Página | Busca | Filtros e ordenação |
|---|---|---|
| **Músicas** (`/musicas`) | Título e artista | Colunas: título, artistas, tom original e última execução. Filtro por artista. Ordem A–Z ou Z–A. Ordem por **mais** ou **menos tocada**, com seletor de período. |
| **Artistas** (`/artistas`) | Nome | Ordem A–Z ou Z–A. Ordem por **mais** ou **menos tocado**, com seletor de período. |
| **Instrumentos** (`/instrumentos`) | — | Ordem A–Z ou Z–A. |
| **Usuários** (`/usuarios`) | Nome | Ordem A–Z ou Z–A. |
| **Listas** (`/listas`) | Nome | Ordem A–Z ou Z–A. |
| **Eventos** (`/eventos`) | Nome | Filtro por data. Ordem A–Z ou Z–A, ou por data (mais recente ou mais antiga). |

O seletor de período de músicas e artistas tem: **mês** (o atual), **ano** (o atual), **geral** ou um **mês ou ano específico**.

### Como se conta

Uma música é **tocada** quando está no setlist publicado de um evento que já aconteceu e não foi cancelado, uma vez por evento. As execuções de um artista são a soma das execuções das músicas dele. As nunca tocadas entram com zero.

A view `vw_execucoes` tem uma linha por música tocada em cada evento. A contagem de um período filtra essa view pela data do evento, em uma consulta como esta (músicas):

```sql
SELECT m.id, m.titulo, m.slug, COUNT(x.evento_id)::INTEGER AS execucoes
FROM musicas m
LEFT JOIN vw_execucoes x ON x.musica_id = m.id
                        AND x.data_evento >= :inicio AND x.data_evento < :fim
WHERE (:artista_id IS NULL OR EXISTS (
         SELECT 1 FROM musica_artistas ma
         WHERE ma.musica_id = m.id AND ma.artista_id = :artista_id))
GROUP BY m.id, m.titulo, m.slug
ORDER BY execucoes DESC, busca_norm(m.titulo), m.id;   -- execucoes ASC para as menos tocadas
```

Para mês, ano ou um mês ou ano específico, `:inicio` e `:fim` são o primeiro dia do período e o primeiro dia do período seguinte. No período **geral** o filtro de datas é omitido. A API faz essas consultas direto nas tabelas, sem views de ranking. A contagem de artistas segue a mesma ideia, juntando `artistas`, `musica_artistas` e `vw_execucoes`.

O dashboard é servido por `GET /api/dashboard`, e cada listagem pela própria rota do seu tipo (veja a tabela de endpoints). Como o resto do app, o dashboard pode ser consultado offline com os últimos dados carregados. Os números saem de consultas do Prisma (contagens e próximos eventos) e as execuções, de `$queryRaw`; só `vw_execucoes` e `vw_ultima_execucao` existem como views.

## Músicas

### Biblioteca

Há uma única biblioteca de músicas, sem divisão por períodos. A ordem de grandeza é de pelo menos 500 músicas, e a busca por título e artista precisa continuar fluida (índice de busca por similaridade no banco).

Uma música tem **título**, **um ou mais artistas** (o primeiro, pela ordem, dá o slug), **cifra** (em graus), **tom original** (opcional, só informativo), **link do YouTube** (opcional) e a marca de revisão. **Não tem músicos**: estes existem apenas nos setlists. O tom tocado é definido apenas nos setlists e listas. A música não guarda arquivos de áudio.

### Cadastro

O botão **"+"** abre o formulário de nova música. Ao digitar o título, o app avisa se já existe uma música parecida ("Já existe 'Segura na Mão de Deus'. Usar essa?"). A API não aceita duas músicas com o mesmo título e o mesmo conjunto de artistas.

O formulário tem título, artistas, **tom original** (opcional, só informativo), cifra e link do YouTube (opcional).

### Edição e versões

Qualquer membro ativo edita uma música. Cada música tem um número de versão: a gravação só é aceita se a versão que a pessoa leu ainda for a atual. Se outra pessoa alterou antes, a API responde `409 CONFLITO_VERSAO` e o app mostra o aviso.

Cada gravação que muda a cifra, o tom original, os artistas ou o tom tocado pede um título. A versão fica no **histórico** da música, com autor e data: a tela mostra cada versão, permite compará-la com a atual e voltar a ela. Voltar também cria um ponto novo no histórico (RN90). Título, link e nome de artista podem ser alterados sem gerar versão.

### Apagar

Uma música que aparece em algum setlist ou lista não pode ser apagada (o banco impede), e continua no histórico dos eventos. Uma música que não está em nenhuma coleção pode ser apagada.

### Revisão

Qualquer membro ativo pode **marcar e desmarcar** uma música para revisão. É só uma marca, sem campo de motivo. O dashboard mostra quantas músicas estão marcadas.

### Status de escuta

Cada usuário marca, por música, **Não ouvi** (padrão), **Ouvi** ou **Toquei**.

### Última vez tocada

A tela da música e a listagem mostram quando a música foi tocada pela última vez, calculado a partir dos eventos (`vw_ultima_execucao`).

### Artistas

O artista tem tabela própria, com `nome` e `slug`, e uma página própria com as músicas dele. Compositores e intérpretes são artistas. Uma música pode ter mais de um artista, guardados em ordem na tabela `musica_artistas`.

## Eventos, setlists e listas

### Eventos

Um **evento** tem nome, data e hora, `slug` e a opção `requerir_presenca`. Coordenadores criam, editam e cancelam eventos. Um evento cancelado fica no histórico, sai dos próximos eventos e não conta nas execuções.

### Coleções: setlist e lista

Setlist e lista genérica compartilham a estrutura da **coleção**, diferenciada por `tipo`:

| | SETLIST | LISTA |
|---|---|---|
| Vinculada a | um evento (`evento_id`) | um ou mais donos (`listas_donos`) |
| Nome | o do evento | `nome` próprio |
| Publicação | `publicado` | não se aplica |
| Presença | pode exigir | não |
| Escala de músicos (por seção e por evento) | sim | não |
| Seções | sim | sim |
| Tom tocado e cifra local por música | sim | sim |
| Conta nas execuções | **sim** (se publicado e o evento já aconteceu) | não |

Uma coleção pode ter **seções** opcionais (por exemplo "Animação" e "Adoração"), nomeadas livremente. Cada seção pertence a uma única coleção.

### Edição de uma música dentro da coleção

1. A pessoa entra na música e edita o tom tocado e a cifra.
2. Clica em **Salvar** e escolhe: **[Salvar na música]**, **[Salvar só neste setlist]** ou **[Cancelar]**.
   - *Salvar na música*: a cifra editada passa a valer para a música, para todos.
   - *Salvar só neste setlist*: a cifra editada vale só neste setlist/lista.
   - O **tom tocado** fica sempre só no setlist ou na lista.
3. Se sair sem salvar, as mudanças são perdidas.

### Reordenar por arrastar e soltar

As **músicas** (dentro de uma seção ou entre seções) e as **seções** são reordenadas por drag-and-drop com [dnd-kit](https://dndkit.com).

O campo `ordem` é `DOUBLE PRECISION`. Ao soltar um item entre A e B, a nova ordem é a média `(A + B) / 2`, de modo que só **uma linha** é atualizada, sem renumerar a lista. Se a diferença entre vizinhos ficar pequena demais, a API renumera a coleção inteira.

### Copiar setlist

Em um setlist vazio, a pessoa pode **copiar o setlist de outro evento**. A cópia traz seções, músicas, tons e cifras locais, e depois é ajustada normalmente. Os músicos escalados não são copiados: a escala de seção e a do evento começam vazias.

## Escala de músicos

A escala existe **só nos setlists de eventos**, em dois níveis: por seção, na tabela `secao_musicos`, e por evento, na tabela `colecao_musicos`. Não há escala por música. Listas genéricas e a biblioteca não têm músicos.

**Por seção:** na seção, a pessoa escolhe o instrumento e depois uma pessoa que toque aquele instrumento (RF30, RN46). Se a seção já tem músicos, aparecem **Sobrescrever** e **Completar** (RF31, RN47). Escalar numa seção também inclui a pessoa na lista do evento, se ela ainda não estiver nela (RN92).

**Escala do evento:** a lista das pessoas escaladas para o evento, com os instrumentos que cada uma toca, aparece em `/eventos/[slug]`. Qualquer membro ativo, e os convidados dos eventos a que foram convidados, adiciona e remove pessoas dela (RF66, RN92). Os botões **Escalar todos** e **Escalar todos os <instrumento>** adicionam membros a ela (RF67, RN94). A lista não preenche as seções.

Uma pessoa pode ser escalada em mais de um evento na mesma data e hora, sem aviso (RF36, RN51).

## Confirmação de presença

A presença é por evento e por pessoa, e se aplica quando `requerir_presenca = true`:

- Ao publicar o setlist, todos os membros e os convidados do evento recebem um push pedindo a confirmação, **inclusive os desativados**.
- Cada pessoa responde **Vou** ou **Não vou** e pode **trocar a resposta a qualquer momento**. Quem não respondeu aparece como **pendente**.
- Todos os que veem o evento veem a resposta de cada pessoa.
- Na véspera, quem ainda não respondeu recebe um lembrete (veja [Notificações push](#notificações-push)).

Os botões **Vou** e **Não vou** também aparecem nos próximos eventos do dashboard. A confirmação aponta para o **evento**, não para a coleção.

## Notificações push

- Enviadas **quando o setlist é publicado**, para os membros e para os convidados do evento. Alterações posteriores não notificam.
- Enviadas aos **coordenadores quando uma conta é desativada**, pela própria pessoa ou por um coordenador (RN93).
- Se o evento exige presença, a notificação inclui o pedido de confirmação.
- **Lembrete diário:** uma rotina agendada (Vercel Cron) roda uma vez por dia e avisa quem ainda não respondeu aos eventos publicados, com presença exigida, do dia seguinte. A mesma rotina apaga os convites, os códigos de e-mail e os contadores de tentativas vencidos.
- No iPhone e no iPad, o push só funciona com o app instalado na tela inicial; o app avisa isso ao pedir a permissão.
- **Sem histórico** de notificações.
- Tecnologia: **Web Push API com VAPID**, sem Firebase. A chave pública fica no front (`NEXT_PUBLIC_VAPID_PUBLIC_KEY`) e a privada só no servidor.
- Fluxo: alguém publica → a rota serverless acorda → busca os `device_tokens` dos usuários → envia os pushes → volta a dormir.

Gere as chaves com `npx web-push generate-vapid-keys`.

## PWA e uso offline

- `manifest.json` e Service Worker registrados no layout raiz.
- **Offline é somente leitura**: o app mostra o que foi carregado (dashboard, músicas, cifras, eventos e setlists), e edições exigem conexão. Não há fila de sincronização.
- Atualização dos dados ao abrir o app ou recarregar a página.
- O cache é feito pelo service worker (por exemplo com Serwist): as páginas e as respostas `GET` da API já visitadas ficam guardadas e são atualizadas ao abrir o app (*stale-while-revalidate*). Não há banco de dados local.
- A leitura offline inclui a cifra, o tamanho da fonte e a rolagem automática, que não dependem de rede.

## Desativação e exclusão de contas

Desativar uma conta (`ativo = false`) tira a pessoa da **lista do evento e de todas as escalas de seção dos eventos futuros**. A pessoa continua vendo os dados e confirmando presença. Reativar a conta **não** a recoloca na escala.

Coordenadores podem desativar e reativar contas. A própria pessoa também pode desativar a conta dela, mas só um coordenador a reativa. Convidados não têm o campo `ativo`: para encerrar o acesso de um convidado, o coordenador o remove de todos os eventos a que foi convidado.

### Desativação pela própria pessoa

A pessoa desativa a própria conta em `/configuracoes/seguranca`, com confirmação pela senha. A conta não é apagada: ela fica inativa, sai da lista do evento e de todas as escalas dos eventos futuros e pode continuar vendo os dados e confirmando presença. Só um coordenador a reativa.

### Apagar a própria conta

A pessoa apaga a própria conta em `/configuracoes/seguranca`, com um aviso do que será perdido. A pessoa confirma com a senha e com **um** código: do app autenticador, de backup ou enviado por e-mail (RN104). O app confere os impedimentos antes de gastar o código: a única conta de coordenador não pode ser apagada. A exclusão é definitiva e segue RN83. Só a própria pessoa apaga a conta; coordenadores só desativam e reativam.

### Conta e segurança

Em `/configuracoes/seguranca`, a pessoa vê e troca o e-mail principal, adiciona, troca ou remove o de recuperação, troca a senha, liga o segundo fator, gera os códigos de recuperação, desativa e apaga a própria conta. A recuperação de senha ("esqueci a senha") fica na tela de login.

### Segundo fator (app autenticador)

Opcional para todos e obrigatório para coordenadores (RN103). A pessoa pode usar qualquer app autenticador (Google Authenticator, Authy, 1Password etc.).

1. **Ligar:** `/configuracoes/seguranca` mostra o QR code e o segredo para digitar. A pessoa informa a senha e o primeiro código do app. Só então o segundo fator vale, e o app mostra uma vez os 10 códigos de backup.
2. **Entrar:** e-mail e senha, depois o código de 6 dígitos (RN107). Um código de backup serve no lugar do app, uma única vez.
3. **Perdi o celular:** com um código de backup a pessoa entra e liga o app de novo. Sem eles, um coordenador redefine o segundo fator dela (RF78), e ela o liga outra vez.
4. **Desligar:** exige a senha e um código. Coordenadores não desligam.

Os momentos em que cada comprovação entra:

| Momento | Comprovação | Código por e-mail? |
| --- | --- | --- |
| Login normal | senha, e o código do app se ligado | Não |
| Ligar o segundo fator | senha e primeiro código do app | Não |
| Esqueci a senha | código no e-mail ou de recuperação | Sim, e não pula o segundo fator |
| Trocar ou adicionar e-mail | senha, código do app se ligado e código ao endereço novo | Sim, no endereço novo |
| Apagar a conta | senha e um código (app, backup ou e-mail) | Opcional |
| Cadastro por convite | código no e-mail informado | Sim |

