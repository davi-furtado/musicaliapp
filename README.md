# MusicaliAPP

PWA para organizar a biblioteca de músicas, os eventos e os setlists de um ministério de música. Funciona no celular como um aplicativo instalável, atualiza ao ser aberto e pode ser consultado offline.

## Sumário

1. [Visão geral](#visão-geral)
2. [Requisitos](#requisitos)
3. [Regras de negócio](#regras-de-negócio)
4. [Usuários, papéis e permissões](#usuários-papéis-e-permissões)
5. [Convites e primeiro acesso](#convites-e-primeiro-acesso)
6. [Convidados de evento](#convidados-de-evento)
7. [Dashboard e rankings](#dashboard-e-rankings)
8. [Músicas](#músicas)
9. [Cifra, graus e tons](#cifra-graus-e-tons)
10. [Eventos, setlists e listas](#eventos-setlists-e-listas)
11. [Escala de músicos](#escala-de-músicos)
12. [Confirmação de presença](#confirmação-de-presença)
13. [Notificações push](#notificações-push)
14. [PWA e uso offline](#pwa-e-uso-offline)
15. [Desativação de contas](#desativação-de-contas)
16. [Stack técnica](#stack-técnica)
17. [Modelo de dados](#modelo-de-dados)
18. [API e Swagger](#api-e-swagger)
19. [Estrutura de pastas](#estrutura-de-pastas)
20. [Rodando localmente](#rodando-localmente)
21. [Variáveis de ambiente](#variáveis-de-ambiente)
22. [Deploy](#deploy)
23. [Segurança](#segurança)
24. [Sprints e milestones](#sprints-e-milestones)

---

## Visão geral

- Mantém uma **biblioteca de músicas** com a cifra escrita em **graus do campo harmônico**, que o app mostra em qualquer tom.
- Organiza **eventos** (cultos, ensaios, retiros) e **setlists**, com seções, escala de músicos e tom tocado em cada evento.
- Mostra um **dashboard** com os números do ministério, os próximos eventos e os rankings de músicas e autores, visível a todos os membros.
- Permite **convidar pessoas de fora** para participarem de um evento, sem acesso ao resto do ministério.
- Atualiza os dados quando o app é aberto ou a página é recarregada.
- Funciona offline **somente para leitura**, com cache do que já foi carregado.
- Avisa por notificação push quando um setlist é **publicado** e lembra de confirmar presença na véspera.
- Cada usuário, autor, instrumento e evento tem uma página própria, acessada por um `slug` amigável.
- Cada pessoa pode ter vários e-mails e recuperar a senha por qualquer um deles verificado.

## Requisitos

### Requisitos funcionais

| ID | Requisito |
|---|---|
| **Acesso e contas** | |
| RF01 | Coordenadores e o admin geram links de convite com o cargo que a pessoa terá. O link vale 30 minutos e serve uma única vez. Ao gerar o link, quem o criou vê quanto tempo falta para ele expirar. |
| RF02 | Quem recebe o convite cria a conta (nome completo, e-mail, senha) e entra logado. |
| RF03 | Coordenadores e o admin geram o link de convite de **um evento** para uma pessoa de fora (convidado). |
| RF04 | Os usuários fazem login e logout. O botão **Lembrar de mim** vem marcado por padrão: marcado, o login fica salvo no aparelho e é renovado a cada acesso, sem prazo para expirar; desmarcado, vale só enquanto a sessão do navegador estiver aberta. |
| RF05 | Cada pessoa tem uma área de conta, onde altera nome, senha e **foto de perfil**. |
| RF06 | Cada pessoa escolhe e altera os instrumentos que toca (zero ou mais). |
| RF07 | Coordenadores e o admin alteram o cargo e os instrumentos de qualquer pessoa, inclusive tornando um convidado ministeriado. |
| RF08 | Coordenadores e o admin desativam e reativam contas. |
| RF09 | Cada usuário, autor, instrumento e evento tem página própria, acessada pelo `slug`. A página do instrumento lista os músicos que o tocam. |
| **Dashboard e rankings** | |
| RF10 | O dashboard mostra o número de músicos, o número de músicas e o número de músicas marcadas para revisão. |
| RF11 | O dashboard mostra o número de músicos por instrumento. |
| RF12 | O dashboard mostra os próximos eventos, com nome, data e hora e os botões **Vou** e **Não vou**. |
| RF13 | O dashboard mostra as 5 músicas e os 5 autores **mais tocados** e os 5 **menos tocados**, no mês ou no ano. |
| RF14 | Há uma página com o **ranking completo de músicas**, com filtro por autor e ordenação da mais ou da menos tocada. |
| RF15 | Há uma página com o **ranking completo de autores**, ordenado do mais ou do menos tocado. |
| RF16 | Os rankings aceitam o período **mês**, **ano**, **geral** ou um mês ou ano específico escolhido pela pessoa. |
| **Músicas** | |
| RF17 | Cadastrar uma música (título, autor, cifra, link do YouTube opcional), com aviso quando já existe uma parecida. |
| RF18 | Escrever a cifra em graus ou em um tom qualquer; o app a guarda sempre em graus. |
| RF19 | Ver a cifra em qualquer tom, transpor de meio em meio tom ou de tom em tom, aumentar a fonte e usar a **rolagem automática**, com a velocidade ajustável durante a rolagem. Só o botão pausa; rolar a tela com o dedo avança a música e não pausa. |
| RF20 | Editar qualquer música, com aviso quando outra pessoa a alterou antes. |
| RF21 | Marcar e desmarcar uma música para revisão. |
| RF22 | Marcar o status de escuta de uma música (Não ouvi, Ouvi, Toquei). |
| RF23 | Apagar as músicas que não estão em nenhum setlist ou lista. |
| RF24 | Buscar músicas por título e autor, vendo a última vez em que cada uma foi tocada. |
| RF25 | Criar, editar e apagar instrumentos e cadastrar autores. |
| **Eventos, setlists e listas** | |
| RF26 | Coordenadores criam, editam e cancelam eventos, com a opção de exigir confirmação de presença. |
| RF27 | Montar o setlist: adicionar músicas, criar seções e reordenar músicas e seções por arrastar e soltar. |
| RF28 | Definir, em cada música do setlist ou da lista, o tom que será tocado (opcional). |
| RF29 | Editar a cifra de uma música no setlist e escolher se a mudança vale só para o setlist ou para a música. |
| RF30 | Escalar os músicos de cada música do setlist (instrumento, depois pessoa). |
| RF31 | Escalar os músicos de uma **seção inteira**, com confirmação quando já há músicos definidos. |
| RF32 | Publicar o setlist de um evento. |
| RF33 | Copiar o setlist de outro evento. |
| RF34 | Criar listas genéricas de músicas, com seções e ordem. |
| RF35 | Confirmar presença com **Vou** ou **Não vou**, trocar a resposta quando quiser e ver a resposta de todos. |
| RF36 | Ao abrir uma música, ser avisado se um músico escalado não confirmou, e poder substituí-lo. |
| RF37 | Ser avisado ao escalar alguém que já está escalado em outro evento no mesmo horário. |
| RF38 | O convidado vê o evento a que foi convidado (setlist, cifras, escala e presença) e altera as músicas só dentro dele. |
| **Notificações e uso offline** | |
| RF39 | Receber push quando um setlist é publicado, com o pedido de presença quando houver. |
| RF40 | Receber um lembrete na véspera, se ainda não respondeu à presença. |
| RF41 | Consultar os dados já carregados sem conexão. |
| RF42 | Instalar o app na tela inicial do celular. |
| **API** | |
| RF43 | O admin consulta a documentação da API (Swagger). |
| **Conta e segurança** | |
| RF44 | Esqueci a senha: a pessoa informa um e-mail verificado da conta e recebe um link para criar nova senha. |
| RF45 | Cada conta pode ter vários e-mails, todos com o mesmo peso. A pessoa adiciona e verifica cada um, e qualquer um verificado serve para entrar ou recuperar a senha. |
| RF46 | Trocar a senha na tela de segurança, informando a senha atual. |
| RF47 | Desativar a própria conta na tela de segurança, com confirmação pela senha. Quem a reativa é um coordenador ou o admin. |
| RF48 | Só o admin altera o e-mail e a senha de outra pessoa. Ele adiciona, remove ou verifica e-mails de qualquer conta e envia o link de redefinição de senha para um e-mail verificado da pessoa, vendo quanto tempo falta para o link expirar. Coordenadores não fazem nenhuma dessas trocas. |

### Requisitos não funcionais

| ID | Requisito |
|---|---|
| RNF01 | O app é um PWA instalável e atualiza os dados ao ser aberto ou recarregado. |
| RNF02 | O uso offline é somente leitura. |
| RNF03 | A biblioteca comporta pelo menos 500 músicas, e a listagem, a busca e os rankings continuam fluidos. |
| RNF04 | Reordenar um item por arrastar e soltar atualiza uma única linha no banco. |
| RNF05 | Front e back em um único projeto Next.js com TypeScript no modo `strict`. |
| RNF06 | Banco PostgreSQL. |
| RNF07 | Notificações por Web Push com VAPID, sem Firebase. |
| RNF08 | Hospedagem apenas em Vercel, GitHub e Supabase, com deploy automático por push no GitHub. |
| RNF09 | Senhas com hash bcrypt e sessão em cookie `httpOnly`. |
| RNF10 | Toda autorização é verificada no servidor, por uma função central. |
| RNF11 | Não há histórico de notificações. |
| RNF12 | O banco não tem colunas de criação ou edição. As únicas datas são a do evento e a expiração do convite. |
| RNF13 | Edições concorrentes são detectadas por um contador de versão, sem sobrescrever em silêncio. |
| RNF14 | Fotos de perfil têm até 2 MB, em JPG, PNG ou WebP, e são redimensionadas no front antes do envio. |
| RNF15 | Login e aceitação de convite têm limite de tentativas. |

## Regras de negócio

### Contas e cargos

| ID | Regra |
|---|---|
| RN01 | O acesso é só por convite. A única exceção é a conta inicial, criada direto no banco. |
| RN02 | Um convite é de uso único, vale **30 minutos** (valor fixo, que quem convida não altera) e carrega o cargo da pessoa. Não tem e-mail: é um link. Quem gera o convite vê o tempo restante até a expiração. |
| RN03 | Cada e-mail é único no sistema e gravado em minúsculas. O `slug` de usuário, autor, instrumento e evento também é único. |
| RN04 | O cargo é `COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`. O admin (`is_admin`) é um indicador independente do cargo e não existe para convidados. |
| RN05 | Só coordenadores e o admin convidam, alteram cargos, criam eventos, desativam e reativam contas de outras pessoas. |
| RN06 | Conta desativada (`ativo = false`) só visualiza os dados e confirma presença. |
| RN07 | Desativar uma conta tira a pessoa da escala dos setlists de eventos futuros. Reativar não a recoloca. |
| RN08 | Todo usuário ativo pode editar cifra e tom, marcar revisão, escalar músicos, publicar setlists, criar e editar instrumentos, anexar a foto de perfil e escolher seus instrumentos. |
| RN09 | O campo de nome guarda o **nome completo**. |
| RN10 | Convidado não tem o campo `ativo` e não pode ser desativado. Seu acesso termina quando a pessoa é removida do evento. |
| RN11 | Um convidado vira ministeriado por um convite de ministeriado aceito com a conta logada, ou por atribuição de um coordenador ou do admin. |

### Slugs

| ID | Regra |
|---|---|
| RN12 | O `slug` usa minúsculas, números e hífens no lugar de espaços e acentos (`Violão` vira `violao`). |
| RN13 | O slug de instrumento acompanha o nome quando ele muda. Os de usuário, autor e evento ficam fixos depois de criados. |
| RN14 | O slug de evento é o nome mais a data (`missa-de-domingo-2026-10-12`), e recebe um sufixo numérico em caso de repetição. |
| RN15 | Nomes reservados pelas rotas (`admin`, `docs`, `api`, entre outros) não são aceitos como slug. |

### Instrumentos

| ID | Regra |
|---|---|
| RN16 | Não existem dois instrumentos com o mesmo nome, nem com caixa diferente ("Violão" e "violão"). |
| RN17 | Um instrumento novo fica disponível na hora, sem aprovação. |
| RN18 | Um instrumento que alguém toca, ou em que alguém está escalado, não pode ser apagado. |
| RN19 | A página de um instrumento mostra o total de contas ativas que o tocam, igual ao número do dashboard, e depois a lista delas. |

### Dashboard e rankings

| ID | Regra |
|---|---|
| RN20 | Todo membro logado vê o dashboard, inclusive com a conta desativada. Convidados não o veem. |
| RN21 | O **número de músicos** é a quantidade de contas ativas. Convidados não entram. |
| RN22 | O **número de músicas** é a quantidade de músicas cadastradas. |
| RN23 | O **número de músicos por instrumento** conta as contas ativas que tocam cada instrumento. Quem toca dois instrumentos entra nos dois, e um instrumento sem músicos aparece com zero. |
| RN24 | Uma música é **tocada** em um evento quando está no setlist **publicado** de um evento que já aconteceu e não foi cancelado. Cada evento conta uma vez por música. Listas não contam. |
| RN25 | As execuções de um **autor** são a soma das execuções das músicas dele. Autor sem música tocada aparece com zero. |
| RN26 | O período do ranking é o mês ou o ano do calendário, o histórico inteiro (geral) ou um mês ou ano específico. As datas são no horário local do ministério. |
| RN27 | "Mais tocadas" lista só quem tem ao menos uma execução. "Menos tocadas" inclui quem tem zero. Empates são desempatados pela ordem alfabética. |
| RN28 | Todas as músicas cadastradas entram nos rankings, inclusive as nunca tocadas. |
| RN29 | Os próximos eventos do dashboard são os que ainda vão acontecer e não foram cancelados, do mais próximo ao mais distante. |

### Músicas e cifras

| ID | Regra |
|---|---|
| RN30 | A música não tem tom nem músicos. A cifra é sempre guardada em graus. |
| RN31 | Quem escreve a cifra pode usar graus ou um tom qualquer. O front converte para graus antes de enviar. |
| RN32 | O tom só é salvo em uma música de **setlist ou lista**, e é opcional. Esse tom nunca altera a música. |
| RN33 | Em qualquer tela o front pode mostrar a cifra em outro tom. É só visualização e nada é gravado. A opção de transpose (meio tom ou tom em tom) só fica ativa com um tom de referência: na biblioteca, o tom escolhido para ver a música; no setlist, o tom tocado do item. Em graus do campo harmônico, fica desativada. |
| RN34 | Não existem duas músicas com o mesmo título (sem diferenciar maiúsculas) e o mesmo autor. Ao cadastrar, o app avisa sobre títulos parecidos. |
| RN35 | A marca de revisão é só sim ou não, sem motivo. Qualquer usuário ativo marca e desmarca. Convidados não marcam. |
| RN36 | O status de escuta é por usuário e por música, e o padrão é "Não ouvi". |
| RN37 | Uma música que aparece em algum setlist ou lista não pode ser apagada. Ela continua no banco e no histórico dos eventos. |
| RN38 | Cada música e cada item de setlist tem um número de versão. Se a versão mudou desde que a pessoa abriu a tela, a gravação é recusada com aviso. |
| RN39 | A música pode ter um link do YouTube, que é opcional. O app não guarda arquivos de áudio. |

### Eventos, setlists e listas

| ID | Regra |
|---|---|
| RN40 | Cada evento tem no máximo um setlist. Uma lista genérica pertence a um usuário e tem nome. |
| RN41 | Um evento cancelado fica no histórico, não aparece nos próximos eventos e não conta nos rankings. |
| RN42 | Uma coleção (setlist ou lista) pode ter seções opcionais, nomeadas livremente e ordenadas. Cada seção pertence a uma única coleção. |
| RN43 | Uma música no setlist ou na lista pode ter tom e cifra próprios. Mudanças locais não afetam a música por padrão. |
| RN44 | Ao salvar a cifra de uma música da coleção, a pessoa escolhe **Salvar na música**, **Salvar só neste setlist** ou **Cancelar**. O tom nunca é salvo na música. Sair sem salvar descarta as mudanças. |
| RN45 | A escala de músicos existe só nos setlists. Listas genéricas não têm músicos. |
| RN46 | Ao escalar, escolhe-se o instrumento e depois uma pessoa entre as que tocam aquele instrumento. Uma pessoa pode tocar mais de um instrumento na mesma música. |
| RN47 | Ao escalar uma **seção**, se alguma música dela já tem músicos, aparecem as opções **Sobrescrever existentes**, **Escrever nas que não têm** e **Cancelar**. A escala da seção é uma ação em massa: grava a escala em cada música, e a seção não guarda escala própria. |
| RN48 | Ao mover uma música para uma seção cujas músicas têm todas a mesma escala, aparecem as mesmas opções para aplicar essa escala à música movida. Se as escalas forem diferentes, nada é oferecido. |
| RN49 | A ordem das músicas e das seções é um número decimal. Ao soltar um item entre A e B, a nova ordem é `(A + B) / 2`, e a coleção é renumerada quando os vizinhos ficam próximos demais. |
| RN50 | Um setlist está publicado quando `publicado` é verdadeiro. |
| RN51 | **Copiar setlist** traz seções, músicas, tons, cifras locais e escala de outro evento para um setlist vazio. Pessoas com conta desativada ficam de fora da escala. |
| RN52 | Ao escalar uma pessoa que já está escalada em outro evento na mesma data e hora, aparece um aviso. O aviso não bloqueia. |

### Convidados

| ID | Regra |
|---|---|
| RN53 | O convite de convidado é sempre de **um evento** e é gerado por coordenador ou admin. |
| RN54 | O convidado cria conta (nome completo, e-mail, senha), tem área de conta e pode escolher seus instrumentos para ser escalado. |
| RN55 | O convidado vê tudo o que é do evento: setlist, seções, músicas com cifra e link, escala, presença e os convidados do evento. |
| RN56 | O convidado altera tom, cifra e escala só dentro do evento, sempre como **Salvar só neste setlist**. Não altera a música, não marca revisão e não cria instrumentos. |
| RN57 | O convidado não vê dashboard, biblioteca, rankings, lista de usuários, páginas de instrumentos nem eventos aos quais não foi convidado. |
| RN58 | O convidado aparece na busca de escala apenas dos eventos aos quais foi convidado. |
| RN59 | A conta do convidado permanece depois do evento e pode ser convidada para outros eventos. |
| RN60 | Um convidado é visto na página pública apenas por quem está no mesmo evento, pelos coordenadores e pelo admin. |

### Presença e notificações

| ID | Regra |
|---|---|
| RN61 | Se o evento exige presença, ao publicar o setlist todos os membros e os convidados do evento recebem o pedido de confirmação, inclusive os desativados. |
| RN62 | A resposta é **Vou** ou **Não vou**, pode ser trocada a qualquer momento e quem não respondeu aparece como pendente. Todos os que veem o evento veem a resposta de cada pessoa. |
| RN63 | Se um músico escalado não confirmou, ao abrir a música aparece "X não confirmou. Deseja substituir para este evento?". A substituição vale só para aquele evento. |
| RN64 | O push é enviado quando o setlist é publicado. Alterações posteriores não notificam. |
| RN65 | Uma vez por dia, quem ainda não respondeu a um evento publicado que exige presença e acontece no dia seguinte recebe um lembrete. |
| RN66 | Não há histórico de notificações. |

### Uso offline e API

| ID | Regra |
|---|---|
| RN67 | Offline só há leitura. Qualquer edição exige conexão. |
| RN68 | O Swagger e a especificação OpenAPI só são acessíveis ao admin. |
| RN69 | Toda rota decide o acesso por uma função central que considera o cargo, o estado `ativo` e, para convidados, o evento. |

### Conta, e-mails e desativação

| ID | Regra |
|---|---|
| RN70 | Cada conta tem um ou mais e-mails, todos com o mesmo peso. Não existe e-mail principal. |
| RN71 | Um e-mail pertence a uma única conta. Só serve para entrar ou recuperar a senha depois de verificado. |
| RN72 | Toda conta ativa tem pelo menos um e-mail verificado. O último e-mail verificado não pode ser removido. |
| RN73 | O pedido de "esqueci a senha" responde da mesma forma exista ou não a conta, para não revelar quais e-mails estão cadastrados. |
| RN74 | O link de redefinição de senha vale 30 minutos e serve uma única vez, igual ao convite. Quando o admin gera o link para outra pessoa (RF48), ele vê quanto tempo falta para a expiração. |
| RN75 | Trocar a senha exige a senha atual. |
| RN76 | A própria pessoa pode desativar a própria conta, na tela de segurança, com confirmação pela senha. Valem as mesmas regras de RN06 e RN07: ela sai da escala de eventos futuros e continua vendo os dados e confirmando presença. |
| RN77 | Só um coordenador ou o admin reativa uma conta desativada pela própria pessoa. Reativar não a recoloca na escala (RN07). |
| RN78 | Nenhuma conta é apagada pela aplicação. O histórico de eventos, escalas, presenças e rankings sempre permanece. |
| RN79 | Só o admin altera o e-mail e a senha de outra pessoa. Coordenadores não podem fazer isso. O admin não define senha manualmente: a troca de senha de outra pessoa é feita pelo link de redefinição enviado a um e-mail verificado dela (RN74). O admin tem acesso total ao banco, por isso a conta de admin deve ser restrita a quem é de confiança. |

## Usuários, papéis e permissões

| Papel | O que pode |
|---|---|
| **Admin** (`is_admin`) | Acessa o Swagger e a especificação da API. Pode tudo o que um coordenador pode. |
| **Coordenador** | Convida pessoas (inclusive convidados de evento) e define o cargo delas, altera o cargo e os instrumentos de qualquer usuário, cria e cancela eventos, desativa e reativa contas. |
| **Ministeriado** | Usa o app como músico, dentro das permissões de qualquer usuário ativo (abaixo). |
| **Convidado** | Acessa apenas os eventos a que foi convidado (veja [Convidados de evento](#convidados-de-evento)). |

**Qualquer usuário ativo** pode:

- cadastrar e editar músicas e cifras, e definir o tom de uma música no setlist;
- marcar e desmarcar músicas para revisão;
- escalar músicos nos setlists e publicar setlists de eventos;
- criar e editar instrumentos e autores;
- alterar nome, e-mails, senha, foto e os instrumentos que toca;
- marcar seu status de escuta e confirmar presença.

**Qualquer membro logado**, ativo ou não, vê o dashboard e os dados do app, e confirma presença.

## Convites e primeiro acesso

Coordenadores e o admin geram um **link de convite** e o enviam à pessoa. O link tem o cargo que a pessoa terá (ministeriado ou coordenador), é de uso único e vale 30 minutos. Não há e-mail do convidado, e quem convida só escolhe o cargo. Logo após gerar o link, quem o criou vê a contagem do tempo restante até a expiração.

1. A pessoa abre o link e informa nome completo, e-mail e senha. O sistema cria a conta com o cargo do convite e já deixa a pessoa logada.
2. Se o e-mail já tem conta, a API responde `409 CONTA_EXISTENTE` e o app orienta a fazer login e abrir o link de novo.
3. No primeiro login, a pessoa escolhe os instrumentos que toca (zero ou mais) e pode alterá-los depois.

A conta inicial (admin e coordenador) é criada direto no banco, porque ainda não há quem convide. Veja [Rodando localmente](#rodando-localmente).

## Convidados de evento

Permite que alguém de fora do ministério participe de um evento.

1. Um coordenador ou o admin gera o **link de convite do evento**. Ele vale 30 minutos e é de uso único.
2. A pessoa abre o link e cria a conta (ou, se já é convidada, entra e abre o link). Ela ganha acesso ao evento, registrado em `eventos_convidados`.
3. A conta tem papel `CONVIDADO` e fica depois do evento. Pode ser convidada para outros eventos e, se virar ministeriada, passa ao papel de ministeriado.

| O convidado | |
|---|---|
| Vê | O evento: setlist, seções, músicas com cifra e link do YouTube, escala, presença e os outros convidados. |
| Faz | Confirma a própria presença, escolhe seus instrumentos e altera tom, cifra e escala **só dentro do evento**. |
| Não faz | Alterar a música, marcar revisão, criar instrumentos, ver o dashboard, a biblioteca, os rankings, os usuários e outros eventos. |

Cada rota da API confere o papel e, para convidados, se o evento está em `eventos_convidados`. O convidado não conta nos números do dashboard.

## Dashboard e rankings

Página inicial do app para **todos os membros logados**. Convidados não a veem.

### Indicadores

| Indicador | O que mostra |
|---|---|
| **Músicos** | Contas ativas. |
| **Músicas** | Todas as músicas cadastradas. |
| **Para revisão** | Músicas marcadas para revisão. |
| **Músicos por instrumento** | Contas ativas que tocam cada instrumento. Quem toca dois instrumentos entra nos dois, e instrumentos sem músicos aparecem com zero. Cada barra leva à página do instrumento. |
| **Próximos eventos** | Nome, data e hora, e os botões **Vou** e **Não vou** (a resposta pode ser trocada). Cada item leva à página do evento. |
| **Mais tocadas** | As 5 músicas e os 5 autores com mais execuções no período. |
| **Menos tocadas** | As 5 músicas e os 5 autores com menos execuções no período, incluindo as nunca tocadas. |

Os números em destaque aparecem como cartões, os músicos por instrumento como um gráfico de barras horizontais e os rankings como listas curtas. Um seletor troca o período dos rankings entre **este mês** e **este ano**.

### Rankings completos

Duas páginas, ligadas aos rankings do dashboard por um botão "Ver ranking completo":

| Página | Conteúdo |
|---|---|
| **Músicas** | Todas as músicas com o número de execuções. Filtro por autor. Ordenação da **mais tocada** ou da **menos tocada**. |
| **Autores** | Todos os autores com o número de execuções. Ordenação do **mais tocado** ou do **menos tocado**. |

As duas têm seletor de período: **mês** (o atual), **ano** (o atual), **geral** ou um **mês ou ano específico**, escolhido em um seletor.

### Como se conta

Uma música é **tocada** quando está no setlist publicado de um evento que já aconteceu e não foi cancelado, uma vez por evento. As execuções de um autor são a soma das execuções das músicas dele. As nunca tocadas entram com zero.

A view `vw_execucoes` tem uma linha por música tocada em cada evento. O ranking de um período filtra essa view pela data do evento, em uma consulta como esta (músicas):

```sql
SELECT m.id, m.titulo, a.nome AS autor, COUNT(x.evento_id)::INTEGER AS execucoes
FROM musicas m
LEFT JOIN autores a      ON a.id = m.autor_id
LEFT JOIN vw_execucoes x ON x.musica_id = m.id
                        AND x.data_evento >= :inicio AND x.data_evento < :fim
WHERE (:autor_id IS NULL OR m.autor_id = :autor_id)
GROUP BY m.id, m.titulo, a.nome
ORDER BY execucoes DESC, m.titulo;   -- execucoes ASC para as menos tocadas
```

Para mês, ano ou um mês ou ano específico, `:inicio` e `:fim` são o primeiro dia do período e o primeiro dia do período seguinte. No período **geral** o filtro de datas é omitido (as views `vw_ranking_musicas_geral` e `vw_ranking_autores_geral` já trazem esse caso). O ranking de autores segue a mesma ideia, juntando `autores`, `musicas` e `vw_execucoes`.

Tudo é servido por `GET /api/dashboard` e `GET /api/rankings/*`. Como o resto do app, o dashboard pode ser consultado offline com os últimos dados carregados.

## Músicas

### Biblioteca

Há uma única biblioteca de músicas, sem divisão por períodos. A ordem de grandeza é de pelo menos 500 músicas, e a busca por título e autor precisa continuar fluida (índice de busca por similaridade no banco).

Uma música tem **título**, **autor**, **cifra** (em graus), **link do YouTube** (opcional) e a marca de revisão. **Não tem tom nem músicos**: o tom é definido apenas nos setlists e listas, e os músicos apenas nos setlists. A música não guarda arquivos de áudio.

### Cadastro

O botão **"+"** abre o formulário de nova música. Ao digitar o título, o app avisa se já existe uma música parecida ("Já existe 'Segura na Mão de Deus'. Usar essa?"). O banco não aceita duas músicas com o mesmo título e o mesmo autor.

### Edição e versões

Qualquer usuário ativo edita uma música. Cada música tem um número de versão: a gravação só é aceita se a versão que a pessoa leu ainda for a atual. Se outra pessoa alterou antes, a API responde `409 CONFLITO_VERSAO` e o app mostra o aviso.

### Apagar

Uma música que aparece em algum setlist ou lista não pode ser apagada (o banco impede), e continua no histórico dos eventos. Uma música que não está em nenhuma coleção pode ser apagada.

### Revisão

Qualquer usuário ativo pode **marcar e desmarcar** uma música para revisão. É só uma marca, sem campo de motivo. O dashboard mostra quantas músicas estão marcadas.

### Status de escuta

Cada usuário marca, por música, **Não ouvi** (padrão), **Ouvi** ou **Toquei**.

### Última vez tocada

A tela da música e a listagem mostram quando a música foi tocada pela última vez, calculado a partir dos eventos (`vw_ultima_execucao`).

### Autores

O autor tem tabela própria, com `nome` e `slug`, e uma página pública com as músicas dele.

## Cifra, graus e tons

A cifra é guardada **em graus do campo harmônico**, no estilo do Nashville Number System, e o app a mostra em qualquer tom.

| Em graus | Significado |
|---|---|
| `1`, `4`, `5` | Acordes sobre o primeiro, quarto e quinto graus. |
| `2m`, `3m`, `6m` | Acordes menores. |
| `b3`, `b7`, `#4` | Graus alterados. |
| `5sus4`, `1maj7`, `5/7` | Variações, extensões e baixo. |
| `1m` | Tônica menor (em música de tom menor, o grau `1` é sempre a tônica). |

### Formato

A cifra é um texto com os acordes entre colchetes, no ponto exato da letra em que mudam (por exemplo `[1]Senhor, [5]tu és [6m]fiel`). O front posiciona os acordes acima da letra, como em um site de cifras.

### Como funciona

- **Escrever:** a pessoa digita a cifra em graus ou em um tom qualquer e informa o tom em que digitou. O front converte tudo para graus antes de enviar. O banco recebe e guarda só graus.
- **Ler:** a tela da música mostra os graus. A pessoa escolhe um tom e o front converte na hora para as notas daquele tom. A escolha vale só para quem está vendo, e nada é gravado.
- **Tom do evento:** no setlist ou na lista, uma música pode ter um **tom tocado** (por exemplo, "no evento X tocamos esta música em D"). Quem abre o evento vê a cifra já nesse tom. Esse tom fica só no item do setlist e nunca altera a música. Em tom menor (`F#m`), a tônica (`F#`) é o que vale para a conversão.
- **Cifra local:** no setlist, a cifra pode ser editada só para aquele evento (também em graus), sem mudar a música.

### Tela de leitura

Na tela de uma música com cifra:

- **Tamanho da fonte:** botões para aumentar e diminuir.
- **Rolagem automática:** botão de iniciar e pausar, com botões de mais e menos velocidade que valem na hora, no estilo do Cifra Club. Só o botão pausa: rolar a tela com o dedo avança a música e não pausa.
- **Transpose:** botões de meio tom e de tom, para cima e para baixo, a partir do tom de referência (veja RN33). Desativado sem tom de referência e em graus.
- O tamanho da fonte e a velocidade ficam salvos no próprio aparelho, sem passar pelo servidor.

## Eventos, setlists e listas

### Eventos

Um **evento** tem nome, data e hora, `slug` e a opção `requerir_presenca`. Coordenadores criam, editam e cancelam eventos. Um evento cancelado fica no histórico, sai dos próximos eventos e não conta nos rankings.

### Coleções: setlist e lista

Setlist e lista genérica compartilham a estrutura da **coleção**, diferenciada por `tipo`:

| | SETLIST | LISTA |
|---|---|---|
| Vinculada a | um evento (`evento_id`) | um usuário (`usuario_id`) |
| Nome | o do evento | `nome` próprio |
| Publicação | `publicado` | não se aplica |
| Presença | pode exigir | não |
| Seções | sim | sim |
| Tom tocado e cifra local por música | sim | sim |
| **Escala de músicos** | **sim** | **não** |
| Conta nos rankings | **sim** (se publicado e o evento já aconteceu) | não |

Uma coleção pode ter **seções** opcionais (por exemplo "Animação" e "Adoração"), nomeadas livremente. Cada seção pertence a uma única coleção.

### Edição de uma música dentro da coleção

1. A pessoa entra na música e edita o tom tocado, a cifra e/ou, no setlist, a escala de músicos.
2. Clica em **Salvar** e escolhe: **[Salvar na música]**, **[Salvar só neste setlist]** ou **[Cancelar]**.
   - *Salvar na música*: a cifra editada passa a valer para a música, para todos.
   - *Salvar só neste setlist*: a cifra editada vale só neste setlist/lista.
   - O **tom tocado** e a **escala de músicos** ficam sempre só no setlist ou na lista.
3. Se sair sem salvar, as mudanças são perdidas.

### Reordenar por arrastar e soltar

As **músicas** (dentro de uma seção ou entre seções) e as **seções** são reordenadas por drag-and-drop com [dnd-kit](https://dndkit.com).

O campo `ordem` é `DOUBLE PRECISION`. Ao soltar um item entre A e B, a nova ordem é a média `(A + B) / 2`, de modo que só **uma linha** é atualizada, sem renumerar a lista. Se a diferença entre vizinhos ficar pequena demais, a API renumera a coleção inteira.

### Copiar setlist

Em um setlist vazio, a pessoa pode **copiar o setlist de outro evento**. A cópia traz seções, músicas, tons, cifras locais e a escala, e depois é ajustada normalmente. Quem está com a conta desativada não entra na escala copiada.

## Escala de músicos

A escala (quem toca cada música) existe **só nos setlists de eventos**, na tabela `colecao_musicas_musicos`. Listas genéricas e a biblioteca não têm músicos.

**Por música:** "Adicionar músico" → escolhe o instrumento → seleciona entre as pessoas que tocam aquele instrumento. Uma pessoa pode tocar mais de um instrumento na mesma música.

**Por seção:** na seção, a pessoa define os músicos que tocam nela. A ação grava a escala em cada música da seção.

- Se alguma música da seção já tem músicos definidos, aparece: **[Sobrescrever existentes]**, **[Escrever nas que não têm]** ou **[Cancelar]**.
- O mesmo acontece ao mover uma música para uma seção cujas músicas têm todas a mesma escala.
- A seção não guarda escala própria. A escala de cada música continua sendo a única fonte.

Ao escalar alguém que já está escalado em outro evento na mesma data e hora, aparece um aviso (que não bloqueia).

## Confirmação de presença

A presença é por evento e por pessoa, e se aplica quando `requerir_presenca = true`:

- Ao publicar o setlist, todos os membros e os convidados do evento recebem um push pedindo a confirmação, **inclusive os desativados**.
- Cada pessoa responde **Vou** ou **Não vou** e pode **trocar a resposta a qualquer momento**. Quem não respondeu aparece como **pendente**.
- Todos os que veem o evento veem a resposta de cada pessoa.
- Na véspera, quem ainda não respondeu recebe um lembrete (veja [Notificações push](#notificações-push)).
- Se um músico escalado numa música não confirmou, ao abrir a música aparece o aviso **"X não confirmou. Deseja substituir para este evento?"** com **[Substituir]** e **[Cancelar]**. A substituição vale só para aquele evento.

Os botões **Vou** e **Não vou** também aparecem nos próximos eventos do dashboard. A confirmação aponta para o **evento**, não para a coleção.

## Notificações push

- Enviadas **quando o setlist é publicado**, para os membros e para os convidados do evento. Alterações posteriores não notificam.
- Se o evento exige presença, a notificação inclui o pedido de confirmação.
- **Lembrete diário:** uma rotina agendada (Vercel Cron) roda uma vez por dia e avisa quem ainda não respondeu aos eventos publicados, com presença exigida, do dia seguinte.
- **Sem histórico** de notificações.
- Tecnologia: **Web Push API com VAPID**, sem Firebase. A chave pública fica no front (`NEXT_PUBLIC_VAPID_PUBLIC_KEY`) e a privada só no servidor.
- Fluxo: alguém publica → a rota serverless acorda → busca os `device_tokens` dos usuários → envia os pushes → volta a dormir.

Gere as chaves com `npx web-push generate-vapid-keys`.

## PWA e uso offline

- `manifest.json` e Service Worker registrados no layout raiz.
- **Offline é somente leitura**: o app mostra o que foi carregado (dashboard, músicas, cifras, eventos e setlists), e edições exigem conexão. Não há fila de sincronização.
- Atualização dos dados ao abrir o app ou recarregar a página.
- Cache local de dados em IndexedDB/LocalStorage. O contador de versão de cada registro indica quando o cache está desatualizado.
- A leitura offline inclui a cifra, o tamanho da fonte e a rolagem automática, que não dependem de rede.

## Desativação de contas

Desativar uma conta (`ativo = false`) tira a pessoa da **escala dos setlists de eventos futuros**, e a vaga fica em aberto, com o mesmo aviso de substituição da presença. A pessoa continua vendo os dados e confirmando presença. Reativar a conta **não** a recoloca na escala.

Coordenadores e o admin podem desativar e reativar contas. A própria pessoa também pode desativar a conta dela, mas só um coordenador ou o admin a reativa. Convidados não têm o campo `ativo`: para encerrar o acesso de um convidado, o coordenador o remove do evento.

### Desativação pela própria pessoa

A pessoa desativa a própria conta na tela de segurança, com confirmação pela senha. A conta não é apagada: ela fica inativa, sai da escala dos eventos futuros e pode continuar vendo os dados e confirmando presença. Só um coordenador ou o admin a reativa.

### Conta e segurança

Na tela de segurança, a pessoa vê e gerencia os próprios e-mails, troca a senha e desativa a própria conta. A recuperação de senha ("esqueci a senha") fica na tela de login.

## Stack técnica

| Camada | Escolha |
|---|---|
| Frontend e backend | **Next.js 15** (App Router) + **React 19**, tudo em **TypeScript** (`strict`) |
| API | Route Handlers do Next (`src/app/api/**/route.ts`) |
| Banco | **PostgreSQL** (Supabase em produção, Postgres em Docker em desenvolvimento) |
| ORM | **Prisma 6**, com o schema gerado do banco (`prisma db pull`) |
| Validação | **Zod** |
| Autenticação | **JWT** em cookie `httpOnly`, senhas com **bcryptjs** |
| Drag-and-drop | **dnd-kit** (`@dnd-kit/core`, `@dnd-kit/sortable`, `@dnd-kit/utilities`) |
| Push | Web Push + VAPID (biblioteca `web-push`) |
| Fotos de perfil | **Supabase Storage** (só a URL vai para o banco) |
| Lembretes | **Vercel Cron** |
| Documentação da API | **Swagger / OpenAPI**, restrito ao admin |
| Deploy | **Vercel** (deploy automático por push no GitHub) |

Tudo num único projeto TypeScript (front e back), sem plataformas além de Vercel, GitHub e Supabase.

## Modelo de dados

17 tabelas e 7 views, definidas em **`DDL.SQL`** (PostgreSQL 13 ou superior). O arquivo tem quatro partes: a **parte 1** (tabelas, chaves e únicas) é a mais segura para visualizadores como o Esquema 3D; a **parte 2** (CHECKs e índices), a **parte 3** (views) e a **parte 4** (instrumentos iniciais) podem ser apagadas se o visualizador não as reconhecer.

O banco não tem colunas de criação ou edição. As únicas datas são `eventos.data_evento`, `convites_acesso.expira_em` e `redefinicoes_senha.expira_em`. A parte 2 usa a extensão `pg_trgm` para a busca por título.

| Tabela | Propósito |
|---|---|
| `usuarios` | Pessoas. `papel` (`COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`), `is_admin`, `ativo` (vazio para convidados), `foto_url`, `slug` e hash da senha. |
| `emails_usuario` | Os e-mails de cada conta, todos com o mesmo peso, em minúsculas e únicos no sistema. `verificado` libera o login e a recuperação de senha. |
| `redefinicoes_senha` | Pedidos de "esqueci a senha": hash do token, e-mail, expiração de 30 minutos e se já foi usado. |
| `instrumentos` | Catálogo de instrumentos, com `nome` e `slug`. |
| `usuarios_instrumentos` | Quais instrumentos cada pessoa toca. |
| `autores` | Compositores, com página pública. |
| `musicas` | A biblioteca: título, autor, cifra em graus, link do YouTube, marca de revisão e `versao`. Sem tom e sem músicos. |
| `status_escuta` | Status pessoal por usuário × música. |
| `eventos` | Cultos, ensaios, retiros: nome, `slug`, data e hora, `requerir_presenca` e `cancelado`. |
| `eventos_convidados` | Quais eventos cada convidado pode acessar. |
| `convites_acesso` | Convites de uso único: token, cargo, quem criou, evento (só para convidados), `usado`, `usado_por_id` e `expira_em` (30 minutos). |
| `confirmacoes_presenca` | Presença por evento × usuário (vazio, vai ou não vai). |
| `colecoes` | Setlist ou lista, com `publicado`. |
| `secoes` | Agrupamentos opcionais dentro de uma coleção. |
| `colecao_musicas` | Música na coleção: tom tocado (opcional), cifra local (opcional), ordem e versão. |
| `colecao_musicas_musicos` | **A escala**: quem toca cada música do setlist. |
| `device_tokens` | Inscrições de push (endpoint, chaves) por usuário. |

| View | Propósito |
|---|---|
| `vw_dashboard_resumo` | Uma linha com `total_musicos`, `total_musicas` e `total_para_revisao`. |
| `vw_dashboard_musicos_por_instrumento` | Uma linha por instrumento, com `total_musicos`. |
| `vw_dashboard_proximos_eventos` | Eventos futuros não cancelados. |
| `vw_execucoes` | Uma linha por música tocada em cada evento. Base dos rankings. |
| `vw_ultima_execucao` | Última vez que cada música foi tocada. |
| `vw_ranking_musicas_geral` | Execuções por música, em todo o histórico. |
| `vw_ranking_autores_geral` | Execuções por autor, em todo o histórico. |

Os ids são `UUID` gerados pelo banco (`gen_random_uuid()`), então um `INSERT` direto no `psql` funciona sem informar o id. A parte 4 do `DDL.SQL` cadastra os instrumentos iniciais: Voz, Violão, Guitarra, Baixo, Teclado, Bateria e Cajón.

### Diagrama

```mermaid
erDiagram
    USUARIO }o--o{ INSTRUMENTO : "toca"
    AUTOR |o--o{ MUSICA : "compoe"
    USUARIO ||--o{ STATUS_ESCUTA : "marca"
    MUSICA ||--o{ STATUS_ESCUTA : "recebe"
    USUARIO ||--o{ CONVITE_ACESSO : "cria"
    EVENTO |o--o{ CONVITE_ACESSO : "convida para"
    EVENTO ||--o{ EVENTO_CONVIDADO : "libera"
    USUARIO ||--o{ EVENTO_CONVIDADO : "acessa"
    EVENTO ||--o{ CONFIRMACAO_PRESENCA : "pede"
    USUARIO ||--o{ CONFIRMACAO_PRESENCA : "responde"
    EVENTO |o--o| COLECAO : "setlist"
    USUARIO |o--o{ COLECAO : "listas"
    COLECAO ||--o{ SECAO : "divide em"
    COLECAO ||--o{ COLECAO_MUSICA : "contem"
    SECAO |o--o{ COLECAO_MUSICA : "agrupa"
    MUSICA ||--o{ COLECAO_MUSICA : "aparece em"
    COLECAO_MUSICA ||--o{ ESCALA : "escala"
    USUARIO ||--o{ ESCALA : "toca em"
    INSTRUMENTO ||--o{ ESCALA : "usa"
    USUARIO ||--o{ DEVICE_TOKEN : "registra"
```

(`ESCALA` é a tabela `colecao_musicas_musicos`; `EVENTO_CONVIDADO`, a `eventos_convidados`.)

### Regras garantidas no banco

Estão na parte 2 do `DDL.SQL` e foram testadas tentando violá-las:

- `papel` só aceita `COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`; convidado tem `ativo` vazio e não é admin, e os demais têm `ativo` preenchido.
- Convite de convidado exige evento; os outros convites não têm evento.
- O `slug` só aceita minúsculas, números e hífens.
- Nome de instrumento e de autor **únicos sem diferenciar maiúsculas**.
- Cada e-mail existe uma única vez no sistema, em minúsculas e com formato mínimo.
- Não existem duas músicas com o mesmo título e o mesmo autor, sem diferenciar maiúsculas.
- Tom tocado no formato `D`, `F#m` ou `Bb`.
- Em `colecoes`: SETLIST exige evento e não tem dono nem nome; LISTA exige dono e nome, não tem evento e não é publicada.
- Instrumento em uso e música usada em setlist ou lista não podem ser apagados (`RESTRICT`).
- O convite expira 30 minutos depois de criado, por padrão do banco.

### Regras que a API valida

O banco não cobre estas:

- A escala (`colecao_musicas_musicos`) só pode existir em coleções SETLIST.
- A seção de uma música pertence à mesma coleção da música.
- Apenas coordenadores e o admin convidam, alteram cargos, criam eventos e desativam contas.
- Conta desativada não edita nada: só visualiza e confirma presença.
- O convidado só acessa os eventos em `eventos_convidados` e só altera as músicas dentro do evento.
- A gravação só é aceita se a `versao` enviada ainda for a atual.
- Nomes reservados pelas rotas não são aceitos como `slug`.
- Toda conta ativa tem pelo menos um e-mail verificado; o último não pode ser removido.

## API e Swagger

A API é composta por Route Handlers em `src/app/api`. A documentação é em **OpenAPI 3** com interface **Swagger UI**, **acessível somente ao admin** (`is_admin`).

A especificação é gerada a partir dos **schemas Zod** que já validam as requisições (por exemplo com `@asteasolutions/zod-to-openapi`), de modo que o contrato e a documentação saem da mesma fonte. Ela é servida em `/api/openapi.json` e a interface em `/docs`; ambas exigem sessão de admin. A autenticação é por cookie, declarada como esquema de segurança `cookieAuth`.

### Endpoints

| Recurso | Endpoints |
|---|---|
| Autenticação | `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/me`, `POST /api/auth/accept-invite` |
| Conta | `GET, PATCH /api/conta`, `PUT, DELETE /api/conta/foto` |
| Dashboard | `GET /api/dashboard?periodo=mes\|ano` (membros logados) |
| Rankings | `GET /api/rankings/musicas`, `GET /api/rankings/autores` (parâmetros: `periodo=mes\|ano\|geral`, `ano`, `mes`, `autor`, `ordem=desc\|asc`, `pagina`) |
| Usuários | `GET /api/usuarios`, `GET /api/usuarios/{slug}`, `PATCH /api/usuarios/{id}` (cargo), `PATCH /api/usuarios/{id}/ativo` (desativar e reativar), `PUT /api/usuarios/{id}/instrumentos` |
| Convites | `POST /api/convites` (com `papel` e, para convidados, `evento_id`) |
| Instrumentos | `GET, POST /api/instrumentos`, `GET /api/instrumentos/{slug}` (com o total e os músicos), `PATCH, DELETE /api/instrumentos/{id}` |
| Autores | `GET, POST /api/autores`, `GET /api/autores/{slug}` |
| Músicas | `GET, POST /api/musicas?busca=&autor=&revisao=`, `GET /api/musicas/parecidas?titulo=`, `GET, PATCH, DELETE /api/musicas/{id}`, `PUT /api/musicas/{id}/revisao`, `PUT /api/musicas/{id}/status-escuta` |
| Eventos | `GET, POST /api/eventos`, `GET /api/eventos/{slug}`, `PATCH, DELETE /api/eventos/{id}` (inclui cancelar), `POST /api/eventos/{id}/publicar`, `POST /api/eventos/{id}/copiar-setlist` |
| Convidados do evento | `GET /api/eventos/{id}/convidados`, `DELETE /api/eventos/{id}/convidados/{usuarioId}` |
| Presença | `PUT /api/eventos/{id}/presenca` |
| Coleções | `GET, POST /api/colecoes`, `GET, PATCH, DELETE /api/colecoes/{id}`, `POST /api/colecoes/{id}/secoes`, `PATCH /api/colecoes/{id}/secoes/{id}` (renomear, mover), `POST /api/colecoes/{id}/musicas`, `PATCH /api/colecoes/{id}/musicas/{id}` (mover, tom, cifra; `salvar_em=musica\|colecao`) |
| Escala | `PUT /api/colecoes/{id}/musicas/{id}/musicos`, `PUT /api/colecoes/{id}/secoes/{id}/musicos` (`modo=sobrescrever\|completar`) |
| Push e lembretes | `POST, DELETE /api/push/subscribe`, `GET /api/cron/lembretes` (só o Vercel Cron, com `CRON_SECRET`) |

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
    { "nome": "Missa de domingo", "slug": "missa-de-domingo-2026-10-18",
      "dataEvento": "2026-10-18T19:00:00", "minhaResposta": null }
  ],
  "rankings": {
    "periodo": "mes",
    "musicas": {
      "maisTocadas": [ { "titulo": "Segura na Mão de Deus", "autor": "Autor Um", "execucoes": 4 } ],
      "menosTocadas": [ { "titulo": "Música D", "autor": null, "execucoes": 0 } ]
    },
    "autores": {
      "maisTocados": [ { "autor": "Autor Um", "slug": "autor-um", "execucoes": 7 } ],
      "menosTocados": [ { "autor": "Autor Três", "slug": "autor-tres", "execucoes": 0 } ]
    }
  }
}
```

(`minhaResposta` é `true` para "Vou", `false` para "Não vou" e `null` para pendente. As listas de ranking têm até 5 itens.)

## Estrutura de pastas

```
.
├─ DDL.SQL                   # modelo de dados em SQL (PostgreSQL)
├─ vercel.json               # agenda do lembrete diário (Vercel Cron)
├─ prisma/
│  └─ schema.prisma          # gerado do banco com `prisma db pull`
├─ public/
│  ├─ manifest.json          # manifesto do PWA
│  └─ sw.js                  # service worker
├─ src/
│  ├─ app/
│  │  ├─ layout.tsx          # layout raiz (registra o service worker)
│  │  ├─ auth/               # login e aceitar convite
│  │  ├─ (app)/              # área autenticada
│  │  │  ├─ dashboard/       # página inicial
│  │  │  ├─ rankings/        # ranking completo de músicas e de autores
│  │  │  ├─ musicas/         # biblioteca e tela da cifra
│  │  │  ├─ instrumentos/[slug]/
│  │  │  ├─ autores/[slug]/
│  │  │  ├─ usuarios/[slug]/
│  │  │  ├─ eventos/[slug]/  # evento, setlist, escala e presença
│  │  │  ├─ listas/
│  │  │  └─ conta/           # nome, e-mails, senha, foto, instrumentos e desativação
│  │  ├─ admin/              # gestão de usuários e convites
│  │  ├─ docs/               # Swagger UI (só admin)
│  │  └─ api/                # Route Handlers
│  ├─ components/            # componentes React (ui, forms, setlist, cifra, dashboard)
│  ├─ lib/
│  │  ├─ db.ts               # cliente Prisma (singleton)
│  │  ├─ auth.ts             # JWT e leitura da sessão
│  │  ├─ autorizar.ts        # função central de permissão (cargo, ativo, evento)
│  │  ├─ cifra/              # conversão de tom para graus e de graus para tom
│  │  └─ ...                 # validadores Zod, slugs, etc.
│  └─ hooks/
└─ .env.example
```

## Rodando localmente

Pré-requisitos: Node.js 20+ e Docker.

```bash
# 1. Postgres local
docker run --name musicaliapp-db -e POSTGRES_PASSWORD=dev -e POSTGRES_DB=musicaliapp \
  -p 5432:5432 -d postgres:16

# 2. Projeto Next com TypeScript e App Router
npx create-next-app@latest musicaliapp

# 3. Dependências
npm i prisma@6 @prisma/client@6 zod jsonwebtoken bcryptjs web-push \
      @supabase/supabase-js @dnd-kit/core @dnd-kit/sortable @dnd-kit/utilities
npm i -D @types/jsonwebtoken @types/web-push

# 4. Variáveis de ambiente
cp .env.example .env.local
#   DATABASE_URL="postgresql://postgres:dev@localhost:5432/musicaliapp"

# 5. Banco: aplicar o DDL e gerar o schema do Prisma a partir dele
psql "postgresql://postgres:dev@localhost:5432/musicaliapp" -f DDL.SQL
npx prisma init --datasource-provider postgresql
npx prisma db pull
npx prisma generate

# 6. Rodar
npm run dev
```

### Conta inicial

Como o acesso é por convite, a primeira conta é criada direto no banco:

```bash
HASH=$(node -e "console.log(require('bcryptjs').hashSync('SUA_SENHA', 10))")
psql "postgresql://postgres:dev@localhost:5432/musicaliapp" -c \
  "WITH u AS (
     INSERT INTO usuarios (nome, slug, senha_hash, papel, is_admin)
     VALUES ('Seu Nome Completo', 'seu-nome', '$HASH', 'COORDENADOR', TRUE)
     RETURNING id)
   INSERT INTO emails_usuario (usuario_id, email, verificado)
   SELECT id, 'voce@exemplo.com', TRUE FROM u;"
```

### Comandos úteis

`npx prisma studio` (ver os dados), `npx prisma validate` (checar o schema), `npx tsc --noEmit` (checar tipos).

## Variáveis de ambiente

| Variável | Para quê |
|---|---|
| `DATABASE_URL` | Conexão do Prisma. Em produção, a string do pooler do Supabase. |
| `JWT_SECRET` | Segredo para assinar o token de sessão. Longo e aleatório. |
| `NEXT_PUBLIC_VAPID_PUBLIC_KEY` | Chave pública VAPID, enviada ao navegador. |
| `VAPID_PRIVATE_KEY` | Chave privada VAPID. **Só no servidor.** |
| `VAPID_SUBJECT` | `mailto:` de contato exigido pelo VAPID. |
| `SUPABASE_URL` | Endereço do projeto Supabase, usado para enviar as fotos de perfil. |
| `SUPABASE_SERVICE_ROLE_KEY` | Chave de serviço do Supabase Storage. **Só no servidor.** |
| `CRON_SECRET` | Segredo que o Vercel Cron envia à rota de lembretes. |
| `NODE_ENV` | `development` ou `production` (controla o cookie `secure`). |

## Deploy

- **Supabase:** crie o projeto na região de São Paulo e execute o `DDL.SQL` no *SQL Editor* (a extensão `pg_trgm` está disponível). Crie um bucket de Storage `fotos-perfil` para as fotos.
- **Vercel:** projeto único, com deploy automático a cada push no GitHub. Cadastre as variáveis acima em *Settings → Environment Variables*. O `vercel.json` agenda a rota `/api/cron/lembretes` uma vez por dia.
- **Conexão serverless:** em `DATABASE_URL`, use a conexão do **pooler** do Supabase com `?pgbouncer=true`.
- **Conta inicial:** crie-a com o mesmo `INSERT` da seção anterior, pelo SQL Editor.

## Segurança

- Senhas guardadas com hash **bcrypt**; nunca em texto.
- Sessão em **cookie `httpOnly`**, `sameSite=lax` e `secure` em produção, inacessível ao JavaScript da página.
- Convites de uso único, com validade de 30 minutos, consumidos dentro de transação para evitar uso duplo em requisições simultâneas.
- Toda entrada validada com **Zod**.
- **Autorização sempre no servidor**, por uma função central usada em todas as rotas: ela confere o cargo, o estado `ativo` e, para convidados, se o evento está liberado. O que o front esconde não conta como proteção.
- A rota `GET /api/cron/lembretes` só aceita a chamada que traz o `CRON_SECRET`.
- Fotos de perfil validadas no servidor (tipo e tamanho) e gravadas com nome aleatório.
- O Swagger e o `openapi.json` exigem sessão de admin.
- A chave privada VAPID, o `JWT_SECRET`, o `CRON_SECRET` e a chave de serviço do Supabase nunca vão para o front nem para o repositório.
- Login, aceitação de convite e pedidos de "esqueci a senha" têm limite de tentativas (rate limit).
- O pedido de "esqueci a senha" responde igual exista ou não a conta. O token de redefinição é guardado em hash, vale 30 minutos e serve uma única vez.

## Sprints e milestones

Premissas: sprints de **2 semanas**. As datas de início e de fim serão definidas quando o desenvolvimento começar. Um milestone termina quando todos os requisitos listados nele estão implementados e testados. A ordem segue as dependências: cada milestone usa o que o anterior entregou.

| Sprint | Milestone | Entrega principal | Requisitos |
|---|---|---|---|
| S1 | **M1 Fundação** | Projeto Next com TypeScript, banco aplicado a partir do `DDL.SQL`, login com "Lembrar de mim", convites de 30 minutos, cargos, instrumentos, conta com foto, e-mails, esqueci a senha, troca de senha e desativação pela própria pessoa. Página pública. PWA instalável. | RF01, RF02, RF04 a RF09, RF42, RF44 a RF47 |
| S2 | **M2 Biblioteca** | Cadastro e edição de músicas e autores. Cifra em graus, com conversão para qualquer tom. Busca por título com aviso de músicas parecidas. Controle de versão. Revisão e status de escuta. | RF17, RF18, RF20 a RF25 |
| S3 | **M3 Leitura da cifra** | Tela da cifra com troca de tom, transpose, aumento de fonte e rolagem automática com velocidade ajustável. Preferências salvas no aparelho. | RF19 |
| S4 | **M4 Eventos e setlists** | Eventos com `slug`, cancelamento, setlists e listas com seções. Reordenação por arrastar e soltar. Tom tocado por música. Cifra local e "Salvar na música" ou "Salvar só neste setlist". Copiar setlist. | RF26 a RF29, RF33, RF34 |
| S5 | **M5 Escala, presença e convidados** | Escala por música e por seção, com as opções sobrescrever ou completar. Aviso de conflito de horário. Presença com Vou e Não vou. Aviso de substituição. Convite de convidado para um evento. Página de instrumento com os músicos. | RF03, RF30, RF31, RF35 a RF38 |
| S6 | **M6 Dashboard e rankings** | Dashboard com os números, instrumentos e próximos eventos. Rankings de músicas e de autores, mais e menos tocados, com período mês, ano, geral ou um mês ou ano escolhido. | RF10 a RF16 |
| S7 | **M7 Notificações e offline** | Push na publicação do setlist. Lembrete diário de presença pelo Vercel Cron. Cache offline somente leitura, com atualização ao abrir o app. | RF39 a RF41 |
| S8 | **M8 Entrega** | Swagger restrito ao admin. Rate limit. Testes de permissão para cada papel e estado da conta. Deploy na Vercel e no Supabase. Conta inicial criada. | RF43, RNF10, RNF15 |

Dependências: M2 depende de M1. M3 depende de M2. M4 depende de M2. M5 depende de M4. M6 depende de M2 e M4. M7 depende de M5. M8 vem por último.
