# Segurança e privacidade

## Segurança

- Senhas guardadas com hash **scrypt** (`node:crypto`), com sal aleatório; nunca em texto.
- Sessão em **cookie `httpOnly`**, `sameSite=lax` e `secure` em produção, inacessível ao JavaScript da página.
- Convites de uso único, com validade de 30 minutos, consumidos por um `DELETE ... RETURNING` atômico, que impede o uso duplo em requisições simultâneas.
- Toda entrada validada com **Zod**.
- **Autorização sempre no servidor**, por uma função central usada em todas as rotas: ela confere o cargo, o estado `ativo`, se o convidado só pode ler, o acesso do convidado (ao menos um evento) e, nas listas, o dono, o acesso concedido ou a condição de lista pública. O que o front esconde não conta como proteção.
- A rota `GET /api/cron/diario` só aceita a chamada que traz o `CRON_SECRET`.
- Fotos de perfil validadas no servidor (tipo e tamanho do arquivo enviado). Antes de gravar, são decodificadas e regravadas pelo `sharp`, o que remove metadados como localização e descarta conteúdo que não seja imagem válida.
- O Swagger e o `openapi.json` são públicos. A validação de sessão e de permissão fica nos endpoints.
- A chave privada VAPID, o `JWT_SECRET`, o `TOTP_ENCRYPTION_KEY`, o `SETUP_TOKEN` e o `CRON_SECRET` nunca vão para o front nem para o repositório.
- Login, aceitação de convite e pedidos de "esqueci a senha" têm limite de tentativas (rate limit), contado na tabela `limites_tentativas`, por IP e por e-mail, ambos guardados em hash.
- A sessão (JWT) leva o `token_versao` da pessoa. Trocar ou redefinir a senha o incrementa, e a função central recusa tokens com versão antiga, o que encerra as outras sessões.
- O pedido de "esqueci a senha" responde igual exista ou não a conta. Os códigos de e-mail e de recuperação são guardados em hash. Os de e-mail valem 30 minutos e servem uma única vez.
- **Senha:** de 8 a 128 caracteres, diferente da atual na troca. Hash scrypt (N=2^14, r=8, p=1, sal de 16 bytes), no formato `scrypt$N$r$p$sal$hash`, conferido com `timingSafeEqual`. O hash de uma conta sem senha válida nunca confere.
- **Segundo fator (TOTP):** opcional, obrigatório para coordenadores (RN102). O segredo (160 bits) fica criptografado com AES-256-GCM e a chave `TOTP_ENCRYPTION_KEY`. Cada código vale uma vez (`totp_ultimo_passo`), com a janela atual e uma vizinha de 30 s. Os 10 códigos de backup ficam só como hash. O login em duas etapas usa um token de 5 minutos (`typ: "mfa"`) que não abre sessão (RN106). A segunda etapa, a exclusão da conta e o primeiro acesso têm limite de tentativas.
- **Falha de configuração em produção (RNF21):** com `NODE_ENV=production`, o app valida o ambiente ao subir (`src/lib/config.ts`, chamado por `instrumentation.ts`, com Zod) e **recusa iniciar** se o `JWT_SECRET` faltar, for o do exemplo ou tiver menos de 32 caracteres, se o `TOTP_ENCRYPTION_KEY` não for uma chave de 32 bytes em base64, se `APP_URL` não for HTTPS (`localhost` é aceito, para testar o contêiner) ou se `COOKIE_SECURE` for falso. A mensagem de erro diz qual variável corrigir, sem imprimir o valor.
- **Primeiro acesso:** sem conta nem senha padrão. A rota só existe enquanto `usuarios` está vazia, exige o `SETUP_TOKEN` (comparado em tempo constante) e cria o coordenador numa transação com `pg_advisory_xact_lock`, para que duas requisições simultâneas não criem dois (RN105).
- **Sessão:** o cookie tem `httpOnly`, `sameSite=lax` e `secure` em produção. O JWT leva `jti`, e o tipo (`sessão` ou `mfa`) impede usar um no lugar do outro (RN107).
- **Contêiner:** a imagem roda com usuário sem privilégios, não leva `.env*` nem `.git` (`.dockerignore`) e não carrega segredos no build: as variáveis entram só na execução. A porta do banco do compose não é publicada fora da rede interna.
- **CSRF:** toda gravação usa `POST`, `PUT`, `PATCH` ou `DELETE`, com cookie `sameSite=lax`, e a API confere se o cabeçalho `Origin` é o de `APP_URL`. As rotas `GET` não alteram dados.
- **Login com Google:** `openid-client` com `state`, `nonce` e PKCE. O vínculo usa o `google_sub`, não o e-mail.
- **Cabeçalhos HTTP:** `Content-Security-Policy` restritiva (`default-src 'self'`, scripts com *nonce* e `frame-ancestors 'none'`), `X-Content-Type-Options: nosniff`, `Strict-Transport-Security` e `Referrer-Policy`, configurados em `next.config.ts` e no middleware.
- **Entrada e saída:** corpo com tamanho máximo em cada rota (2 MB só na foto), consultas sempre parametrizadas, e cifra e letra tratadas como texto puro, nunca como HTML.
- **Logs:** estruturados e sem dados pessoais. Não registram senha, código, token, e-mail nem IP puro; usam o id da pessoa e o `codigo` do erro (RNF20).
- **Dependências:** versões travadas no `package-lock.json`, com Dependabot e `npm audit` na CI.
- **Rotação de segredos:** trocar o `JWT_SECRET` encerra todas as sessões. Trocar o `TOTP_ENCRYPTION_KEY` invalida todos os segundos fatores (as pessoas ligam de novo, e os coordenadores redefinem os que ficarem presos). Trocar as chaves VAPID invalida as inscrições de push, e as pessoas precisam reativar as notificações. O `SETUP_TOKEN` pode ser removido depois do primeiro acesso.

