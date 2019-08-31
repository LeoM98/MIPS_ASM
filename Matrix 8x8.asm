#Suma de Matrices
#Impresión del resultado
#Resultado de la diagonal de la matriz resultante
#Matriz resultante en forma de fila y columna mayor


.data
MatrizA:   	.word 11, 12, 13, 14, 15, 35, 56, 23
		.word 16, 17, 18, 19, 20, 30, 23, 12
		.word 21, 22, 23, 24, 25, 25, 34, 12
		.word 26, 27, 28, 29, 30, 20, 34, 17	#Matriz de ejemplo en el libro (MIPStextSMv11.pdf)
		.word 31, 32, 33, 34, 35, 15, 18, 9
		.word 11, 17, 23, 29, 35, 15, 10, 12
		.word 14, 12, 34, 35, 11, 10, 29, 30
		.word 12, 13, 14, 15, 16, 17, 18, 19

MatrizB:   	.word 23, 43, 54, 67, 56, 5, 13, 33
                .word 11, 56, 23, 1, 4, 4, 56, 45
                .word 67, 23, 0, 44, 35, 45, 43, 23
                .word 5, 11, 23, 86, 30, 67, 22, 12 	#Matriz Al azar
                .word 31, 22, 21, 35, 43, 34, 32, 34
                .word 3, 78, 55, 23, 1, 21, 32, 21, 67
                .word 7, 8, 23, 45, 34, 45, 23, 67, 54
                .word 12, 3, 80, 67, 23, 56, 45, 12, 9

Resultante: 
                .word 0, 0, 0, 0, 0, 0, 0, 0
                .word 0, 0, 0, 0, 0, 0, 0, 0 
                .word 0, 0, 0, 0, 0, 0, 0, 0 
                .word 0, 0, 0, 0, 0, 0, 0, 0 		#Matriz en 0 ( resultante )
                .word 0, 0, 0, 0, 0, 0, 0, 0 
                .word 0, 0, 0, 0, 0, 0, 0, 0 
                .word 0, 0, 0, 0, 0, 0, 0, 0 
                .word 0, 0, 0, 0, 0, 0, 0, 0 
           
size:           .word 8        #Tamaño de las Matrices
dSum:  .word 0

t: .asciiz "\t"
n: .asciiz "\n"
.eqv DATA_SIZE 4                             # 4 bytes for words

FilaMayor:  .asciiz "\n\t|**********Fila Mayor**********|\n"
ColumMa:    .asciiz "\n\t|**********Columna Mayor**********|\n"
matrizA:    .asciiz "\n####################|-----------Matriz A----------|####################\n\n"
matrizB:    .asciiz "\n####################|-----------Matriz B----------|####################\n\n"
matrizc:    .asciiz "\n####################|-----------Matriz C----------|####################\n"

finalMsg:   .ascii    "Two-Dimensional Diagonal"
            .ascii    "Sumatoria\n\n"
            .asciiz   "Resultado de la diagonal = "

.text
.globl      main
main:

     la     $a1, MatrizA          # Direccion de la matriz
     lw     $a2, size             # Tamaño de las matrices
     
     li $v0, 4
     la $a0, matrizA	#Impresión del mensaje  Matriz A
     syscall
     
     jal Impresion #Se hace un salto al metodo de impresion de matriz
     
     
     li $v0, 4
     la $a0, matrizB #Impresion del Mensaje de la Matriz B
     syscall
     
     jal Impresion
     
     la $s1, MatrizA
     la $s2, MatrizB #Carga en sus respectivas variables el contenido de sus matrices
     la $s3, Resultante
     
     jal suma #El Jal permite hacer el salto a la funcion que sumara las matrices 
     
     li $v0, 4
     la $a0, matrizc #Muestra en pantalla el mensaje que esta asigando a matriz c
     syscall
     
     li $v0, 4
     la $a0, FilaMayor #Muestra Fila mayor como mensaje 
     syscall
     
     la $a1, Resultante #Se carga la direccion de la resultante (Matriz)
     
     jal Impresion #Salto a la funcion 
     
     
     li $v0, 4
     la $a0, ColumMa #Impresion de mensaje 
     syscall
     
     jal imprimirc #Salto a funcion col mayor

     jal   diagSummer #Salto a la funcion de suma diagonal
     sw $v0,dSum

#Resultado final en pantalla.
     li $v0, 4  		        # print prompt string
     la $a0, finalMsg
     
     syscall
     li $v0, 1 		#Impresion del entero
     lw $a0, dSum
     syscall
     

# Se llama a la funcion para finalizar.

     li $v0, 10    	       # call code for terminate
     syscall 		       # system call
.end main #Finaliza

