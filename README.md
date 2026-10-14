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

Os requisitos têm identificadores estáveis: **RF** (requisito funcional), **RNF** (não funcional) e **RN** (regra de negócio). Um identificador não é reaproveitado, e as referências (por exemplo, "RN92") apontam para a regra de mesmo número. O texto, a interface, o banco, as rotas e as mensagens do app estão em português do Brasil.

### Glossário

| Termo | Significado |
|---|---|
| Cifra | A música escrita com acordes sobre a letra. Fica guardada em graus. |
| Grau | O acorde pela posição no campo harmônico (`1`, `4`, `5`, `6m`…). Não depende do tom. |
| Tom original | O tom em que a música costuma ser tocada ou foi escrita. Opcional e só informativo. |
| Tom tocado | O tom escolhido para uma música em um setlist ou lista. Vale só ali. |
| Evento | Missa, ensaio ou retiro, com data e hora. |
| Setlist | O repertório de um evento, no máximo um por evento. |
| Lista | Um repertório avulso, sem evento, com um ou mais donos. |
| Coleção | O que o setlist e a lista têm em comum: seções e músicas em ordem. |
| Seção | Agrupamento dentro de uma coleção ("Animação", "Adoração"). |
| Marcador de seção | A linha `[Refrão]` ou `[Verso 1]` dentro da cifra. Não é a seção da coleção. |
| Execução | Uma música tocada no setlist publicado de um evento que já aconteceu (RN24). |
| Ministeriado e coordenador | Cargos de membro. O coordenador convida e gerencia eventos e contas (RN05). |
| Admin | Indicador à parte do cargo. Só ele acessa o Swagger (RN04). |
| Convidado | Pessoa de fora, convidada para eventos. Vê tudo e não edita (RN56). |
| Slug | Parte legível da URL (`/musicas/<slug>`). Acompanha o nome (RN13). |
| Versão do histórico | Um ponto do histórico da música, com título, autor e data (RN92). |
| `versao` (contador) | Número que detecta edições simultâneas (RN38). Não é o histórico. |

## Requisitos

### Requisitos funcionais

| ID | Requisito |
|---|---|
| **Acesso e contas** | |
| RF01 | Coordenadores e o admin geram links de convite com o cargo que a pessoa terá. O link vale 30 minutos e serve uma única vez. Ao gerar o link, quem o criou vê quanto tempo falta para ele expirar. |
| RF02 | Quem recebe o convite informa nome completo, e-mail e senha, aceita os Termos de Uso e a Política de Privacidade (RF59), confirma o código enviado ao e-mail e entra logado. A conta só é criada depois da confirmação. |
| RF03 | Coordenadores e o admin geram o link de convite de **um evento** para uma pessoa de fora (convidado). |
| RF04 | Os usuários fazem login e logout. O botão **Lembrar de mim** vem marcado por padrão: marcado, o login fica salvo no aparelho e é renovado a cada acesso, sem prazo para expirar; desmarcado, vale só enquanto a sessão do navegador estiver aberta. |
| RF05 | Cada pessoa tem uma área de conta, onde altera nome, **foto de perfil** e instrumentos, e uma página de configurações com a segurança (senha, e-mails, apagar a própria conta), os termos e os padrões de visualização e exportação (RF58, RF66). |
| RF06 | Cada pessoa escolhe e altera os instrumentos que toca (zero ou mais). |
| RF07 | Coordenadores e o admin alteram o cargo de qualquer pessoa, inclusive tornando um convidado ministeriado. Nome, foto e instrumentos só são alterados pela própria pessoa (RN05). |
| RF08 | Coordenadores e o admin desativam e reativam contas. |
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
| RF18 | Escrever a cifra em graus ou em um tom qualquer; o app a guarda sempre em graus. A tela de escrita tem o campo **tom da escrita**, que é **graus** por padrão ou um tom. Esse campo só diz como converter o que foi digitado e não é guardado. |
| RF19 | Ver a cifra em qualquer tom, transpor de meio em meio tom ou de tom em tom, aumentar a fonte e usar a **rolagem automática**, com a velocidade ajustável durante a rolagem. Só o botão pausa; rolar a tela com o dedo avança a música e não pausa. Há também a opção **Letra**, que mostra só a letra, sem os acordes, com o botão **Seções** para mostrar ou ocultar os marcadores de seção (padrão: ocultos). Nesse modo a transposição fica desativada, porque não há acordes para transpor. |
| RF20 | Editar qualquer música, com aviso quando outra pessoa a alterou antes. Cada alteração da cifra, do tom original, dos artistas ou do tom tocado (no setlist ou na lista) gera uma versão no histórico, com título obrigatório (RN92). |
| RF21 | Marcar e desmarcar uma música para revisão. |
| RF22 | Marcar o status de escuta de uma música (Não ouvi, Ouvi, Toquei). |
| RF23 | Apagar as músicas que não estão em nenhum setlist ou lista. |
| RF24 | Buscar músicas por título e artista, vendo a última vez em que cada uma foi tocada. |
| RF25 | Criar, editar e apagar instrumentos, e cadastrar e renomear artistas. Todo usuário ativo pode renomear um artista (RN82). |
| **Eventos, setlists e listas** | |
| RF26 | Coordenadores criam, editam e cancelam eventos, com a opção de exigir confirmação de presença. |
| RF27 | Montar o setlist: adicionar músicas, criar seções e reordenar músicas e seções por arrastar e soltar. |
| RF28 | Definir, em cada música do setlist ou da lista, o tom que será tocado (opcional). |
| RF29 | Editar a cifra de uma música no setlist e escolher se a mudança vale só para o setlist ou para a música. |
| RF30 | Escalar os músicos de cada música do setlist (instrumento, depois pessoa). |
| RF31 | Escalar os músicos de uma **seção inteira**, com confirmação quando já há músicos definidos. |
| RF32 | Publicar o setlist de um evento. |
| RF33 | Copiar o setlist de outro evento. |
| RF34 | Criar listas genéricas de músicas, com seções e ordem. A lista pode ter mais de um dono e pode ser compartilhada para edição (RF56). |
| RF35 | Confirmar presença com **Vou** ou **Não vou**, trocar a resposta quando quiser e ver a resposta de todos. |
| RF36 | Ao abrir uma música, ser avisado se um músico escalado não confirmou, e poder substituí-lo. |
| RF37 | Ser avisado ao escalar alguém que já está escalado em outro evento no mesmo horário. |
| RF38 | O convidado vê tudo o que um membro vê (dashboard, biblioteca, listagens, busca, eventos, setlists, cifras, escala e presença), mas não edita nada. Pode apenas cuidar da própria conta, escolher seus instrumentos, confirmar presença nos eventos a que foi convidado e ativar as notificações (RN56). |
| **Notificações e uso offline** | |
| RF39 | Receber push quando um setlist é publicado, com o pedido de presença quando houver. |
| RF40 | Receber um lembrete na véspera, se ainda não respondeu à presença. |
| RF41 | Consultar os dados já carregados sem conexão. |
| RF42 | Instalar o app na tela inicial do celular. |
| **API** | |
| RF43 | O admin consulta a documentação da API (Swagger) em `/api/docs`. |
| **Conta e segurança** | |
| RF44 | Esqueci a senha: a pessoa informa o e-mail da conta, recebe um código de 6 dígitos e o usa para definir a senha nova. Pode usar um código de recuperação no lugar do e-mail. |
| RF45 | Cada conta tem de um a três e-mails, todos únicos no sistema. Cada e-mail é confirmado por código de 6 dígitos enviado a ele ao ser adicionado. Quando um código precisa ser enviado, a pessoa escolhe para qual dos seus e-mails. A pessoa entra com qualquer e-mail confirmado ou com o Google, se vinculado (RF61). |
| RF46 | Trocar a senha em `/configuracoes/seguranca`, informando a senha atual. |
| RF47 | Desativar a própria conta em `/configuracoes/seguranca`, com confirmação pela senha. Quem a reativa é um coordenador ou o admin. |
| RF48 | Coordenadores e o admin não veem os e-mails de ninguém, não apagam contas e não alteram nome, foto ou instrumentos de outra pessoa. O admin não define senha: a pessoa redefine a própria pelo código enviado a um dos seus e-mails. |
| RF49 | A pessoa gera 10 códigos de recuperação em `/configuracoes/seguranca`. Eles são mostrados uma única vez, cada um serve uma vez, e gerar de novo invalida os anteriores. |
| RF50 | A página de instrumentos lista todos, 30 por página, sem busca e sem filtro, com ordem A–Z ou Z–A. Cada item leva à página do instrumento. |
| RF51 | A página de listas tem busca pelo nome e ordem A–Z ou Z–A, 30 por página. Mostra todas as listas (RN81). |
| RF52 | A página de eventos tem busca pelo nome, filtro por data e ordem A–Z ou Z–A ou por data (mais recente ou mais antiga), 30 por página. |
| RF53 | A página de usuários tem busca pelo nome e ordem A–Z ou Z–A, 30 por página. Os e-mails de cada pessoa só aparecem para ela (RN83). |
| RF54 | Há uma **busca geral**: um campo de busca no topo do app leva à página `/busca`, que pesquisa ao mesmo tempo músicas, artistas, listas, eventos, usuários e instrumentos, com filtro por tipo. |
| RF55 | Toda página de música, artista, instrumento, usuário, lista e evento tem um botão **Compartilhar**: no celular abre o menu de compartilhamento do aparelho e, onde ele não existir, copia o link. Quem abre o link precisa estar logado (RN84). |
| RF56 | Os donos de uma lista incluem ou retiram outros donos e dão ou retiram acesso de edição a usuários ativos, pelo botão **Compartilhar** da lista. Ao menos um dono sempre permanece (RN81). |
| RF57 | Todas as listas são visíveis para todos os usuários logados, inclusive convidados. Só donos e editores as alteram (RN81). |
| RF58 | A pessoa apaga a própria conta em `/configuracoes/seguranca`, com confirmação pela senha (RN85). |
| RF59 | Os Termos de Uso (`/termos-de-uso`) e a Política de Privacidade (`/politica-privacidade`) ficam publicados e podem ser baixados em Markdown ou PDF. O cadastro exige o aceite (RN86). |
| RF60 | Toda cifra pode ser exportada em Markdown ou PDF. O tom do arquivo é o da tela, e pode ser trocado no diálogo de exportação sem mudar a tela (RN90). Também é possível escolher se o link do YouTube sai no PDF (RN88). |
| RF61 | A pessoa vincula uma conta Google à própria conta em `/configuracoes/seguranca`, com a senha, e passa a entrar também pelo botão **Entrar com Google** (RN87). O Google não cria conta: o cadastro segue por convite e código de e-mail. |
| RF62 | A letra de uma música pode ser exportada em Markdown ou PDF, sem acordes, com ou sem seções (RN88, RN89). |
| RF63 | Um artista, um evento ou uma lista pode ser exportado de uma vez em PDF: cada música em sua página, com a capa e o índice. Vale para cifra ou letra, com ou sem seções e com ou sem o link do YouTube. O tom padrão é o tocado de cada item; sem tom tocado, o tom original da música; sem ele, graus. O diálogo pode aplicar um único tom a todas (RN90, RN91). |
| RF64 | Cada alteração da cifra, do tom original, dos artistas ou do tom tocado de uma música fica no histórico, com título obrigatório, autor e data. Qualquer usuário ativo vê o histórico, compara versões e volta a uma delas. Voltar cria um novo ponto no histórico, e nada se perde (RN92). |
| RF65 | Todas as páginas e listagens mostram a data de criação e a de atualização de cada item (RNF12). |
| RF66 | Cada pessoa tem uma página de configurações (`/configuracoes`), com quatro partes: **segurança** (as funções de RF46 a RF49, RF58 e RF61), **termos e condições**, **visualização** (a tela abre em cifra ou em letra, com ou sem seções na letra, e com o tamanho padrão da fonte da cifra) e **exportação** (o arquivo sai em cifra ou em letra, com ou sem seções). Os padrões valem em qualquer aparelho (RN93). |

