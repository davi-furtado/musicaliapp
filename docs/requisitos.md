# Requisitos e regras de negócio

## Requisitos

### Requisitos funcionais

| ID | Requisito |
|---|---|
| **Acesso e contas** | |
| RF01 | Coordenadores geram links de convite com o cargo que a pessoa terá. O link vale 7 dias e serve uma única vez. Qualquer coordenador pode cancelar um convite pendente, e o link deixa de funcionar. Ao gerar o link, quem o criou vê quanto tempo falta para ele expirar. |
| RF02 | Quem recebe o convite informa nome completo, e-mail e senha, aceita os Termos de Uso e a Política de Privacidade (RF58) pela frase "Ao se registrar você concorda com nossos termos e condições de uso", com links para os documentos e exibida abaixo do botão de cadastro, confirma o código enviado ao e-mail e entra logado. A conta só é criada depois da confirmação. |
| RF03 | Coordenadores geram o link de convite de **um evento** para uma pessoa de fora (convidado). |
| RF04 | Os usuários fazem login e logout. O botão **Lembrar de mim** vem marcado por padrão: marcado, o login fica salvo no aparelho e é renovado a cada acesso. Se a pessoa não acessar o app por 30 dias, a sessão se encerra e o login é apagado do aparelho; desmarcado, vale só enquanto a sessão do navegador estiver aberta. Com o segundo fator ligado, o login tem uma segunda etapa (RF77). |
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
| RF43 | Esqueci a senha: a pessoa informa o e-mail principal ou o de recuperação, recebe um código de 6 dígitos no endereço escolhido e o usa para definir a senha nova. Pode usar um código de recuperação no lugar do e-mail. |
| RF44 | Cada conta tem um **e-mail principal**, obrigatório, onde a pessoa recebe e-mails e códigos. Pode ter também um **e-mail de recuperação**, opcional, usado se ela perder o principal. Os dois são únicos no sistema e confirmados por código de 6 dígitos enviado ao endereço ao ser adicionado. A pessoa entra com o principal, com o de recuperação ou com o Google, se vinculado (RF60). Enquanto a conta não tem e-mail de recuperação, a tela de segurança mostra um lembrete para cadastrar um. |
| RF45 | Trocar a senha em `/configuracoes/seguranca`, informando a senha atual. A nova tem de 8 a 128 caracteres e é diferente da atual (RN73). |
| RF46 | Desativar a própria conta em `/configuracoes/seguranca`, com confirmação pela senha. Quem a reativa é um coordenador. |
| RF47 | Coordenadores não veem os e-mails de ninguém, não apagam contas e não alteram nome, foto ou instrumentos de outra pessoa. Ninguém define senha por outra pessoa: a pessoa redefine a própria pelo código enviado ao seu e-mail principal ou ao de recuperação. |
| RF48 | A pessoa gera 10 códigos de recuperação em `/configuracoes/seguranca`. Eles são mostrados uma única vez, com o aviso para guardá-los fora do aparelho, cada um serve uma vez, e gerar de novo invalida os anteriores. Na primeira entrada, o app oferece gerá-los. |
| RF49 | A página de instrumentos lista todos, 30 por página, sem busca e sem filtro, com ordem A–Z ou Z–A. Cada item leva à página do instrumento. |
| RF50 | A página de listas tem busca pelo nome e ordem A–Z ou Z–A, 30 por página. Mostra todas as listas (RN79). |
| RF51 | A página de eventos tem busca pelo nome, filtro por data e ordem A–Z ou Z–A ou por data (mais recente ou mais antiga), 30 por página. |
| RF52 | A página de usuários tem busca pelo nome e ordem A–Z ou Z–A, 30 por página. Os e-mails de cada pessoa só aparecem para ela (RN81). |
| RF53 | Há uma **busca geral**: um campo de busca no topo do app leva à página `/busca`, que pesquisa ao mesmo tempo músicas, artistas, listas, eventos, usuários e instrumentos, com filtro por tipo. |
| RF54 | Toda página de música, artista, instrumento, usuário, lista e evento tem um botão **Compartilhar**: no celular abre o menu de compartilhamento do aparelho e, onde ele não existir, copia o link. Quem abre o link precisa estar logado (RN82). |
| RF55 | Os donos de uma lista incluem ou retiram outros donos e dão ou retiram acesso de edição a membros ativos, pelo botão **Compartilhar** da lista. Enquanto a lista tiver donos, ao menos um permanece (RN79). |
| RF56 | Todas as listas são visíveis para todos os usuários logados, inclusive convidados. Donos e editores alteram a lista. Com **Edição pública** marcada, ou sem dono, todo membro ativo a altera (RN79). |
| RF57 | A pessoa apaga a própria conta em `/configuracoes/seguranca`, confirmando com a senha e com um código: do app autenticador, de backup ou recebido por e-mail (RN83, RN104). |
| RF58 | Os Termos de Uso (`/documentos/termos-de-uso`) e a Política de Privacidade (`/documentos/politica-privacidade`) ficam publicados e podem ser baixados em Markdown ou PDF. Cada documento tem um único link, o mesmo para visitantes e para usuários logados. O cadastro exige o aceite (RN84). |
| RF59 | Toda cifra pode ser exportada em Markdown ou PDF. O tom do arquivo é o da tela, e pode ser trocado no diálogo de exportação sem mudar a tela (RN88). Também é possível escolher se o link do YouTube sai no PDF (RN86). |
| RF60 | A pessoa vincula uma conta Google à própria conta em `/configuracoes/seguranca`, com a senha, e passa a entrar também pelo botão **Entrar com Google** (RN85). O Google não cria conta: o cadastro segue por convite e código de e-mail. |
| RF61 | A letra de uma música pode ser exportada em Markdown ou PDF, sem acordes, com ou sem seções (RN86, RN87). |
| RF62 | Um artista, um evento ou uma lista pode ser exportado de uma vez em PDF: cada música em sua página, com a capa e o índice. Vale para cifra ou letra, com ou sem seções e com ou sem o link do YouTube. O tom padrão é o tocado de cada item; sem tom tocado, o tom original da música; sem ele, graus. O diálogo pode aplicar um único tom a todas (RN88, RN89). |
| RF63 | Cada alteração da cifra, do tom original, dos artistas ou do tom tocado de uma música fica no histórico, com título obrigatório, autor e data. Qualquer membro ativo vê o histórico, compara versões e volta a uma delas. Voltar cria um novo ponto no histórico, e nada se perde (RN90). |
| RF64 | Todas as páginas e listagens mostram a data de criação e a de atualização de cada item (RNF12). |
| RF65 | Cada pessoa tem uma página de configurações (`/configuracoes`), com cinco partes: **segurança** (as funções de RF45 a RF48, RF57, RF60 e RF76), **termos e condições** (data e versão do aceite, e links para os documentos), **visualização** (a tela abre em cifra ou em letra, com ou sem seções na letra, com o tamanho padrão da fonte da cifra, o formato dos graus, em números ou romanos, se o modo Reduzido começa ligado e o tema, claro, escuro ou automático) **exportação** (o arquivo sai em cifra ou em letra, com ou sem seções) e **notificações** (para coordenadores, o aviso de quem responde Não vou, ligado por padrão; RF73). Os padrões valem em qualquer aparelho (RN91). |
| RF66 | Ver a lista de escalados do evento, com os instrumentos que cada pessoa toca, e adicionar ou remover pessoas dela, sem preencher as seções (RN92). |
| RF67 | Botões **Escalar todos** e **Escalar todos os <instrumento>** na lista do evento, que adicionam os membros ativos ou só os que tocam aquele instrumento (RN94). |
| RF68 | Uma página de tutorial (`/ajuda/acordes`) ensina o padrão de escrita dos acordes, com a tabela de formas, as regras que mais confundem, a tabela de variações aceitas com o que é gravado, um exemplo completo, explicações sobre seções e repetições, e um campo para testar um acorde. O editor de cifra tem o link para ela (RN95). |
| RF69 | Modo **Reduzido** na tela da cifra, ativado por um botão: mostra só os acordes de todas as seções, sem a letra, na ordem da música, com o nome de cada seção. Não há escolha de seção. Pode começar ligado por padrão na configuração da pessoa (RF65). Nesse modo a rolagem automática fica desativada (RN98). |
| RF70 | A exportação da cifra (Markdown ou PDF) tem o modo Reduzido, com os acordes de todas as seções, no mesmo padrão da tela (RF69, RN98). |
| RF71 | Modo **Reduzido** no editor da cifra, ativado por padrão. Mostra as repetições em `{xN}` e, desativado, mostra a letra por completo (RN101). |
| RF72 | Ao salvar um setlist já publicado, quem salva pode marcar **Avisar alteração** (desligado por padrão). Marcado, as pessoas que receberam o push da publicação recebem um novo push (RN62). |
| RF73 | Os coordenadores recebem push quando alguém responde **Não vou** a um evento. Cada coordenador pode desligar esse aviso em `/configuracoes` (padrão: ligado; RN91). |
| RF74 | Com internet, o app guarda no aparelho o setlist e as cifras do próximo evento publicado, para consulta sem conexão (RF40). |
| RF75 | O app tem tema claro, escuro e automático (que segue o aparelho), escolhido em `/configuracoes` (RN91). |
| RF76 | Em `/configuracoes/seguranca`, a pessoa liga o **segundo fator** (app autenticador, TOTP): lê o QR code, confirma com a senha e o primeiro código do app e recebe 10 códigos de backup, mostrados uma vez. Desligar exige a senha e um código. É opcional, e **obrigatório para coordenadores** (RN103). |
| RF77 | Com o segundo fator ligado, o login tem duas etapas: e-mail e senha, depois o código de 6 dígitos do app ou um código de backup (RN107). |
| RF78 | Um coordenador redefine o segundo fator de outra pessoa que perdeu o celular e os códigos de backup, depois de confirmar a identidade dela fora do sistema (RN107). |
| RF79 | Os coordenadores alteram o **nome** e a **logo** do ministério em `/coordenacao`. O valor inicial vem do ambiente (RN105). |
| RF80 | Num sistema sem nenhuma conta, `/primeiro-acesso` cria o primeiro coordenador, com o `SETUP_TOKEN` do ambiente (RN106). |


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
| RNF09 | Senhas com hash scrypt e sessão em cookie `httpOnly`. O segredo do app autenticador fica criptografado no banco. |
| RNF10 | Toda autorização é verificada no servidor, por uma função central. |
| RNF11 | Não há histórico de notificações. |
| RNF12 | Os itens principais (usuários, instrumentos, artistas, músicas, eventos e coleções) têm data de criação e de atualização, mantida pelo banco. O histórico da cifra guarda autor e data de cada versão. |
| RNF13 | Edições concorrentes são detectadas por um contador de versão, sem sobrescrever em silêncio. |
| RNF14 | Fotos de perfil têm até 2 MB, em JPG, PNG ou WebP. O servidor as redimensiona para um quadrado de 256 px, em WebP ou JPEG, e só então grava no banco. |
| RNF15 | Login, aceitação de convite, pedidos de código e envio de códigos têm limite de tentativas, contado no banco (tabela `limites_tentativas`), porque a Vercel não guarda memória entre as requisições. |
| RNF16 | Datas e horas são guardadas com fuso (`TIMESTAMPTZ`) e calculadas e exibidas em `America/Sao_Paulo`. |
| RNF17 | Um backup semanal do banco fica guardado fora dele, cifrado (veja [Deploy](desenvolvimento.md#deploy)). |
| RNF18 | A interface segue o nível AA do WCAG 2.1 e está toda em português do Brasil (veja [Acessibilidade e idioma](desenvolvimento.md#acessibilidade-e-idioma)). |
| RNF19 | Toda regra crítica (cifra, slugs, permissões, histórico, exclusão de conta) tem teste automatizado, e a integração contínua barra o código que quebra os testes (veja [Qualidade e testes](desenvolvimento.md#qualidade-e-testes)). |
| RNF20 | Os logs não registram senhas, códigos, tokens, e-mails nem IP puro (veja [Segurança](seguranca-e-privacidade.md#segurança)). |
| RNF21 | Em produção, o app se recusa a subir com configuração insegura: `JWT_SECRET` ausente, igual ao do exemplo ou com menos de 32 caracteres, `TOTP_ENCRYPTION_KEY` ausente ou inválida, `APP_URL` sem HTTPS (exceto `localhost`) ou cookie sem `secure` (veja [Segurança](seguranca-e-privacidade.md#segurança)). |
| RNF22 | O app tem uma **opção de rodar em contêiner** (`Dockerfile` e `docker-compose.yml`), com as mesmas funções, sem estado em disco e com a rotina diária feita por um serviço próprio. É uma alternativa à Vercel, não a substitui como hospedagem principal (RNF08). Veja [Rodando em contêiner](desenvolvimento.md#rodando-em-contêiner-opcional). |

## Regras de negócio

### Contas e cargos

| ID | Regra |
|---|---|
| RN01 | O acesso é só por convite. A única exceção é o primeiro coordenador, criado em `/primeiro-acesso` num sistema sem contas (RN106). |
| RN02 | Um convite é de uso único, vale **7 dias** (valor fixo, que quem convida não altera) e carrega o cargo da pessoa. Não tem e-mail: é um link. Quem gera o convite vê o tempo restante até a expiração. O convite usado é apagado. Qualquer coordenador pode cancelar um convite pendente, e o link deixa de funcionar. |
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
|---|---|
| RN12 | O `slug` usa minúsculas, números e hífens no lugar de espaços e acentos (`Violão` vira `violao`). |
| RN13 | Quando o slug muda, o anterior vai para a tabela `slugs_antigos` e a URL antiga responde com redirecionamento permanente (308) para a página atual. Se outro item já passou a usar o slug antigo, a URL aponta para esse outro item. |
| RN14 | O slug de evento é a data ISO mais o nome (`2026-10-12-missa-de-domingo`). Muda quando a data ou o nome muda, com redirecionamento (RN13), e recebe sufixo numérico em caso de repetição. |
| RN15 | Slugs que coincidem com um trecho fixo de rota (`nova`, `novo`, `editar`, `foto`, `parecidas`, `coordenacao`, `docs`, `api`) não são aceitos: o app gera outro, com sufixo numérico. |

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
| RN31 | Quem escreve a cifra pode usar graus ou um tom qualquer. O front converte para graus antes de enviar. Em qualquer dos dois casos, os acordes seguem o padrão de escrita (RN95). |
| RN32 | O tom só é salvo em uma música de **setlist ou lista**, e é opcional. Esse tom nunca altera a música. |
| RN33 | Em qualquer tela o front pode mostrar a cifra em outro tom. É só visualização e nada é gravado. O tom original aparece destacado na lista de tons da visualização, mas a biblioteca não abre nele: abre em graus, a não ser que a pessoa escolha outro tom. A opção de transpose (meio tom ou tom em tom) só fica ativa com um tom de referência: na biblioteca, o tom escolhido para ver a música; no setlist, o tom tocado do item. Em graus do campo harmônico, fica desativada. |
| RN34 | Não existem duas músicas com o mesmo título (sem diferenciar maiúsculas nem acentos) e o mesmo conjunto de artistas. Ao cadastrar, o app avisa sobre títulos parecidos. Toda música tem pelo menos um artista. |
| RN35 | A marca de revisão é só sim ou não, sem motivo. Qualquer membro ativo marca e desmarca. Convidados não marcam. |
| RN36 | O status de escuta é por usuário e por música, e o padrão é "Não ouvi". Convidados não marcam. |
| RN37 | Uma música que aparece em algum setlist ou lista não pode ser apagada. Ela continua no banco e no histórico dos eventos. |
| RN38 | Cada música e cada item de setlist tem um número de versão. Se a versão mudou desde que a pessoa abriu a tela, a gravação é recusada com aviso. |
| RN39 | A música pode ter um link do YouTube, que é opcional. O app não guarda arquivos de áudio. |
| RN95 | Os acordes são **gravados** só no padrão desta seção (veja [Padrão de escrita](cifra.md#padrão-de-escrita)). Ao digitar, o app aceita estas variações e converte para o padrão antes de gravar: (a) dentro dos parênteses, `b` e `#` no lugar de `-` e `+` (`C7(b9)` = `C7(-9)` = `C7(9-)`; `C7(#5)` = `C7(+5)` = `C7(5+)`), e misturas dos dois na mesma extensão; (b) `maj7`, `M7`, `Δ` e `^7` para `7M`, e `maj9` para `7M(9)`; (c) `sus` e `sus4` para `4`, e `sus2` para `2`; (d) `add9` e `add2` para `9`, e `add4` para `11`; (e) `min` e `-` depois da raiz para `m` (`C-7` = `Cm7`); (f) `º` e `°` para `º`; (g) `m7b5` e `ø` para `m7(5-)`; (h) `C+` para `C5+`, e `C69` para `C6(9)`. Não são aceitas `dim`, `dim7` e `aug`, nem as formas com raiz (`Cdim`, `Cdim7`, `Caug`), porque não dizem se o acorde é tríade ou sétima. A tríade diminuta se escreve `m5-`, a aumentada `5+`, e a sétima diminuta `º`. Dentro dos parênteses, `-` e `+` valem como alterações, e `b` e `#` valem como o mesmo sinal. O `b` e o `#` fora dos parênteses continuam sendo acidentes da nota. Os graus também podem ser digitados em romanos (`I`, `ii`, `bVII`, `#IV`), e o app grava em algarismos (RN97). Um item que o app não reconhece não vira acorde: a linha em que ele aparece é tratada como letra, e o editor avisa, sem bloquear a gravação, com o link para o tutorial (RF68). |
| RN96 | A linha é de acordes ou de letra conforme sua posição e o que ela contém. Uma linha é de acordes quando todos os seus itens são acordes válidos e ela vem logo depois de uma seção, de uma linha de letra ou de outra linha de acordes (a linha de seção também pode trazer acordes depois do marcador). Uma linha de letra sem acordes, que vem depois de outra letra, continua sendo de letra. Uma linha com um só item que também é palavra (`A`, `E`, `vi`, `I`) só é de acordes quando a linha seguinte é de letra. Qualquer outra linha é de letra. |
| RN97 | Em romanos, o grau é `I` a `VII`. Maiúsculo é maior e minúsculo é menor (`vi` = `6m`). Quem digita `VIm` também tem o menor aceito. O sinal `b` ou `#` é aceito antes ou depois do numeral (`bVII` ou `VIIb`), e a tela, em romanos, mostra antes (`bVII`). Os sufixos são os mesmos do padrão: a tríade diminuta aparece como `vii5-` (`1m5-`) e a sétima diminuta como `viiº` (`1º`). A forma gravada é sempre em algarismos. |
| RN98 | No modo Reduzido, a tela e a exportação mostram só os acordes de cada seção, uma linha de acordes por linha, sem letra, na ordem da música. Linhas de acordes **iguais e seguidas** são resumidas como `(2x)`, `(3x)`… O resumo é feito pelo app, só na visualização e na exportação: a cifra gravada nunca contém `(2x)`. Nesse modo a rolagem automática fica desativada, porque a cifra é curta. |
| RN99 | Repetições: a pessoa escreve a repetição com `{xN}` (RN100). Não se usam `(2x)`, `x2`, `bis` nem marcações parecidas. O resumo `(2x)` do modo Reduzido é feito pelo app (RN98). |
| RN100 | O marcador `{xN}` (N maior ou igual a 2) repete, conforme a posição em que é escrito: (a) no fim de uma linha de acordes ou de letra, repete essa linha; (b) sozinho numa linha, logo depois de uma estrofe (bloco de linhas separado por linha em branco), repete a estrofe; (c) depois do nome na linha de seção, como `[Refrão] {x2}`, repete a seção inteira, com a tag. O marcador não conta como acorde nem como letra. Na tela completa e na exportação completa, o app expande o `{xN}`. Ao salvar, o app junta em `{xN}` as estrofes e os trechos instrumentais iguais e seguidos. Dois trechos são iguais quando têm as mesmas linhas, na mesma ordem, com acordes e letra. |
| RN101 | No editor da cifra, o modo Reduzido vem ativado por padrão e mostra a cifra com as repetições em `{xN}`, como ficou salva. Desativado, o editor mostra a letra por completo, com todas as repetições escritas. Editar um trecho em `{xN}` altera todas as suas repetições. Se a pessoa edita uma cópia no modo completo, as cópias ficam diferentes e não são comprimidas ao salvar. |
| RN102 | A cifra de uma música, a cifra local de um item do setlist e a de cada versão do histórico têm no máximo 20.000 caracteres. O banco recusa o que passar disso. |

### Eventos, setlists e listas

| ID | Regra |
|---|---|
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
|---|---|
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
|---|---|
| RN60 | Se o evento exige presença, ao publicar o setlist todos os membros e os convidados do evento recebem o pedido de confirmação, inclusive os desativados. |
| RN61 | A resposta é **Vou** ou **Não vou**, pode ser trocada a qualquer momento e quem não respondeu aparece como pendente. Todos os que veem o evento veem a resposta de cada pessoa. |
| RN62 | O push é enviado quando o setlist é publicado. Alterações posteriores não notificam, a menos que quem salva marque **Avisar alteração** (RF72). |
| RN63 | Uma vez por dia, quem ainda não respondeu a um evento publicado que exige presença e acontece no dia seguinte recebe um lembrete. |
| RN64 | Não há histórico de notificações. |

### Uso offline e API

| ID | Regra |
|---|---|
| RN65 | Offline só há leitura. Qualquer edição exige conexão. |
| RN66 | O Swagger e a especificação OpenAPI são públicos, sem login. A validação de sessão e de permissão fica nos endpoints descritos por ela. |
| RN67 | Toda rota decide o acesso por uma função central que considera o cargo, o estado `ativo`, o convidado somente leitura e, nas listas, o dono, o acesso concedido ou a condição de lista pública. |

### Conta, e-mail e desativação

| ID | Regra |
|---|---|
| RN68 | Cada conta tem um e-mail principal, obrigatório, e pode ter um de recuperação, opcional. Os dois são únicos no sistema e em minúsculas (RN03). Só entra por e-mail quem confirmou o endereço por código. |
| RN69 | A conta só é criada depois que o código enviado ao e-mail é confirmado. O convite só é consumido nesse momento. O convite e o código usados são apagados. |
| RN70 | Adicionar ou trocar o e-mail de recuperação, e trocar o principal, exigem a senha atual (RN73) e a confirmação por código enviado ao endereço novo. Trocar o principal também envia um aviso ao endereço antigo. O principal não é removido: para mudá-lo, troca-se por outro. O de recuperação pode ser removido com a senha atual. Com o segundo fator ligado, essas trocas também exigem o código do app (RN103). |
| RN71 | O pedido de "esqueci a senha" e o pedido de código do cadastro respondem da mesma forma exista ou não a conta, para não revelar quais e-mails estão cadastrados. No cadastro com um e-mail que já tem conta, o dono da conta recebe um aviso no lugar do código (veja [Convites e primeiro acesso](funcionalidades.md#convites-e-primeiro-acesso)). |
| RN72 | Os códigos enviados por e-mail (cadastro, redefinição de senha, troca de e-mail e exclusão da conta) valem 15 minutos, contados a partir do envio, servem uma única vez (são apagados ao serem usados) e são invalidados após o limite de tentativas. Os expirados são apagados pela rotina diária. No pedido de redefinição, a pessoa escolhe o e-mail principal ou o de recuperação, se tiver um. A resposta é a mesma exista ou não o e-mail escolhido (RN71). No cadastro e na troca de e-mail, o envio acontece na própria requisição: a tela só mostra "código enviado" se o provedor de e-mail aceitar a mensagem. No pedido de "esqueci a senha", a resposta não espera o envio, para que o tempo de resposta não revele se a conta existe, e uma falha de envio fica só no registro do servidor. Pedir um novo código invalida o anterior, e um novo pedido para o mesmo e-mail só é aceito 60 segundos depois do anterior (contado em `limites_tentativas`). |
| RN73 | Trocar a senha exige a senha atual, e a nova precisa ser diferente dela. A senha tem de 8 a 128 caracteres e é guardada como hash **scrypt** (N=2^14, r=8, p=1) com sal aleatório, conferido em tempo constante. Trocar ou redefinir a senha incrementa `token_versao` e encerra as outras sessões; na troca, a sessão atual continua, com um cookie novo. |
| RN74 | A própria pessoa pode desativar a própria conta, em `/configuracoes/seguranca`, com confirmação pela senha. Valem as mesmas regras de RN06 e RN07: ela sai da lista do evento e de todas as escalas dos eventos futuros e continua vendo os dados e confirmando presença. |
| RN75 | Só um coordenador reativa uma conta desativada pela própria pessoa. Reativar não a recoloca na escala (RN07). |
| RN76 | Contas só são apagadas pela própria pessoa (RN83). O histórico de eventos e execuções sempre permanece. |
| RN77 | Só a própria pessoa vê, troca ou apaga os seus e-mails. Coordenadores não veem e-mails de ninguém e não alteram e-mail, senha, nome, foto ou instrumentos de outras pessoas. Ninguém define senha por outra pessoa: a redefinição é sempre pelo código enviado ao e-mail principal ou ao de recuperação da própria conta (RN72). Quem tem acesso direto ao banco deve ser restrito a pessoas de confiança. |
| RN78 | Os códigos de recuperação não dependem de e-mail. Usar um deles redefine a senha e o código fica gasto. Eles são o único caminho de volta para quem perde os dois e-mails e não tem o Google vinculado. |

### Listas, artistas e compartilhamento

| ID | Regra |
|---|---|
| RN79 | Todas as listas aparecem para todos os usuários logados, convidados inclusive. Donos e editores editam a lista. Donos também incluem ou retiram donos e dão ou retiram acesso de edição. Editores editam nome, seções, músicas, tom e cifra local, mas não gerenciam donos nem acessos. Só membros ativos e não convidados podem ser donos ou editores. Com a opção **Edição pública** marcada, ou sem donos, todo membro ativo edita a lista; os donos ligam e desligam essa opção quando quiserem. Enquanto a lista tem donos, ao menos um permanece, e um dono com a conta desativada continua dono. Só coordenadores apagam uma lista sem donos. Coordenadores podem tudo o que um dono pode (RN05). |
| RN80 | Qualquer membro ativo renomeia um artista. O slug acompanha o novo nome, e a URL antiga redireciona (RN13). O novo nome não pode repetir outro artista (sem diferenciar maiúsculas nem acentos, RN16). |
| RN81 | Os e-mails de uma pessoa só são vistos por ela. Nas listagens, no perfil e na busca, os demais veem nome, foto e instrumentos. |
| RN82 | O botão **Compartilhar** envia o link da página (`/<tipo>/<slug>`). Quem abre precisa estar logado e ter permissão, senão vê 404. Compartilhar o link não dá acesso a nada. |
| RN83 | Ao apagar a própria conta, a pessoa sai de tudo: e-mails, senha, foto, instrumentos, configurações, códigos, inscrições de notificação, presenças e escalas de seção e de evento dos eventos futuros. Escalas e presenças de eventos passados ficam como "Pessoa removida", para manter o histórico. Listas em que ela era a única dona ficam públicas (RN79); nas que têm outros donos, a lista continua e ela só deixa de ser dona. Convites que ela criou são apagados. Músicas, cifras e artistas que ela cadastrou continuam. Nas versões do histórico que ela fez, o autor vira "Pessoa removida". |
| RN84 | O cadastro, por convite, de convidado ou pelo primeiro acesso, só conclui com o aceite dos Termos de Uso e da Política de Privacidade. O sistema grava a data (`usuarios.termos_aceitos_em`) e a versão (`usuarios.termos_versao`, a constante `TERMOS_VERSAO`). Os três textos têm a mesma versão, e um teste automatizado confere isso. Subir a versão não pede novo aceite. |
| RN85 | O login com Google só vale para contas com o vínculo feito. O vínculo exige a senha atual, é feito em `/configuracoes/seguranca` e liga uma conta Google a uma só conta. Desvincular também pede a senha. O e-mail do Google não entra na lista de e-mails da conta. |
| RN103 | **Segundo fator (TOTP, RFC 6238).** É opcional para todos e obrigatório para coordenadores quando `EXIGIR_TOTP_COORDENADOR` está ligado (padrão em produção). O segredo é criptografado em repouso (AES-256-GCM, chave `TOTP_ENCRYPTION_KEY`). Ligar exige a senha e o primeiro código do app, e gera 10 códigos de backup de uso único (só o hash é guardado, tabela `codigos_backup_totp`). Cada código do app serve uma vez: o app grava o último passo de 30 s aceito (`totp_ultimo_passo`) e aceita a janela atual e a vizinha. Desligar exige a senha e um código, e coordenadores não podem desligar. Coordenador sem o segundo fator só acessa `/configuracoes/seguranca` e as rotas `/api/auth/*` e `/api/conta/*`, até ligá-lo. |
| RN104 | **Exclusão da própria conta.** Além da senha (RN83), a pessoa confirma com **um** código: do app autenticador, de backup ou enviado por e-mail (`finalidade = EXCLUSAO_CONTA`, 15 minutos, uso único, limite de tentativas), ao e-mail principal ou ao de recuperação, à escolha da pessoa. O app confere os impedimentos **antes** de gastar o código: a única conta de coordenador não pode ser apagada (`409`; promova outra pessoa antes). A exclusão é definitiva, encerra a sessão e segue RN83. |
| RN105 | **Identidade do ministério.** O nome e a logo vêm do ambiente (`NOME_MINISTERIO`, `LOGO_MINISTERIO_PATH`, PNG ou JPEG de até 512 KB) só como valor inicial: na primeira subida o app os grava em `configuracoes_app` se ainda não houver linha. Depois vale o que os coordenadores salvarem em `/coordenacao`, e o ambiente não sobrescreve mais. O nome tem de 2 a 80 caracteres; sem nome, vale "MusicaliAPP". Nome e logo são públicos (aparecem no login) e entram no título das páginas, no manifesto do PWA, nos e-mails, no emissor do app autenticador e nos documentos legais. Remover a logo volta ao ícone padrão. |
| RN106 | **Primeiro acesso.** Enquanto não existe nenhuma conta, `/primeiro-acesso` fica aberta e exige o `SETUP_TOKEN` (segredo do ambiente, com 32 caracteres ou mais). Pede o token, o nome completo, o e-mail (confirmado por código, como no cadastro), a senha, o nome do ministério (já preenchido com o do ambiente) e o aceite dos termos, e cria o primeiro coordenador. A criação é atômica (transação com `pg_advisory_xact_lock`, só se `usuarios` estiver vazia); depois dela, a rota responde `404` e o token não serve mais. **Não há conta nem senha padrão.** Sem `SETUP_TOKEN` a rota fica desligada, e a conta pode ser criada pelo `INSERT` do guia de desenvolvimento. O coordenador liga o segundo fator já no primeiro login (RN103). A rota tem limite de tentativas. |
| RN107 | **Login em duas etapas.** Com o segundo fator ligado, e-mail e senha corretos não abrem sessão: a API devolve `mfa_required` e um token temporário de 5 minutos, que só serve à segunda etapa (código do app ou de backup) e é recusado como sessão. Senha errada e e-mail inexistente respondem igual, e a segunda etapa tem limite de tentativas. O e-mail comprova a posse do endereço e o app comprova a pessoa: o código por e-mail ou de recuperação redefine a senha, mas **não** desliga nem pula o segundo fator. Quem perdeu o celular e os códigos de backup tem o segundo fator redefinido por um coordenador (RF78), que confirma a identidade fora do sistema; a ação incrementa `token_versao` e a pessoa precisa ligá-lo de novo. Um coordenador não redefine o próprio. |
| RN108 | **Sessão.** O JWT (HS256) leva `sub`, `ver` (`token_versao`), `rem` (lembrar de mim), `jti`, `iat` e `exp`; o token da segunda etapa leva `typ: "mfa"`, e cada tipo é recusado no lugar do outro. Com **Lembrar de mim**, o cookie é persistente por `SESSAO_LEMBRAR_DIAS` (30) e renovado a cada `GET /api/auth/me`; sem ele, é cookie de sessão e o token expira em `SESSAO_MINUTOS` (480). |
| RN86 | A exportação é só leitura e não grava nada. O Markdown leva a cifra em bloco de código, para preservar o alinhamento. O PDF da cifra usa fonte monoespaçada e quebra as linhas em pares, como a tela. O PDF e o Markdown da letra usam texto normal e quebram as linhas normalmente. O link do YouTube só sai se a opção estiver marcada, e o padrão é não sair. Quem pode ver a música pode exportá-la. |
| RN87 | O botão **Seções** da letra começa no padrão da configuração (RN91), desligado por padrão. Ele vale para a tela, para o Markdown e para o PDF da letra, e fica separado da opção de exportação. A cifra sempre mostra as seções. |
| RN88 | O tom da exportação é, por padrão, o tom que a pessoa vê na tela, inclusive no setlist e na lista. No diálogo de exportação de uma música, a pessoa pode trocar o tom sem mudar o da tela. Em lote, o padrão é o tom tocado de cada item do setlist ou da lista; sem tom tocado, o tom original da música; sem ele, graus. O diálogo de lote pode aplicar um único tom a todas as músicas. |
| RN89 | O lote aceita até 100 músicas por PDF. Cada música começa em página nova, depois da capa com o título, a data (se for evento) e o índice. A ordem é A–Z no artista e a ordem do setlist ou da lista nos eventos e listas. Quem exporta um evento precisa ver o evento: convidados só exportam dos seus. |
| RN90 | Cada gravação que muda a cifra, o tom original, a lista de artistas ou o tom tocado (no setlist ou na lista) cria uma versão no histórico da música, com título obrigatório, autor e data. Título, link e o nome de um artista não geram versão: a música guarda a referência ao artista, não o nome. Qualquer membro ativo vê o histórico e pode comparar uma versão com a atual. Voltar a uma versão cria uma nova versão com o conteúdo antigo, marcada como restaurada, e nada é apagado. Se o autor apagar a conta, a versão continua, com "Pessoa removida". |
| RN91 | Cada pessoa tem uma configuração de visualização e de exportação, guardada na conta. Visualização: a tela abre em cifra ou em letra (padrão: cifra), com ou sem seções na letra (padrão: sem seções), com um tamanho padrão da fonte da cifra (pequeno, médio ou grande; padrão: médio), o formato dos graus (números ou romanos; padrão: números), se o modo Reduzido começa ligado (padrão: desligado; RF69) e o tema (claro, escuro ou automático; padrão: automático). Exportação: o arquivo sai em cifra ou em letra (padrão: cifra), com ou sem seções na letra (padrão: sem seções). Notificações, só para coordenadores: avisar quando alguém responde Não vou (padrão: ligado; RF73). Os botões da tela e do diálogo de exportação valem só naquela vez e não são gravados. Quem ainda não gravou nada tem os padrões acima. |
| RN92 | A escala do evento é a lista das pessoas escaladas para o evento inteiro, com os instrumentos que cada uma toca. Ela não tem instrumento próprio: uma pessoa pode tocar mais de um, e pode estar na lista sem instrumento cadastrado. Qualquer membro ativo, e os convidados dos eventos a que foram convidados, adicionam e removem pessoas dela. Convidados só podem ser escalados por coordenadores. A lista não preenche as seções. Ao escalar alguém numa seção, se a pessoa não está na lista, ela entra automaticamente. Remover alguém da lista também a tira de todas as seções do setlist. |
| RN93 | Quando uma conta é desativada, pela própria pessoa ou por um coordenador, todos os coordenadores recebem um push com o nome da pessoa. Reativar a conta não notifica. |
| RN94 | Os botões **Escalar todos** e **Escalar todos os <instrumento>** (por exemplo, todas as vozes ou todos os violões) são da lista do evento. **Escalar todos** adiciona todos os membros ativos do ministério; o botão de instrumento adiciona só quem toca aquele instrumento. Quem já está na lista não é duplicado. Os botões não escalam ninguém em seções. |

