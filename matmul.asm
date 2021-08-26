
# ======================================
# Esse programa recebe do teclado os valores M, N e P e resolve a 
# multiplicação de matrizes de dimensões (M, N) x (N, P)
# 
# As matrizes são lidas como um vetor, com entradas do usuário. 
# Apenas valores inteiros (positivos ou negativos) admitidos como entrada
# Por exemplo, a matriz
# | 0 | 1 | 2 |
# | 3 | 4 | 5 |   = [0, 1, 2, 3, 4, 5, 6, 7, 8]
# | 6 | 7 | 8 |
# 
# O elemento A[i][j] é lido como A [Ncols * i + j]
# ======================================


################################################
# SEÇÃO DATA PARA ENTRADA DE VARIÁVEIS GLOBAIS #
################################################

.data

#Leitura das dimensões das matrizes. 
#O usuário só entrará com linhas e colunas de A e colunas de B para que não haja problemas com a  
#condição de existência da multiplicação

dimension_M: .asciiz "Insira o numero de linhas da matriz A: "
dimension_N: .asciiz "Insira o numero de colunas da matriz A: "
dimension_P: .asciiz "Insira o numero de colunas da matriz B: "

#Textos para usar em prints
matA_input_text: .asciiz "Insira os elementos da matriz A:\n"
matB_input_text: .asciiz "Insira os elementos da matriz B:\n"

matA_output_text: .asciiz "Matriz A:\n"
matB_output_text: .asciiz "Matriz B:\n"

show_result: .asciiz "Matriz resultado da multiplicação:\n"

space: .asciiz " "
newline: .asciiz "\n"

##############################
#  SEÇÃO TEXT PARA O CÓDIGO  #
##############################
.text
.globl main
main:

# Ler a dimensão M do teclado (numero de linhas da matriz A)
	li $v0, 4 #impressão do texto dimension_M
	la $a0, dimension_M
	syscall

	li $v0, 5 #ler um inteiro do teclado
	syscall
	addu $s0, $zero, $v0		# armazenar M em $s0 ($s0 = M)

# Ler dimensão N do teclado (número de linhas da matriz A = número de colunas matriz B)
	li $v0, 4
	la $a0, dimension_N
	syscall

	li $v0, 5 #ler um inteiro
	syscall
	addu $s1, $zero, $v0		# armazenas N em $s1 ($s1 = N)

# Ler dimensão P do teclado (número de colunas da matriz B)
	li $v0, 4
	la $a0, dimension_P
	syscall

	li $v0, 5 #ler um inteiro
	syscall
	addu $s2, $zero, $v0		# armazenas P em $s2($s2 = P)

# Declaração da matriz A em $s3
	mul $a0, $s0, $s1 #tamanho M x N
	mul $a0, $a0, 4 #para alocar o tamanho correto do vetor, precisamos multiplicar por 4 pois uma palavra tem 4 bytes
	li $v0, 9 #vetor A é alocado dinamicamente em $v0
	syscall
	addu $s3, $zero, $v0 #salvamos o vetor no registrador $s3
	
# Declaração da matriz B em $s4
	mul $a0, $s1, $s2 #tamanho N x P
	mul $a0, $a0, 4
	li $v0, 9
	syscall
	addu $s4, $zero, $v0
	
# Declaração da matriz resultado em $s5
	mul $a0, $s0, $s2 #tamanho M x P
	mul $a0, $a0, 4
	li $v0, 9
	syscall
	addu $s5, $zero, $v0

# $s6 = M x N - aqui armazenamos o tamanho do vetor de matA (quantidade de elementos para receber os valores 
#por entrada do usuário
	mul $s6, $s0, $s1

#$s7 = N x P - quantidade de elementos da matB
	mul $s7, $s1, $s2
	
# Recebendo os inouts da Matriz A
	li $v0, 4
	la $a0, matA_input_text #impressão do texto
	syscall
	
	add $t1, $zero, $zero		# iterador = 0
	move $t2, $s3			# ponteiro para percorrer o vetor
loop1:
	slt $t0, $t1, $s6  #if (t1<s4) 1; else 0 -- while iterador < vector.lenght
	beq $t0, $zero, exit1 #condição de saída do loop - se condição for verdadeira, vai a exit
	
	li $v0, 5 #ler um inteiro do teclado e armazenar em $v0
	syscall
	sw $v0, 0($t2) #escreve o valor de $v0 na posição 0 + $t2 do vetor apontado por $t2
	
	addiu $t1, $t1, 1 #atualiza o iterador
	addiu $t2, $t2, 4 #atualiza a posição do ponteiro - 4 por causa do tamanho da palavra
	
	j loop1
exit1:

# Recebendo os inouts da Matriz B
	li $v0, 4
	la $a0, matB_input_text
	syscall

	add $t1, $zero, $zero		# iterador = 0
	move $t2, $s4			# ponteiro para percorrer o vetor
