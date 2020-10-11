include macrosp2.asm

.model small
.stack 100h 
.data
;================ SEGMENTO DE DATOS ==============================
line db 0ah,0dh,'========================================================================','$'
usac db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA','$'
facultad db 0ah,0dh,'FACULTAD DE INGENIERIA','$'
escuela db 0ah,0dh,'CIENCIAS Y SISTEMAS','$'
curso db 0ah,0dh,'CURSO: ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1','$'
nombre db 0ah,0dh,'NOMBRE: JUAN CARLOS ARAGON BAMACA','$'
carnet db 0ah,0dh,'CARNET: 201403552','$'
whitespace db 0ah,0dh,'$','$'
op1 db 0ah,0dh,'1) CARGAR ARCHIVO','$'
op2 db 0ah,0dh,'2) CONSOLA','$'
op3 db 0ah,0dh,'3) SALIR','$'
ruta db 0ah,0dh,'ruta del archivo:','$'
entrada db 0ah,0dh,'Ingrese Opcion: ','$'
errormsg db 0ah,0dh,'Error al abrir el archivo ','$'
readerrormsg db 0ah,0dh,'Error al leer el archivo ','$'
rutaArchivo db 100 dup('$')
bufferReader db 3000 dup('$')
resultados   db 1000 dup('$')
numero       db 100 dup('$')
resultadosNumeros db 100 dup('$')
copiaResultadosNumeros db 100 dup('$')
auxId db 1000 dup('$')
auxnumero db 100 dup('$')
raux db 0


media db 100 dup('$')
mediana db 100 dup('$')
moda db 100 dup('$')
mayor db 100 dup('$')
menor db 100 dup('$')


contador dw 0
contadorAuxiliar dw 0
fileHandler dw ?
co db 0
com db ',','$'
imprimirAUX dw 0

