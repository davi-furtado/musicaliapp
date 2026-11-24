# Design, tema e responsividade

A paleta vem do site da Comunidade de Aliança Trindade Santa (`DESIGN.md` do projeto `trindade-santa`): **azul domina, amarelo chama, os demais acentuam**. Aqui ela vira o tema do **Material UI** (MUI), que é a única camada de componentes e de estilo do app (veja [Arquitetura](arquitetura.md)). Só a paleta foi importada: tipografia, símbolos e layouts do site da comunidade não fazem parte deste app.

## Paleta

### Base (do logo da comunidade)

| Token | Hex | Uso no app |
| --- | --- | --- |
| `azul-profundo` | `#0b4ea2` | Cor primária: botões principais, links, barra de topo |
| `azul-celeste` | `#1b95d8` | Detalhes e ícones grandes. **Não serve como texto pequeno** (3,3:1 sobre branco) |
| `celeste-texto` | `#0a6aa6` | O celeste quando vira texto (5,8:1 sobre branco) |
| `azul-mar` | `#2489ae` | Fim de degradês e realces |
| `turquesa` | `#4fa6c0` | Meio de degradês |
| `bruma` | `#bcdde3` | Início de degradês |
| `nevoa` | `#eef6f8` | Fundo das telas |
| `tinta` | `#0a2a4a` | Texto principal (14,5:1 sobre branco) |
| `tinta-suave` | `#4a6580` | Texto secundário (6,1:1 sobre branco, 5,5:1 sobre a névoa) |
| `linha` | `#d6e6ee` | Bordas e divisores |

Degradês: `bruma → turquesa → azul-mar` a 35° (fundos de destaque) e `azul-profundo → azul-mar` a 135° (cabeçalho do dashboard).

### Identidade atual (banner "Vocacional TS")

| Token | Hex | Uso no app |
| --- | --- | --- |
| `ts-azul` | `#2a6fc9` | Primária no modo escuro e telas azuis cheias (login, primeiro acesso) |
| `ts-noite` | `#071937` | Texto sobre amarelo e fundo mais escuro |
| `ts-amarelo` | `#ffd83a` | Botão de destaque, seleção de texto e anel de foco |
| `ts-laranja` | `#f2672a` | Aviso e revisão (texto `tinta` por cima, 4,7:1; branco não passa) |
| `ts-rosa` | `#e07bc9` | Acento (texto `ts-noite` por cima) |
| `ts-roxo` | `#7c55c7` | Acento (texto branco por cima, 5,3:1) |
| `ts-verde` | `#7cc143` | Acento (texto `tinta` por cima; branco não passa) |
| `ts-lilas` | `#b9a3ea` | Acento |
| `ts-papel` | `#f6f3ee` | Fundo "papel" da tela da cifra |

Regra de uso: no máximo **dois acentos vivos por tela**, e o amarelo só para a ação de destaque e para o foco.

### Cores semânticas (derivadas, a validar com o ministério)

A paleta da comunidade não tem vermelho nem um verde escuro. Estas duas foram acrescentadas para passar o contraste AA com texto branco:

| Papel | Hex | Contraste com branco |
| --- | --- | --- |
| `error` | `#b3261e` | 6,5:1 |
| `success` | `#2e7d32` | 5,1:1 |

### Modo escuro

| Token | Hex | Uso |
| --- | --- | --- |
| Fundo | `#081428` | `background.default` |
| Superfície | `#0e2040` | Cartões, diálogos e menus (`background.paper`) |
| Superfície elevada | `#132a52` | Cabeçalhos de tabela, itens selecionados |
| Linha | `#2a4570` | Bordas e divisores |
| Texto | `#e9f1fc` | 16,2:1 sobre o fundo |
| Texto suave | `#adc0da` | 9,9:1 sobre o fundo |
| Primária (botão) | `#2a6fc9` | Texto branco por cima, 5,0:1 |
| Primária (texto e link) | `#9cc9ff` | 10,7:1 sobre o fundo |
| Celeste (detalhes) | `#5cc0ff` | Ícones e realces |

O anel de foco continua amarelo (`#ffd83a`, 13,3:1 sobre o fundo escuro).

## Tema no MUI

O tema fica em `src/tema/` e tem dois esquemas de cor (`light` e `dark`) com variáveis CSS, escolhidos pela preferência da pessoa (RF75: claro, escuro ou automático). O esquema vai no atributo `data-tema` do `<html>` e é aplicado antes da primeira pintura (`InitColorSchemeScript`), sem piscar.