loop2:
	slt $t0, $t1, $s7 #if (t1<s7) 1; else 0 -- while iterador < vector.lenght
	beq $t0, $zero, exit2 #condição de saída do loop - se condição for verdadeira, vai a exit
	
	li $v0, 5 #ler um inteiro do teclado e armazenar em $v0
	syscall
	sw $v0, 0($t2) #escreve o valor de $v0 na posição 0 + $t2 do vetor apontado por $t2
	
	addiu $t1, $t1, 1 #atualiza o iterador
	addiu $t2, $t2, 4 #atualiza a posição do ponteiro
	
	j loop2 #salto para o inicio do loop (onde irá verificar novamente a condição)
exit2: 

####################################################
# ALGORITMO PRINCIPAL DE MULTIPLICAÇÃO DE MATRIZES #
####################################################


	add $t1, $zero, $zero	#iterador i 
L1: #loop mais externo	- itera linhas da matriz A
	slt $t0, $t1, $s0 #for i in M
	beq $t0, $zero, endL1

	add $t2, $zero, $zero	#iterador j
	L2: #segundo loop - itera colunas da matriz B
		slt $t0, $t2, $s2 #for j in P
		beq $t0, $zero, endL2
		
		mul $t4, $t1, $s2 # as quatro instruções a seguir são para acessar res[i][j] como res[P * i + j]
		addu $t4, $t4, $t2
		mul $t4, $t4, 4 #multiplicar por 4 (tamanho da palavra) - $t4 armazena a posição lida da matriz resultado
		addu $t4, $t4, $s5 #Encontra a posição res
		
		add $t3, $zero, $zero #iterador k
		L3: #terceiro loop - itera dentro da dimensão N 
			slt $t0, $t3, $s1 #for k in N
			beq $t0, $zero, endL3
			
			mul $t5, $t1, $s1	#acessar matA[i][k]
			addu $t5, $t5, $t3
			mul $t5, $t5, 4
			addu $t5, $t5, $s3 #Encontra posição matA
			
			mul $t6, $t3, $s2	#acessar matB[k][j]
			addu $t6, $t6, $t2
			mul $t6, $t6, 4
			addu $t6, $t6, $s4 #Encontra matB
			
			lw $t7, 0($t5)			# carrega matA[i][k] em $t7
			lw $t8, 0($t6)			# carrega matB[k][j] em $t8
			
			mul $t9, $t7, $t8		# $t9 = matA[i][k] * matB[k][j]
			
			lw $t8, 0($t4) #matriz resultado posição $t4
			addu $t9, $t9, $t8  #resultado += matA[i][k] * matB[k][j] em res[$t8]
			
			sw $t9, 0($t4) #escreve na matriz resultado o valor obtido na soma anterior ($t9)	
		
			addiu $t3, $t3, 1 #atualiza iterador k
			j L3
		endL3:
		
		addiu $t2, $t2, 1	#atualiza iterador j
		j L2
	endL2:

	addiu $t1, $t1, 1 #atualiza iterador i
	j L1
endL1:

# Print matrix A
	li $v0, 4
	la $a0, matA_output_text
	syscall

	move $a1, $s3 #arg1 - matrix
	move $a2, $s0 #arg2 - nlinhas
	move $a3, $s1 #arg3 - ncols
	jal printMatrix

# Print matrix B
	li $v0, 4
	la $a0, matB_output_text
	syscall
	
	move $a1, $s4 #arg1 - matrix
	move $a2, $s1 #arg2 - nlinhas
	move $a3, $s2 #arg3 - ncols
	jal printMatrix
	
# Print resultant matrix
	li $v0, 4
	la $a0, show_result
	syscall
	
	move $a1, $s5 #arg3 - matrix
	move $a2, $s0 #arg2 - nlinhas
	move $a3, $s2 #arg3 - ncols
	jal printMatrix

# Terminate program
EXIT: 
	li $v0,10
	syscall

########## FIM DO PROGRAMA ########

# Impressão dos resultados obtidos
printMatrix:
	add $t1, $zero, $zero	#iterador de linha
	print1:	
		slt $t0, $t1, $a2
		beq $t0, $zero, end_print1
		addiu $t1, $t1, 1
	
		add $t2, $zero, $zero	#iterador de coluna
		print2:
			slt $t0, $t2, $a3
			beq $t0, $zero, end_print2
			addiu $t2, $t2, 1
		
			li $v0, 1
			lw $a0, 0($a1)
			syscall
			
			addiu $a1, $a1, 4		# incrementar ponteiro
			
			li $v0, 4
			la $a0, space
			syscall
			
			j print2		
		end_print2:
	
		li $v0, 4
		la $a0, newline
		syscall
	
		j print1
	end_print1:
	jr $ra
