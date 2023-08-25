# Conversor Python para JavaScript

## Sobre o Projeto
O objetivo do  trabalho é permitir a conversão de códigos básicos escritos em Python para código equivalente em JavaScript.
O analisador lexa atua como uma ponte entre essas duas linguagens, possibilitando que programas escritos em Python possam ser executados em ambientes que suportam JavaScript, como navegadores da web ou servidores Node.js.
Ele visa permitir que desenvolvedores aproveitem a lógica de seus programas Python em ambientes onde apenas JavaScript é viável.

## Como Usar
### Online
Existem duas maneiras de utilizar o analisador lexa, uma online e outra offline.

###Versão disponibilizada online: 
Na primeira requisição, pode levar um pouco mais de tempo devido ao servidor, mas aguarde que o sistema irá funcionar.
Acesse o [Conversor Online](https://conversor-codigo.onrender.com/). Aguarde o carregamento inicial.

### Offline
1. Baixe os arquivos "lexer.l","arquivo.y" e “arquivo.print”
2. Utilize o arquivo "arquivo.print" para inserir o código que você deseja converter.
3. É importante que não haja uma linha em branco no início do arquivo "arquivo.print". Comece a escrever o código a partir do início.
4. Também observe que deve haver uma linha em branco no final do código, caso contrário, a última linha pode não ser reconhecida corretamente.
5. Instale o Bison (Yacc) e o Flex (Lex) no seu sistema.
6. Execute no Linux:
   ```sh
   flex lexer.l
   bison -d arquivo.y
   gcc lex.yy.c arquivo.tab.c -o parser
   ./parser arquivo.print
  
7. No Windows:
   ```sh
   flex lexer.l
   bison -d arquivo.y
   gcc -o parser arquivo.tab.c
   parser.exe arquivo.print 

##Exemplos entrada e saidas:

1. Entrada A (exemplo.print):
   ```sh
   print("x")
   print(34456567)
   print(10)
   x = 'oiii'
   numero = 10

2. Saída A (gerada em JavaScript):
   ```sh
   console.log("x");
   console.log(34456567);
   console.log(10);
   let x = 'oiii';
   let numero = 10;

3. Entrada B (exemplo.print):
   ```sh
   if numero > 0
       print("O numero e positivo.")
   elif numero < 0
    print("O numero e negativo.")
   else
    print("O numero e zero.")  

4. Saída B (gerada em JavaScript):
   ```sh
   if (numero > 0) {
   console.log("O numero e positivo.");
   } else if (numero < 0) {
   console.log("O numero e negativo.");
   } else {
   console.log("O numero e zero.");

5. Entrada C (exemplo.print):
   ```sh
   contador = 0
   while contador < 7:
    print(contador)
    contador += 1

6. Saída C (gerada em JavaScript):
   ```sh
   let contador = 0;
   while (contador < 7) {
   console.log(contador);
   contador++;
   
7. Entrada D (exemplo.print):
   ```sh
   contador = 0
   while contador <= 7:
    print(contador)
    contador += 1
8. Saída D (gerada em JavaScript):
   ```sh
   let contador = 0;
   while (contador <= 7) {
   console.log(contador);
   contador++;
   }
9. Entrada E (exemplo.print):
    ```sh
    def uma(x):
    numero = x
    return numero

    x = 5

    conta = uma(x)
    print(conta)
    
10. Saída E (gerada em JavaScript):
    ```sh
    function uma(x);
    let numero = x;
    return numero;
    }
    let x = 5;
    let conta = uma(x)
    console.log(conta);

11. Entrada F (exemplo.print):
    ```sh
    def comduas(x, r):
    soma = x + r
    return soma

    x = 5
    r = 6
    conta = comduas(x, r)
    print(conta)
    
12. Saída F (gerada em JavaScript):
    ```sh
    function comduas(x,r){
    let soma = x + r;
    return soma;
    }
    let x = 5;
    let r = 6;
    let conta = comduas(x,r)
    console.log(conta)

##Limitações em Relação à Linguagem Original

Limitações Sintáticas e Semânticas: O analisador lexa se baseia nas regras definidas na gramática e nos tokens reconhecidos pelo lexer. Portanto, ele pode não lidar adequadamente com construções não previstas na gramática ou com uso incorreto dos tokens.
Tratamento de Erros: A maneira como erros são tratados no código não é completa. Erros podem ser mal reportados ou não tratados corretamente.
Limitações na Sintaxe: A sintaxe da linguagem customizada parece ser uma mistura de Python e JavaScript. Isso pode levar a situações em que a semântica original é preservada, mas a sintaxe resultante em JavaScript não é sempre a mais idiomática.

##Conclusão
O Conversor Python para JavaScript é útil para traduzir pequenos trechos de código Python para JavaScript. Esteja ciente das limitações e faça testes antes de usá-lo em projetos maiores.