### Requisitos não funcionais

| ID | Requisito |
|---|---|
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
|---|---|
| RN01 | O acesso é só por convite. A única exceção é a conta inicial, criada direto no banco. |
| RN02 | Um convite é de uso único, vale **30 minutos** (valor fixo, que quem convida não altera) e carrega o cargo da pessoa. Não tem e-mail: é um link. Quem gera o convite vê o tempo restante até a expiração. O convite usado é apagado. |
| RN03 | Cada e-mail é único no sistema e gravado em minúsculas. O `slug` de usuário, artista, instrumento, evento, música e lista também é único. Os formatos são: pessoa, artista e instrumento, o nome em minúsculas com hífens; música, `artista-titulo`, com o primeiro artista da ordem; lista, `primeiro-dono-nome`, com o primeiro dono; evento, `data-nome` no formato ISO (`2026-10-12-missa-de-domingo`). Se o slug já existir, um sufixo numérico é acrescentado. O slug é recalculado quando o nome (ou, em música e lista, o primeiro artista ou dono) muda. A chave interna continua sendo o id (UUID). |
| RN04 | O cargo é `COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`. O admin (`is_admin`) é um indicador independente do cargo e não existe para convidados. Admin e coordenador têm os mesmos poderes; a única diferença é que só o admin acessa o Swagger (RN68). |
| RN05 | Coordenadores e o admin convidam, alteram cargos, criam eventos e desativam e reativam contas. Não apagam contas de outras pessoas, não veem e-mails de ninguém e não alteram nome, foto ou instrumentos de outra pessoa (RN79). |
| RN06 | Conta desativada (`ativo = false`) só visualiza os dados e confirma presença. |
| RN07 | Desativar uma conta tira a pessoa da escala dos setlists de eventos futuros. Reativar não a recoloca. |
| RN08 | Todo usuário ativo pode editar cifra e tom, marcar revisão, escalar músicos, publicar setlists, criar e editar instrumentos, renomear artistas, criar listas, anexar a foto de perfil e escolher seus instrumentos. |
| RN09 | O campo de nome guarda o **nome completo**. |
| RN10 | Convidado não tem o campo `ativo` e não pode ser desativado. Seu acesso ao app dura enquanto ele estiver em ao menos um evento; ao ser removido de todos, perde o acesso. |
| RN11 | Um convidado vira ministeriado por um convite de ministeriado aceito com a conta logada, ou por atribuição de um coordenador ou do admin. |

### Slugs

| ID | Regra |
|---|---|
| RN12 | O `slug` usa minúsculas, números e hífens no lugar de espaços e acentos (`Violão` vira `violao`). |
| RN13 | Quando o slug muda, o anterior vai para a tabela `slugs_antigos` e a URL antiga responde com redirecionamento permanente (308) para a página atual. Se outro item já passou a usar o slug antigo, a URL aponta para esse outro item. |
| RN14 | O slug de evento é a data ISO mais o nome (`2026-10-12-missa-de-domingo`). Muda quando a data ou o nome muda, com redirecionamento (RN13), e recebe sufixo numérico em caso de repetição. |
| RN15 | Slugs que coincidem com um trecho fixo de rota (`nova`, `novo`, `editar`, `foto`, `parecidas`, `admin`, `docs`, `api`) não são aceitos: o app gera outro, com sufixo numérico. |

### Instrumentos

| ID | Regra |
|---|---|
| RN16 | Não existem dois instrumentos com o mesmo nome, nem com caixa ou acento diferente ("Violão", "violão" e "violao" são o mesmo). O mesmo vale para artistas. |
| RN17 | Um instrumento novo fica disponível na hora, sem aprovação. |
| RN18 | Um instrumento que alguém toca, ou em que alguém está escalado, não pode ser apagado. |
| RN19 | A página de um instrumento mostra o total de contas ativas que o tocam, igual ao número do dashboard, e depois a lista delas. |

### Dashboard e listagens

