# Logo e ícones do MusicaliAPP

Logo padrão do app (cada ministério pode enviar a própria logo, que aparece no lugar desta: RN105). Paleta em [docs/design.md](../../docs/design.md).

## Arquivos

| Arquivo | Uso |
| --- | --- |
| `simbolo-escuro.svg` | Símbolo (folha de setlist com a nota), com as cores da paleta e fundo `#081428`. Gerado no Recraft (conceito 8) e recolorido. |
| `logotipo-azul.svg` | Logotipo horizontal: símbolo e nome, para o topo do app, o login e os e-mails. |
| `nome.svg` | Só o nome "MusicaliAPP", sem o símbolo. |
| `icones/icon-192.png`, `icones/icon-512.png` | Ícones do PWA (`purpose: "any"`), com cantos arredondados. |
| `icones/icon-maskable-192.png`, `icones/icon-maskable-512.png` | Ícones do PWA (`purpose: "maskable"`), com o símbolo dentro da área segura do Android. |
| `icones/apple-touch-icon.png` | Ícone da tela inicial do iPhone e do iPad (180 px). |
| `icones/favicon.svg`, `icones/favicon.ico`, `icones/favicon-16.png`, `icones/favicon-32.png` | Ícone da aba do navegador. O `favicon.svg` troca sozinho entre a versão escura e a clara, conforme o tema do sistema. |
| `icones/*-claro.png` | Versões para fundo claro: fundo névoa `#eef6f8`, borda azul `#0b4ea2` no ícone e na folha e borda preta na nota. Nos ícones `maskable` e da Apple não há borda externa, porque o sistema recorta esses ícones e a borda seria cortada. Servem para materiais e páginas com fundo branco; o manifesto do PWA continua com os escuros. |
| `conceitos/` | Conceitos gerados no Recraft, guardados como referência. |

## Scripts

Rodados nesta pasta, com Node 20 ou mais. Não precisam de pacotes do npm.

- `node logotipo.js`: refaz `logotipo-azul.svg` e `nome.svg` (cores, espaçamento, selo do APP).
- `node icones.js`: refaz a pasta `icones/` a partir do `simbolo-escuro.svg`. Usa o Chrome ou o Edge instalado, em modo headless, para gerar os PNGs.

## Como ligar ao app

Quando o projeto Next existir, copie a pasta `icones/` para `public/icones/` e:

- no `app/layout.tsx`, declare `icons: { icon: [{ url: '/icones/favicon.svg', type: 'image/svg+xml' }, { url: '/icones/favicon.ico' }], apple: '/icones/apple-touch-icon.png' }` nos `metadata`;
- no manifesto (`app/manifest.ts`), use `background_color` e `theme_color` `#081428` e os ícones:

```ts
icons: [
  { src: '/icones/icon-192.png', sizes: '192x192', type: 'image/png', purpose: 'any' },
  { src: '/icones/icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'any' },
  { src: '/icones/icon-maskable-192.png', sizes: '192x192', type: 'image/png', purpose: 'maskable' },
  { src: '/icones/icon-maskable-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
],
```

Se o ministério enviar a própria logo, o manifesto passa a usar `/api/ministerio/logo?tamanho=192|512` (RN105).
