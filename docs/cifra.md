# Cifra, graus e tons

## Cifra, graus e tons

A cifra é guardada **em graus do campo harmônico**, no estilo do Nashville Number System, com os algarismos de 1 a 7, e o app a mostra em letras, em qualquer tom. Quem escreve em graus pode digitar em algarismos ou em romanos (RN97), e a tela mostra como a pessoa configurou. A escrita dos acordes segue **um só padrão**, descrito nesta seção. O app grava sempre esse padrão. Ao digitar, aceita também algumas variações de escrita, listadas em RN95, e converte tudo para o padrão antes de gravar.

### Padrão de escrita

O grau toma o lugar da letra da nota, e o resto do acorde segue as regras de sufixo, alteração e baixo desta seção.

| Em letras (padrão) | Em graus | Significado |
|---|---|---|
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
3. **As regras que mais confundem:** `9` é nona adicionada e a nona dominante é `7(9)`; `b` e `#` valem na raiz e no baixo, e a raiz com acidente tem prioridade (`Cb9` é Dó bemol com nona; para a nona bemol, escreva `C7(b9)`); dentro dos parênteses o padrão é `+` e `-`, e `b` e `#` também são aceitos ao digitar, mas o app grava `+` e `-`; a sétima maior é gravada como `7M`, e `maj7` e `M7` também são aceitos.
   - A página mostra uma tabela de equivalências: `C7(b9)` e `C7(-9)` viram `C7(9-)`; `C7(#5)` e `C7(+5)` viram `C7(5+)`.
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
|---|---|---|
| `C` | `1` | Maior, sobre o primeiro grau. |
| `Dm`, `Em`, `Am` | `2m`, `3m`, `6m` | Menor. |
| `Eb`, `Bb`, `F#` | `3b`, `7b`, `4#` | Grau alterado: o `b` ou o `#` vem depois do grau. |
| `Cm` em tom menor | `1m` | Em tom menor, o grau 1 é a tônica. |

##### Sétimas

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C7` | `17` | Dominante: maior com sétima menor. |
| `C7M` | `17M` | Sétima maior. |
| `Cm7` | `1m7` | Menor com sétima. |

##### Sextas e nonas

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C6` | `16` | Sexta. |
| `C6(9)` | `16(9)` | Sexta com nona. |
| `C9` | `19` | Nona adicionada (`add9`), **sem sétima**. |
| `C7(9)` | `17(9)` | Nona dominante, **com sétima**. |
| `C7M(9)` | `17M(9)` | Nona com sétima maior. |

Atenção: no padrão do app, `C9` é nona adicionada. A nona dominante é sempre `C7(9)`. Em algumas bibliotecas americanas, `C9` quer dizer nona dominante. Aqui não.

##### Suspensas

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C2` | `12` | Suspensa de segunda (`sus2`). |
| `C4` | `14` | Suspensa de quarta (`sus4`). |
| `C7(4)` | `17(4)` | Suspensa de quarta com sétima. |

##### Quarta adicionada

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C11` | `111` | Quarta adicionada (`add4`), **sem sétima**. |

Atenção: aqui `C11` quer dizer quarta adicionada, não a undécima dominante. Se o acorde tiver sétima, use `C7(11)`.

##### Alterações (dentro dos parênteses)

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C7(9-)` | `17(9-)` | Nona bemol. |
| `C7(9+)` | `17(9+)` | Nona sustenido. |
| `C7(5+)` | `17(5+)` | Quinta aumentada. |
| `C7(5-)` | `17(5-)` | Quinta diminuta. |
| `C7(9-/11+/13-)` | `17(9-/11+/13-)` | Várias alterações, em ordem crescente, separadas por `/`. |

Dentro dos parênteses, o número vem **antes** do sinal, e o sinal é `+` (aumentado) ou `-` (diminuto ou bemol). Você também pode digitar `b` e `#` ali (Variações que você pode digitar).