# Función simple para sumar las diagonales de un
# matriz bidimensional cuadrada.

# Nota, para matriz bidimensional:
# addr = baseAddr + (rowIndex * colSize + colIndex) * dataSize

# Arguments
#     $a0 - direcciión base del arreglo
#     $a1 - size (cuadrado, arreglo bidmiensional)

# Retorna la suma de la diagonal

.globl     diagSummer
.ent diagSummer
diagSummer:

       li   $v0, 0                         # sum=0
       li   $t1, 0                          # indice de bucle, i=0
       
diagSumLoop:
       mul  $t3, $t1, $a2             # (rowIndex * colSize
       add  $t3, $t3, $t1              #              + colIndex)
                                                # note, rowIndex=colIndex
       mul $t3, $t3, DATA_SIZE   #              * dataSize
       add $t4, $a1, $t3              # + base address
       
       lw  $t5, ($t4)                    # get mdArray[i][i]
       add $v0, $v0, $t5            # sum = sum+mdArray[i][i]
       addi $t1, $t1, 1                # i = i + 1
       blt $t1, $a2, diagSumLoop	#Saltar si es menor 

# Retorna el primer valor y vuelve.
            jr  $ra
.end diagSummer

#Impresion de filas
.globl Impresion
.ent Impresion

Impresion:
	li $t1, 0    #indice i
Impresion1:
         li $t2, 0    #indice j
Impresion2:
	mul  $t3, $t1, $a2               # (rowIndex * colSize
       	add  $t3, $t3, $t2                #              + colIndex)
                                                     # note, rowIndex=colIndex
       	mul $t3, $t3, DATA_SIZE    #              *dataSize
        add $t4, $a1, $t3 	           #base address
         
        lw $t5, ($t4)                         #accede a M[i][j] (La direccionde t4 pasa a t5) posicion del vector 
         
        li $v0, 1 	#Carga para imprimir un entero la matriz (construccion)
        add $a0, $0, $t5
        syscall
         
        li $v0, 4
        la $a0, t  		            #deja el espacio
        syscall
         
        addi $t2, $t2, 1	               #j++
        blt $t2, $a2, Impresion2
         
        li $v0, 4	#Termino la linea y hace un salto hacia abajo
        la $a0, n
        syscall
         
        addi $t1, $t1, 1	               #i++
        blt $t1, $a2, Impresion1
         
         jr $ra
         
.end Impresion

#Impresion de columnas
.globl imprimirc
.ent imprimirc
imprimirc:
	li $t1, 0 #indice i
imprimirc1:
	li $t2, 0 #indice j
imprimirc2:
	mul $t3, $t2, $a2 # (rowIndex * colSize
	add $t3, $t3, $t1 	# + colIndex)
				# note, rowIndex=colIndex
	mul $t3, $t3, DATA_SIZE # * dataSize
	add $t4, $a1, $t3 #base address
	lw $t5, ($t4) #accede a M[i][j]
	
	li $v0, 1
	add $a0, $0, $t5
	syscall
	
	li $v0, 4
	la $a0, t #deja el espacio
	syscall
	
	addi $t2, $t2, 1 #j++
	blt $t2, $a2, imprimirc2
	
	li $v0, 4
	la $a0, n
	syscall
	
	addi $t1, $t1, 1 #i++
	blt $t1, $a2, imprimirc1
	jr $ra
.end imprimirc


# SUMA        
.globl suma
.ent suma

suma:  
         li $t1, 0    #indice i
suma1:
         li $t2, 0    #indice j
suma2:
	mul  $t3, $t1, $a2                # (rowIndex * colSize
       	add  $t3, $t3, $t2                 #              + colIndex)
                                                       # note, rowIndex=colIndex
       	mul $t3, $t3, DATA_SIZE     #              * dataSize
         
        add $t4, $s1, $t3                  
        add $t5, $s2, $t3	#Posicion inicial de cada matriz con direccion base
        add $t6, $s3, $t3	#resultante
         
        lw $t4, ($t4)	#Carga en el registro $t4 el contenido del valor  en memoria cuya dirección es t4 
        lw $t5, ($t5)	#Carga en el registro $t5 el contenido del valor  en memoria cuya dirección es t5 
        add $t7, $t4, $t5 #Se hace la suma de los dos
        
        sw $t7, ($t6) #Guarda la suma de las posiciones de ambas matrices y las guarda en la matriz resultante
         
        addi $t2, $t2, 1	              #j++
        blt $t2, $a2, suma2	#salta si es menor que el tamaño de la fila
        
        addi $t1, $t1, 1	              #i++
        blt $t1, $a2, suma1	 #salta si es menor que el tamaño de la columna
         
         jr $ra
         
.end suma