| ID | Regra |
|---|---|
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
|---|---|
| RN30 | A música pode ter um tom original, opcional, informado no cadastro ou depois na edição. Ele é só informativo: não altera a cifra, que é sempre guardada em graus, e não é o tom tocado (RN32). A pessoa pode escrever a cifra no tom original ou em graus; isso não muda o tom original. A música não tem músicos. |
| RN31 | Quem escreve a cifra pode usar graus ou um tom qualquer. O front converte para graus antes de enviar. |
| RN32 | O tom só é salvo em uma música de **setlist ou lista**, e é opcional. Esse tom nunca altera a música. |
| RN33 | Em qualquer tela o front pode mostrar a cifra em outro tom. É só visualização e nada é gravado. O tom original aparece destacado na lista de tons da visualização, mas a biblioteca não abre nele: abre em graus, a não ser que a pessoa escolha outro tom. A opção de transpose (meio tom ou tom em tom) só fica ativa com um tom de referência: na biblioteca, o tom escolhido para ver a música; no setlist, o tom tocado do item. Em graus do campo harmônico, fica desativada. |
| RN34 | Não existem duas músicas com o mesmo título (sem diferenciar maiúsculas nem acentos) e o mesmo conjunto de artistas. Ao cadastrar, o app avisa sobre títulos parecidos. Toda música tem pelo menos um artista. |
| RN35 | A marca de revisão é só sim ou não, sem motivo. Qualquer usuário ativo marca e desmarca. Convidados não marcam. |
| RN36 | O status de escuta é por usuário e por música, e o padrão é "Não ouvi". Convidados não marcam. |
| RN37 | Uma música que aparece em algum setlist ou lista não pode ser apagada. Ela continua no banco e no histórico dos eventos. |
| RN38 | Cada música e cada item de setlist tem um número de versão. Se a versão mudou desde que a pessoa abriu a tela, a gravação é recusada com aviso. |
| RN39 | A música pode ter um link do YouTube, que é opcional. O app não guarda arquivos de áudio. |

### Eventos, setlists e listas

| ID | Regra |
|---|---|
| RN40 | Cada evento tem no máximo um setlist. Uma lista genérica tem nome e pertence a um ou mais donos (RN81). |
| RN41 | Um evento cancelado fica no histórico, não aparece nos próximos eventos e não conta nas execuções. |
| RN42 | Uma coleção (setlist ou lista) pode ter seções opcionais, nomeadas livremente e ordenadas. Cada seção pertence a uma única coleção. |
| RN43 | Uma música no setlist ou na lista pode ter tom e cifra próprios. Mudanças locais não afetam a música por padrão. |
| RN44 | Ao salvar a cifra de uma música da coleção, a pessoa escolhe **Salvar na música**, **Salvar só neste setlist** ou **Cancelar**. O tom tocado nunca é salvo na música. Sair sem salvar descarta as mudanças. |
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
| RN54 | O convidado cria conta (nome completo, e-mail, senha, aceite dos termos), tem área de conta e pode escolher seus instrumentos para ser escalado. |
| RN55 | O convidado vê tudo o que um membro vê: dashboard, biblioteca, listagens, busca, usuários, eventos, setlists com cifra e link, escala e presença. |
| RN56 | O convidado **não edita nada**: não altera música, cifra, tom, escala, lista, evento, artista nem instrumento, não marca revisão e não cria listas. Pode apenas alterar a própria conta (nome, foto, senha e e-mail), escolher seus instrumentos, confirmar presença e ativar as notificações. |
| RN57 | As telas de criação e edição (`/nova`, `/novo`, `/editar`) e o `/admin` não abrem para convidados, e os botões de gravação não aparecem para eles. |
| RN58 | O convidado aparece na busca de escala apenas dos eventos aos quais foi convidado. |
| RN59 | A conta do convidado permanece depois do evento e pode ser convidada para outros eventos. |
| RN60 | A página de um convidado só é vista por quem está no mesmo evento, pelos coordenadores e pelo admin. |

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
| RN69 | Toda rota decide o acesso por uma função central que considera o cargo, o estado `ativo`, o convidado somente leitura e, nas listas, o dono ou o acesso concedido. |

### Conta, e-mail e desativação

| ID | Regra |
|---|---|
| RN70 | Cada conta tem de um a três e-mails, em minúsculas e únicos no sistema (RN03). Só entra por e-mail quem confirmou o endereço por código. |
| RN71 | A conta só é criada depois que o código enviado ao e-mail é confirmado. O convite só é consumido nesse momento. O convite e o código usados são apagados. |
| RN72 | Adicionar ou remover um e-mail exige a senha atual (RN75) e, ao adicionar, a confirmação por código enviado ao novo endereço. A conta sempre tem ao menos um e-mail. |
| RN73 | O pedido de "esqueci a senha" responde da mesma forma exista ou não a conta, para não revelar quais e-mails estão cadastrados. |
| RN74 | Os códigos enviados por e-mail (cadastro, redefinição e troca de e-mail) valem 30 minutos, servem uma única vez (são apagados ao serem usados) e são invalidados após o limite de tentativas. Os expirados são apagados pela rotina diária. Quando a conta tem mais de um e-mail, a pessoa escolhe para qual deles o código vai. |
| RN75 | Trocar a senha exige a senha atual. Trocar ou redefinir a senha encerra as outras sessões da pessoa (incrementa `token_versao`). |
| RN76 | A própria pessoa pode desativar a própria conta, em `/configuracoes/seguranca`, com confirmação pela senha. Valem as mesmas regras de RN06 e RN07: ela sai da escala de eventos futuros e continua vendo os dados e confirmando presença. |
| RN77 | Só um coordenador ou o admin reativa uma conta desativada pela própria pessoa. Reativar não a recoloca na escala (RN07). |
| RN78 | Contas só são apagadas pela própria pessoa (RN85). O histórico de eventos e execuções sempre permanece. |
| RN79 | Só a própria pessoa vê, troca ou apaga os seus e-mails. Coordenadores e o admin não veem e-mails de ninguém e não alteram e-mail, senha, nome, foto ou instrumentos de outras pessoas. Ninguém define senha por outra pessoa: a redefinição é sempre pelo código enviado a um dos e-mails confirmados da própria conta (RN74). O admin tem acesso total ao banco, por isso a conta de admin deve ser restrita a quem é de confiança. |
| RN80 | Os códigos de recuperação não dependem de e-mail. Usar um deles redefine a senha e o código fica gasto. |

### Listas, artistas e compartilhamento

| ID | Regra |
|---|---|
| RN81 | Todas as listas aparecem para todos os usuários logados, convidados inclusive. Donos e editores editam a lista. Donos também incluem ou retiram donos e dão ou retiram acesso de edição. Editores editam nome, seções, músicas, tom e cifra local, mas não gerenciam donos nem acessos. Só usuários ativos e não convidados podem ser donos ou editores. Ao menos um dono sempre permanece. Coordenadores e o admin podem tudo o que um dono pode (RN05). |
| RN82 | Qualquer usuário ativo renomeia um artista. O slug acompanha o novo nome, e a URL antiga redireciona (RN13). O novo nome não pode repetir outro artista (sem diferenciar maiúsculas nem acentos, RN16). |
| RN83 | Os e-mails de uma pessoa só são vistos por ela. Nas listagens, no perfil e na busca, os demais veem nome, foto e instrumentos. |
| RN84 | O botão **Compartilhar** envia o link da página (`/<tipo>/<slug>`). Quem abre precisa estar logado e ter permissão, senão vê 404. Compartilhar o link não dá acesso a nada. |
| RN85 | Ao apagar a própria conta, a pessoa sai de tudo: e-mails, senha, foto, instrumentos, configurações, códigos, inscrições de notificação, presenças e escalas de eventos futuros. Escalas e presenças de eventos passados ficam como "Pessoa removida", para manter o histórico. Listas em que ela era a única dona são apagadas com seus itens; nas que têm outros donos, a lista continua e ela só deixa de ser dona. Convites que ela criou são apagados. Músicas, cifras e artistas que ela cadastrou continuam. Nas versões do histórico que ela fez, o autor vira "Pessoa removida". |
| RN86 | O cadastro, por convite ou de convidado, só conclui com o aceite dos Termos de Uso e da Política de Privacidade, registrado com a data em `usuarios.termos_aceitos_em`. |
| RN87 | O login com Google só vale para contas com o vínculo feito. O vínculo exige a senha atual, é feito em `/configuracoes/seguranca` e liga uma conta Google a uma só conta. Desvincular também pede a senha. O e-mail do Google não entra na lista de e-mails da conta. |
| RN88 | A exportação é só leitura e não grava nada. O Markdown leva a cifra em bloco de código, para preservar o alinhamento. O PDF da cifra usa fonte monoespaçada e quebra as linhas em pares, como a tela. O PDF e o Markdown da letra usam texto normal e quebram as linhas normalmente. O link do YouTube só sai se a opção estiver marcada, e o padrão é não sair. Quem pode ver a música pode exportá-la. |
| RN89 | O botão **Seções** da letra começa no padrão da configuração (RN93), desligado por padrão. Ele vale para a tela, para o Markdown e para o PDF da letra, e fica separado da opção de exportação. A cifra sempre mostra as seções. |
| RN90 | O tom da exportação é, por padrão, o tom que a pessoa vê na tela, inclusive no setlist e na lista. No diálogo de exportação de uma música, a pessoa pode trocar o tom sem mudar o da tela. Em lote, o padrão é o tom tocado de cada item do setlist ou da lista; sem tom tocado, o tom original da música; sem ele, graus. O diálogo de lote pode aplicar um único tom a todas as músicas. |
| RN91 | O lote aceita até 100 músicas por PDF. Cada música começa em página nova, depois da capa com o título, a data (se for evento) e o índice. A ordem é A–Z no artista e a ordem do setlist ou da lista nos eventos e listas. Quem exporta um evento precisa ver o evento: convidados só exportam dos seus. |
| RN92 | Cada gravação que muda a cifra, o tom original, a lista de artistas ou o tom tocado (no setlist ou na lista) cria uma versão no histórico da música, com título obrigatório, autor e data. Título, link e o nome de um artista não geram versão: a música guarda a referência ao artista, não o nome. Qualquer usuário ativo vê o histórico e pode comparar uma versão com a atual. Voltar a uma versão cria uma nova versão com o conteúdo antigo, marcada como restaurada, e nada é apagado. Se o autor apagar a conta, a versão continua, com "Pessoa removida". |
| RN93 | Cada pessoa tem uma configuração de visualização e de exportação, guardada na conta. Visualização: a tela abre em cifra ou em letra (padrão: cifra), com ou sem seções na letra (padrão: sem seções), e com um tamanho padrão da fonte da cifra (pequeno, médio ou grande; padrão: médio). Exportação: o arquivo sai em cifra ou em letra (padrão: cifra), com ou sem seções na letra (padrão: sem seções). Os botões da tela e do diálogo de exportação valem só naquela vez e não são gravados. Quem ainda não gravou nada tem os padrões acima. |

