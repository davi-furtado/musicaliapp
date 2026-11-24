# Política de Cookies

Termos de Uso (`/documentos/termos-de-uso`) · Política de Privacidade (`/documentos/politica-privacidade`). [Os dois textos ainda serão escritos.]

> **Rascunho para revisão jurídica.** Este texto descreve o que o MusicaliAPP grava no seu navegador, segundo o que a documentação do projeto prevê. Precisa ser conferido com o app pronto e revisado por advogado antes de ser publicado. Os trechos entre colchetes `[ ]` devem ser preenchidos pelo ministério.
>
> Quando o código existir, este arquivo passa a viver em `src/content/legal/politica-de-cookies.md`, de onde o app o exibe em `/documentos/politica-de-cookies`.

**Vigência a partir de:** [data]

**Versão:** 1.0 (a mesma dos Termos de Uso e da Política de Privacidade: `TERMOS_VERSAO`)

## 1. O que são cookies e armazenamento no navegador

Cookies são pequenos arquivos que um site grava no seu navegador. O navegador também oferece outros espaços de armazenamento (como o armazenamento local, o cache e o banco de dados do navegador), que funcionam de modo parecido. Nesta política, chamamos tudo isso de "armazenamento no navegador".

## 2. O que o MusicaliAPP grava

O app grava apenas o que é **necessário para funcionar** ou o que você mesmo escolhe. **Não há cookies de análise, de publicidade nem de rastreamento**, e o app não carrega scripts de terceiros.

| Nome | Tipo | Para quê | Quanto tempo dura |
| --- | --- | --- | --- |
| `musicaliapp_sessao` | Cookie essencial | Manter você conectado. Guarda um identificador assinado da sessão, nunca a sua senha. É `HttpOnly` (o JavaScript da página não o lê), `SameSite=Lax` e `Secure` (só trafega por HTTPS) em produção | Com **Lembrar de mim**: 30 dias, contados do último acesso e renovados a cada acesso. Sem a marcação: é um cookie de sessão, apagado ao fechar o navegador, e a sessão expira em 8 horas. Em ambos os casos, é apagado ao sair ou ao apagar a conta |
| `musicaliapp_google` | Cookie essencial, temporário | Concluir com segurança o **Entrar com Google** ou o vínculo da conta Google: guarda valores de verificação (`state`, `nonce` e PKCE) que só valem naquele login. É `HttpOnly`, `SameSite=Lax` e `Secure` | 10 minutos, e é apagado assim que o login termina. Só existe se você usar o Google |
| `musicaliapp_tema` | Armazenamento local, preferência | Lembrar se você prefere o tema claro, escuro ou o do aparelho, para a tela aparecer certa antes do login. Com a conta aberta, a escolha também fica guardada na sua conta | Até você apagar os dados do site no navegador |
| `musicaliapp-v1` | Cache do navegador (service worker) | Guardar os arquivos do aplicativo (telas, scripts, ícones e a logo do ministério) para ele abrir mais rápido e funcionar sem internet | Até você apagar os dados do site; o app o renova a cada versão |
| `musicaliapp-offline` | Banco de dados do navegador (IndexedDB) | Guardar as músicas, os setlists e as listas que **você baixou** pelo botão **Baixar**, para consultar sem internet. É só leitura, e nada entra aqui sem você apertar o botão | Até você remover o download, apertar **Apagar todos os downloads** em Configurações, sair ou apagar a conta, a sua sessão terminar ou você apagar os dados do site |

O app não usa `sessionStorage`.

[Os prazos de 30 dias e de 8 horas são os padrões do app e podem ser mudados na configuração do servidor (`SESSAO_LEMBRAR_DIAS` e `SESSAO_MINUTOS`). O ministério deve confirmar os valores em produção.]

## 3. Notificações por push

Se você ativar as notificações, o navegador cria uma **inscrição de push** para este aparelho. Ela não é um cookie: o app guarda o endereço da inscrição e as chaves dela no servidor, ligados à sua conta, só para enviar os avisos de setlist publicado e de presença. Você a desliga a qualquer momento nas configurações do navegador ou do app, e ela é apagada quando você apaga a conta. Os avisos passam pelo serviço de push do seu navegador (por exemplo, o do Google, o da Apple ou o da Mozilla).

## 4. Por que não pedimos o seu consentimento

O cookie de sessão é **estritamente necessário**: sem ele, não há login. O tema, o cache e a leitura sem internet só servem para o app funcionar do jeito que você escolheu ou esperaria. Por isso o app **não exibe aviso de cookies com opção de recusar**: não há o que recusar sem impedir o uso. Se algum dia o app passar a usar cookies de análise, de publicidade ou de terceiros, esta política será atualizada e o consentimento será pedido **antes**. [O ministério deve confirmar este entendimento com o advogado.]

## 5. Conteúdo de terceiros

- **Fontes tipográficas:** são servidas pelo próprio app, a partir do mesmo endereço. O navegador não consulta o Google nem outro terceiro para obtê-las, e nenhum endereço IP ou dado técnico é enviado a terceiros por causa delas.
- **Entrar com Google:** é opcional. Ao clicar, você sai do app e vai para o site do Google, que grava os próprios cookies, sob a política dele. O app não recebe nem guarda esses cookies. De volta ao app, ele recebe só o identificador da conta Google e confirma que a conta está vinculada à sua.
- **E-mails:** os códigos e avisos que o app envia não têm imagens de rastreamento.
- **Hospedagem:** o app é servido por provedores de infraestrutura [Vercel, Supabase e Resend, ou os que o ministério usar]. Eles tratam os dados no servidor, como explica a Política de Privacidade. [Se o provedor de hospedagem passar a gravar algum cookie técnico no seu navegador, esta política será atualizada.]

## 6. Como apagar ou controlar

- **Sair da conta** apaga o cookie `musicaliapp_sessao` e os seus downloads (`musicaliapp-offline`). Em **Configurações**, **Apagar todos os downloads** apaga só os downloads e mantém você conectado.
- Nas configurações do navegador (privacidade ou dados do site), você pode apagar os cookies, o armazenamento local, o cache e o banco de dados deste site, ou bloquear os cookies. Apagar o cookie de sessão encerra o seu login; apagar `musicaliapp_tema` volta o tema ao automático; apagar o cache só deixa o próximo carregamento mais lento.
- Bloquear todos os cookies do site **impede o login**, porque a sessão depende do `musicaliapp_sessao`.
- Você escolhe o tema em **Configurações**.

## 7. Alterações desta Política

Esta Política pode ser atualizada. A versão em vigor é a publicada no app, com a data de vigência e o número da versão no topo. Dúvidas: [e-mail de contato do ministério ou do encarregado].