##### Aumentado, diminuto e meio-diminuto

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C5+` | `15+` | Tríade aumentada. |
| `Cm5-` | `1m5-` | Tríade diminuta. |
| `Cº` | `1º` | Sétima diminuta (quatro notas). |
| `Cm7(5-)` | `1m7(5-)` | Meio-diminuto (sétima menor com quinta diminuta). |

Para a tríade, escreva sempre `5+` ou `m5-`. Para a sétima diminuta, use `º`.

##### Baixo

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C/E` | `1/3` | Baixo na terça. |
| `Am7/G` | `6m7/5` | Baixo no quinto grau, em tom de C. |
| `Dm6/B` | `2m6/7` | Baixo no sétimo grau, em tom de C. |
| `D9/C#` | `19/7` | Em tom de D, o `C#` é o sétimo grau. |

Obs.: o baixo também é escrito em grau. O acidente vem depois do grau, como no acorde.

#### Variações que você pode digitar

Ao digitar, o app aceita estas variações e converte para o padrão. A coluna da direita é o que fica gravado e o que aparece na tela.

##### Alterações entre parênteses

| Você digita | Gravado | Observação |
|---|---|---|
| `C7(b9)` | `C7(9-)` | `b` no lugar de `-`. |
| `C7(-9)` | `C7(9-)` | Padrão. |
| `C7(9b)` | `C7(9-)` | Sinal depois do número, como o padrão. |
| `C7(#5)` | `C7(5+)` | `#` no lugar de `+`. |
| `C7(+5)` | `C7(5+)` | Padrão. |
| `C7(b9,#11,b13)` | `C7(9-/11+/13-)` | Vírgula ou espaço viram `/`. Misturar `b` e `-` na mesma extensão também funciona. |

##### Sétimas, sus e add

| Você digita | Gravado |
|---|---|
| `Cmaj7`, `CM7`, `CΔ`, `C^7` | `C7M` |
| `Cmaj9` | `C7M(9)` |
| `Csus`, `Csus4` | `C4` |
| `Csus2` | `C2` |
| `C7sus4` | `C7(4)` |
| `Cadd9`, `Cadd2` | `C9` |
| `Cadd4` | `C11` |

##### Menor, sétima diminuta e meio-diminuto

| Você digita | Gravado |
|---|---|
| `C-7`, `Cmin7` | `Cm7` |
| `Cº`, `C°` | `Cº` |
| `Cm7b5`, `Cø` | `Cm7(5-)` |

##### Outros

| Você digita | Gravado |
|---|---|
| `C+` | `C5+` |
| `C6/9`, `C69` | `C6(9)` |
| `C13` | `C7(13)` |

##### Formas que não são aceitas

Estas formas não são aceitas, porque não dizem se o acorde é tríade ou sétima. Use a forma da coluna da direita.

| Não use | Use | Motivo |
|---|---|---|
| `Cdim`, `Cdim7` | `Cm5-` (tríade) ou `Cº` (sétima) | `dim` não diz qual dos dois é. |
| `Caug` | `C5+` | `aug` não diz se é tríade. Use `5+`. |
| `dim`, `dim7`, `aug` sozinhos | a forma com a raiz, como acima | Sem raiz, não há acorde. |

##### Graus em romanos

Quem escreve em graus pode digitar em algarismos ou em romanos. Na configuração de visualização e no campo de escrita, o botão **Números** ou **Romanos** escolhe a forma. O que fica gravado é sempre em algarismos.

| Em romanos (digitado ou mostrado) | Em algarismos (gravado) | Observação |
|---|---|---|
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

**Como escrevo uma nona bemol?** Dentro dos parênteses: `C7(b9)` ou `C7(9-)`. `Cb9` é Dó bemol com nona, porque a raiz com acidente tem prioridade.

**Posso usar uma cifra de outro site?** Sim. Copie o texto, cole no editor e escolha o tom da escrita: as letras são convertidas para graus, e o app avisa o que não reconhecer, para você corrigir na hora.

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