## Usuários, papéis e permissões

| Papel | O que pode |
|---|---|
| **Admin** (`is_admin`) | Acessa o Swagger e a especificação da API. Tem os mesmos poderes do coordenador (RN05). |
| **Coordenador** | Convida pessoas (inclusive convidados de evento), altera o cargo de qualquer usuário, cria e cancela eventos, desativa e reativa contas. Não apaga contas, não vê e-mails e não altera nome, foto ou instrumentos de outras pessoas (RN05). |
| **Ministeriado** | Usa o app como músico, dentro das permissões de qualquer usuário ativo (abaixo). |
| **Convidado** | Vê tudo o que um membro vê, mas não edita nada (veja [Convidados de evento](#convidados-de-evento)). |

**Qualquer usuário ativo** pode:

- cadastrar e editar músicas e cifras, e definir o tom de uma música no setlist;
- marcar e desmarcar músicas para revisão;
- escalar músicos nos setlists e publicar setlists de eventos;
- criar listas, editar as que são suas ou que foram compartilhadas com elas, e compartilhá-las;
- criar e editar instrumentos, e cadastrar e renomear artistas;
- alterar nome, e-mails, senha, foto e os instrumentos que toca, e apagar a própria conta;
- marcar seu status de escuta e confirmar presença.

**Qualquer usuário logado**, ativo, desativado ou convidado, vê o dashboard e os dados do app. Os membros, ativos ou não, confirmam presença; o convidado confirma nos eventos a que foi convidado.

## Convites e primeiro acesso

Coordenadores e o admin geram um **link de convite** e o enviam à pessoa. O link tem o cargo que a pessoa terá (ministeriado ou coordenador), é de uso único e vale 30 minutos. Não há e-mail do convidado, e quem convida só escolhe o cargo. Logo após gerar o link, quem o criou vê a contagem do tempo restante até a expiração.

1. A pessoa abre o link, informa nome completo, e-mail e senha e pede o código. O código de 6 dígitos chega ao e-mail; ela o digita e a conta é criada com o cargo do convite, já logada. O convite só é consumido nesse momento.
2. Se o e-mail já tem conta, a API responde `409 CONTA_EXISTENTE` e o app orienta a fazer login e abrir o link de novo.
3. No primeiro login, a pessoa escolhe os instrumentos que toca (zero ou mais) e pode alterá-los depois.

A conta inicial (admin e coordenador) é criada direto no banco, porque ainda não há quem convide. Veja [Rodando localmente](#rodando-localmente).

## Convidados de evento

Permite que alguém de fora do ministério participe de um evento.

1. Um coordenador ou o admin gera o **link de convite do evento**. Ele vale 30 minutos e é de uso único.
2. A pessoa abre o link e cria a conta (ou, se já é convidada, entra e abre o link). Ela é registrada como convidada do evento, em `eventos_convidados`.
3. A conta tem papel `CONVIDADO` e fica depois do evento. Pode ser convidada para outros eventos e, se virar ministeriada, passa ao papel de ministeriado.

| O convidado | |
|---|---|
| Vê | Tudo o que um membro vê: dashboard, biblioteca, listagens, busca, usuários, eventos, setlists, cifras, escala e presença. |
| Faz | Cuida da própria conta, escolhe seus instrumentos, confirma a própria presença nos eventos a que foi convidado, pode ser escalado neles e ativa as notificações. |
| Não faz | **Editar qualquer coisa**: músicas, cifras, tons, escala, listas, eventos, artistas e instrumentos, marcar revisão e criar listas. |

Cada rota de gravação da API confere o papel e recusa o convidado, exceto nas ações da própria conta, nos instrumentos e na presença. O convidado não conta nos números do dashboard. O acesso dele dura enquanto estiver em ao menos um evento, e o coordenador o encerra removendo-o dos eventos (RN10). A página do convidado só é vista por quem a RN60 permite.

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

Qualquer usuário ativo edita uma música. Cada música tem um número de versão: a gravação só é aceita se a versão que a pessoa leu ainda for a atual. Se outra pessoa alterou antes, a API responde `409 CONFLITO_VERSAO` e o app mostra o aviso.

Cada gravação que muda a cifra, o tom original, os artistas ou o tom tocado pede um título. A versão fica no **histórico** da música, com autor e data: a tela mostra cada versão, permite compará-la com a atual e voltar a ela. Voltar também cria um ponto novo no histórico (RN92). Título, link e nome de artista podem ser alterados sem gerar versão.

### Apagar

Uma música que aparece em algum setlist ou lista não pode ser apagada (o banco impede), e continua no histórico dos eventos. Uma música que não está em nenhuma coleção pode ser apagada.

### Revisão

Qualquer usuário ativo pode **marcar e desmarcar** uma música para revisão. É só uma marca, sem campo de motivo. O dashboard mostra quantas músicas estão marcadas.

### Status de escuta

Cada usuário marca, por música, **Não ouvi** (padrão), **Ouvi** ou **Toquei**.

### Última vez tocada

A tela da música e a listagem mostram quando a música foi tocada pela última vez, calculado a partir dos eventos (`vw_ultima_execucao`).

### Artistas

O artista tem tabela própria, com `nome` e `slug`, e uma página própria com as músicas dele. Compositores e intérpretes são artistas. Uma música pode ter mais de um artista, guardados em ordem na tabela `musica_artistas`.

## Cifra, graus e tons

A cifra é guardada **em graus do campo harmônico**, no estilo do Nashville Number System, e o app a mostra em qualquer tom.

| Em graus | Significado |
|---|---|
| `1`, `4`, `5` | Acordes sobre o primeiro, quarto e quinto graus. |
| `2m`, `3m`, `6m` | Acordes menores. |
| `3b`, `7b`, `4#` | Graus alterados: o `b` ou o `#` vem depois do grau. |
| `5sus4`, `1maj7`, `5/7` | Variações, extensões e baixo. |
| `1m` | Tônica menor (em música de tom menor, o grau `1` é sempre a tônica). |

### Formato

A cifra é um texto em que a linha de acordes fica logo acima da linha da letra, e cada acorde começa na coluna da sílaba onde deve ser tocado. Por exemplo:

```
1       5     6m
Senhor, tu és fiel
```

- **Linha de acordes:** uma linha cujos itens são todos acordes válidos (pela gramática de graus). Um marcador `[Seção]` no início da linha é permitido e não conta como acorde. Por isso, `[Intro] D Em A` é uma linha de acordes. Uma linha de acordes pode ser seguida de outra linha de acordes, e isso forma um trecho instrumental.
- **Linha de letra:** qualquer outra linha. A linha de acordes logo acima dela vale para ela.
- **Linha instrumental:** linha de acordes sem linha de letra logo abaixo. Ela aparece na visualização com acordes. No modo Letra, os acordes somem. Um marcador de seção que estiver nela (como `[Intro]` ou `[Solo]`) só aparece se o botão **Seções** estiver ativo (RN89).
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

- **Tamanho da fonte:** botões para aumentar e diminuir. O tamanho inicial vem da configuração (RN93).
- **Rolagem automática:** botão de iniciar e pausar, com botões de mais e menos velocidade que valem na hora. Só o botão pausa: rolar a tela com o dedo avança a música e não pausa.
- **Tom original:** aparece destacado ao lado do seletor de tom, quando preenchido. Não é escolhido por padrão (RN33).
- **Transpose:** botões de meio tom e de tom, para cima e para baixo, a partir do tom de referência (veja RN33). Desativado sem tom de referência, em graus e no modo letra.
- **Letra:** alterna entre a cifra com acordes e só a letra, sem acordes. Combina com o aumento de fonte e com a rolagem automática. A tela abre no padrão da configuração (RN93).
- **Exportar:** abre o diálogo de exportação, com formato (Markdown ou PDF), conteúdo (cifra ou letra), seções (só na letra), link do YouTube (desligado por padrão) e tom. O tom começa no da tela, e trocá-lo no diálogo não muda a tela (RN90). Conteúdo e seções começam no padrão da configuração (RN93).
- **Seções:** aparece só no modo Letra. Liga e desliga a exibição dos marcadores de seção (`[Refrão]`, `[Intro]`, `[Solo]`…). **Padrão: desativado**, ou o que a configuração indicar (RN93).
- A velocidade da rolagem fica salva no próprio aparelho, sem passar pelo servidor. Os botões de fonte, letra e seções não são gravados.

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
| Seções | sim | sim |
| Tom tocado e cifra local por música | sim | sim |
| **Escala de músicos** | **sim** | **não** |
| Conta nas execuções | **sim** (se publicado e o evento já aconteceu) | não |

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

Desativar uma conta (`ativo = false`) tira a pessoa da **escala dos setlists de eventos futuros**, e a vaga fica em aberto, com o mesmo aviso de substituição da presença. A pessoa continua vendo os dados e confirmando presença. Reativar a conta **não** a recoloca na escala.

Coordenadores e o admin podem desativar e reativar contas. A própria pessoa também pode desativar a conta dela, mas só um coordenador ou o admin a reativa. Convidados não têm o campo `ativo`: para encerrar o acesso de um convidado, o coordenador o remove de todos os eventos a que foi convidado.

### Desativação pela própria pessoa

A pessoa desativa a própria conta em `/configuracoes/seguranca`, com confirmação pela senha. A conta não é apagada: ela fica inativa, sai da escala dos eventos futuros e pode continuar vendo os dados e confirmando presença. Só um coordenador ou o admin a reativa.

### Apagar a própria conta

A pessoa apaga a própria conta em `/configuracoes/seguranca`, com confirmação pela senha e um aviso do que será perdido. A exclusão é definitiva e segue RN85. Só a própria pessoa apaga a conta; coordenadores e o admin só desativam e reativam.

### Conta e segurança

Em `/configuracoes/seguranca`, a pessoa vê, adiciona e remove os próprios e-mails, troca a senha, gera os códigos de recuperação, desativa e apaga a própria conta. A recuperação de senha ("esqueci a senha") fica na tela de login.

## Stack técnica

| Camada | Escolha |
|---|---|
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
| Documentação da API | **Swagger / OpenAPI**, restrito ao admin |
| Deploy | **Vercel** (deploy automático por push no GitHub) |

Tudo num único projeto TypeScript (front e back), sem plataformas além de Vercel, GitHub e Supabase (o Resend, só para e-mail).

### Decisões e alternativas descartadas

| Decisão | Alternativa descartada | Motivo |
|---|---|---|
| Autenticação própria (JWT em cookie `httpOnly`) | Supabase Auth | O Supabase entra só como banco. Vários e-mails por conta, convites de 30 minutos e códigos de recuperação não cabem no fluxo pronto. |
| Cifra guardada em graus | Guardar um tom e transpor | Uma única fonte serve qualquer tom. O tom original e o tocado são informação à parte. |
| PDF por código, com `pdf-lib` | HTML2PDF e Puppeteer | O HTML2PDF transforma o texto em imagem, e o Puppeteer é pesado demais para a Vercel. O `pdf-lib` mantém o texto selecionável, com fontes embutidas. |
| Busca com `pg_trgm` e `unaccent` | Busca de texto completo (`tsvector`) | Os títulos são curtos e a busca é por trecho. Trigramas atendem sem depender de raízes de palavras. |
| Fotos no Postgres | Storage externo | Menos peças (RNF08), e a foto é pequena (256 px). |
| Resend atrás de `src/lib/email.ts` | SMTP direto, SES, Brevo | O plano gratuito basta, e a camada própria permite trocar de provedor. |
| Prisma com `db pull` e `$queryRaw` | Migrations do Prisma | O `DDL.SQL` é a fonte da verdade, e a busca usa funções que o Prisma não expressa. |
| `ordem` decimal (média dos vizinhos) | Inteiros renumerados | Reordenar atualiza uma única linha (RNF04). |
| Contador `versao` | Bloqueio pessimista | Detecta edição simultânea sem travar ninguém (RNF13). |
| Limite de tentativas no banco | Memória do servidor ou Redis | A Vercel não guarda memória entre requisições, e não há outra plataforma (RNF15). |

## Modelo de dados

28 tabelas e 2 views, definidas em **`DDL.SQL`** (PostgreSQL 13 ou superior). O arquivo tem quatro partes: a **parte 1** (tabelas, chaves e únicas) é a mais segura para visualizadores como o Esquema 3D; a **parte 2** (CHECKs e índices), a **parte 3** (views) e a **parte 4** (instrumentos iniciais) podem ser apagadas se o visualizador não as reconhecer.

Os itens principais (usuários, instrumentos, artistas, músicas, eventos e coleções) têm `criado_em` e `atualizado_em`, e o banco mantém `atualizado_em` por trigger. Também têm data o histórico (`musica_versoes.criado_em`), `eventos.data_evento`, `usuarios.termos_aceitos_em`, `convites_acesso.expira_em`, `codigos_email.expira_em` e `limites_tentativas.janela_fim`, todas com fuso (`TIMESTAMPTZ`). A parte 2 cria as extensões `pg_trgm` e `unaccent` e a função `busca_norm`, usadas na busca (veja [Busca e ordenação](#busca-e-ordenação)).

| Tabela | Propósito |
|---|---|
| `usuarios` | Pessoas. `papel` (`COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`), `is_admin`, `ativo` (vazio para convidados), `slug`, hash da senha, `token_versao` (invalida as sessões antigas quando a senha muda) e `termos_aceitos_em`. |
| `preferencias_usuario` | A configuração de visualização e de exportação de cada pessoa (RN93): padrão da tela (cifra ou letra), seções na letra, tamanho da fonte e padrão do arquivo exportado. Uma linha por pessoa, guardada na conta. |
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
| `confirmacoes_presenca` | Presença por evento × usuário (vazio, vai ou não vai). Fica sem usuário (vazio) quando a conta é apagada. |
| `colecoes` | Setlist (com `publicado`) ou lista. |
| `listas_donos` | Os donos de cada lista, com ordem (`posicao`). O primeiro dono entra no slug. |
| `listas_acessos` | Quem recebeu do dono o acesso de edição de uma lista (editores). |
| `slugs_antigos` | Slugs que deixaram de ser usados por renomeação, para o redirecionamento. |
| `secoes` | Agrupamentos opcionais dentro de uma coleção. |
| `colecao_musicas` | Música na coleção: tom tocado (opcional), cifra local (opcional), ordem e versão. |
| `colecao_musicas_musicos` | **A escala**: quem toca cada música do setlist. Sem usuário (vazio) em eventos passados quando a conta é apagada. |
| `device_tokens` | Inscrições de push (endpoint, chaves) por usuário. |
| `limites_tentativas` | Contador do limite de tentativas (login, convites, códigos), no banco por causa da Vercel. |

| View | Propósito |
|---|---|
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
    MUSICA ||--o{ COLECAO_MUSICA : "aparece em"
    COLECAO_MUSICA ||--o{ ESCALA : "escala"
    USUARIO ||--o{ ESCALA : "toca em"
    INSTRUMENTO ||--o{ ESCALA : "usa"
    USUARIO ||--o{ DEVICE_TOKEN : "registra"
    USUARIO ||--|| PREFERENCIA : "configura"
    MUSICA ||--o{ MUSICA_VERSAO : "tem histórico"
    USUARIO |o--o{ MUSICA_VERSAO : "grava"
    COLECAO |o--o{ MUSICA_VERSAO : "tom tocado"
    MUSICA_VERSAO |o--o{ MUSICA_VERSAO_ARTISTA : "guarda"
    ARTISTA }o--o{ MUSICA_VERSAO_ARTISTA : "aparece em"
```

(`ESCALA` é a tabela `colecao_musicas_musicos`; `EVENTO_CONVIDADO`, a `eventos_convidados`; `LISTA_ACESSO`, a `listas_acessos`; `PREFERENCIA`, a `preferencias_usuario`; `MUSICA_VERSAO` e `MUSICA_VERSAO_ARTISTA`, a `musica_versoes` e a `musica_versoes_artistas`.)

### Regras garantidas no banco

Estão na parte 2 do `DDL.SQL` e foram testadas tentando violá-las:

- `papel` só aceita `COORDENADOR`, `MINISTERIADO` ou `CONVIDADO`; convidado tem `ativo` vazio e não é admin, e os demais têm `ativo` preenchido.
- Convite de convidado exige evento; os outros convites não têm evento.
- O `slug` só aceita minúsculas, números e hífens.
- Nome de instrumento e de artista **únicos sem diferenciar maiúsculas nem acentos** (pela função `busca_norm`).
- Cada e-mail existe uma única vez no sistema, em minúsculas e com formato mínimo. Cada conta tem de um a três e-mails.
- A posição dos artistas de uma música é única, e a música tem pelo menos um. O conjunto de artistas e o título não se repetem, mas isso é validado pela API, não pelo banco.
- Tom tocado e tom original no formato `D`, `F#m` ou `Bb`.
- Nomes e títulos não vazios, e link do YouTube começando com `http://` ou `https://`.
- Cada versão tem número único por música e título não vazio. Uma versão `MUSICA` não tem setlist; uma `TOM_TOCADO` tem setlist e não tem cifra. Tons válidos em todas. Data de criação e atualização são mantidas pelo banco.
- A configuração aceita só `CIFRA` ou `LETRA` para visualização e exportação, e só `PEQUENA`, `MEDIA` ou `GRANDE` para a fonte.
- Em `colecoes`: SETLIST exige evento e não tem nome; LISTA exige nome, não tem evento e não é publicada. Os donos de uma lista ficam em `listas_donos`; a API garante ao menos um.
- Instrumento em uso e música usada em setlist ou lista não podem ser apagados (`RESTRICT`).
- O convite expira 30 minutos depois de criado, por padrão do banco.
- A finalidade de `codigos_email` é `CADASTRO` (sem usuário), `REDEFINICAO` ou `TROCA_EMAIL` (com usuário).
- `token_versao` começa em 1.

### Regras que a API valida

O banco não cobre estas:

- A escala (`colecao_musicas_musicos`) só pode existir em coleções SETLIST.
- A seção de uma música pertence à mesma coleção da música.
- Apenas coordenadores e o admin convidam, alteram cargos, criam eventos e desativam e reativam contas. Ninguém além da própria pessoa apaga a conta, vê e-mails ou altera nome, foto e instrumentos dela (RN05, RN79).
- Conta desativada não edita nada: só visualiza e confirma presença.
- O convidado só lê (exceto conta, instrumentos e presença) e só tem acesso enquanto está em ao menos um evento de `eventos_convidados`.
- Uma lista é editada pelos donos e pelos editores (`listas_acessos`). Só os donos apagam a lista e gerenciam donos e acessos. Só usuários ativos e não convidados recebem qualquer papel nela. Todas as listas aparecem para todos os usuários logados (RN81).
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
- Quem não tem permissão para um item recebe **404**, igual a quando o item não existe, para não revelar o que existe. Isso vale, por exemplo, para quem abre a página de um convidado sem poder vê-la (RN60).
- Quando o nome muda e o slug muda com ele, a URL antiga redireciona (308) para a nova (RN13).
- Os `slug`s nunca coincidem com os trechos fixos das rotas (RN15): `nova`, `novo`, `editar`, `foto`, `parecidas`.
- O link de convite leva o token na URL. As páginas enviam `Referrer-Policy: no-referrer` para que o token não vaze por links externos.
- O caminho das rotas é em minúsculas. Um caminho com outra caixa (`/API/docs`) não é uma rota do app.

### Páginas

| Rota | Quem acessa | O que mostra |
|---|---|---|
| `/` | todos | Só redireciona (veja acima). |
| `/auth/login` | sem sessão | Login, com "Lembrar de mim", o botão **Entrar com Google** e o link "esqueci a senha". |
| `/auth/esqueci-senha` | sem sessão | Pedido do código por e-mail (ou uso de um código de recuperação) e definição da senha nova. |
| `/auth/convite/[token]` | sem sessão, ou convidado logado | Cadastro pelo convite (de ministério ou de evento): dados, código do e-mail e entrada logado. |
| `/inicio` | todos logados | Dashboard. |
| `/busca` | todos logados | Busca geral em todos os tipos, com filtro por tipo. |
| `/musicas` | todos logados | Listagem de músicas. |
| `/musicas/nova` | membros ativos | Cadastro de música. |
| `/musicas/[slug]` | todos logados | Tela da cifra (tom, transpose, letra, fonte e rolagem), revisão, status de escuta, exportação, histórico e datas de criação e atualização. |
| `/musicas/[slug]/editar` | membros ativos | Edição da música. |
| `/musicas/[slug]/historico` | todos logados | Histórico da cifra: versões, comparação com a atual e volta a uma versão. |
| `/artistas` | todos logados | Listagem de artistas. Cadastrar um artista é um diálogo nesta página ou no formulário da música. |
| `/artistas/[slug]` | todos logados | O artista e as músicas dele. Botão **Exportar PDF** para o lote (RF63). |
| `/instrumentos` | todos logados | Todos os instrumentos. Criar um instrumento é um diálogo nesta página. |
| `/instrumentos/[slug]` | todos logados | O total de contas ativas que tocam o instrumento e a lista delas. |
| `/usuarios` | todos logados | Listagem de usuários. |
| `/usuarios/[slug]` | todos logados | Perfil: foto, instrumentos e listas. Os e-mails só aparecem para a própria pessoa. Coordenadores e o admin veem aqui o controle de cargo e de ativação. |
| `/listas` | todos logados | Listagem de listas. |
| `/listas/nova` | membros ativos | Criação de lista. |
| `/listas/[slug]` | todos logados | A lista, com seções e músicas. Botão **Exportar PDF** para o lote (RF63). |
| `/listas/[slug]/musicas/[musica]` | todos logados | Uma música dentro da lista (tom tocado e cifra local). `[musica]` é o `slug` da música. |
| `/eventos` | todos logados | Listagem de eventos. |
| `/eventos/novo` | coordenadores e admin | Criação de evento. |
| `/eventos/[slug]` | todos logados | O evento: setlist, seções, escala, presença e convidados. Botão **Exportar PDF** para o lote (RF63). Coordenadores geram aqui o convite de convidado. |
| `/eventos/[slug]/editar` | coordenadores e admin | Nome, data e hora, presença exigida e cancelamento. |
| `/eventos/[slug]/musicas/[musica]` | todos logados | Uma música dentro do setlist: cifra, tom tocado, escala e aviso de substituição. |
| `/conta` | todos logados | Nome, foto e instrumentos. |
| `/configuracoes` | todos logados | Padrões de visualização e de exportação (RN93), com links para as outras partes. |
| `/configuracoes/seguranca` | todos logados | E-mails, senha, Google, códigos de recuperação, desativação e exclusão da própria conta. |
| `/configuracoes/termos` | todos logados | Data do aceite dos termos e links para os Termos de Uso e a Política de Privacidade. |
| `/termos-de-uso` | todos | Termos de Uso, com download em Markdown ou PDF. |
| `/politica-privacidade` | todos | Política de Privacidade, com download em Markdown ou PDF. |
| `/admin` | coordenadores e admin | Convites e ativação e desativação de contas. |
| `/api/docs` | admin | Swagger UI. |
| `/api/openapi.json` | admin | Especificação OpenAPI. |

O convidado acessa todas as páginas de leitura, `/conta`, `/configuracoes`, `/configuracoes/seguranca`, `/configuracoes/termos`, `/termos-de-uso` e `/politica-privacidade`. As rotas de edição (`/nova`, `/novo`, `/editar`) e `/admin` não abrem para ele.

A conta desativada acessa as páginas normalmente, mas as rotas de edição (`/nova`, `/novo`, `/editar`) e os botões de gravação ficam bloqueados (RN06).

### Compartilhar

Toda página de música, artista, instrumento, usuário, lista e evento (e de música dentro de um setlist ou lista) tem o botão **Compartilhar** no cabeçalho.

- No celular, abre o menu de compartilhamento do aparelho (Web Share API) com o título da página e o link. Onde esse menu não existir, o botão copia o link e avisa "Link copiado".
- O link é o endereço da própria página (`/<tipo>/<slug>`). Quem o abre precisa estar logado e ter permissão; senão vê 404 (RN84).
- Na página de uma **lista**, o botão **Compartilhar** tem a seção **Donos e acesso**, para os donos: incluir ou retirar donos e dar ou retirar acesso de edição. Editores veem a lista, mas não essa seção (RN81).

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
| 404 | `NAO_ENCONTRADO` | O item não existe ou a pessoa não pode vê-lo (RN84). |
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
|---|---|
| Listagem de **músicas** | Título e nome dos artistas. |
| Listagem de **artistas**, **usuários**, **listas** e **eventos** | O nome. |
| Listagem de **instrumentos** | A listagem não tem caixa de busca (RF50), mas os instrumentos aparecem na busca geral. |
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
10. **Busca geral.** Usa as mesmas regras de normalização, palavras e escape. Com `tipo=todos`, a página roda uma consulta por tipo, em paralelo, e mostra cada tipo em um bloco com **até 5 resultados**, o total encontrado e o link "ver todos", que leva à listagem do tipo já com `busca=` aplicada. Em cada bloco, quem começa com o termo vem primeiro, depois a ordem A–Z. Os filtros de tipo mostram a contagem ("Músicas (12)"). Com um `tipo` específico, a página mostra a própria listagem daquele tipo (30 por página, com `ordem` e `pagina`), sem lógica duplicada. O termo precisa de pelo menos 2 caracteres. Usuários convidados só aparecem para quem a RN60 permite. O campo no topo do app abre `/busca?busca=termo` ao enviar.

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

A API é composta por Route Handlers em `src/app/api`. A documentação é em **OpenAPI 3** com interface **Swagger UI**, **acessível somente ao admin** (`is_admin`).

A especificação é gerada a partir dos **schemas Zod** que já validam as requisições (por exemplo com `@asteasolutions/zod-to-openapi`), de modo que o contrato e a documentação saem da mesma fonte. Ela é servida em `/api/openapi.json` e a interface em `/api/docs`; ambas exigem sessão de admin. A autenticação é por cookie, declarada como esquema de segurança `cookieAuth`.

### Endpoints

| Recurso | Endpoints |
|---|---|
| Autenticação | `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/me`, `GET /api/auth/google` (inicia o login com Google), `GET /api/auth/google/callback` |
| Cadastro e senha | `GET /api/convites/{token}` (confere se o convite vale e mostra o cargo e o evento), `POST /api/auth/cadastro/codigo` (envia o código ao e-mail), `POST /api/auth/cadastro` (confirma o código, cria a conta e consome o convite), `POST /api/auth/esqueci-senha` (envia o código), `POST /api/auth/redefinir-senha` (código do e-mail ou de recuperação, mais a senha nova) |
| Conta | `GET, PATCH /api/conta` (nome), `PUT /api/conta/senha`, `PUT /api/conta/instrumentos`, `GET, POST /api/conta/emails` (lista; envia o código ao novo e-mail), `PUT /api/conta/emails/{id}` (confirma o código), `DELETE /api/conta/emails/{id}`, `DELETE /api/conta` (apaga a própria conta, com a senha), `GET /api/conta/google` (inicia o vínculo), `DELETE /api/conta/google` (desvincula, com a senha), `POST /api/conta/codigos-recuperacao`, `POST /api/conta/desativar`, `PUT, DELETE /api/conta/foto`, `GET, PUT /api/conta/preferencias` (padrões de visualização e de exportação, RN93) |
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
| Escala | `PUT /api/colecoes/{id}/musicas/{id}/musicos`, `PUT /api/colecoes/{id}/secoes/{id}/musicos` (`modo=sobrescrever\|completar`) |
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
│  │  ├─ termos-de-uso/      # Termos de Uso (pública)
│  │  ├─ politica-privacidade/ # Política de Privacidade (pública)
│  │  ├─ auth/               # fora da área autenticada
│  │  │  ├─ login/
│  │  │  ├─ esqueci-senha/
│  │  │  └─ convite/[token]/ # cadastro pelo convite
│  │  ├─ (app)/              # área autenticada (o grupo não entra na URL)
│  │  │  ├─ inicio/          # dashboard
│  │  │  ├─ busca/           # busca geral
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
│  │  │  ├─ conta/           # nome, foto e instrumentos
│  │  │  ├─ configuracoes/   # visualização e exportação (padrões)
│  │  │  │  ├─ seguranca/    # e-mails, senha, Google, códigos, desativação e exclusão
│  │  │  │  └─ termos/       # aceite dos termos e links dos documentos
│  │  │  └─ admin/           # convites e gestão de contas
│  │  └─ api/                # Route Handlers
│  │     └─ docs/            # Swagger UI (só admin)
│  ├─ components/            # componentes React (ui, forms, setlist, cifra, dashboard)
│  ├─ lib/
│  │  ├─ db.ts               # cliente Prisma (singleton)
│  │  ├─ auth.ts             # JWT e leitura da sessão
│  │  ├─ autorizar.ts        # função central de permissão (cargo, ativo, convidado, lista)
│  │  ├─ email.ts            # envio de e-mail (Resend), trocável
│  │  ├─ exportar.ts         # Markdown e PDF da cifra, da letra e das políticas
│  │  ├─ google.ts           # login com Google (OpenID Connect)
│  │  ├─ busca.ts            # filtros de busca e ordenação (SQL parametrizado)
│  │  ├─ cifra/              # conversão de tom para graus e de graus para tom
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
npm i -D @types/web-push @types/swagger-ui-react vitest @playwright/test prettier

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
     INSERT INTO usuarios (nome, slug, senha_hash, papel, is_admin)
     VALUES ('Seu Nome Completo', 'seu-nome', '$HASH', 'COORDENADOR', TRUE)
     RETURNING id)
   INSERT INTO emails_usuario (usuario_id, email) SELECT id, 'voce@exemplo.com' FROM u;"
```

### Comandos úteis

| Comando | Para quê |
|---|---|
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
|---|---|
| `DATABASE_URL` | Conexão do Prisma. Em produção, a string do pooler do Supabase. |
| `DIRECT_URL` | Conexão direta, sem pooler, usada pelo `prisma db pull`, pelas migrações e pelo backup. No schema: `directUrl = env("DIRECT_URL")`. |
| `APP_URL` | Endereço público do app. Serve para conferir o cabeçalho `Origin` das gravações e para montar links. Ex.: `https://musicaliapp.exemplo.com`. |
| `JWT_SECRET` | Segredo para assinar o token de sessão. Longo e aleatório. |
| `NEXT_PUBLIC_VAPID_PUBLIC_KEY` | Chave pública VAPID, enviada ao navegador. |
| `VAPID_PRIVATE_KEY` | Chave privada VAPID. **Só no servidor.** |
| `VAPID_SUBJECT` | `mailto:` de contato exigido pelo VAPID. |
| `CRON_SECRET` | Segredo que o Vercel Cron envia à rota da rotina diária. |
| `RESEND_API_KEY` | Chave da API do Resend, para enviar os códigos. Sem ela, em desenvolvimento, o código é impresso no terminal. |
| `EMAIL_FROM` | Remetente dos e-mails, em um domínio verificado no Resend (ex.: `MusicaliAPP <nao-responda@seudominio.com>`). |
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
|---|---|---|
| Unitário | Vitest | Conversão de graus e tons e gramática de acordes; quebra da cifra em pares; slugs (RN03, RN13, RN15); filtro de busca e escape; datas em `America/Sao_Paulo`; `autorizar` (papel × ação). |
| Integração | Vitest, com PostgreSQL 16 real (Docker local e *service container* na CI) | Cada rota por papel (admin, coordenador, ministeriado, convidado, conta desativada e sem sessão); `versao` e `409 CONFLITO_VERSAO`; histórico (gravar e restaurar); convite consumido uma só vez em requisições simultâneas; exclusão de conta (RN85); limite de tentativas; as regras do `DDL.SQL`. |
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
- **Termos e privacidade:** antes do deploy, escreva `/termos-de-uso` e `/politica-privacidade` e revise com um advogado. Sem o aceite, o cadastro não conclui (RN86).
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
- **Autorização sempre no servidor**, por uma função central usada em todas as rotas: ela confere o cargo, o estado `ativo`, se o convidado só pode ler, o acesso do convidado (ao menos um evento) e, nas listas, o dono ou o acesso concedido. O que o front esconde não conta como proteção.
- A rota `GET /api/cron/diario` só aceita a chamada que traz o `CRON_SECRET`.
- Fotos de perfil validadas no servidor (tipo e tamanho do arquivo enviado). Antes de gravar, são decodificadas e regravadas pelo `sharp`, o que remove metadados como localização e descarta conteúdo que não seja imagem válida.
- O Swagger e o `openapi.json` exigem sessão de admin.
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
|---|---|---|
| Nome completo, e-mails (até 3) e hash da senha | Identificar a pessoa e permitir o acesso | `usuarios`, `emails_usuario` |
| Foto (opcional) | Reconhecer os músicos nas escalas | `fotos_perfil` |
| Instrumentos, escalas, presenças e status de escuta | Organizar os eventos | `usuarios_instrumentos`, `colecao_musicas_musicos`, `confirmacoes_presenca`, `status_escuta` |
| Identificador do Google (`google_sub`, opcional) | Login com Google | `contas_google` |
| Inscrição de push | Avisar sobre setlists | `device_tokens` |
| Hash do IP e do e-mail, com a contagem de tentativas | Limite de tentativas | `limites_tentativas` (apagado todo dia) |
| Data do aceite dos termos | Registro do consentimento | `usuarios.termos_aceitos_em` |

- **Consentimento:** o cadastro só conclui com o aceite dos Termos de Uso e da Política de Privacidade (RN86).
- **Minimização:** o app não pede CPF, telefone, endereço nem data de nascimento.
- **Quem vê o quê:** os e-mails só aparecem para a própria pessoa, e coordenadores e admin não os veem (RN79, RN83). O admin tem acesso total ao banco, por isso essa conta é restrita a quem é de confiança.
- **Eliminação:** a pessoa apaga a própria conta, e seus dados saem (RN85). O histórico de eventos e de cifras permanece sem identificá-la ("Pessoa removida").
- **Retenção:** os dados duram enquanto a conta existir. Convites e códigos vencidos e os contadores de tentativas são apagados todo dia (RN74).
- **Pedidos do titular:** corrigir nome, e-mails, foto e instrumentos e apagar a conta a própria pessoa faz no app. Os demais pedidos (como uma cópia dos dados) vão ao responsável indicado na Política de Privacidade.
- **Operadores:** Vercel (hospedagem), Supabase (banco), Resend (e-mail), Google (login opcional) e os serviços de push dos navegadores. Alguns processam dados fora do Brasil, e a Política informa essa transferência.
- **Incidentes:** identificar e conter, avaliar o risco, trocar os segredos afetados e comunicar a ANPD e as pessoas atingidas nos casos e prazos da regulamentação vigente.
- **Textos jurídicos:** os Termos de Uso e a Política de Privacidade precisam ser escritos e revisados por advogado antes do uso (veja [Deploy](#deploy)).

## Sprints e milestones

Premissas: sprints de **2 semanas**. As datas de início e de fim serão definidas quando o desenvolvimento começar. Um milestone termina quando todos os requisitos listados nele estão implementados e testados, segundo o critério de pronto de [Qualidade e testes](#qualidade-e-testes). Cada requisito funcional (RF) pertence a um único milestone. A ordem segue as dependências: cada milestone usa o que o anterior entregou.

| Sprint | Milestone | Entrega principal | Requisitos |
|---|---|---|---|
| S1 | **M1 Fundação** | Projeto Next com TypeScript, banco aplicado a partir do `DDL.SQL`, login com "Lembrar de mim", login com Google vinculado, convites de 30 minutos, cargos, instrumentos, conta com foto, e-mail confirmado por código (envio pelo Resend), esqueci a senha por código, troca de senha e desativação e exclusão pela própria pessoa, termos e privacidade. Limite de tentativas no banco. Páginas próprias por `slug`. PWA instalável. | RF01, RF02, RF04 a RF09, RF42, RF44 a RF48, RF58, RF59, RF61, RNF15 |
| S2 | **M2 Biblioteca** | Cadastro e edição de músicas e artistas (inclusive renomear). Cifra em graus, com conversão para qualquer tom. Busca por título e artista, com aviso de músicas parecidas. Controle de versão e histórico da cifra, com título, autor e data. Revisão. | RF17, RF18, RF20, RF21, RF23 a RF25, RF64 |
| S3 | **M3 Leitura da cifra** | Tela da cifra com troca de tom, transpose, modo letra, aumento de fonte e rolagem automática com velocidade ajustável. Página de configurações, com os padrões de visualização e de exportação (RN93); a parte de segurança vem dos milestones M1 e M9. Exportação da cifra e da letra (Markdown ou PDF) e exportação em lote. | RF19, RF60, RF62, RF63, RF66 |
| S4 | **M4 Eventos e setlists** | Eventos com `slug`, cancelamento, setlists e listas com seções e vários donos. Reordenação por arrastar e soltar. Tom tocado por música. Cifra local e "Salvar na música" ou "Salvar só neste setlist". Botão Compartilhar, donos e acesso de edição às listas. Redirecionamento de slugs antigos. Listas visíveis a todos. | RF26 a RF29, RF34, RF55 a RF57 |
| S5 | **M5 Escala, presença e convidados** | Escala por música e por seção, com as opções sobrescrever ou completar. Aviso de conflito de horário. Presença com Vou e Não vou. Aviso de substituição. Convite de convidado para um evento, com acesso somente leitura. Página de instrumento com os músicos. | RF03, RF30, RF31, RF35 a RF38 |
| S6 | **M6 Dashboard e listagens** | Dashboard com os números, instrumentos e próximos eventos. Listagens de músicas, artistas, instrumentos, usuários, listas e eventos, com busca, filtros e ordenação, 30 por página. Busca geral. Mais e menos tocados, com período mês, ano, geral ou um mês ou ano escolhido. Datas de criação e atualização nas páginas e listagens. | RF10 a RF16, RF50 a RF54, RF65 |
| S7 | **M7 Notificações e offline** | Publicação do setlist com push. Lembrete diário de presença pelo Vercel Cron. Cache offline somente leitura, com atualização ao abrir o app. | RF32, RF39 a RF41 |
| S8 | **M8 Entrega** | Swagger restrito ao admin. Testes de permissão para cada papel (inclusive convidado somente leitura e acesso às listas) e estado da conta. Deploy na Vercel e no Supabase. Conta inicial criada. Backup semanal do banco. | RF43, RNF10, RNF17 |
| S9 | **M9 Complementos** | Status de escuta (Não ouvi, Ouvi, Toquei). Códigos de recuperação de senha. Copiar o setlist de outro evento. Ao mover uma música para uma seção cuja escala é uniforme, oferecer aplicar essa escala (RN48). | RF22, RF33, RF49 |

Dependências: M2 depende de M1. M3 depende de M2. M4 depende de M2. M5 depende de M4. M6 depende de M2 e M4. M7 depende de M5. M8 fecha a entrega inicial. M9 depende de M5 e pode vir depois do M8.
