getChr macro
MOV ah,01h
int 21h
endm

print macro string
	MOV ah,09h
	MOV dx, offset string
	int 21h
endm

cambiarBx macro
	LOCAL a1,a2,salir
	cmp bx,0
	je a1
	cmp bx,1
	je a2
	jmp salir
	a1:
		mov bx,1
		jmp salir
	a2:
		mov bx,0
		jmp salir
	salir:

endm

cambiarAx macro
	LOCAL a1,a2,salir
	cmp bx,0
	je a1
	cmp bx,1
	je a2
	jmp salir
	a1:
		mov bx,1
		jmp salir
	a2:
		mov bx,0
		mov al,'?'
		mov resultados[di],al
		add di,1
		jmp salir
	salir:

endm

calcArray macro array
	LOCAL iniciar,salir
	xor si,si
	mov cx,999

	iniciar:
		cmp array[si],'$'
		je salir
		inc si
		loop iniciar
	salir:

endm

ConvString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov ah,24h
		mov buffer[si],ah
		inc si
	FIN:
endm


ConvertirString macro buffer,contador
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	calcArray buffer
	;xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov buffer[si],','
		inc si
		mov ah,24h
		mov buffer[si],ah
		inc si
		
		;mov contador,si
	FIN:
endm

copiarArregloResultadosNumeros macro resultadosNumeros,copiaResultadosNumeros
	LOCAL iniciar,salir
	xor si,si
	mov cx,99
	iniciar:
		mov al,resultadosNumeros[si]
		mov copiaResultadosNumeros[si],al
		inc si
		loop iniciar
	salir:


endm


calcCantidadNumeros macro resultadosNumeros
	LOCAL iniciar,contador,salir
	xor si,si
	mov cx,99
	mov bx,0
	jmp iniciar
	contador:
		add bx,1
		inc si
		loop iniciar
	iniciar:
		mov al,resultadosNumeros[si]
		cmp al,'$'
		je salir
		cmp al,','
		je contador
		inc si
		loop iniciar
	salir:

endm

CovertirAscii macro numero
	LOCAL INICIO,FIN
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO
	FIN:
endm

getNumero macro auxNumero,resultadosNumeros
	LOCAL iniciar,salir
	mov si,di
	xor di,di
	iniciar:

		cmp si,bx
		jg salir
		mov al,resultadosNumeros[si]
		mov auxNumero[di],al
		inc si
		inc di
		jmp iniciar
	salir:


endm

getPosicionNumero macro resultadosNumeros
	LOCAL iniciar,conteo,salir
	xor si,si
	mov cx,999
	mov bx,0;fin
	mov di,0;inicio 

	mov dx,0
	jmp iniciar
	conteo:
		cmp dx,bp
		je salir

		add dx,1
		inc si
		inc bx
		mov di,bx
		loop iniciar
	iniciar:
		cmp resultadosNumeros[si],','
		je conteo
		inc bx
		inc si
		loop iniciar
	salir:

endm

getNumeroId macro buffer,arrayID
	LOCAL iniciar,nocheck,qend,res,salir

	xor si,si
	mov cx,999
	xor di,di
	mov bx,1
	mov bp,0
	jmp iniciar

	qend:

		;mov al,'Q'
		;mov co,al
		;print co



		cmp bx,1
		je salir

		add bp,1
		xor di,di
		inc si
		mov bx,1
		loop iniciar
	nocheck:
		;mov al,'&'
		;mov co,al
		;print co
		inc si
		inc di
		loop iniciar
	res:
		mov bx,0
		inc si
		inc di
		loop iniciar
	iniciar:
		
		;mov al,buffer[si]
		;mov co,al
		;print co

		;cmp buffer[si],'$'
		;je salir
		cmp buffer[si],'?';63->?
		je qend
		
		cmp bx,1
		jne nocheck


		mov al,buffer[si]
		mov ah,arrayID[di]

		cmp al,ah
		jne res
		
		inc si
		inc di
		loop iniciar
	salir:
endm

getOp macro buffer,resultados,co,com,numero
	LOCAL iniciar,ax0,negh,nega,copiar,dobcomillas,dobcomillas2,loopB,addl,num,salir,exit
	xor di,di
	mov bp,0
	ax0:
		jmp iniciar
	negh:
		neg ax
		jmp loopB
	nega:
		mov bp,1
		inc si
		sub cx,1
		jmp iniciar
	copiar:
		mov al,buffer[si]
		mov numero[di],al
		
		inc di
		inc si
		loop iniciar
	iniciar:
		cmp buffer[si],45
		je nega

		cmp buffer[si],48
		jl salir
		cmp buffer[si],57
		jg salir
		jmp copiar
		
		inc si
		loop iniciar

	salir:
		;print numero

		;push ax
		push bx
		push cx
		push si

		CovertirAscii numero
		;mov ax,bx

		pop si
		pop cx
		pop bx
		;pop ax
		push cx

		;push bp
		;mov bp,co
		
		;pop bp

		mov cx,di
		xor di,di

		cmp bp,1
		je negh

	loopB:
		;mov al,'$'
		mov numero[di],'$'
		inc di 
		loop loopB	

	exit:
		pop cx
endm


clearAuxId macro auxId
	LOCAL iniciar,salir
	xor si,si
	mov cx,999
	iniciar:
		mov auxId[si],'$'
		inc si
		loop iniciar
	salir:

endm

clearAuxNumero macro auxNumero
	LOCAL iniciar,salir
	xor si,si
	mov cx,99
	iniciar:
		mov auxNumero[si],'$'
		inc si
		loop iniciar
	salir:
		
endm

negNum macro
	LOCAL negh,iniciar,salir
	jmp iniciar
	negh:
		neg cx
		jmp salir
	iniciar:
		cmp bp,1
		je negh
	salir:

	
endm

sumarNumeros macro resultadosNumeros,numero
	LOCAL iniciar,sumar,salir
	xor si,si
	xor di,di
	mov cx,99
	mov bp,0
	jmp iniciar
	;negh:
	;	neg ax
	;	inc si
	;	xor di,di
	;	mov bp,0
	;	loop iniciar
	nega:
		mov bp,1
		inc si
		sub cx,1
		jmp iniciar
	sumar:

		
		push bx
		push cx
		push si
		push ax

		CovertirAscii numero
		
		mov cx,ax
		negNum
		;cmp bp,1
		;je negh

		pop ax
		
		add ax,cx

		pop si
		pop cx
		pop bx
		

		push bx
		push cx
		push si
		push ax
		clearAuxNumero numero
		pop ax
		pop si
		pop cx
		pop bx

		

		inc si
		xor di,di

		loop iniciar
	iniciar:
		mov dl,resultadosNumeros[si]
		cmp dl,'$'
		je salir
		cmp dl,','
		je sumar
		cmp dl,'-'
		je nega
		mov numero[di],dl

		inc di
		inc si
		loop iniciar
	salir:

endm



printArray macro buffer,co
	LOCAL iniciar,salir
	xor si,si
	mov cx,25
	iniciar:
		mov al,buffer[si]
		mov co , al
		print co
		inc si
		loop iniciar
	salir:

endm

getPath macro buffer
	LOCAL iniciar,salir
		xor si,si
	iniciar:
		getChr
		cmp al, 0dh
		je salir
		mov buffer[si], al
		inc si
		jmp iniciar
	salir:
		mov buffer[si],00h
endm

openFile macro path,handler
	mov ah,3dh
	mov al,000b
	lea dx, path
	int 21h
	mov handler,ax
	jc fileError
endm

readFile macro handler,numBytes,buffer
	mov ah,3fh
	mov bx,handler
	mov cx,numBytes
	lea dx,buffer
	int 21h
	jc readFileError
endm

closeFile macro handler
	mov ah,3eh
	mov handler,bx
	int 21h
endm