```ts
// src/tema/tema.ts (esboço)
import { createTheme } from '@mui/material/styles';

export const tema = createTheme({
  cssVariables: { colorSchemeSelector: 'data-tema' },
  colorSchemes: {
    light: {
      palette: {
        primary: { main: '#0b4ea2', contrastText: '#ffffff' },
        secondary: { main: '#0a6aa6', contrastText: '#ffffff' },
        error: { main: '#b3261e' },
        warning: { main: '#f2672a', contrastText: '#0a2a4a' },
        success: { main: '#2e7d32' },
        background: { default: '#eef6f8', paper: '#ffffff' },
        text: { primary: '#0a2a4a', secondary: '#4a6580' },
        divider: '#d6e6ee',
      },
    },
    dark: {
      palette: {
        primary: { main: '#2a6fc9', contrastText: '#ffffff' },
        secondary: { main: '#5cc0ff', contrastText: '#071937' },
        background: { default: '#081428', paper: '#0e2040' },
        text: { primary: '#e9f1fc', secondary: '#adc0da' },
        divider: '#2a4570',
      },
    },
  },
  shape: { borderRadius: 10 },
  components: {
    MuiCssBaseline: {
      styleOverrides: { '::selection': { background: '#ffd83a', color: '#071937' } },
    },
    MuiButtonBase: {
      styleOverrides: {
        root: {
          '&.Mui-focusVisible': { outline: '3px solid #ffd83a', boxShadow: '0 0 0 5px #0a2a4a' },
        },
      },
    },
  },
});
```

- A cor de **destaque** (`ts-amarelo`) é uma variante `destaque` do `Button`, usada uma vez por tela, sempre com texto `ts-noite`.
- Os componentes usam sempre `theme.palette` e as variáveis CSS do tema, nunca um hex solto no código. Uma cor nova entra primeiro neste documento.
- `ts-papel` (`#f6f3ee`) é o fundo da leitura da cifra no modo claro. No escuro, vale o fundo `#081428`.
- As fontes são servidas pelo próprio app (`next/font`), sem consultar o Google em tempo de execução (veja a [Política de Cookies](legal/politica-de-cookies.md)).

## Responsividade

O app é **para celular e para computador**, com o mesmo código (RNF23). Desenha-se primeiro para o celular (375 px) e se amplia.

### Pontos de quebra (os do MUI)

| Nome | A partir de | Dispositivo típico |
| --- | --- | --- |
| `xs` | 0 | Celular |
| `sm` | 600 px | Celular grande, tablet em pé |
| `md` | 900 px | Tablet deitado, computador pequeno |
| `lg` | 1200 px | Computador |
| `xl` | 1536 px | Tela grande |

O conteúdo tem largura máxima de **1200 px**, centralizado, com margens laterais de `clamp(16px, 4vw, 40px)`.

### O que muda de um tamanho para outro

| Elemento | Celular (`xs` e `sm`) | Computador (`md` em diante) |
| --- | --- | --- |
| Navegação | Barra inferior com os 4 destinos principais (Início, Músicas, Eventos, Listas) e um botão **Mais** | Menu lateral fixo com todos os destinos |
| Topo | Barra enxuta com o título, a busca (ícone) e a conta | Barra com campo de busca aberto e a conta |
| Listagens | Lista de cartões, um por linha, com a ação principal à vista | Tabela ou grade de 2 a 4 colunas, 30 por página |
| Formulários | Uma coluna, campos de largura total | Duas colunas quando houver espaço |
| Diálogos | Tela cheia, com botão de fechar no topo | Janela centralizada |
| Tela da cifra | Coluna única, controles (tom, fonte, letra, reduzido, rolagem) numa barra fixa embaixo | Cifra à esquerda e painel de controles à direita |
| Setlist e escala | Seções recolhíveis; reordenar pela alça, com toque longo | Seções lado a lado quando couber; arrastar com o mouse |
| Dashboard | Cartões empilhados | Grade de 2 a 3 colunas |
| Exportação e compartilhar | Menu de compartilhamento do aparelho (RF54) | Salvar o arquivo e copiar o link |

### Regras

1. **Sem rolagem horizontal** em nenhuma tela, de 320 px a 1920 px. A cifra quebra a linha de acordes de forma controlada (ou rola só o bloco da cifra, nunca a página).
2. **Alvos de toque** de pelo menos 44 × 44 px (`size="large"` nos botões de ícone no celular).
3. **Teclado e foco** sempre visíveis, com o anel amarelo do tema (WCAG 2.1 AA, RNF18).
4. **Altura da tela:** use `dvh`, não `vh`, para a barra do navegador do celular não cobrir botões. Respeite as áreas seguras do aparelho (`env(safe-area-inset-bottom)`) na barra inferior.
5. **Texto em `rem`**, para respeitar o tamanho de fonte do sistema. O tamanho da cifra é uma preferência (RN91) e continua escalável.
6. **Arrastar e soltar** funciona com toque (`TouchSensor` do dnd-kit, com atraso curto) e com mouse e teclado, e a rolagem da página não é bloqueada.
7. **Imagens e logo** com `width` e `height` definidos, para a página não pular ao carregar. A logo do ministério tem altura máxima de 40 px no topo do celular e de 56 px no computador.
8. **Movimento:** animações respeitam `prefers-reduced-motion`.
9. **PWA instalado:** o app abre em tela cheia (`display: standalone`), no modo retrato e no deitado.

### Como testar

- Playwright roda os fluxos principais em **375 × 812** (celular) e em **1280 × 800** (computador), e o critério de pronto exige os dois (veja [Qualidade e testes](desenvolvimento.md#qualidade-e-testes)).
- Um teste confere que nenhuma tela principal tem rolagem horizontal nesses dois tamanhos.
- A revisão visual inclui o modo escuro e o tamanho de fonte maior do sistema.
