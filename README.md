# MusicaliAPP

PWA para organizar a biblioteca de músicas, os eventos e os setlists de um ministério de música. Funciona no celular como um aplicativo instalável, atualiza ao ser aberto e pode ser consultado offline.

## Sumário

1. [Visão geral](#visão-geral)
2. [Requisitos](#requisitos)
3. [Regras de negócio](#regras-de-negócio)
4. [Usuários, papéis e permissões](#usuários-papéis-e-permissões)
5. [Convites e primeiro acesso](#convites-e-primeiro-acesso)
6. [Convidados de evento](#convidados-de-evento)
7. [Dashboard e listagens](#dashboard-e-listagens)
8. [Músicas](#músicas)
9. [Cifra, graus e tons](#cifra-graus-e-tons)
10. [Eventos, setlists e listas](#eventos-setlists-e-listas)
11. [Escala de músicos](#escala-de-músicos)
12. [Confirmação de presença](#confirmação-de-presença)
13. [Notificações push](#notificações-push)
14. [PWA e uso offline](#pwa-e-uso-offline)
15. [Desativação e exclusão de contas](#desativação-e-exclusão-de-contas)
16. [Stack técnica](#stack-técnica)
17. [Modelo de dados](#modelo-de-dados)
18. [Esquema de URLs](#esquema-de-urls)
19. [Busca e ordenação](#busca-e-ordenação)
20. [API e Swagger](#api-e-swagger)
21. [Estrutura de pastas](#estrutura-de-pastas)
22. [Rodando localmente](#rodando-localmente)
23. [Variáveis de ambiente](#variáveis-de-ambiente)
24. [Qualidade e testes](#qualidade-e-testes)
25. [Deploy](#deploy)
26. [Segurança](#segurança)
27. [Privacidade e LGPD](#privacidade-e-lgpd)
28. [Sprints e milestones](#sprints-e-milestones)

---

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

### Como ler este documento

Os requisitos têm identificadores estáveis: **RF** (requisito funcional), **RNF** (não funcional) e **RN** (regra de negócio). Um identificador não é reaproveitado, e as referências (por exemplo, "RN90") apontam para a regra de mesmo número. O texto, a interface, o banco, as rotas e as mensagens do app estão em português do Brasil.

### Glossário

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

## Requisitos

### Requisitos funcionais

| ID | Requisito |
| --- | --- |
| **Acesso e contas** | |
| RF01 | Coordenadores geram links de convite com o cargo que a pessoa terá. O link vale 30 minutos e serve uma única vez. Ao gerar o link, quem o criou vê quanto tempo falta para ele expirar. |
| RF02 | Quem recebe o convite informa nome completo, e-mail e senha, aceita os Termos de Uso e a Política de Privacidade (RF58) pela frase "Ao se registrar você concorda com nossos termos e condições de uso", com links para os documentos e exibida abaixo do botão de cadastro, confirma o código enviado ao e-mail e entra logado. A conta só é criada depois da confirmação. |
| RF03 | Coordenadores geram o link de convite de **um evento** para uma pessoa de fora (convidado). |
| RF04 | Os usuários fazem login e logout. O botão **Lembrar de mim** vem marcado por padrão: marcado, o login fica salvo no aparelho e é renovado a cada acesso, sem prazo para expirar; desmarcado, vale só enquanto a sessão do navegador estiver aberta. |
| RF05 | Cada pessoa tem uma área de conta, onde altera nome, **foto de perfil** e instrumentos, e uma página de configurações com a segurança (senha, e-mails, apagar a própria conta) e os padrões de visualização e exportação (RF57, RF65). |
| RF06 | Cada pessoa escolhe e altera os instrumentos que toca (zero ou mais). |
| RF07 | Coordenadores alteram o cargo de qualquer pessoa, inclusive tornando um convidado ministeriado. Nome, foto e instrumentos só são alterados pela própria pessoa (RN05). |
| RF08 | Coordenadores desativam e reativam contas. |
| RF09 | Cada usuário, artista, instrumento, evento, música e lista tem página própria, acessada pelo `slug`. O slug acompanha o nome e a URL antiga redireciona (RN13). A página do instrumento lista os músicos que o tocam. |
| **Dashboard e listagens** | |
| RF10 | O dashboard mostra o número de músicos, o número de músicas e o número de músicas marcadas para revisão. |
| RF11 | O dashboard mostra o número de músicos por instrumento. |
| RF12 | O dashboard mostra os próximos eventos, com nome, data e hora e os botões **Vou** e **Não vou**. |
| RF13 | O dashboard mostra as 5 músicas e os 5 artistas **mais tocados** e os 5 **menos tocados**, no mês ou no ano. |
| RF14 | A página de músicas tem busca por título e artista, filtro por artista, ordem A–Z ou Z–A e ordem por mais ou menos tocada, 30 por página. |
| RF15 | A página de artistas tem busca por nome, ordem A–Z ou Z–A e ordem por mais ou menos tocado, 30 por página. |
| RF16 | Os mais e menos tocados aceitam o período **mês**, **ano**, **geral** ou um mês ou ano específico escolhido pela pessoa. |
| **Músicas** | |
| RF17 | Cadastrar uma música (título, pelo menos um artista, **tom original** opcional, cifra, link do YouTube opcional), com aviso quando já existe uma parecida. |
| RF18 | Escrever a cifra em graus ou em um tom qualquer; o app a guarda sempre em graus. A tela de escrita tem o campo **tom da escrita**, que é **graus** por padrão ou um tom. Quando é graus, aparece um botão **Números** ou **Romanos** (padrão: Números), para dizer em que forma a cifra foi digitada. Esse campo só diz como converter o que foi digitado e não é guardado. Os acordes seguem sempre o padrão de escrita (RN95). |
| RF19 | Ver a cifra em qualquer tom, transpor de meio em meio tom ou de tom em tom, aumentar a fonte e usar a **rolagem automática**, com a velocidade ajustável durante a rolagem. Só o botão pausa; rolar a tela com o dedo avança a música e não pausa. Há também a opção **Letra**, que mostra só a letra, sem os acordes, com o botão **Seções** para mostrar ou ocultar os marcadores de seção (padrão: ocultos). Nesse modo a transposição fica desativada, porque não há acordes para transpor. |
| RF20 | Editar qualquer música, com aviso quando outra pessoa a alterou antes. Cada alteração da cifra, do tom original, dos artistas ou do tom tocado (no setlist ou na lista) gera uma versão no histórico, com título obrigatório (RN90). |
| RF21 | Marcar e desmarcar uma música para revisão. |
| RF22 | Marcar o status de escuta de uma música (Não ouvi, Ouvi, Toquei). |
| RF23 | Apagar as músicas que não estão em nenhum setlist ou lista. |
| RF24 | Buscar músicas por título e artista, vendo a última vez em que cada uma foi tocada. |
| RF25 | Criar, editar e apagar instrumentos, e cadastrar e renomear artistas. Todo membro ativo pode renomear um artista (RN80). |
| **Eventos, setlists e listas** | |
| RF26 | Coordenadores criam, editam e cancelam eventos, com a opção de exigir confirmação de presença. |
| RF27 | Montar o setlist: adicionar músicas, criar seções e reordenar músicas e seções por arrastar e soltar. |
| RF28 | Definir, em cada música do setlist ou da lista, o tom que será tocado (opcional). |
| RF29 | Editar a cifra de uma música no setlist e escolher se a mudança vale só para o setlist ou para a música. |
| RF30 | Escalar os músicos de uma **seção** do setlist (instrumento, depois pessoa que toca aquele instrumento). |
| RF31 | Escalar os músicos de uma seção que já tem músicos, escolhendo entre **Sobrescrever** e **Completar**. |
| RF32 | Publicar o setlist de um evento. |
| RF33 | Copiar o setlist de outro evento. |
| RF34 | Criar listas genéricas de músicas, com seções e ordem. A lista pode ter mais de um dono e pode ser compartilhada para edição (RF55). |
| RF35 | Confirmar presença com **Vou** ou **Não vou**, trocar a resposta quando quiser e ver a resposta de todos. |
| RF36 | Escalar uma pessoa em mais de um evento no mesmo horário é permitido, sem aviso. |
| RF37 | O convidado vê tudo o que um membro vê (dashboard, biblioteca, listagens, busca, eventos, setlists, cifras, escala e presença) e edita a escala dos eventos a que foi convidado. Também cuida da própria conta, confirma presença nesses eventos e ativa as notificações (RN55), e escolhe seus instrumentos nas configurações de perfil. |
| **Notificações e uso offline** | |
| RF38 | Receber push quando um setlist é publicado, com o pedido de presença quando houver. Os coordenadores recebem push quando uma conta é desativada (RN93). |
| RF39 | Receber um lembrete na véspera, se ainda não respondeu à presença. |
| RF40 | Consultar os dados já carregados sem conexão. |
| RF41 | Instalar o app na tela inicial do celular. |
| **API** | |
| RF42 | Qualquer pessoa consulta a documentação da API (Swagger) em `/api/docs`, sem precisar de login. |
| **Conta e segurança** | |
| RF43 | Esqueci a senha: a pessoa informa o e-mail da conta, recebe um código de 6 dígitos e o usa para definir a senha nova. Pode usar um código de recuperação no lugar do e-mail. |
| RF44 | Cada conta tem de um a três e-mails, todos únicos no sistema. Cada e-mail é confirmado por código de 6 dígitos enviado a ele ao ser adicionado. Quando um código precisa ser enviado, a pessoa escolhe para qual dos seus e-mails. A pessoa entra com qualquer e-mail confirmado ou com o Google, se vinculado (RF60). |
| RF45 | Trocar a senha em `/configuracoes/seguranca`, informando a senha atual. |
| RF46 | Desativar a própria conta em `/configuracoes/seguranca`, com confirmação pela senha. Quem a reativa é um coordenador. |
| RF47 | Coordenadores não veem os e-mails de ninguém, não apagam contas e não alteram nome, foto ou instrumentos de outra pessoa. Ninguém define senha por outra pessoa: a pessoa redefine a própria pelo código enviado a um dos seus e-mails. |
| RF48 | A pessoa gera 10 códigos de recuperação em `/configuracoes/seguranca`. Eles são mostrados uma única vez, cada um serve uma vez, e gerar de novo invalida os anteriores. |
| RF49 | A página de instrumentos lista todos, 30 por página, sem busca e sem filtro, com ordem A–Z ou Z–A. Cada item leva à página do instrumento. |
| RF50 | A página de listas tem busca pelo nome e ordem A–Z ou Z–A, 30 por página. Mostra todas as listas (RN79). |
| RF51 | A página de eventos tem busca pelo nome, filtro por data e ordem A–Z ou Z–A ou por data (mais recente ou mais antiga), 30 por página. |
| RF52 | A página de usuários tem busca pelo nome e ordem A–Z ou Z–A, 30 por página. Os e-mails de cada pessoa só aparecem para ela (RN81). |
| RF53 | Há uma **busca geral**: um campo de busca no topo do app leva à página `/busca`, que pesquisa ao mesmo tempo músicas, artistas, listas, eventos, usuários e instrumentos, com filtro por tipo. |
| RF54 | Toda página de música, artista, instrumento, usuário, lista e evento tem um botão **Compartilhar**: no celular abre o menu de compartilhamento do aparelho e, onde ele não existir, copia o link. Quem abre o link precisa estar logado (RN82). |
| RF55 | Os donos de uma lista incluem ou retiram outros donos e dão ou retiram acesso de edição a membros ativos, pelo botão **Compartilhar** da lista. Enquanto a lista tiver donos, ao menos um permanece (RN79). |
| RF56 | Todas as listas são visíveis para todos os usuários logados, inclusive convidados. Donos e editores alteram a lista. Com **Edição pública** marcada, ou sem dono, todo membro ativo a altera (RN79). |
| RF57 | A pessoa apaga a própria conta em `/configuracoes/seguranca`, com confirmação pela senha (RN83). |
| RF58 | Os Termos de Uso (`/documentos/termos-de-uso`) e a Política de Privacidade (`/documentos/politica-privacidade`) ficam publicados e podem ser baixados em Markdown ou PDF. Cada documento tem um único link, o mesmo para visitantes e para usuários logados. O cadastro exige o aceite (RN84). |
| RF59 | Toda cifra pode ser exportada em Markdown ou PDF. O tom do arquivo é o da tela, e pode ser trocado no diálogo de exportação sem mudar a tela (RN88). Também é possível escolher se o link do YouTube sai no PDF (RN86). |
| RF60 | A pessoa vincula uma conta Google à própria conta em `/configuracoes/seguranca`, com a senha, e passa a entrar também pelo botão **Entrar com Google** (RN85). O Google não cria conta: o cadastro segue por convite e código de e-mail. |
| RF61 | A letra de uma música pode ser exportada em Markdown ou PDF, sem acordes, com ou sem seções (RN86, RN87). |
| RF62 | Um artista, um evento ou uma lista pode ser exportado de uma vez em PDF: cada música em sua página, com a capa e o índice. Vale para cifra ou letra, com ou sem seções e com ou sem o link do YouTube. O tom padrão é o tocado de cada item; sem tom tocado, o tom original da música; sem ele, graus. O diálogo pode aplicar um único tom a todas (RN88, RN89). |
| RF63 | Cada alteração da cifra, do tom original, dos artistas ou do tom tocado de uma música fica no histórico, com título obrigatório, autor e data. Qualquer membro ativo vê o histórico, compara versões e volta a uma delas. Voltar cria um novo ponto no histórico, e nada se perde (RN90). |
| RF64 | Todas as páginas e listagens mostram a data de criação e a de atualização de cada item (RNF12). |
| RF65 | Cada pessoa tem uma página de configurações (`/configuracoes`), com quatro partes: **segurança** (as funções de RF45 a RF48, RF57 e RF60), **termos e condições** (data do aceite, que é a data do cadastro, e links para os documentos), **visualização** (a tela abre em cifra ou em letra, com ou sem seções na letra, com o tamanho padrão da fonte da cifra, o formato dos graus, em números ou romanos, e se o modo Reduzido começa ligado) e **exportação** (o arquivo sai em cifra ou em letra, com ou sem seções). Os padrões valem em qualquer aparelho (RN91). |
| RF66 | Ver a lista de escalados do evento, com os instrumentos que cada pessoa toca, e adicionar ou remover pessoas dela, sem preencher as seções (RN92). |
| RF67 | Botões **Escalar todos** e **Escalar todos os <instrumento>** na lista do evento, que adicionam os membros ativos ou só os que tocam aquele instrumento (RN94). |
| RF68 | Uma página de tutorial (`/ajuda/acordes`) ensina o padrão de escrita dos acordes, com a tabela de formas, as regras que mais confundem, a tabela de variações aceitas com o que é gravado, um exemplo completo, explicações sobre seções e repetições, e um campo para testar um acorde. O editor de cifra tem o link para ela (RN95). |
| RF69 | Modo **Reduzido** na tela da cifra, ativado por um botão: mostra só os acordes de todas as seções, sem a letra, na ordem da música, com o nome de cada seção. Não há escolha de seção. Pode começar ligado por padrão na configuração da pessoa (RF65). Nesse modo a rolagem automática fica desativada (RN98). |
| RF70 | A exportação da cifra (Markdown ou PDF) tem o modo Reduzido, com os acordes de todas as seções, no mesmo padrão da tela (RF69, RN98). |
| RF71 | Modo **Reduzido** no editor da cifra, ativado por padrão. Mostra as repetições em `{xN}` e, desativado, mostra a letra por completo (RN101). |

### Requisitos não funcionais

| ID | Requisito |
| --- | --- |
| RNF01 | O app é um PWA instalável e atualiza os dados ao ser aberto ou recarregado. |
| RNF02 | O uso offline é somente leitura. |
| RNF03 | A biblioteca comporta pelo menos 500 músicas, e as listagens, a busca e a ordenação continuam fluidas. |
| RNF04 | Reordenar um item por arrastar e soltar atualiza uma única linha no banco. |
| RNF05 | Front e back em um único projeto Next.js com TypeScript no modo `strict`. |
| RNF06 | Banco PostgreSQL. |
| RNF07 | Notificações por Web Push com VAPID, sem Firebase. |
| RNF08 | Hospedagem apenas em Vercel, GitHub e Supabase (este só como banco PostgreSQL), com deploy automático por push no GitHub. O envio dos códigos por e-mail usa o Resend, no plano gratuito, atrás de uma camada própria que permite trocá-lo. |
| RNF09 | Senhas com hash bcrypt e sessão em cookie `httpOnly`. |
| RNF10 | Toda autorização é verificada no servidor, por uma função central. |
| RNF11 | Não há histórico de notificações. |
| RNF12 | Os itens principais (usuários, instrumentos, artistas, músicas, eventos e coleções) têm data de criação e de atualização, mantida pelo banco. O histórico da cifra guarda autor e data de cada versão. |
| RNF13 | Edições concorrentes são detectadas por um contador de versão, sem sobrescrever em silêncio. |
| RNF14 | Fotos de perfil têm até 2 MB, em JPG, PNG ou WebP. O servidor as redimensiona para um quadrado de 256 px, em WebP ou JPEG, e só então grava no banco. |
| RNF15 | Login, aceitação de convite, pedidos de código e envio de códigos têm limite de tentativas, contado no banco (tabela `limites_tentativas`), porque a Vercel não guarda memória entre as requisições. |
| RNF16 | Datas e horas são guardadas com fuso (`TIMESTAMPTZ`) e calculadas e exibidas em `America/Sao_Paulo`. |
| RNF17 | Um backup semanal do banco fica guardado fora dele, cifrado (veja [Deploy](#deploy)). |
| RNF18 | A interface segue o nível AA do WCAG 2.1 e está toda em português do Brasil (veja [Acessibilidade e idioma](#acessibilidade-e-idioma)). |
| RNF19 | Toda regra crítica (cifra, slugs, permissões, histórico, exclusão de conta) tem teste automatizado, e a integração contínua barra o código que quebra os testes (veja [Qualidade e testes](#qualidade-e-testes)). |
| RNF20 | Os logs não registram senhas, códigos, tokens, e-mails nem IP puro (veja [Segurança](#segurança)). |

## Regras de negócio

### Contas e cargos

| ID | Regra |
| --- | --- |
| RN01 | O acesso é só por convite. A única exceção é a conta inicial, criada direto no banco. |
| RN02 | Um convite é de uso único, vale **30 minutos** (valor fixo, que quem convida não altera) e carrega o cargo da pessoa. Não tem e-mail: é um link. Quem gera o convite vê o tempo restante até a expiração. O convite usado é apagado. |
| RN03 | Cada e-mail é único no sistema e gravado em minúsculas. O `slug` de usuário, artista, instrumento, evento, música e lista também é único. Os formatos são: pessoa, artista e instrumento, o nome em minúsculas com hífens; música, `artista-titulo`, com o primeiro artista da ordem; lista, `primeiro-dono-nome`, com o primeiro dono; evento, `data-nome` no formato ISO (`2026-10-12-missa-de-domingo`). Se o slug já existir, um sufixo numérico é acrescentado. O slug é recalculado quando o nome (ou, em música e lista, o primeiro artista ou dono) muda. A chave interna continua sendo o id (UUID). |
| RN04 | O cargo é `COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`. Não há outro cargo de administração. A documentação da API é pública (RN66). |
| RN05 | Coordenadores convidam, alteram cargos, criam eventos e desativam e reativam contas. Não apagam contas de outras pessoas, não veem e-mails de ninguém e não alteram nome, foto ou instrumentos de outra pessoa (RN77). |
| RN06 | Conta desativada (`ativo = false`) só visualiza os dados e confirma presença. |
| RN07 | Desativar uma conta tira a pessoa da lista do evento e de todas as escalas de seção dos eventos futuros. Reativar não a recoloca. |
| RN08 | Todo membro ativo pode editar cifra e tom, marcar revisão, escalar músicos em seções e eventos, publicar setlists, criar e editar instrumentos, apagar os que ninguém toca (RN18), renomear artistas, criar listas, anexar a foto de perfil e escolher seus instrumentos. |
| RN09 | O campo de nome guarda o **nome completo**. |
| RN10 | Convidado não tem o campo `ativo` e não pode ser desativado. Seu acesso ao app dura enquanto ele estiver em ao menos um evento; ao ser removido de todos, perde o acesso. |
| RN11 | Um convidado vira ministeriado por um convite de ministeriado aceito com a conta logada, ou por atribuição de um coordenador. |

### Slugs

| ID | Regra |
| --- | --- |
| RN12 | O `slug` usa minúsculas, números e hífens no lugar de espaços e acentos (`Violão` vira `violao`). |
| RN13 | Quando o slug muda, o anterior vai para a tabela `slugs_antigos` e a URL antiga responde com redirecionamento permanente (308) para a página atual. Se outro item já passou a usar o slug antigo, a URL aponta para esse outro item. |
| RN14 | O slug de evento é a data ISO mais o nome (`2026-10-12-missa-de-domingo`). Muda quando a data ou o nome muda, com redirecionamento (RN13), e recebe sufixo numérico em caso de repetição. |
| RN15 | Slugs que coincidem com um trecho fixo de rota (`nova`, `novo`, `editar`, `foto`, `parecidas`, `coordenacao`, `docs`, `api`) não são aceitos: o app gera outro, com sufixo numérico. |

### Instrumentos

| ID | Regra |
| --- | --- |
| RN16 | Não existem dois instrumentos com o mesmo nome, nem com caixa ou acento diferente ("Violão", "violão" e "violao" são o mesmo). O mesmo vale para artistas. |
| RN17 | Um instrumento novo fica disponível na hora, sem aprovação. |
| RN18 | Um instrumento que alguém toca, ou em que alguém está escalado, não pode ser apagado. |
| RN19 | A página de um instrumento mostra o total de contas ativas que o tocam, igual ao número do dashboard, e depois a lista delas. |

### Dashboard e listagens

| ID | Regra |
| --- | --- |
| RN20 | Todo usuário logado vê o dashboard, inclusive com a conta desativada e os convidados. |
| RN21 | O **número de músicos** é a quantidade de contas ativas. Convidados não entram. |
| RN22 | O **número de músicas** é a quantidade de músicas cadastradas. |
| RN23 | O **número de músicos por instrumento** conta as contas ativas que tocam cada instrumento. Quem toca dois instrumentos entra nos dois, e um instrumento sem músicos aparece com zero. |
| RN24 | Uma música é **tocada** em um evento quando está no setlist **publicado** de um evento que já aconteceu e não foi cancelado. Cada evento conta uma vez por música. Listas não contam. |
| RN25 | As execuções de um **artista** são a soma das execuções das músicas dele. Uma música com dois artistas conta para os dois. Artista sem música tocada aparece com zero. |
| RN26 | O período dos mais e menos tocados é o mês ou o ano do calendário, o histórico inteiro (geral) ou um mês ou ano específico. As datas são no horário de `America/Sao_Paulo`. |
| RN27 | "Mais tocadas" lista só quem tem ao menos uma execução. "Menos tocadas" inclui quem tem zero. Empates são desempatados pela ordem alfabética. |
| RN28 | Todas as músicas cadastradas entram nas contagens de execução, inclusive as nunca tocadas. |
| RN29 | Os próximos eventos do dashboard são os que ainda vão acontecer e não foram cancelados, do mais próximo ao mais distante. |

### Músicas e cifras

| ID | Regra |
| --- | --- |
| RN30 | A música pode ter um tom original, opcional, informado no cadastro ou depois na edição. Ele é só informativo: não altera a cifra, que é sempre guardada em graus, e não é o tom tocado (RN32). A pessoa pode escrever a cifra no tom original ou em graus; isso não muda o tom original. A música não tem músicos. |
| RN31 | Quem escreve a cifra pode usar graus ou um tom qualquer. O front converte para graus antes de enviar. Em qualquer dos dois casos, os acordes seguem o padrão de escrita (RN95). |
| RN32 | O tom só é salvo em uma música de **setlist ou lista**, e é opcional. Esse tom nunca altera a música. |
| RN33 | Em qualquer tela o front pode mostrar a cifra em outro tom. É só visualização e nada é gravado. O tom original aparece destacado na lista de tons da visualização, mas a biblioteca não abre nele: abre em graus, a não ser que a pessoa escolha outro tom. A opção de transpose (meio tom ou tom em tom) só fica ativa com um tom de referência: na biblioteca, o tom escolhido para ver a música; no setlist, o tom tocado do item. Em graus do campo harmônico, fica desativada. |
| RN34 | Não existem duas músicas com o mesmo título (sem diferenciar maiúsculas nem acentos) e o mesmo conjunto de artistas. Ao cadastrar, o app avisa sobre títulos parecidos. Toda música tem pelo menos um artista. |
| RN35 | A marca de revisão é só sim ou não, sem motivo. Qualquer membro ativo marca e desmarca. Convidados não marcam. |
| RN36 | O status de escuta é por usuário e por música, e o padrão é "Não ouvi". Convidados não marcam. |
| RN37 | Uma música que aparece em algum setlist ou lista não pode ser apagada. Ela continua no banco e no histórico dos eventos. |
| RN38 | Cada música e cada item de setlist tem um número de versão. Se a versão mudou desde que a pessoa abriu a tela, a gravação é recusada com aviso. |
| RN39 | A música pode ter um link do YouTube, que é opcional. O app não guarda arquivos de áudio. |
| RN95 | Os acordes são **gravados** só no padrão desta seção (veja [Padrão de escrita](#padrão-de-escrita)). Ao digitar, o app aceita estas variações e converte para o padrão antes de gravar: (a) dentro dos parênteses, `b` e `#` no lugar de `-` e `+` (`C7(b9)` = `C7(-9)` = `C7(9-)`; `C7(#5)` = `C7(+5)` = `C7(5+)`), e misturas dos dois na mesma extensão; (b) `maj7`, `M7`, `Δ` e `^7` para `7M`, e `maj9` para `7M(9)`; (c) `sus` e `sus4` para `4`, e `sus2` para `2`; (d) `add9` e `add2` para `9`, e `add4` para `11`; (e) `min` e `-` depois da raiz para `m` (`C-7` = `Cm7`); (f) `º` e `°` para `º`; (g) `m7b5` e `ø` para `m7(5-)`; (h) `C+` para `C5+`, e `C69` para `C6(9)`. Não são aceitas `dim`, `dim7` e `aug`, nem as formas com raiz (`Cdim`, `Cdim7`, `Caug`), porque não dizem se o acorde é tríade ou sétima. A tríade diminuta se escreve `m5-`, a aumentada `5+`, e a sétima diminuta `º`. Dentro dos parênteses, `-` e `+` valem como alterações, e `b` e `#` valem como o mesmo sinal. O `b` e o `#` fora dos parênteses continuam sendo acidentes da nota. Os graus também podem ser digitados em romanos (`I`, `ii`, `bVII`, `#IV`), e o app grava em algarismos (RN97). Um item que o app não reconhece não vira acorde: a linha em que ele aparece é tratada como letra, e o editor avisa, sem bloquear a gravação, com o link para o tutorial (RF68). |
| RN96 | A linha é de acordes ou de letra conforme sua posição e o que ela contém. Uma linha é de acordes quando todos os seus itens são acordes válidos e ela vem logo depois de uma seção, de uma linha de letra ou de outra linha de acordes (a linha de seção também pode trazer acordes depois do marcador). Uma linha de letra sem acordes, que vem depois de outra letra, continua sendo de letra. Uma linha com um só item que também é palavra (`A`, `E`, `vi`, `I`) só é de acordes quando a linha seguinte é de letra. Qualquer outra linha é de letra. |
| RN97 | Em romanos, o grau é `I` a `VII`. Maiúsculo é maior e minúsculo é menor (`vi` = `6m`). Quem digita `VIm` também tem o menor aceito. O sinal `b` ou `#` é aceito antes ou depois do numeral (`bVII` ou `VIIb`), e a tela, em romanos, mostra antes (`bVII`). Os sufixos são os mesmos do padrão: a tríade diminuta aparece como `vii5-` (`1m5-`) e a sétima diminuta como `viiº` (`1º`). A forma gravada é sempre em algarismos. |
| RN98 | No modo Reduzido, a tela e a exportação mostram só os acordes de cada seção, uma linha de acordes por linha, sem letra, na ordem da música. Linhas de acordes **iguais e seguidas** são resumidas como `(2x)`, `(3x)`… O resumo é feito pelo app, só na visualização e na exportação: a cifra gravada nunca contém `(2x)`. Nesse modo a rolagem automática fica desativada, porque a cifra é curta. |
| RN99 | Repetições: a pessoa escreve a repetição com `{xN}` (RN100). Não se usam `(2x)`, `x2`, `bis` nem marcações parecidas. O resumo `(2x)` do modo Reduzido é feito pelo app (RN98). |
| RN100 | O marcador `{xN}` (N maior ou igual a 2) repete, conforme a posição em que é escrito: (a) no fim de uma linha de acordes ou de letra, repete essa linha; (b) sozinho numa linha, logo depois de uma estrofe (bloco de linhas separado por linha em branco), repete a estrofe; (c) depois do nome na linha de seção, como `[Refrão] {x2}`, repete a seção inteira, com a tag. O marcador não conta como acorde nem como letra. Na tela completa e na exportação completa, o app expande o `{xN}`. Ao salvar, o app junta em `{xN}` as estrofes e os trechos instrumentais iguais e seguidos. Dois trechos são iguais quando têm as mesmas linhas, na mesma ordem, com acordes e letra. |
| RN101 | No editor da cifra, o modo Reduzido vem ativado por padrão e mostra a cifra com as repetições em `{xN}`, como ficou salva. Desativado, o editor mostra a letra por completo, com todas as repetições escritas. Editar um trecho em `{xN}` altera todas as suas repetições. Se a pessoa edita uma cópia no modo completo, as cópias ficam diferentes e não são comprimidas ao salvar. |

### Eventos, setlists e listas

| ID | Regra |
| --- | --- |
| RN40 | Cada evento tem no máximo um setlist. Uma lista genérica tem nome e pertence a um ou mais donos (RN79). |
| RN41 | Um evento cancelado fica no histórico, não aparece nos próximos eventos e não conta nas execuções. |
| RN42 | Uma coleção (setlist ou lista) pode ter seções opcionais, nomeadas livremente e ordenadas. Cada seção pertence a uma única coleção. |
| RN43 | Uma música no setlist ou na lista pode ter tom e cifra próprios. Mudanças locais não afetam a música por padrão. |
| RN44 | Ao salvar a cifra de uma música da coleção, a pessoa escolhe **Salvar na música**, **Salvar só neste setlist** ou **Cancelar**. O tom tocado nunca é salvo na música. Sair sem salvar descarta as mudanças. |
| RN45 | A escala de músicos existe só nos setlists, por seção e por evento. Listas genéricas não têm músicos. |
| RN46 | Ao escalar numa seção, escolhe-se o instrumento e depois uma pessoa que toque aquele instrumento. A API valida isso. Uma pessoa pode tocar mais de um instrumento na mesma seção. Quem remove um instrumento do perfil sai da escala desse instrumento nos eventos futuros. |
| RN47 | Ao escalar uma **seção** que já tem músicos, aparecem as opções **Sobrescrever** (troca a escala da seção pela nova), **Completar** (acrescenta só quem ainda não está nela) e **Cancelar**. A seção guarda a própria escala. |
| RN48 | A ordem das músicas e das seções é um número decimal. Ao soltar um item entre A e B, a nova ordem é `(A + B) / 2`, e a coleção é renumerada quando os vizinhos ficam próximos demais. |
| RN49 | Um setlist está publicado quando `publicado` é verdadeiro. |
| RN50 | **Copiar setlist** traz seções, músicas, tons e cifras locais de outro evento para um setlist vazio. As escalas de seção e de evento não são copiadas: o setlist copiado começa sem músicos escalados. |
| RN51 | Uma pessoa pode ser escalada em mais de um evento na mesma data e hora, sem aviso. |

### Convidados

| ID | Regra |
| --- | --- |
| RN52 | O convite de convidado é sempre de **um evento** e é gerado por coordenador. |
| RN53 | O convidado cria conta (nome completo, e-mail, senha, aceite dos termos), tem área de conta e escolhe seus instrumentos nas configurações de perfil, como qualquer usuário. |
| RN54 | O convidado vê tudo o que um membro vê: dashboard, biblioteca, listagens, busca, usuários, eventos, setlists com cifra e link, escala e presença. |
| RN55 | O convidado edita a escala dos eventos a que foi convidado, mas não altera música, cifra, tom, lista, evento, artista nem instrumento, não marca revisão e não cria listas. Também altera a própria conta (nome, foto, senha e e-mail), confirma presença e ativa as notificações. Escolhe seus instrumentos nas configurações de perfil, como qualquer usuário. |
| RN56 | As telas de criação e edição (`/nova`, `/novo`, `/editar`) e o `/coordenacao` não abrem para convidados, e os botões de gravação não aparecem para eles. |
| RN57 | Só coordenadores incluem convidados na escala de um evento. Na busca de escala, os convidados aparecem apenas nos eventos aos quais foram convidados. |
| RN58 | A conta do convidado permanece depois do evento, sem acesso ao app enquanto ele não estiver em nenhum evento (RN10), e pode ser convidada para outros eventos. |
| RN59 | A página de um convidado é vista por todos os logados, como a de qualquer usuário. Os e-mails continuam visíveis só para a própria pessoa (RN81). |

### Presença e notificações

| ID | Regra |
| --- | --- |
| RN60 | Se o evento exige presença, ao publicar o setlist todos os membros e os convidados do evento recebem o pedido de confirmação, inclusive os desativados. |
| RN61 | A resposta é **Vou** ou **Não vou**, pode ser trocada a qualquer momento e quem não respondeu aparece como pendente. Todos os que veem o evento veem a resposta de cada pessoa. |
| RN62 | O push é enviado quando o setlist é publicado. Alterações posteriores não notificam. |
| RN63 | Uma vez por dia, quem ainda não respondeu a um evento publicado que exige presença e acontece no dia seguinte recebe um lembrete. |
| RN64 | Não há histórico de notificações. |

### Uso offline e API

| ID | Regra |
| --- | --- |
| RN65 | Offline só há leitura. Qualquer edição exige conexão. |
| RN66 | O Swagger e a especificação OpenAPI são públicos, sem login. A validação de sessão e de permissão fica nos endpoints descritos por ela. |
| RN67 | Toda rota decide o acesso por uma função central que considera o cargo, o estado `ativo`, o convidado somente leitura e, nas listas, o dono, o acesso concedido ou a condição de lista pública. |

### Conta, e-mail e desativação

| ID | Regra |
| --- | --- |
| RN68 | Cada conta tem de um a três e-mails, em minúsculas e únicos no sistema (RN03). Só entra por e-mail quem confirmou o endereço por código. |
| RN69 | A conta só é criada depois que o código enviado ao e-mail é confirmado. O convite só é consumido nesse momento. O convite e o código usados são apagados. |
| RN70 | Adicionar ou remover um e-mail exige a senha atual (RN73) e, ao adicionar, a confirmação por código enviado ao novo endereço. A conta sempre tem ao menos um e-mail. |
| RN71 | O pedido de "esqueci a senha" responde da mesma forma exista ou não a conta, para não revelar quais e-mails estão cadastrados. |
| RN72 | Os códigos enviados por e-mail (cadastro, redefinição e troca de e-mail) valem 30 minutos, servem uma única vez (são apagados ao serem usados) e são invalidados após o limite de tentativas. Os expirados são apagados pela rotina diária. Quando a conta tem mais de um e-mail, a pessoa escolhe para qual deles o código vai. |
| RN73 | Trocar a senha exige a senha atual. Trocar ou redefinir a senha encerra as outras sessões da pessoa (incrementa `token_versao`). |
| RN74 | A própria pessoa pode desativar a própria conta, em `/configuracoes/seguranca`, com confirmação pela senha. Valem as mesmas regras de RN06 e RN07: ela sai da lista do evento e de todas as escalas dos eventos futuros e continua vendo os dados e confirmando presença. |
| RN75 | Só um coordenador reativa uma conta desativada pela própria pessoa. Reativar não a recoloca na escala (RN07). |
| RN76 | Contas só são apagadas pela própria pessoa (RN83). O histórico de eventos e execuções sempre permanece. |
| RN77 | Só a própria pessoa vê, troca ou apaga os seus e-mails. Coordenadores não veem e-mails de ninguém e não alteram e-mail, senha, nome, foto ou instrumentos de outras pessoas. Ninguém define senha por outra pessoa: a redefinição é sempre pelo código enviado a um dos e-mails confirmados da própria conta (RN72). Quem tem acesso direto ao banco deve ser restrito a pessoas de confiança. |
| RN78 | Os códigos de recuperação não dependem de e-mail. Usar um deles redefine a senha e o código fica gasto. |

### Listas, artistas e compartilhamento

| ID | Regra |
| --- | --- |
| RN79 | Todas as listas aparecem para todos os usuários logados, convidados inclusive. Donos e editores editam a lista. Donos também incluem ou retiram donos e dão ou retiram acesso de edição. Editores editam nome, seções, músicas, tom e cifra local, mas não gerenciam donos nem acessos. Só membros ativos e não convidados podem ser donos ou editores. Com a opção **Edição pública** marcada, ou sem donos, todo membro ativo edita a lista. Enquanto a lista tem donos, ao menos um permanece. Só coordenadores apagam uma lista sem donos. Coordenadores podem tudo o que um dono pode (RN05). |
| RN80 | Qualquer membro ativo renomeia um artista. O slug acompanha o novo nome, e a URL antiga redireciona (RN13). O novo nome não pode repetir outro artista (sem diferenciar maiúsculas nem acentos, RN16). |
| RN81 | Os e-mails de uma pessoa só são vistos por ela. Nas listagens, no perfil e na busca, os demais veem nome, foto e instrumentos. |
| RN82 | O botão **Compartilhar** envia o link da página (`/<tipo>/<slug>`). Quem abre precisa estar logado e ter permissão, senão vê 404. Compartilhar o link não dá acesso a nada. |
| RN83 | Ao apagar a própria conta, a pessoa sai de tudo: e-mails, senha, foto, instrumentos, configurações, códigos, inscrições de notificação, presenças e escalas de seção e de evento dos eventos futuros. Escalas e presenças de eventos passados ficam como "Pessoa removida", para manter o histórico. Listas em que ela era a única dona ficam públicas (RN79); nas que têm outros donos, a lista continua e ela só deixa de ser dona. Convites que ela criou são apagados. Músicas, cifras e artistas que ela cadastrou continuam. Nas versões do histórico que ela fez, o autor vira "Pessoa removida". |
| RN84 | O cadastro, por convite ou de convidado, só conclui com o aceite dos Termos de Uso e da Política de Privacidade, registrado com a data do cadastro em `usuarios.criado_em`, que é a data do aceite. |
| RN85 | O login com Google só vale para contas com o vínculo feito. O vínculo exige a senha atual, é feito em `/configuracoes/seguranca` e liga uma conta Google a uma só conta. Desvincular também pede a senha. O e-mail do Google não entra na lista de e-mails da conta. |
| RN86 | A exportação é só leitura e não grava nada. O Markdown leva a cifra em bloco de código, para preservar o alinhamento. O PDF da cifra usa fonte monoespaçada e quebra as linhas em pares, como a tela. O PDF e o Markdown da letra usam texto normal e quebram as linhas normalmente. O link do YouTube só sai se a opção estiver marcada, e o padrão é não sair. Quem pode ver a música pode exportá-la. |
| RN87 | O botão **Seções** da letra começa no padrão da configuração (RN91), desligado por padrão. Ele vale para a tela, para o Markdown e para o PDF da letra, e fica separado da opção de exportação. A cifra sempre mostra as seções. |
| RN88 | O tom da exportação é, por padrão, o tom que a pessoa vê na tela, inclusive no setlist e na lista. No diálogo de exportação de uma música, a pessoa pode trocar o tom sem mudar o da tela. Em lote, o padrão é o tom tocado de cada item do setlist ou da lista; sem tom tocado, o tom original da música; sem ele, graus. O diálogo de lote pode aplicar um único tom a todas as músicas. |
| RN89 | O lote aceita até 100 músicas por PDF. Cada música começa em página nova, depois da capa com o título, a data (se for evento) e o índice. A ordem é A–Z no artista e a ordem do setlist ou da lista nos eventos e listas. Quem exporta um evento precisa ver o evento: convidados só exportam dos seus. |
| RN90 | Cada gravação que muda a cifra, o tom original, a lista de artistas ou o tom tocado (no setlist ou na lista) cria uma versão no histórico da música, com título obrigatório, autor e data. Título, link e o nome de um artista não geram versão: a música guarda a referência ao artista, não o nome. Qualquer membro ativo vê o histórico e pode comparar uma versão com a atual. Voltar a uma versão cria uma nova versão com o conteúdo antigo, marcada como restaurada, e nada é apagado. Se o autor apagar a conta, a versão continua, com "Pessoa removida". |
| RN91 | Cada pessoa tem uma configuração de visualização e de exportação, guardada na conta. Visualização: a tela abre em cifra ou em letra (padrão: cifra), com ou sem seções na letra (padrão: sem seções), com um tamanho padrão da fonte da cifra (pequeno, médio ou grande; padrão: médio), o formato dos graus (números ou romanos; padrão: números) e se o modo Reduzido começa ligado (padrão: desligado; RF69). Exportação: o arquivo sai em cifra ou em letra (padrão: cifra), com ou sem seções na letra (padrão: sem seções). Os botões da tela e do diálogo de exportação valem só naquela vez e não são gravados. Quem ainda não gravou nada tem os padrões acima. |
| RN92 | A escala do evento é a lista das pessoas escaladas para o evento inteiro, com os instrumentos que cada uma toca. Ela não tem instrumento próprio: uma pessoa pode tocar mais de um, e pode estar na lista sem instrumento cadastrado. Qualquer membro ativo, e os convidados dos eventos a que foram convidados, adicionam e removem pessoas dela. Convidados só podem ser escalados por coordenadores. A lista não preenche as seções. Ao escalar alguém numa seção, se a pessoa não está na lista, ela entra automaticamente. Remover alguém da lista também a tira de todas as seções do setlist. |
| RN93 | Quando uma conta é desativada, pela própria pessoa ou por um coordenador, todos os coordenadores recebem um push com o nome da pessoa. Reativar a conta não notifica. |
| RN94 | Os botões **Escalar todos** e **Escalar todos os <instrumento>** (por exemplo, todas as vozes ou todos os violões) são da lista do evento. **Escalar todos** adiciona todos os membros ativos do ministério; o botão de instrumento adiciona só quem toca aquele instrumento. Quem já está na lista não é duplicado. Os botões não escalam ninguém em seções. |

## Usuários, papéis e permissões

| Papel | O que pode |
| --- | --- |
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

Coordenadores geram um **link de convite** e o enviam à pessoa. O link tem o cargo que a pessoa terá (ministeriado ou coordenador), é de uso único e vale 30 minutos. Não há e-mail do convidado, e quem convida só escolhe o cargo. Logo após gerar o link, quem o criou vê a contagem do tempo restante até a expiração.

1. A pessoa abre o link, informa nome completo, e-mail e senha e pede o código. O código de 6 dígitos chega ao e-mail; ela o digita e a conta é criada com o cargo do convite, já logada. O convite só é consumido nesse momento.
2. Se o e-mail já tem conta, a API responde `409 CONTA_EXISTENTE` e o app orienta a fazer login e abrir o link de novo.
3. No primeiro login, a pessoa escolhe os instrumentos que toca (zero ou mais) e pode alterá-los depois.

A conta inicial (coordenador) é criada direto no banco, porque ainda não há quem convide. Veja [Rodando localmente](#rodando-localmente).

## Convidados de evento

Permite que alguém de fora do ministério participe de um evento.

1. Um coordenador gera o **link de convite do evento**. Ele vale 30 minutos e é de uso único.
2. A pessoa abre o link e cria a conta (ou, se já é convidada, entra e abre o link). Ela é registrada como convidada do evento, em `eventos_convidados`.
3. A conta tem papel `CONVIDADO` e fica depois do evento. Pode ser convidada para outros eventos e, se virar ministeriada, passa ao papel de ministeriado.

| O convidado | |
| --- | --- |
| Vê | Tudo o que um membro vê: dashboard, biblioteca, listagens, busca, usuários, eventos, setlists, cifras e presença. |
| Faz | Cuida da própria conta, escolhe seus instrumentos nas configurações de perfil, confirma a própria presença nos eventos a que foi convidado e ativa as notificações. |
| Não faz | **Editar qualquer coisa**: músicas, cifras, tons, listas, eventos, artistas e instrumentos, marcar revisão e criar listas. |

Cada rota de gravação da API confere o papel e recusa o convidado, exceto nas ações da própria conta, nos instrumentos e na presença. O convidado não conta nos números do dashboard. O acesso dele dura enquanto estiver em ao menos um evento, e o coordenador o encerra removendo-o dos eventos (RN10). A página do convidado só é vista por quem a RN59 permite.

## Dashboard e listagens

Página inicial do app para **todos os usuários logados**, inclusive convidados (que só leem).

### Indicadores

| Indicador | O que mostra |
| --- | --- |
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
| --- | --- | --- |
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

## Cifra, graus e tons

A cifra é guardada **em graus do campo harmônico**, no estilo do Nashville Number System, com os algarismos de 1 a 7, e o app a mostra em letras, em qualquer tom. Quem escreve em graus pode digitar em algarismos ou em romanos (RN97), e a tela mostra como a pessoa configurou. A escrita dos acordes segue **um só padrão**, descrito nesta seção. O app grava sempre esse padrão. Ao digitar, aceita também algumas variações de escrita, listadas em RN95, e converte tudo para o padrão antes de gravar.

### Padrão de escrita

O grau toma o lugar da letra da nota, e o resto do acorde segue as regras de sufixo, alteração e baixo desta seção.

| Em letras (padrão) | Em graus | Significado |
| --- | --- | --- |
| `C` | `1` | Acorde maior sobre o primeiro grau. |
| `Dm`, `Em`, `Am` | `2m`, `3m`, `6m` | Acordes menores. |
| `Eb`, `Bb`, `F#` | `3b`, `7b`, `4#` | Graus alterados: o `b` ou o `#` vem depois do grau. |
| `C7` | `17` | Com sétima. |
| `C7M` | `17M` | Sétima maior. |
| `Cm7` | `1m7` | Menor com sétima. |
| `C6`, `C6(9)` | `16`, `16(9)` | Sexta, e sexta com nona. |
| `C9` | `19` | Nona adicionada (`add9`), sem sétima. |
| `C7(9)` | `17(9)` | Nona dominante, com sétima. |
| `C2` | `12` | Suspensa de segunda. |
| `C4` | `14` | Suspensa de quarta. |
| `C7(4)` | `17(4)` | Suspensa de quarta com sétima. |
| `C11` | `111` | Quarta adicionada (`add4`). |
| `C5+` | `15+` | Aumentado. |
| `Cm5-` | `1m5-` | Tríade diminuta. |
| `Cº` | `1º` | Sétima diminuta. |
| `Cm7(5-)` | `1m7(5-)` | Meio-diminuto. |
| `C7(9-)`, `C7(9+)`, `C7(5+)` | `17(9-)`, `17(9+)`, `17(5+)` | Alterações: dentro dos parênteses, o número vem antes do sinal, e o sinal é `+` (aumentado) ou `-` (diminuto). Quem digita também pode usar `b` e `#`, veja RN95. |
| `C7(9/11+/13-)` | `17(9/11+/13-)` | Várias extensões, em ordem crescente, separadas por `/`. |
| `C/E`, `D9/C#` | `1/3`, `29/1#` | Baixo depois da barra, também em grau. |
| `Cm` em tom menor | `1m` | Em música de tom menor, o grau `1` é sempre a tônica. |

O grau tem sempre **um só algarismo**, então `111` lê-se grau `1` com sufixo `11`, e `14` lê-se grau `1` com sufixo `4`. Na tela, o app desenha o grau em destaque e o sufixo menor, em sobrescrito, para a leitura ficar clara.

### Tutorial de acordes

A página `/ajuda/acordes` ensina o padrão de escrita para quem digita a cifra. Qualquer pessoa logada a abre, e o editor de cifra tem o link **Como escrever acordes**. Ela mostra:

1. **Como o app guarda a cifra:** em graus, e por que isso permite ver a música em qualquer tom.
2. **A tabela do padrão**, com a escrita em letras, a escrita em graus e o significado, agrupada por tipo (maiores e menores, sétimas, suspensas, nona e extensões, alterações, diminutos, baixo).
3. **As regras que mais confundem:** `9` é nona adicionada e a nona dominante é `7(9)`; `b` e `#` valem na raiz e no baixo; dentro dos parênteses o padrão é `+` e `-`, e `b` e `#` também são aceitos ao digitar, mas o app grava `+` e `-`; `7M` e não `maj7`.
   + A página mostra uma tabela de equivalências: `C7(b9)` e `C7(-9)` viram `C7(9-)`; `C7(#5)` e `C7(+5)` viram `C7(5+)`.
4. **Um exemplo completo:** uma estrofe com acordes sobre a letra, escrita em graus e mostrada em letras.
5. **Experimente:** um campo onde a pessoa digita um acorde e vê na hora se o app o reconhece, como ele é gravado (no padrão) e como aparece em um tom escolhido. Nada é gravado.
6. **Variações aceitas:** a tabela de RN95, com a grafia digitada, a gravada e a exibida, e uma nota de que o app sempre grava e mostra no padrão, mesmo que a pessoa digite de outro jeito.

A tabela da página, a lista de variações e o leitor de acordes saem da **mesma lista de formas** em `src/lib/cifra/`, então o tutorial nunca diverge do que o app reconhece.

### Formato

A cifra é um texto em que a linha de acordes fica logo acima da linha da letra, e cada acorde começa na coluna da sílaba onde deve ser tocado. Por exemplo:

```
1       5     6m
Senhor, tu és fiel
```

- **Linha de acordes:** uma linha cujos itens são todos acordes válidos (pela gramática de graus), na posição indicada pela RN96. Um marcador `[Seção]` no início da linha é permitido e não conta como acorde. Por isso, `[Intro] D Em A` é uma linha de acordes. Uma linha de acordes pode ser seguida de outra linha de acordes, e isso forma um trecho instrumental.
- **Linha de letra:** qualquer outra linha. A linha de acordes logo acima dela vale para ela.
- **Linha instrumental:** linha de acordes sem linha de letra logo abaixo. Ela aparece na visualização com acordes. No modo Letra, os acordes somem. Um marcador de seção que estiver nela (como `[Intro]` ou `[Solo]`) só aparece se o botão **Seções** estiver ativo (RN87).
- **Seção da música:** uma linha só com `[Nome]`, como `[Refrão]` ou `[Verso 1]`, sem acordes. Ao salvar, o app garante uma linha em branco acima e outra abaixo, mesmo que a pessoa não as tenha digitado. O app não valida o nome. É um marcador de organização, separado das seções do setlist.
- **Monoespaçado e quebra por pares:** a cifra é exibida em fonte de largura fixa. O editor não quebra linha. O visualizador pode quebrar uma linha longa, mas quebra a linha de acordes junto com a linha de letra, no mesmo ponto, em um espaço da letra. Cada trecho mostra os próprios acordes acima do próprio texto. Por exemplo, `A       B` sobre `Linha longa` vira dois blocos: `A` sobre `Linha` e `B` sobre `longa`.
- **Modo Letra:** mostra só as linhas de letra, sem os acordes. Com o botão **Seções** ativo, mostra também as seções, incluindo as de intro e solo. Sem alinhamento a preservar, a letra pode quebrar linha normalmente.

Como os acordes são identificados pela gramática, não há escape nem validação de colchetes na letra.

### Como funciona

- **Escrever:** a pessoa digita a cifra em graus ou em um tom qualquer e informa o tom em que digitou. O front converte tudo para graus antes de enviar. O banco recebe e guarda só graus.
- **Ler:** a tela da música mostra os graus. A pessoa escolhe um tom e o front converte na hora para as notas daquele tom. A escolha vale só para quem está vendo, e nada é gravado. Se a música tem tom original, ele aparece destacado na lista de tons, sem ser escolhido por padrão.
- **Tom do evento:** no setlist ou na lista, uma música pode ter um **tom tocado** (por exemplo, "no evento X tocamos esta música em D"). Quem abre o evento vê a cifra já nesse tom. Esse tom fica só no item do setlist e nunca altera a música. Em tom menor (`F#m`), a tônica (`F#`) é o que vale para a conversão.
- **Cifra local:** no setlist, a cifra pode ser editada só para aquele evento (também em graus), sem mudar a música.

### Tela de leitura

Na tela de uma música com cifra:

- **Tamanho da fonte:** botões para aumentar e diminuir. O tamanho inicial vem da configuração (RN91).
- **Rolagem automática:** botão de iniciar e pausar, com botões de mais e menos velocidade que valem na hora. Só o botão pausa: rolar a tela com o dedo avança a música e não pausa.
- **Tom original:** aparece destacado ao lado do seletor de tom, quando preenchido. Não é escolhido por padrão (RN33).
- **Transpose:** botões de meio tom e de tom, para cima e para baixo, a partir do tom de referência (veja RN33). Desativado sem tom de referência, em graus e no modo letra.
- **Letra:** alterna entre a cifra com acordes e só a letra, sem acordes. Combina com o aumento de fonte e com a rolagem automática. A tela abre no padrão da configuração (RN91).
- **Exportar:** abre o diálogo de exportação, com formato (Markdown ou PDF), conteúdo (cifra ou letra), seções (só na letra), link do YouTube (desligado por padrão) e tom. O tom começa no da tela, e trocá-lo no diálogo não muda a tela (RN88). Conteúdo e seções começam no padrão da configuração (RN91).
- **Seções:** aparece só no modo Letra. Liga e desliga a exibição dos marcadores de seção (`[Refrão]`, `[Intro]`, `[Solo]`…). **Padrão: desativado**, ou o que a configuração indicar (RN91).
- A velocidade da rolagem fica salva no próprio aparelho, sem passar pelo servidor. Os botões de fonte, letra e seções não são gravados.

### Tutorial de escrita

Este é o conteúdo da página `/ajuda/acordes` (RF68). Ele explica como a cifra é gravada, como o app padroniza o que você digita e quais grafias são aceitas (RN95, RN96, RN97, RN98, RN99, RN100, RN101).

Este é o conteúdo da página `/ajuda/acordes` (RF68). Ele explica como a cifra é gravada, como o app padroniza o que você digita e quais grafias são aceitas (RN95).

#### Como a cifra é guardada

O app grava a cifra em **graus do campo harmônico**, com algarismos de 1 a 7. O grau **1** é a tônica, e o **5** é a dominante, por exemplo. Como o grau não depende da tonalidade, a mesma música aparece em qualquer tom. Você escreve uma vez e a tela mostra em letras no tom que quiser.

A escrita dos acordes segue **um padrão fixo**: letras para as notas, `m` para menor, `7M` para sétima maior, `+` e `-` nas alterações. Tudo que é gravado segue esse padrão.

#### Processo de padronização

Quando você salva a cifra, o app faz estes passos:

1. **Separa** cada linha em partes: acordes, letra, marcador de seção (`[Refrão]`) e linhas vazias.
2. **Reconhece** cada acorde pela tabela de formas (Tabela do padrão). Variações conhecidas são convertidas para o padrão (Variações que você pode digitar).
3. **Converte** as letras para graus, usando o tom que você escolheu como tom da escrita. Se você escreveu em graus, nada muda.
4. **Grava** só os graus, com as posições dos acordes na letra.
5. **Avisa** sobre o que não reconheceu. Uma linha com um item que o app não entende é tratada como letra, e o aviso mostra o item. Nada é recusado.

O texto original que você digitou não fica guardado. O que fica é o padrão em graus.

#### Tabela do padrão

##### Maiores e menores

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C` | `1` | Maior, sobre o primeiro grau. |
| `Dm`, `Em`, `Am` | `2m`, `3m`, `6m` | Menor. |
| `Eb`, `Bb`, `F#` | `3b`, `7b`, `4#` | Grau alterado: o `b` ou o `#` vem depois do grau. |
| `Cm` em tom menor | `1m` | Em tom menor, o grau 1 é a tônica. |

##### Sétimas

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C7` | `17` | Dominante: maior com sétima menor. |
| `C7M` | `17M` | Sétima maior. |
| `Cm7` | `1m7` | Menor com sétima. |

##### Sextas e nonas

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C6` | `16` | Sexta. |
| `C6(9)` | `16(9)` | Sexta com nona. |
| `C9` | `19` | Nona adicionada (`add9`), **sem sétima**. |
| `C7(9)` | `17(9)` | Nona dominante, **com sétima**. |
| `C7M(9)` | `17M(9)` | Nona com sétima maior. |

Atenção: no padrão do app, `C9` é nona adicionada. A nona dominante é sempre `C7(9)`. Em algumas bibliotecas americanas, `C9` quer dizer nona dominante. Aqui não.

##### Suspensas

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C2` | `12` | Suspensa de segunda (`sus2`). |
| `C4` | `14` | Suspensa de quarta (`sus4`). |
| `C7(4)` | `17(4)` | Suspensa de quarta com sétima. |

##### Quarta adicionada

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C11` | `111` | Quarta adicionada (`add4`), **sem sétima**. |

Atenção: aqui `C11` quer dizer quarta adicionada, não a undécima dominante. Se o acorde tiver sétima, use `C7(11)`.

##### Alterações (dentro dos parênteses)

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C7(9-)` | `17(9-)` | Nona bemol. |
| `C7(9+)` | `17(9+)` | Nona sustenido. |
| `C7(5+)` | `17(5+)` | Quinta aumentada. |
| `C7(5-)` | `17(5-)` | Quinta diminuta. |
| `C7(9-/11+/13-)` | `17(9-/11+/13-)` | Várias alterações, em ordem crescente, separadas por `/`. |

Dentro dos parênteses, o número vem **antes** do sinal, e o sinal é `+` (aumentado) ou `-` (diminuto ou bemol). Você também pode digitar `b` e `#` ali (Variações que você pode digitar).

##### Aumentado, diminuto e meio-diminuto

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C5+` | `15+` | Tríade aumentada. |
| `Cm5-` | `1m5-` | Tríade diminuta. |
| `Cº` | `1º` | Sétima diminuta (quatro notas). |
| `Cm7(5-)` | `1m7(5-)` | Meio-diminuto (sétima menor com quinta diminuta). |

Para a tríade, escreva sempre `5+` ou `m5-`. Para a sétima diminuta, use `º`.

##### Baixo

| Em letras (padrão) | Em graus (gravado) | Significado |
| --- | --- | --- |
| `C/E` | `1/3` | Baixo na terça. |
| `Am7/G` | `6m7/5` | Baixo no quinto grau, em tom de C. |
| `Dm6/B` | `2m6/7` | Baixo no sétimo grau, em tom de C. |
| `D9/C#` | `19/7` | Em tom de D, o `C#` é o sétimo grau. |

Obs.: o baixo também é escrito em grau. O acidente vem depois do grau, como no acorde.

#### Variações que você pode digitar

Ao digitar, o app aceita estas variações e converte para o padrão. A coluna da direita é o que fica gravado e o que aparece na tela.

##### Alterações entre parênteses

| Você digita | Gravado | Observação |
| --- | --- | --- |
| `C7(b9)` | `C7(9-)` | `b` no lugar de `-`. |
| `C7(-9)` | `C7(9-)` | Padrão. |
| `C7(9b)` | `C7(9-)` | Sinal depois do número, como o padrão. |
| `C7(#5)` | `C7(5+)` | `#` no lugar de `+`. |
| `C7(+5)` | `C7(5+)` | Padrão. |
| `C7(b9,#11,b13)` | `C7(9-/11+/13-)` | Vírgula ou espaço viram `/`. Misturar `b` e `-` na mesma extensão também funciona. |

##### Sétimas, sus e add

| Você digita | Gravado |
| --- | --- |
| `Cmaj7`, `CM7`, `CΔ`, `C^7` | `C7M` |
| `Cmaj9` | `C7M(9)` |
| `Csus`, `Csus4` | `C4` |
| `Csus2` | `C2` |
| `C7sus4` | `C7(4)` |
| `Cadd9`, `Cadd2` | `C9` |
| `Cadd4` | `C11` |

##### Menor, sétima diminuta e meio-diminuto

| Você digita | Gravado |
| --- | --- |
| `C-7`, `Cmin7` | `Cm7` |
| `Cº`, `C°` | `Cº` |
| `Cm7b5`, `Cø` | `Cm7(5-)` |

##### Outros

| Você digita | Gravado |
| --- | --- |
| `C+` | `C5+` |
| `C6/9`, `C69` | `C6(9)` |
| `C13` | `C7(13)` |

##### Formas que não são aceitas

Estas formas não são aceitas, porque não dizem se o acorde é tríade ou sétima. Use a forma da coluna da direita.

| Não use | Use | Motivo |
| --- | --- | --- |
| `Cdim`, `Cdim7` | `Cm5-` (tríade) ou `Cº` (sétima) | `dim` não diz qual dos dois é. |
| `Caug` | `C5+` | `aug` não diz se é tríade. Use `5+`. |
| `dim`, `dim7`, `aug` sozinhos | a forma com a raiz, como acima | Sem raiz, não há acorde. |

##### Graus em romanos

Quem escreve em graus pode digitar em algarismos ou em romanos. Na configuração de visualização e no campo de escrita, o botão **Números** ou **Romanos** escolhe a forma. O que fica gravado é sempre em algarismos.

| Em romanos (digitado ou mostrado) | Em algarismos (gravado) | Observação |
| --- | --- | --- |
| `I` | `1` | Maiúsculo é maior. |
| `ii`, `IIm` | `2m` | Minúsculo é menor. `m` também é aceito, mas a tela, em romanos, mostra só `ii`. |
| `bVII`, `VIIb` | `7b` | `b` e `#` valem antes ou depois do numeral. |
| `#IV` | `4#` | |
| `V7M` | `57M` | Sufixos iguais aos de algarismos. |
| `viiº` | `7º` | Sétima diminuta. |
| `vii5-` | `7m5-` | Tríade diminuta. |

Na tela, em romanos, o `b` e o `#` ficam antes do numeral (`bVII`), como é comum. Em algarismos, ficam depois (`7b`).

##### Como o app reconhece uma linha de acordes

Não é preciso marcar nada. O app olha a posição da linha e o que ela contém.

- Uma linha é de **acordes** quando todos os seus itens são acordes válidos, e ela vem logo depois de uma seção (`[Refrão]`), de uma linha de letra ou de outra linha de acordes.
- A linha que traz um marcador de seção e acordes na mesma linha (`[Intro] D Em A`) também é de acordes.
- Uma linha de letra que não tem acordes continua sendo de letra, mesmo depois de outra letra. É o caso de um verso repetido sem cifra.
- Uma linha com um só item que também é palavra (`A`, `E`, `vi`, `I`) só é de acordes quando a linha seguinte é de letra. Assim, `vi`, que pode ser "eu vi", não vira acorde no meio de uma frase.
- Qualquer outra linha é de letra.

Exemplo:

```
[Refrão]
D      Bm      G       A7       ← acordes: vem depois da seção
Senhor, tu és fiel             ← letra: vem depois dos acordes
Em     A                       ← acordes: vem depois da letra
Tu és o meu Deus               ← letra
Eu vi a tua glória             ← letra: "vi" não é acorde, a linha tem palavras
```

#### O que não é reconhecido

Se o app não entender um acorde, ele não grava um acorde errado. A linha em que o item aparece é tratada como letra, e o editor mostra um aviso com o item. Exemplos:

- `C7alt`, `Cx`, símbolos que não estão nas tabelas;
- uma linha com acordes e uma palavra no meio, como `C Am Senhor G`.

Corrija o item no editor. O aviso some quando a linha vira acordes válidos.

#### Seções e repetições

**Seção.** Uma linha só com um nome entre colchetes: `[Intro]`, `[Verso 1]`, `[Refrão]`, `[Ponte]`, `[Solo]`. Use o nome que o grupo usa. O app não confere o nome.

**Repetição com `{x2}`.** Não escreva `(2x)`, `x2` nem `bis`. Use `{x2}` (ou `{x3}`, `{x4}`…). Onde você escreve o marcador define o que se repete:

- **No fim de uma linha:** repete essa linha.
- **Sozinho numa linha, depois de uma estrofe** (um bloco de linhas, separado por uma linha em branco): repete a estrofe.
- **Depois do nome da seção:** repete a seção inteira, com a tag.

Exemplo, com o Refrão repetido duas vezes:

```
[Refrão] {x2}
D      Bm      G       A7
Senhor, tu és fiel
```

**O que o app faz com isso.**

- Ao salvar, ele junta em `{xN}` as estrofes e os trechos iguais e seguidos.
- Na tela completa e na exportação completa, mostra tudo expandido.
- No modo Reduzido, mostra só os acordes de cada seção, com `(2x)` quando a linha se repete.
- No editor, o modo Reduzido vem ligado por padrão e mostra as repetições em `{xN}`. Desligado, mostra a letra por completo.

#### Perguntas frequentes

**Por que graus e não letras?** Porque uma cifra em graus serve para qualquer tom. Você escreve uma vez e a música aparece em D, Eb ou qualquer outro tom.

**Posso digitar em letras?** Sim, em um tom que você informa como tom da escrita. O app converte para graus. Sempre se grava em graus.

**Por que `C9` não é nona dominante?** No padrão do app, `9` é nona adicionada. A nona dominante é `C7(9)`. Isso é o que a maioria dos músicos brasileiros escreve.

**Por que `b` e `#` às vezes não funcionam?** Fora dos parênteses, `b` e `#` são acidentes da nota (`Bb`, `C#m7`). Dentro dos parênteses, eles viram alteração: `(b9)` é o mesmo que `(-9)`.

**O app mostra o que eu digitei?** Não. Ele mostra o padrão, em letras, no tom que você escolher.

**Quem vê a cifra em outro tom?** Qualquer pessoa. A escolha de tom vale só para quem está vendo e não é gravada.

#### Experimente

Um campo onde você digita um acorde e vê:

- se o app reconhece;
- como fica gravado (em graus);
- como aparece no tom que você escolher.

Nada é gravado.

#### Exemplo completo

Digitado em letras, no tom de **D**:

```
D      Bm      G       A7
Senhor, tu és fiel
```

Gravado em graus:

```
1      6m      4       57
Senhor, tu és fiel
```

Na tela, no tom de **E**:

```
E      C#m     A       B7
Senhor, tu és fiel
```

A letra não muda. Só os acordes são convertidos.

## Eventos, setlists e listas

### Eventos

Um **evento** tem nome, data e hora, `slug` e a opção `requerir_presenca`. Coordenadores criam, editam e cancelam eventos. Um evento cancelado fica no histórico, sai dos próximos eventos e não conta nas execuções.

### Coleções: setlist e lista

Setlist e lista genérica compartilham a estrutura da **coleção**, diferenciada por `tipo`:

| | SETLIST | LISTA |
| --- | --- | --- |
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
   + *Salvar na música*: a cifra editada passa a valer para a música, para todos.
   + *Salvar só neste setlist*: a cifra editada vale só neste setlist/lista.
   + O **tom tocado** fica sempre só no setlist ou na lista.
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

A pessoa apaga a própria conta em `/configuracoes/seguranca`, com confirmação pela senha e um aviso do que será perdido. A exclusão é definitiva e segue RN83. Só a própria pessoa apaga a conta; coordenadores só desativam e reativam.

### Conta e segurança

Em `/configuracoes/seguranca`, a pessoa vê, adiciona e remove os próprios e-mails, troca a senha, gera os códigos de recuperação, desativa e apaga a própria conta. A recuperação de senha ("esqueci a senha") fica na tela de login.

## Stack técnica

| Camada | Escolha |
| --- | --- |
| Frontend e backend | **Next.js 15** (App Router) + **React 19**, tudo em **TypeScript** (`strict`) |
| API | Route Handlers do Next (`src/app/api/**/route.ts`) |
| Banco | **PostgreSQL padrão** (Supabase em produção, usado só como banco; Postgres em Docker em desenvolvimento) |
| ORM | **Prisma 6**, com o schema gerado do banco (`prisma db pull`) |
| Validação | **Zod** |
| Autenticação | **JWT** (biblioteca `jose`, que roda também no middleware) em cookie `httpOnly`, senhas com **bcryptjs**; login com Google por OpenID Connect (`openid-client`) |
| Qualidade | **Vitest** (unitários e integração), **Playwright** (ponta a ponta), **ESLint** e **Prettier**, com **GitHub Actions** |
| Drag-and-drop | **dnd-kit** (`@dnd-kit/core`, `@dnd-kit/sortable`, `@dnd-kit/utilities`) |
| Push | Web Push + VAPID (biblioteca `web-push`) |
| Fotos de perfil | **Postgres** (tabela `fotos_perfil`), redimensionadas no servidor com **sharp** |
| Lembretes | **Vercel Cron** |
| Exportação | Markdown como texto; PDF gerado por código com `pdf-lib` e fontes embutidas (monoespaçada para a cifra, proporcional para a letra). Sem navegador headless. |
| E-mail | **Resend** (plano gratuito), isolado em `src/lib/email.ts` para poder ser trocado |
| Busca | PostgreSQL com `pg_trgm` e `unaccent`, em consultas SQL parametrizadas (`$queryRaw`) |
| Documentação da API | **Swagger / OpenAPI**, público |
| Deploy | **Vercel** (deploy automático por push no GitHub) |

Tudo num único projeto TypeScript (front e back), sem plataformas além de Vercel, GitHub e Supabase (o Resend, só para e-mail).

### Decisões de arquitetura

| Decisão | Motivo |
| --- | --- |
| Autenticação própria (JWT em cookie `httpOnly`) | Atende a vários e-mails por conta, convites de 30 minutos e códigos de recuperação, que exigem fluxos próprios. O Supabase entra só como banco. |
| Cifra guardada em graus | Uma única fonte serve qualquer tom. O tom original e o tocado são informações à parte. |
| PDF gerado no código, com `pdf-lib` | Mantém o texto selecionável, com fontes embutidas, e roda na Vercel sem navegador. |
| Busca com `pg_trgm` e `unaccent` | Os títulos são curtos e a busca é por trecho. Trigramas atendem sem depender de raízes de palavras. |
| Fotos no Postgres | Mantém menos peças (RNF08), e a foto é pequena (256 px). |
| Resend atrás de `src/lib/email.ts` | O plano gratuito basta, e a camada própria permite trocar de provedor. |
| Prisma com `db pull` e `$queryRaw` | O `DDL.SQL` é a fonte da verdade, e a busca usa funções que o Prisma não expressa. |
| `ordem` decimal (média dos vizinhos) | Reordenar atualiza uma única linha (RNF04). |
| Contador `versao` | Detecta edição simultânea sem travar ninguém (RNF13). |
| Limite de tentativas no banco | A Vercel não guarda memória entre requisições, e a hospedagem fica restrita às plataformas da RNF08 (RNF15). |
| Cache de cliente (service worker e IndexedDB), só leitura offline | O volume é pequeno e o offline não edita, então não há conflito a resolver. Cache de servidor não se justifica nesse porte. |
| Banco relacional (PostgreSQL) | O modelo se conecta por chaves e precisa de transações, como no histórico. Campos de estrutura livre usam `JSONB`. |

## Modelo de dados

29 tabelas e 2 views, definidas em **`DDL.SQL`** (PostgreSQL 13 ou superior). O arquivo tem quatro partes: a **parte 1** (tabelas, chaves e únicas) é a mais segura para visualizadores como o Esquema 3D; a **parte 2** (CHECKs e índices), a **parte 3** (views) e a **parte 4** (instrumentos iniciais) podem ser apagadas se o visualizador não as reconhecer.

Os itens principais (usuários, instrumentos, artistas, músicas, eventos e coleções) têm `criado_em` e `atualizado_em`, e o banco mantém `atualizado_em` por trigger. Também têm data o histórico (`musica_versoes.criado_em`), `eventos.data_evento`, `convites_acesso.expira_em`, `codigos_email.expira_em` e `limites_tentativas.janela_fim`, todas com fuso (`TIMESTAMPTZ`). A parte 2 cria as extensões `pg_trgm` e `unaccent` e a função `busca_norm`, usadas na busca (veja [Busca e ordenação](#busca-e-ordenação)).

| Tabela | Propósito |
| --- | --- |
| `usuarios` | Pessoas. `papel` (`COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`), `ativo` (vazio para convidados), `slug`, hash da senha, `token_versao` (invalida as sessões antigas quando a senha muda) `criado_em` é também a data do aceite dos termos. |
| `preferencias_usuario` | A configuração de visualização e de exportação de cada pessoa (RN91): padrão da tela (cifra ou letra), seções na letra, tamanho da fonte e padrão do arquivo exportado. Uma linha por pessoa, guardada na conta. |
| `emails_usuario` | Os e-mails de cada pessoa: de um a três por conta, únicos no sistema e em minúsculas. Só entram os confirmados por código. |
| `contas_google` | O vínculo com uma conta Google, para o login com Google (um por conta). |
| `fotos_perfil` | A foto de perfil de cada pessoa, em bytes (`BYTEA`), já redimensionada, com o tipo MIME. Uma por usuário, no máximo. |
| `codigos_email` | Códigos de 6 dígitos enviados por e-mail, só o hash. `finalidade` é `CADASTRO` (antes da conta existir), `REDEFINICAO` ou `TROCA_EMAIL`. Tem expiração de 30 minutos e contador de `tentativas`; a linha é apagada ao usar o código. |
| `codigos_recuperacao` | Os 10 códigos de recuperação de cada pessoa, só o hash, e se cada um já foi usado. |
| `instrumentos` | Catálogo de instrumentos, com `nome` e `slug`. |
| `usuarios_instrumentos` | Quais instrumentos cada pessoa toca. |
| `artistas` | Compositores e intérpretes, com `nome` e `slug`, e página própria. |
| `musica_versoes` | O histórico da música: número, título, `tipo` (`MUSICA` ou `TOM_TOCADO`), cifra e tom original (no tipo `MUSICA`), tom tocado e setlist ou lista (no tipo `TOM_TOCADO`), autor (`usuario_id`), data e de qual versão veio, se foi restaurada. |
| `musica_versoes_artistas` | Os artistas de cada versão do tipo `MUSICA`, em ordem. Guarda a referência ao artista, não o nome. |
| `musicas` | A biblioteca: título, `slug`, cifra em graus, tom original (opcional, só informativo), link do YouTube, marca de revisão e `versao`. Sem músicos. |
| `musica_artistas` | Os artistas de cada música, em ordem (`posicao`). Uma música tem pelo menos um. |
| `status_escuta` | Status pessoal por usuário × música. |
| `eventos` | Missas, ensaios, retiros: nome, `slug`, data e hora, `requerir_presenca` e `cancelado`. |
| `eventos_convidados` | Quais eventos cada convidado pode acessar. |
| `convites_acesso` | Convites de uso único: token, cargo, quem criou, evento (só para convidados) e `expira_em` (30 minutos). A linha é apagada ao usar o convite. |
| `secao_musicos` | **A escala de cada seção**: quem toca cada seção do setlist. Sem usuário (vazio) em eventos passados quando a conta é apagada. |
| `colecao_musicos` | **A escala do evento**: as pessoas escaladas para o evento inteiro. Sem usuário (vazio) em eventos passados quando a conta é apagada. |
| `confirmacoes_presenca` | Presença por evento × usuário (vazio, vai ou não vai). Fica sem usuário (vazio) quando a conta é apagada. |
| `colecoes` | Setlist (com `publicado`) ou lista. |
| `listas_donos` | Os donos de cada lista, com ordem (`posicao`). O primeiro dono entra no slug. |
| `listas_acessos` | Quem recebeu do dono o acesso de edição de uma lista (editores). |
| `slugs_antigos` | Slugs que deixaram de ser usados por renomeação, para o redirecionamento. |
| `secoes` | Agrupamentos opcionais dentro de uma coleção. |
| `colecao_musicas` | Música na coleção: tom tocado (opcional), cifra local (opcional), ordem e versão. |
| `device_tokens` | Inscrições de push (endpoint, chaves) por usuário. |
| `limites_tentativas` | Contador do limite de tentativas (login, convites, códigos), no banco por causa da Vercel. |

| View | Propósito |
| --- | --- |
| `vw_execucoes` | Uma linha por música tocada em cada evento. Base das contagens. |
| `vw_ultima_execucao` | Última vez que cada música foi tocada. |

Os ids são `UUID` gerados pelo banco (`gen_random_uuid()`), então um `INSERT` direto no `psql` funciona sem informar o id. A parte 4 do `DDL.SQL` cadastra os instrumentos iniciais: Voz, Violão, Guitarra, Baixo, Teclado, Bateria e Cajón.

### Diagrama

```mermaid
erDiagram
    USUARIO }o--o{ INSTRUMENTO : "toca"
    ARTISTA }o--o{ MUSICA : "compoe"
    USUARIO ||--o{ STATUS_ESCUTA : "marca"
    MUSICA ||--o{ STATUS_ESCUTA : "recebe"
    USUARIO ||--o{ CONVITE_ACESSO : "cria"
    EVENTO |o--o{ CONVITE_ACESSO : "convida para"
    EVENTO ||--o{ EVENTO_CONVIDADO : "libera"
    USUARIO ||--o{ EVENTO_CONVIDADO : "acessa"
    EVENTO ||--o{ CONFIRMACAO_PRESENCA : "pede"
    USUARIO ||--o{ CONFIRMACAO_PRESENCA : "responde"
    EVENTO |o--o| COLECAO : "setlist"
    USUARIO }o--o{ COLECAO : "é dono"
    COLECAO ||--o{ LISTA_ACESSO : "compartilha"
    USUARIO ||--o{ LISTA_ACESSO : "edita"
    COLECAO ||--o{ SECAO : "divide em"
    COLECAO ||--o{ COLECAO_MUSICA : "contem"
    SECAO |o--o{ COLECAO_MUSICA : "agrupa"
    SECAO ||--o{ ESCALA_SECAO : "escala da seção"
    USUARIO ||--o{ ESCALA_SECAO : "toca em"
    INSTRUMENTO ||--o{ ESCALA_SECAO : "usa"
    COLECAO ||--o{ ESCALA_EVENTO : "escala do evento"
    USUARIO ||--o{ ESCALA_EVENTO : "está no evento"
    MUSICA ||--o{ COLECAO_MUSICA : "aparece em"
    USUARIO ||--o{ DEVICE_TOKEN : "registra"
    USUARIO ||--|| PREFERENCIA : "configura"
    MUSICA ||--o{ MUSICA_VERSAO : "tem histórico"
    USUARIO |o--o{ MUSICA_VERSAO : "grava"
    COLECAO |o--o{ MUSICA_VERSAO : "tom tocado"
    MUSICA_VERSAO |o--o{ MUSICA_VERSAO_ARTISTA : "guarda"
    ARTISTA }o--o{ MUSICA_VERSAO_ARTISTA : "aparece em"
```

(`ESCALA_SECAO` é a tabela `secao_musicos`; `ESCALA_EVENTO`, a `colecao_musicos`; `EVENTO_CONVIDADO`, a `eventos_convidados`; `LISTA_ACESSO`, a `listas_acessos`; `PREFERENCIA`, a `preferencias_usuario`; `MUSICA_VERSAO` e `MUSICA_VERSAO_ARTISTA`, a `musica_versoes` e a `musica_versoes_artistas`.)

### Regras garantidas no banco

Estão na parte 2 do `DDL.SQL` e foram testadas tentando violá-las:

- `papel` só aceita `COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`; convidado tem `ativo` vazio, e os demais têm `ativo` preenchido.
- Convite de convidado exige evento; os outros convites não têm evento.
- O `slug` só aceita minúsculas, números e hífens.
- Nome de instrumento e de artista **únicos sem diferenciar maiúsculas nem acentos** (pela função `busca_norm`).
- Cada e-mail existe uma única vez no sistema, em minúsculas e com formato mínimo. Cada conta tem de um a três e-mails.
- A posição dos artistas de uma música é única, e a música tem pelo menos um. O conjunto de artistas e o título não se repetem, mas isso é validado pela API, não pelo banco.
- Tom tocado e tom original no formato `D`, `F#m` ou `Bb`.
- Nomes e títulos não vazios, e link do YouTube começando com `http://` ou `https://`.
- Cada versão tem número único por música e título não vazio. Uma versão `MUSICA` não tem setlist; uma `TOM_TOCADO` tem setlist e não tem cifra. Tons válidos em todas. Data de criação e atualização são mantidas pelo banco.
- A configuração aceita só `CIFRA` ou `LETRA` para visualização e exportação, e só `PEQUENA`, `MEDIA` ou `GRANDE` para a fonte.
- Em `colecoes`: SETLIST exige evento e não tem nome; LISTA exige nome, não tem evento e não é publicada. Os donos de uma lista ficam em `listas_donos`; uma lista sem donos é pública.
- Instrumento em uso e música usada em setlist ou lista não podem ser apagados (`RESTRICT`).
- O convite expira 30 minutos depois de criado, por padrão do banco.
- A finalidade de `codigos_email` é `CADASTRO` (sem usuário), `REDEFINICAO` ou `TROCA_EMAIL` (com usuário).
- `token_versao` começa em 1.

### Regras que a API valida

O banco não cobre estas:

- A seção de uma música pertence à mesma coleção da música.
- Apenas coordenadores convidam, alteram cargos, criam eventos e desativam e reativam contas. Ninguém além da própria pessoa apaga a conta, vê e-mails ou altera nome, foto e instrumentos dela (RN05, RN77).
- Conta desativada não edita nada: só visualiza e confirma presença.
- O convidado só lê (exceto conta, instrumentos e presença) e só tem acesso enquanto está em ao menos um evento de `eventos_convidados`.
- Uma lista é editada pelos donos e pelos editores (`listas_acessos`). Só os donos apagam a lista e gerenciam donos e acessos. Com **Edição pública** marcada, ou sem donos, todo membro ativo a edita; só coordenadores apagam uma lista sem donos (RN79). Só membros ativos e não convidados recebem qualquer papel nela. Todas as listas aparecem para todos os usuários logados (RN79).
- Os e-mails de uma pessoa só são devolvidos para ela.
- O login aceita qualquer e-mail confirmado da conta; os códigos de recuperação e de troca são enviados ao e-mail informado, que precisa ser confirmado.
- A gravação só é aceita se a `versao` enviada ainda for a atual.
- Nomes reservados pelas rotas não são aceitos como `slug`.
- Um código de e-mail ou de recuperação serve uma única vez. O código de e-mail é invalidado após o limite de tentativas.

### Evolução do esquema

- O `DDL.SQL` descreve o esquema completo e atual. Serve para criar um banco novo (desenvolvimento, testes e o primeiro deploy).
- Depois do primeiro deploy, cada mudança no banco é um script numerado em `db/migracoes/` (`0001_descricao.sql`, `0002_…`), aplicado em ordem em todos os ambientes. O mesmo commit atualiza o `DDL.SQL`, para que ele continue igual ao resultado de todas as migrações.
- Cada script roda em uma transação e é revisado como código. Uma mudança destrutiva (apagar coluna ou tabela) acontece em dois lançamentos: primeiro o código deixa de usar, depois o script remove.
- Depois de uma migração, rode `npx prisma db pull` e inclua o `schema.prisma` atualizado no mesmo commit.
- Antes de aplicar em produção, faça um backup (veja [Deploy](#deploy)) e teste o script em um banco criado com o `DDL.SQL` anterior.

## Esquema de URLs

### Regras gerais

- Todas as rotas exigem sessão, exceto as de `/auth/*`. Sem sessão, a pessoa vai para `/auth/login?voltar=<caminho>` e, depois de entrar, retorna ao caminho pedido. O parâmetro `voltar` só aceita caminho interno do app.
- `/` redireciona: sem sessão, para o login; com sessão, para `/inicio`.
- Cada item tem uma URL própria, `/<tipo>/<slug>`, em português e no plural. O `slug` é amigável e acompanha o nome (RN03, RN13); a chave interna continua sendo o UUID, que não aparece nas URLs de páginas.
- Quem não tem permissão para um item recebe **404**, igual a quando o item não existe, para não revelar o que existe. Isso vale, por exemplo, para quem abre a página de um convidado sem poder vê-la (RN59).
- Quando o nome muda e o slug muda com ele, a URL antiga redireciona (308) para a nova (RN13).
- Os `slug`s nunca coincidem com os trechos fixos das rotas (RN15): `nova`, `novo`, `editar`, `foto`, `parecidas`.
- O link de convite leva o token na URL. As páginas enviam `Referrer-Policy: no-referrer` para que o token não vaze por links externos.
- O caminho das rotas é em minúsculas. Um caminho com outra caixa (`/API/docs`) não é uma rota do app.

### Páginas

| Rota | Quem acessa | O que mostra |
| --- | --- | --- |
| `/` | todos | Só redireciona (veja acima). |
| `/auth/login` | sem sessão | Login, com "Lembrar de mim", o botão **Entrar com Google** e o link "esqueci a senha". |
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
| `/configuracoes/conta` | todos logados | Nome, foto e instrumentos. |
| `/configuracoes` | todos logados | Padrões de visualização e de exportação (RN91), data do aceite dos termos, links para os documentos e para as outras partes. |
| `/configuracoes/seguranca` | todos logados | E-mails, senha, Google, códigos de recuperação, desativação e exclusão da própria conta. |
| `/documentos/termos-de-uso` | todos | Termos de Uso, com download em Markdown ou PDF. |
| `/documentos/politica-privacidade` | todos | Política de Privacidade, com download em Markdown ou PDF. |
| `/coordenacao` | coordenadores | Convites e ativação e desativação de contas. |
| `/api/docs` | público | Swagger UI. |
| `/api/openapi.json` | público | Especificação OpenAPI. |

O convidado acessa todas as páginas de leitura, `/configuracoes`, `/configuracoes/conta`, `/configuracoes/seguranca`, `/documentos/termos-de-uso` e `/documentos/politica-privacidade`. As rotas de edição (`/nova`, `/novo`, `/editar`) e `/coordenacao` não abrem para ele.

A conta desativada acessa as páginas normalmente, mas as rotas de edição (`/nova`, `/novo`, `/editar`) e os botões de gravação ficam bloqueados (RN06).

### Compartilhar

Toda página de música, artista, instrumento, usuário, lista e evento (e de música dentro de um setlist ou lista) tem o botão **Compartilhar** no cabeçalho.

- No celular, abre o menu de compartilhamento do aparelho (Web Share API) com o título da página e o link. Onde esse menu não existir, o botão copia o link e avisa "Link copiado".
- O link é o endereço da própria página (`/<tipo>/<slug>`). Quem o abre precisa estar logado e ter permissão; senão vê 404 (RN82).
- Na página de uma **lista**, o botão **Compartilhar** tem a seção **Donos e acesso**, para os donos: incluir ou retirar donos e dar ou retirar acesso de edição. Editores veem a lista, mas não essa seção (RN79).

### Parâmetros das listagens

As listagens guardam o estado na URL (a pessoa pode compartilhar o link e o botão voltar funciona). Ao mudar a busca ou um filtro, `pagina` volta a 1.

| Parâmetro | Valores | Onde |
| --- | --- | --- |
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
| --- | --- | --- |
| 401 | `NAO_AUTENTICADO` | Sem sessão, ou com sessão inválida ou encerrada (`token_versao`). |
| 403 | `PROIBIDO` | A pessoa vê o item, mas não pode fazer a ação (por exemplo, um convidado gravando). |
| 404 | `NAO_ENCONTRADO` | O item não existe ou a pessoa não pode vê-lo (RN82). |
| 409 | `CONFLITO_VERSAO` | A `versao` enviada não é mais a atual (RN38). |
| 409 | `CONTA_EXISTENTE` | O e-mail do cadastro já tem conta. |
| 409 | `DUPLICADO` | Outra unicidade violada: nome de artista ou instrumento, título com os mesmos artistas, e-mail em outra conta. |
| 422 | `VALIDACAO` | O corpo ou os parâmetros não passam pelo schema Zod. |
| 429 | `LIMITE_TENTATIVAS` | Passou do limite de tentativas (RNF15), com `Retry-After` em segundos. |
| 500 | `ERRO_INTERNO` | Falha inesperada. O detalhe vai só para o log. |

A API é usada só pelo front do próprio app, por isso as rotas não têm número de versão (`/api/v1`).

## Busca e ordenação

### Onde há busca

| Onde | O que a busca compara |
| --- | --- |
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
7. **Música parecida.** Usa `similarity()` do `pg_trgm` entre os títulos normalizados, com limite de **0,4** (ajustável), mostrando as 5 mais parecidas em ordem decrescente. A pontuação não conta ("Segura na mão de Deus!" é igual a "Segura na mao de Deus"). É um aviso: quem bloqueia é só a duplicata exata de título e conjunto de artistas (RN34), validada pela API.
8. **No front.** A caixa de busca espera cerca de 300 ms sem digitação antes de consultar, cancela a consulta anterior se uma nova começa e grava o termo na URL (`?busca=`). O autocompletar de artista começa com 2 caracteres e mostra até 8 resultados.
9. **Offline.** As listagens já abertas continuam disponíveis; uma busca nova precisa de conexão (RNF02).
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
| --- | --- |
| Autenticação | `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/me`, `GET /api/auth/google` (inicia o login com Google), `GET /api/auth/google/callback` |
| Cadastro e senha | `GET /api/convites/{token}` (confere se o convite vale e mostra o cargo e o evento), `POST /api/auth/cadastro/codigo` (envia o código ao e-mail), `POST /api/auth/cadastro` (confirma o código, cria a conta e consome o convite), `POST /api/auth/esqueci-senha` (envia o código), `POST /api/auth/redefinir-senha` (código do e-mail ou de recuperação, mais a senha nova) |
| Conta | `GET, PATCH /api/conta` (nome), `PUT /api/conta/senha`, `PUT /api/conta/instrumentos`, `GET, POST /api/conta/emails` (lista; envia o código ao novo e-mail), `PUT /api/conta/emails/{id}` (confirma o código), `DELETE /api/conta/emails/{id}`, `DELETE /api/conta` (apaga a própria conta, com a senha), `GET /api/conta/google` (inicia o vínculo), `DELETE /api/conta/google` (desvincula, com a senha), `POST /api/conta/codigos-recuperacao`, `POST /api/conta/desativar`, `PUT, DELETE /api/conta/foto`, `GET, PUT /api/conta/preferencias` (padrões de visualização e de exportação, RN91) |
| Dashboard | `GET /api/dashboard?periodo=mes\|ano` (usuários logados) |
| Listagens | `GET /api/musicas`, `GET /api/artistas`, `GET /api/instrumentos`, `GET /api/usuarios`, `GET /api/listas`, `GET /api/eventos`. Os parâmetros são os da seção [Parâmetros das listagens](#parâmetros-das-listagens): `busca`, `ordem`, `pagina`, `periodo`, `ano`, `mes`, `artista`, `revisao`, `de`, `ate`. |
| Usuários | `GET /api/usuarios/{slug}`, `GET /api/usuarios/{slug}/foto` (com `Cache-Control` e `ETag`), `PATCH /api/usuarios/{id}` (cargo), `PATCH /api/usuarios/{id}/ativo` (desativar e reativar) |
| Convites | `POST /api/convites` (com `papel` e, para convidados, `evento_id`) |
| Instrumentos | `POST /api/instrumentos`, `GET /api/instrumentos/{slug}` (com o total e os músicos), `PATCH, DELETE /api/instrumentos/{id}` |
| Artistas | `POST /api/artistas`, `GET /api/artistas/{slug}`, `PATCH /api/artistas/{id}` (renomear) |
| Músicas | `POST /api/musicas`, `GET /api/musicas/parecidas?titulo=`, `GET /api/musicas/{slug}`, `GET /api/musicas/{slug}/exportar?formato=md\|pdf&modo=cifra\|letra&tom=&secoes=0\|1&link=0\|1`, `PATCH, DELETE /api/musicas/{id}`, `PUT /api/musicas/{id}/revisao`, `PUT /api/musicas/{id}/status-escuta` |
| Eventos | `POST /api/eventos`, `GET /api/eventos/{slug}` (com o setlist), `PATCH /api/eventos/{id}` (inclui cancelar), `POST /api/eventos/{id}/publicar`, `POST /api/eventos/{id}/copiar-setlist` |
| Listas | `GET /api/listas/{slug}` (com seções e músicas; donos e editores também recebem a lista de donos e acessos) |
| Documentos | `GET /api/documentos/{nome}?formato=md\|pdf`, com `nome` = `termos-de-uso` ou `politica-privacidade`. Público. |
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

## Estrutura de pastas

```
.
├─ DDL.SQL                   # modelo de dados em SQL (PostgreSQL)
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
│  │  │  │  ├─ configuracoes/   # visualização e exportação (padrões)
│  │  │  │  ├─ conta/       # nome, foto e instrumentos
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
│  │  ├─ busca.ts            # filtros de busca e ordenação (SQL parametrizado)
│  │  ├─ cifra/              # padrão de escrita, tabela do tutorial, conversão de tom para graus e de graus para tom
│  │  └─ ...                 # validadores Zod, slugs, etc.
│  └─ hooks/
├─ tests/
│  ├─ unit/                  # cifra, slugs, busca, autorizar
│  ├─ integration/           # rotas com PostgreSQL real, criado do DDL.SQL
│  └─ e2e/                   # Playwright
└─ .env.example
```

## Rodando localmente

Pré-requisitos: Node.js 20+ e Docker.

```bash
# 1. Postgres local
docker run --name musicaliapp-db -e POSTGRES_PASSWORD=dev -e POSTGRES_DB=musicaliapp \
  -p 5432:5432 -d postgres:16

# 2. Projeto Next com TypeScript e App Router
npx create-next-app@latest musicaliapp && cd musicaliapp

# 3. Dependências
npm i prisma@6 @prisma/client@6 zod jose bcryptjs openid-client web-push resend \
      sharp pdf-lib @dnd-kit/core @dnd-kit/sortable @dnd-kit/utilities \
      @asteasolutions/zod-to-openapi swagger-ui-react @serwist/next serwist
npm i -D @types/web-push @types/swagger-ui-react vitest @playwright/test prettier eslint

# 4. Variáveis de ambiente
cp .env.example .env.local
#   DATABASE_URL="postgresql://postgres:dev@localhost:5432/musicaliapp"
#   DIRECT_URL="postgresql://postgres:dev@localhost:5432/musicaliapp"
#   APP_URL="http://localhost:3000"

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
     INSERT INTO usuarios (nome, slug, senha_hash, papel)
     VALUES ('Seu Nome Completo', 'seu-nome', '$HASH', 'COORDENADOR')
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
| `JWT_SECRET` | Segredo para assinar o token de sessão. Longo e aleatório. |
| `NEXT_PUBLIC_VAPID_PUBLIC_KEY` | Chave pública VAPID, enviada ao navegador. |
| `VAPID_PRIVATE_KEY` | Chave privada VAPID. **Só no servidor.** |
| `VAPID_SUBJECT` | `mailto:` de contato exigido pelo VAPID. |
| `CRON_SECRET` | Segredo que o Vercel Cron envia à rota da rotina diária. |
| `RESEND_API_KEY` | Chave da API do Resend, para enviar os códigos. Sem ela, em desenvolvimento, o código é impresso no terminal. |
| `EMAIL_FROM` | Remetente dos e-mails, em um domínio verificado no Resend (ex.: `musicaliapp <nao-responda@seudominio.com>`). |
| `GOOGLE_CLIENT_ID` | Identificador do cliente OAuth no Google Cloud. |
| `GOOGLE_CLIENT_SECRET` | Segredo do cliente OAuth. **Só no servidor.** |
| `GOOGLE_REDIRECT_URI` | Endereço de retorno do login, ex.: `https://seu-app/api/auth/google/callback`. |
| `NODE_ENV` | `development` ou `production` (controla o cookie `secure`). |

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
| Integração | Vitest, com PostgreSQL 16 real (Docker local e *service container* na CI) | Cada rota por papel (coordenador, ministeriado, convidado, conta desativada e sem sessão); `versao` e `409 CONFLITO_VERSAO`; histórico (gravar e restaurar); convite consumido uma só vez em requisições simultâneas; exclusão de conta (RN83); limite de tentativas; as regras do `DDL.SQL`. |
| Ponta a ponta | Playwright (Chromium, em tela de celular e de computador) | Convite, cadastro com código e login; montar o setlist, reordenar e escalar; confirmar presença; exportar PDF; abrir offline. |

Os testes de integração usam um banco criado a partir do `DDL.SQL`, o que também valida o próprio DDL. Neles, a camada de e-mail é trocada por um *stub* que guarda o código enviado.

### Critério de pronto

Um requisito está pronto quando:

1. a regra está implementada e tem teste;
2. a autorização foi testada para cada papel;
3. `typecheck`, `lint` e os testes passam na CI;
4. a tela funciona no celular e pelo teclado;
5. o `DDL.SQL`, a migração e este README foram atualizados, quando mudaram;
6. não há segredo, e-mail real nem dado pessoal no código, nos testes ou nos logs.

### Integração contínua

Um workflow do GitHub Actions (`.github/workflows/ci.yml`) roda a cada push e pull request: `npm ci`, `tsc --noEmit`, lint, `prisma validate`, criação de um PostgreSQL 16 limpo com o `DDL.SQL` e os testes unitários e de integração. Os testes ponta a ponta rodam nos pull requests para a `main`. O Dependabot (`.github/dependabot.yml`) abre atualizações toda semana, e o `npm audit` reprova a CI diante de vulnerabilidade alta ou crítica.

### Acessibilidade e idioma

O app segue o nível AA do WCAG 2.1: contraste suficiente, tudo operável pelo teclado, rótulos nos campos, foco visível e alvos de toque de pelo menos 44 px (o uso no palco é com pouca luz e pressa). A interface, as mensagens e os formatos são em português do Brasil: datas como `18/10/2026 19:00`, em `America/Sao_Paulo` (RNF16).

## Deploy

- **Supabase:** crie o projeto na região de São Paulo e execute o `DDL.SQL` no *SQL Editor* (as extensões `pg_trgm` e `unaccent` estão disponíveis).
- **Vercel:** projeto único, com deploy automático a cada push no GitHub. Cadastre as variáveis acima em *Settings → Environment Variables*. O `vercel.json` agenda a rota `/api/cron/diario` uma vez por dia.
- **Conexão serverless:** em `DATABASE_URL`, use a conexão do **pooler** do Supabase com `?pgbouncer=true`.
- **Conta inicial:** crie-a com o mesmo `INSERT` da seção anterior, pelo SQL Editor.
- **Termos e privacidade:** antes do deploy, escreva `/documentos/termos-de-uso` e `/documentos/politica-privacidade` e revise com um advogado. Sem o aceite, o cadastro não conclui (RN84).
- **Google:** no Google Cloud, configure a tela de consentimento com os escopos `openid`, `email` e `profile` e publique o app, saindo do modo Teste. O modo Teste limita a 100 usuários e faz os tokens de atualização expirarem em 7 dias. Esses escopos não exigem verificação do Google.
- **E-mail:** crie a conta no Resend, verifique o domínio de envio nos registros DNS e cadastre `RESEND_API_KEY` e `EMAIL_FROM`. O plano gratuito envia a qualquer destinatário, mas só a partir de um domínio verificado.
- **Backup:** um workflow agendado do GitHub Actions (semanal) roda `pg_dump` com a conexão direta do Supabase (`DIRECT_URL`, não o pooler), cifra o arquivo (por exemplo, com `age`) e o guarda como artefato do workflow, com prazo de retenção definido. Teste a restauração em um banco vazio antes do uso real e depois de tempos em tempos: um backup que nunca foi restaurado não é garantia.
- **Ambientes:** desenvolvimento (Docker) e produção (Supabase). Os deploys de prévia da Vercel usam um segundo projeto do Supabase, nunca o banco de produção.
- **Região:** as funções da Vercel rodam em `gru1` (São Paulo), perto do banco, o que se configura no `vercel.json`.
- **Verificação depois do deploy:** entrar, abrir um setlist, exportar um PDF, instalar o app e receber um push. Se algo falhar, a Vercel permite voltar para o deploy anterior.

## Segurança

- Senhas guardadas com hash **bcrypt**; nunca em texto.
- Sessão em **cookie `httpOnly`**, `sameSite=lax` e `secure` em produção, inacessível ao JavaScript da página.
- Convites de uso único, com validade de 30 minutos, consumidos por um `DELETE ... RETURNING` atômico, que impede o uso duplo em requisições simultâneas.
- Toda entrada validada com **Zod**.
- **Autorização sempre no servidor**, por uma função central usada em todas as rotas: ela confere o cargo, o estado `ativo`, se o convidado só pode ler, o acesso do convidado (ao menos um evento) e, nas listas, o dono, o acesso concedido ou a condição de lista pública. O que o front esconde não conta como proteção.
- A rota `GET /api/cron/diario` só aceita a chamada que traz o `CRON_SECRET`.
- Fotos de perfil validadas no servidor (tipo e tamanho do arquivo enviado). Antes de gravar, são decodificadas e regravadas pelo `sharp`, o que remove metadados como localização e descarta conteúdo que não seja imagem válida.
- O Swagger e o `openapi.json` são públicos. A validação de sessão e de permissão fica nos endpoints.
- A chave privada VAPID, o `JWT_SECRET` e o `CRON_SECRET` nunca vão para o front nem para o repositório.
- Login, aceitação de convite e pedidos de "esqueci a senha" têm limite de tentativas (rate limit), contado na tabela `limites_tentativas`, por IP e por e-mail, ambos guardados em hash.
- A sessão (JWT) leva o `token_versao` da pessoa. Trocar ou redefinir a senha o incrementa, e a função central recusa tokens com versão antiga, o que encerra as outras sessões.
- O pedido de "esqueci a senha" responde igual exista ou não a conta. Os códigos de e-mail e de recuperação são guardados em hash. Os de e-mail valem 30 minutos e servem uma única vez.
- **Senha:** de 8 a 72 caracteres (o bcrypt ignora o que passa de 72 bytes), com custo 10. A conferência usa `bcrypt.compare`.
- **CSRF:** toda gravação usa `POST`, `PUT`, `PATCH` ou `DELETE`, com cookie `sameSite=lax`, e a API confere se o cabeçalho `Origin` é o de `APP_URL`. As rotas `GET` não alteram dados.
- **Login com Google:** `openid-client` com `state`, `nonce` e PKCE. O vínculo usa o `google_sub`, não o e-mail.
- **Cabeçalhos HTTP:** `Content-Security-Policy` restritiva (`default-src 'self'`, scripts com *nonce* e `frame-ancestors 'none'`), `X-Content-Type-Options: nosniff`, `Strict-Transport-Security` e `Referrer-Policy`, configurados em `next.config.ts` e no middleware.
- **Entrada e saída:** corpo com tamanho máximo em cada rota (2 MB só na foto), consultas sempre parametrizadas, e cifra e letra tratadas como texto puro, nunca como HTML.
- **Logs:** estruturados e sem dados pessoais. Não registram senha, código, token, e-mail nem IP puro; usam o id da pessoa e o `codigo` do erro (RNF20).
- **Dependências:** versões travadas no `package-lock.json`, com Dependabot e `npm audit` na CI.
- **Rotação de segredos:** trocar o `JWT_SECRET` encerra todas as sessões. Trocar as chaves VAPID invalida as inscrições de push, e as pessoas precisam reativar as notificações.

## Privacidade e LGPD

O app trata dados pessoais de membros de um ministério de igreja, e participar dele pode revelar a crença religiosa, que a LGPD classifica como dado sensível. Por isso o app coleta o mínimo e pede consentimento.

| Dado | Para quê | Onde fica |
| --- | --- | --- |
| Nome completo, e-mails (até 3) e hash da senha | Identificar a pessoa e permitir o acesso | `usuarios`, `emails_usuario` |
| Foto (opcional) | Reconhecer os músicos nas escalas | `fotos_perfil` |
| Instrumentos, escalas, presenças e status de escuta | Organizar os eventos | `usuarios_instrumentos`, `secao_musicos`, `colecao_musicos`, `confirmacoes_presenca`, `status_escuta` |
| Identificador do Google (`google_sub`, opcional) | Login com Google | `contas_google` |
| Inscrição de push | Avisar sobre setlists | `device_tokens` |
| Hash do IP e do e-mail, com a contagem de tentativas | Limite de tentativas | `limites_tentativas` (apagado todo dia) |
| Data do cadastro, que é o aceite dos termos | Registro do consentimento | `usuarios.criado_em` |

- **Consentimento:** o cadastro só conclui com o aceite dos Termos de Uso e da Política de Privacidade (RN84).
- **Minimização:** o app não pede CPF, telefone, endereço nem data de nascimento.
- **Quem vê o quê:** os e-mails só aparecem para a própria pessoa, e coordenadores não os veem (RN77, RN81). Quem tem acesso total ao banco, por isso essa conta é restrita a quem é de confiança.
- **Eliminação:** a pessoa apaga a própria conta, e seus dados saem (RN83). O histórico de eventos e de cifras permanece sem identificá-la ("Pessoa removida").
- **Retenção:** os dados duram enquanto a conta existir. Convites e códigos vencidos e os contadores de tentativas são apagados todo dia (RN72).
- **Pedidos do titular:** corrigir nome, e-mails, foto e instrumentos e apagar a conta a própria pessoa faz no app. Os demais pedidos (como uma cópia dos dados) vão ao responsável indicado na Política de Privacidade.
- **Operadores:** Vercel (hospedagem), Supabase (banco), Resend (e-mail), Google (login opcional) e os serviços de push dos navegadores. Alguns processam dados fora do Brasil, e a Política informa essa transferência.
- **Incidentes:** identificar e conter, avaliar o risco, trocar os segredos afetados e comunicar a ANPD e as pessoas atingidas nos casos e prazos da regulamentação vigente.
- **Textos jurídicos:** os Termos de Uso e a Política de Privacidade precisam ser escritos e revisados por advogado antes do uso (veja [Deploy](#deploy)).

## Sprints e milestones

Premissas: sprints de **2 semanas**. As datas de início e de fim serão definidas quando o desenvolvimento começar. Um milestone termina quando todos os requisitos listados nele estão implementados e testados, segundo o critério de pronto de [Qualidade e testes](#qualidade-e-testes). Cada requisito funcional (RF) pertence a um único milestone. A ordem segue as dependências: cada milestone usa o que o anterior entregou.

| Sprint | Milestone | Entrega principal | Requisitos |
| --- | --- | --- | --- |
| S1 | **M1 Fundação** | Projeto Next com TypeScript, banco aplicado a partir do `DDL.SQL`, login com "Lembrar de mim", login com Google vinculado, convites de 30 minutos, cargos, instrumentos, conta com foto, e-mail confirmado por código (envio pelo Resend), esqueci a senha por código, troca de senha e desativação e exclusão pela própria pessoa, termos e privacidade. Limite de tentativas no banco. Páginas próprias por `slug`. PWA instalável. | RF01, RF02, RF04 a RF09, RF41, RF43 a RF47, RF57, RF58, RF60, RNF15 |
| S2 | **M2 Biblioteca** | Cadastro e edição de músicas e artistas (inclusive renomear). Cifra em graus, com conversão para qualquer tom. Busca por título e artista, com aviso de músicas parecidas. Controle de versão e histórico da cifra, com título, autor e data. Revisão. Tutorial de acordes. | RF17, RF18, RF20, RF21, RF23 a RF25, RF63, RF68, RF71 |
| S3 | **M3 Leitura da cifra** | Tela da cifra com troca de tom, transpose, modo letra, aumento de fonte e rolagem automática com velocidade ajustável. Página de configurações, com os padrões de visualização e de exportação (RN91); a parte de segurança vem dos milestones M1 e M9. Exportação da cifra e da letra (Markdown ou PDF) e exportação em lote. | RF19, RF59, RF61, RF62, RF65, RF69, RF70 |
| S4 | **M4 Eventos e setlists** | Eventos com `slug`, cancelamento, setlists e listas com seções e vários donos. Reordenação por arrastar e soltar. Tom tocado por música. Cifra local e "Salvar na música" ou "Salvar só neste setlist". Botão Compartilhar, donos e acesso de edição às listas. Redirecionamento de slugs antigos. Listas visíveis a todos. | RF26 a RF29, RF34, RF54 a RF56 |
| S5 | **M5 Escala, presença e convidados** | Escala por seção e do evento, com os botões Escalar todos e Escalar todos os instrumentos, e as opções sobrescrever ou completar nas seções. Presença com Vou e Não vou. Convite de convidado para um evento, com acesso somente leitura. Página de instrumento com os músicos. | RF03, RF30, RF31, RF35, RF36, RF37, RF66, RF67 |
| S6 | **M6 Dashboard e listagens** | Dashboard com os números, instrumentos e próximos eventos. Listagens de músicas, artistas, instrumentos, usuários, listas e eventos, com busca, filtros e ordenação, 30 por página. Busca geral. Mais e menos tocados, com período mês, ano, geral ou um mês ou ano escolhido. Datas de criação e atualização nas páginas e listagens. | RF10 a RF16, RF49 a RF53, RF64 |
| S7 | **M7 Notificações e offline** | Publicação do setlist com push, e aviso aos coordenadores quando uma conta é desativada. Lembrete diário de presença pelo Vercel Cron. Cache offline somente leitura, com atualização ao abrir o app. | RF32, RF38 a RF40 |
| S8 | **M8 Entrega** | Swagger público. Testes de permissão para cada papel (inclusive convidado somente leitura e acesso às listas) e estado da conta. Deploy na Vercel e no Supabase. Conta inicial criada. Backup semanal do banco. | RF42, RNF10, RNF17 |
| S9 | **M9 Complementos** | Status de escuta (Não ouvi, Ouvi, Toquei). Códigos de recuperação de senha. Copiar o setlist de outro evento. | RF22, RF33, RF48 |

Dependências: M2 depende de M1. M3 depende de M2. M4 depende de M2. M5 depende de M4. M6 depende de M2 e M4. M7 depende de M5. M8 fecha a entrega inicial. M9 depende de M5 e pode vir depois do M8.