## Privacidade e LGPD

O app trata dados pessoais de membros de um ministério de igreja, e participar dele pode revelar a crença religiosa, que a LGPD classifica como dado sensível. Por isso o app coleta o mínimo e pede consentimento.

| Dado | Para quê | Onde fica |
| --- | --- | --- |
| Nome completo, e-mails (até 3) e hash da senha | Identificar a pessoa e permitir o acesso | `usuarios`, `emails_usuario` |
| Foto (opcional) | Reconhecer os músicos nas escalas | `fotos_perfil` |
| Instrumentos, escalas, presenças e status de escuta | Organizar os eventos | `usuarios_instrumentos`, `secao_musicos`, `colecao_musicos`, `confirmacoes_presenca`, `status_escuta` |
| Identificador do Google (`google_sub`, opcional) | Login com Google | `contas_google` |
| Segredo do app autenticador (criptografado) e códigos de backup (hash) | Segundo fator | `usuarios.totp_segredo`, `codigos_backup_totp` |
| Nome e logo do ministério | Identidade do app (não é dado pessoal) | `configuracoes_app` |
| Inscrição de push | Avisar sobre setlists | `device_tokens` |
| Hash do IP e do e-mail, com a contagem de tentativas | Limite de tentativas | `limites_tentativas` (apagado todo dia) |
| Versão e data do aceite dos termos | Registro do consentimento | `usuarios.termos_versao`, `usuarios.termos_aceitos_em` |

- **Consentimento:** o cadastro só conclui com o aceite dos Termos de Uso e da Política de Privacidade (RN84).
- **Minimização:** o app não pede CPF, telefone, endereço nem data de nascimento.
- **Quem vê o quê:** os e-mails só aparecem para a própria pessoa, e coordenadores não os veem (RN77, RN81). Quem tem acesso total ao banco, por isso essa conta é restrita a quem é de confiança.
- **Eliminação:** a pessoa apaga a própria conta, e seus dados saem (RN83). O histórico de eventos e de cifras permanece sem identificá-la ("Pessoa removida").
- **Retenção:** os dados duram enquanto a conta existir. Convites e códigos vencidos e os contadores de tentativas são apagados todo dia (RN72).
- **Pedidos do titular:** corrigir nome, e-mails, foto e instrumentos e apagar a conta a própria pessoa faz no app. Os demais pedidos (como uma cópia dos dados) vão ao responsável indicado na Política de Privacidade.
- **Operadores:** Vercel (hospedagem), Supabase (banco), Resend (e-mail), Google (login opcional) e os serviços de push dos navegadores. Alguns processam dados fora do Brasil, e a Política informa essa transferência.
- **Incidentes:** identificar e conter, avaliar o risco, trocar os segredos afetados e comunicar a ANPD e as pessoas atingidas nos casos e prazos da regulamentação vigente.
- **Textos jurídicos:** os Termos de Uso e a Política de Privacidade precisam ser escritos e revisados por advogado antes do uso (veja [Deploy](desenvolvimento.md#deploy)).