;msgSucces db 0ah,0dh,'comillas','$'
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
.code ;segmento de código
;================== SEGMENTO DE CODIGO ===========================
	main proc
			
			MOV dx,@data
			MOV ds,dx 
			menu:
			print line
			print usac
			print facultad
			print escuela
			print curso
			print nombre
			print carnet
			print whitespace
			print op1
			print op2
			print op3
			print whitespace
			print entrada
			
			getChr
			cmp al,49
			je cargarArchivo
			;cmp al,50
			cmp al,51
			je salirp
			jmp menu
			cargarArchivo:
				MOV ah,09h
				MOV dx, offset ruta
				int 21h
				getPath rutaArchivo
				openFile rutaArchivo, fileHandler
				readFile fileHandler,SIZEOF bufferReader,bufferReader
				closeFile fileHandler
				;analizarArchivo bufferReader,resultados,co,com,numero
				xor si,si
				mov bx,0
				xor di,di
				mov cx,2999
				call aux
				print resultadosNumeros
				print resultados
				call calcMedia
				copiarArregloResultadosNumeros resultadosNumeros,copiaResultadosNumeros


				jmp menu
			salirp:
				MOV ah,4ch
				int 21h
			fileError:
				MOV ah,09h
				MOV dx, offset errormsg
				int 21h
				getChr
				jmp menu
			readFileError:
				MOV ah,09h
				MOV dx, offset readerrormsg
				int 21h
				getChr
				jmp menu
	main endp

	aux:
		ax0:
			jmp iniciar
		getid:

			;mov al,"G"
			;mov co,al
			;print co

			push si
			push cx
			push di
			;push al
			;push ah
			push bx
			push bp
			push dx
			

			;print auxId
			;print resultados
			;mov co,"#"
			;print co
			getNumeroId resultados,auxId;#obtengo en que posicion esta el id
			sub bp,1;#el arreglo resultados contiene en la primera posicion 
					;tiene el nombre del arreglo, se le resta uno a "BP" para
					;quitar ese valor
			;mov co,"#"
			;print co
			;DEBUG



			;mov al,"N"
			;mov co,al
			;print co
			;FIN DEBUG
			getPosicionNumero resultadosNumeros
			;mov al,"P"
			;mov co,al
			;print co


			getNumero auxnumero,resultadosNumeros
			;print auxnumero
			;mov al,"B"
			;mov co,al
			;print co

			;print resultadosNumeros
			;print auxnumero

			CovertirAscii auxnumero

			;mov al,"Z"
			;mov co,al
			;print co
			;LIMPIAR auxId
			;LIMPIAR auxnumero

			clearAuxId auxId
			clearAuxNumero auxnumero

			pop dx
			pop bp
			pop bx
			;pop ah
			;pop al
			pop di
			pop cx
			pop si

			;mov co,bufferReader[si]
			inc si
			sub cx,1

			mov bx,0

			jmp salir
		id:
			;mov al,'I'
			;mov co,al
			;print co

			;print auxId

			cmp bufferReader[si],34
			je getid
			
			;push al
			
			mov al,bufferReader[si]

			;DEBUG

			;mov co,al
			;print co
			;FIN DEBUG


			push si

			mov si,contadorAuxiliar
			mov auxId[si], al
			;print auxId
			pop si
			;pop al
			
			inc si
			add contadorAuxiliar,1
			loop id
			jmp salir;estaba jmp iniciar
		esteAlgo:
			inc si
			sub cx,1
			jmp salir

		divi:
			mov al,bufferReader[si]
			
			sub cx,1
			inc si
			
			sub cx,1
			inc si
			
			mov bx,0
			
			add raux,1
			
			call aux
			
			sub raux,1

			push ax
			
			add raux,1
			
			call aux
			
			sub raux,1
			
			mov bp,ax
			pop ax

			cwd
			idiv bp
			
			cmp raux,0
			jg esteAlgo

			push si
			push cx
			push bx
			push dx

			ConvertirString resultadosNumeros,contador

			pop dx
			pop bx
			pop cx
			pop si

			inc si
			sub cx,1
			jmp iniciar

		res:
			mov al,bufferReader[si]

			sub cx,1
			inc si
			
			sub cx,1
			inc si
			
			mov bx,0
			
			add raux,1
			call aux
			sub raux,1
			
			push ax
			
			add raux,1
			call aux
			sub raux,1
			
			mov bp,ax
			pop ax

			sub ax,bp

			cmp raux,0
			jg esteAlgo

			push si
			push cx
			push bx
			push dx

			ConvertirString resultadosNumeros,contador

			pop dx
			pop bx
			pop cx
			pop si

			inc si
			sub cx,1
			jmp iniciar
		
		multi:
			mov al,bufferReader[si]
			sub cx,1
			inc si
			sub cx,1
			inc si
			mov bx,0
			
			add raux,1
			call aux
			sub raux,1
			
			push ax
			
			add raux,1
			call aux
			sub raux,1
			
			mov bp,ax
			pop ax

			imul bp

			cmp raux,0
			jg esteAlgo

			push si
			push cx
			push bx
			push dx

			ConvertirString resultadosNumeros,contador

			pop dx
			pop bx
			pop cx
			pop si

			inc si
			sub cx,1
			jmp iniciar

		addl:
			mov al,bufferReader[si]

			sub cx,1
			inc si

			sub cx,1
			inc si
			
			mov bx,0
			
			add raux,1
			call aux
			sub raux,1
			
			push ax
			
			add raux,1
			call aux
			;mov al,"T"
			;mov co,al
			;print co
			sub raux,1

			mov bp,ax
			pop ax

			add ax,bp

			cmp raux,0
			jg esteAlgo

			push si
			push cx
			push bx
			push dx

			ConvertirString resultadosNumeros,contador
			;print resultadosNumeros
			pop dx
			pop bx
			pop cx
			pop si



			inc si
			sub cx,1



			jmp iniciar
		
		num:
			sub cx,1
			inc si

			mov bx,0
			
			sub cx,2
			inc si
			inc si

			push di
			
			push bp
			getOp bufferReader,resultados,co,com,numero
			pop bp

			pop di

			jmp salir
	
		dobcomillas:
			cambiarAx

			cmp bufferReader[si + 1],97
			je prevadd

			cmp bufferReader[si + 1],115
			je prevsub

			cmp bufferReader[si + 1],109
			je prevmult

			cmp bufferReader[si + 1],100
			je prevdiv

			cmp bufferReader[si + 1],105
			je prevId

			inc si
			sub cx,1
			jmp iniciar


		dobcomillasexit:
			inc si
			sub cx,1
			jmp iniciar
		prevId:

			;mov al,'P'
			;mov co,al
			;print co

			cmp bufferReader[si + 2],100
			jne dobcomillasexit
			cmp bufferReader[si + 3],34
			jne dobcomillasexit

			inc si
			inc si
			inc si
			inc si
			inc si
			inc si

			sub cx,6

			;xor ax,ax
			mov contadorAuxiliar,0
			jmp id
		prevadd:

			cmp bufferReader[si + 2],100
			jne dobcomillasexit
			cmp bufferReader[si + 3],100
			jne dobcomillasexit
			cmp bufferReader[si + 4],34
			jne dobcomillasexit

			inc si
			inc si
			inc si 
			sub cx,3

			jmp addl

		prevsub:

			cmp bufferReader[si + 2],117
			jne dobcomillasexit
			cmp bufferReader[si + 3],98
			jne dobcomillasexit
			cmp bufferReader[si + 4],34
			jne dobcomillasexit

			inc si
			inc si
			inc si 
			sub cx,3

			jmp res

		prevmult:

			cmp bufferReader[si + 2],117
			jne dobcomillasexit
			cmp bufferReader[si + 3],108
			jne dobcomillasexit
			cmp bufferReader[si + 4],34
			jne dobcomillasexit

			inc si
			inc si
			inc si 
			sub cx,3

			jmp multi

		prevdiv:

			cmp bufferReader[si + 2],105
			jne dobcomillasexit
			cmp bufferReader[si + 3],118
			jne dobcomillasexit
			cmp bufferReader[si + 4],34
			jne dobcomillasexit

			inc si
			inc si
			inc si 

			sub cx,3

			jmp divi

		copiar:
			mov al,bufferReader[si]

			cmp al,2bh
			je addl
			cmp al,35
			je num
			cmp al,42
			je multi
			cmp al,45
			je res
			cmp al,47
			je divi

			mov resultados[di],al
			;mov co,al
			;mov al,bp
			;
			;print co
			;print com
			inc si
			add di,1
			loop iniciar
		;llaveCierra:
		;	cmp bx,1
		;	je salir
		;	inc si
		;	loop iniciar
		iniciar:
			
			cmp bufferReader[si],22h
			je dobcomillas
			cmp bx,1
			je copiar
			inc si
			loop iniciar

		salir:

	ret

	calcMedia:
		;1-contar # de operaciones
		calcCantidadNumeros resultadosNumeros
		;uso bx
		clearAuxNumero numero
		mov ax,0
		;2-sumar operaciones
		push bx
		sumarNumeros resultadosNumeros,numero
		pop bx
		;3-dividir suma
		
		;pop bx
		cwd
		idiv bx
		ConvString media
		print media
	ret
end