Esse programa recebe do teclado os valores M, N e P e resolve a 
multiplicação de matrizes de dimensões (M, N) x (N, P) no simulador MARS (MIPS Assembler and Runtime Simulator) em linguagem Assembly

Para rodar:
Fazer o download do MARS --> https://courses.missouristate.edu/KenVollmar/MARS/download.htm
Na interface do MARS, abrir o arquivo matmul.asm

As matrizes são lidas como um vetor, com entradas do usuário. 
Apenas valores inteiros (positivos ou negativos) admitidos como entrada

Por exemplo, 
 | 0 | 1 | 2 |
 | 3 | 4 | 5 |   = [0, 1, 2, 3, 4, 5, 6, 7, 8]
 | 6 | 7 | 8 |
 
O elemento A[i][j] é lido como A [Ncols * i + j]