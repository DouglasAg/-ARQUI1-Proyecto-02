ORG 100h

inicio:
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    mov [numero], eax
    xor ebx, ebx
    mov ebx, 0                          
    mov [numerofunciones], ebx
    xor eax, eax
    mov [numresolvercon], eax
    mov [numreporteuno], eax
    mov [num1], eax
    mov [num2], eax
    mov [resultadogrado0], eax
    mov [resultadogrado1], eax
    mov [resultadogrado2], eax
    mov [resultadogrado3], eax
    mov [resultadogrado4], eax
    mov [resultadogrado5], eax
    mov [resultadofinal], eax
    
    jmp menu


menu:
    call limpiar                        ;limpia la pantalla
    mov dx, menuinicio                  ;mueve a dx el contenido menuinicio
    call escribir                       ;llama a escribi par imprimir en pantalla 

    mov ah, 01                          ;mover a ah 01 para usar la int 21h
    int 21h                             ;leer un carecter con echo

    cmp al, 49                          ;opcion 01 derivar funcion
    je inicioderivar

    cmp al, 50                          ;opcion 02 integrar funcion
    je iniciointegral

    cmp al, 51                          ;opcion 03 ingresar funciones
    je inicioingresar

    cmp al, 52                          ;opcion 04 imprimir funciones
    je inicioimprimir

    cmp al, 53                          ;opcion 05 graficar
    je iniciograficar

    cmp al, 54                          ;opcion 06 resolver ecuaciones
    je inicioresolver

    cmp al, 55                          ;opcion 07 reportes
    je inicioreporte

    cmp al, 56                          ;opcion 08 salir
    je salir
    jne menu                            ;opcion invalida


%macro leerarchivo 3
    ; 1 ruta archivo, 2 contenedor de los datos archivo
    ; 3 se pondra el numero de caracteres leidos
    ;limpiar ax,cx,dx
    xor ax, ax
    xor cx, cx
    xor dx, dx
    xor bx, bx
    ;abrir archivo
    mov ah, 3dh
    mov al, 0h  
    mov cx, 00
    mov dx, %1
    int 21h
    ;archivo no existe
    jc noarchivo
    ;archivo si existe se lee
    mov bx, ax
    mov ah, 3fh
    mov cx, 499
    mov dx, [%2]
    int 21h

    ;numero de caracteres
    mov [%3], ax
    ;cierre del archivo
    mov ah, 3eh
    int 21h
%endmacro

%macro escribir_archivo 3
    ; 1 nombre archivo, 2 numero de caracters,
    ; 3 texto a escribir
    ; crear archivo
    mov ah, 3ch
    mov cx, 0
    mov dx, %1
    int 21h
    jc menu
    mov bx, ax
    mov ah, 3eh
    int 21h

    ;abrir el archivo
    mov ah,3dh
    mov al,1h ;Abrimos el archivo en solo escritura.
    mov dx, %1
    int 21h
    jc menu ;Si hubo error

    ;Escritura de archivo
    mov bx,ax ; mover hadfile
    mov cx,[%2] ;num de caracteres a grabar
    mov dx,%3
    mov ah,40h
    int 21h
    
    cmp cx,ax
    jne menu ;error salir
    mov ah,3eh  ;Cierre de archivo 
    int 21h
%endmacro

%macro pintar_pixel 3
    ; 1. Color, 2. Posicion X, 3. Posicion Y
    xor ax, ax
    xor bx, bx
    xor cx, cx
    mov ah, 0Ch
    mov al, %1
    mov bh, 0
    mov cx, %2
    mov dx, %3
    int 10h
%endmacro

inicioingresoarchivo:
    call limpiar                        ;Se limpia la pantalla
    mov dx, msjpedirruta
    call escribir
    
    push ecx
    push eax
    push ebx
    push edx
    push si
    push edi 


    mov dl, 0                           ;Se pasa 0 anumcar y sinerror
    mov [sinerror], dl
    mov [numcar], dl
    

                                        ;Se lee la ruta del archivo
    mov ah, 3fh
    mov bx, 00
    mov cx, 100
    mov dx, [textoentrada]
    int 21h
    
    call reiniciartemporal              ;Se reinicio la funcion temporal
    
    leerarchivo rutaarchivo, textoleido, numcarleido    ;Llamada al macro que lee archivp
    push si
    
    
    mov si, [textoleido]
    jmp comprobararchivo


inicioderivar:
    call limpiar                        ;Se limpia la pantalla

    call reiniciartemporal              ;Se reinicia la temporal

    call pedirfuncion                   ;Se pine la funcion

                                        ;Se hace la derivada
    mov al, byte[funciontemporal + 3]
    mov [funciontemporal], al
    mov al, byte[funciontemporal + 4]
    mov [funciontemporal + 1], al

    mov al, byte[funciontemporal + 6]
    mov [funciontemporal + 3], al
    mov al, byte[funciontemporal + 7]
    mov bl, 2
    mul bl
    mov [funciontemporal + 4], al

    mov al, byte[funciontemporal + 9]
    mov [funciontemporal + 6], al
    mov al, byte[funciontemporal + 10]
    mov bl, 3
    mul bl
    mov [funciontemporal + 7], al

    mov al, byte[funciontemporal + 12]
    mov [funciontemporal + 9], al
    mov al, byte[funciontemporal + 13]
    mov bl, 4
    mul bl
    mov [funciontemporal + 10], al

    mov al, [cero]
    
    mov [funciontemporal + 12], al
    mov [funciontemporal + 13], al
    mov [funciontemporal + 15], al
    mov [funciontemporal + 16], al
    mov al, [uno]
    mov [funciontemporal + 2], al
    mov [funciontemporal + 5], al
    mov [funciontemporal + 8], al
    mov [funciontemporal + 11], al
    mov [funciontemporal + 14], al
    mov [funciontemporal + 17], al

    xor eax, eax
    xor ebx, ebx
    mov eax, [numerofunciones]
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
 
    push si

    mov si, [numerofuncionespor]        ;Si todo esta bien se guarda la temporal en 
    mov al, [funciontemporal]           ;el arreglo de funciones
    mov [arreglofunciones + si], al
    mov al, [funciontemporal + 1]
    mov [arreglofunciones + si + 1], al
    mov al, [funciontemporal + 2]
    mov [arreglofunciones + si + 2], al
    mov al, [funciontemporal + 3]
    mov [arreglofunciones + si + 3], al
    mov al, [funciontemporal + 4]
    mov [arreglofunciones + si + 4], al
    mov al, [funciontemporal + 5]
    mov [arreglofunciones + si + 5], al
    mov al, [funciontemporal + 6]
    mov [arreglofunciones + si + 6], al
    mov al, [funciontemporal + 7]
    mov [arreglofunciones + si + 7], al
    mov al, [funciontemporal + 8]
    mov [arreglofunciones + si + 8], al
    mov al, [funciontemporal + 9]
    mov [arreglofunciones + si + 9], al
    mov al, [funciontemporal + 10]
    mov [arreglofunciones + si + 10], al
    mov al, [funciontemporal + 11]
    mov [arreglofunciones + si + 11], al
    mov al, [funciontemporal + 12]
    mov [arreglofunciones + si + 12], al
    mov al, [funciontemporal + 13]
    mov [arreglofunciones + si + 13], al
    mov al, [funciontemporal + 14]
    mov [arreglofunciones + si + 14], al
    mov al, [funciontemporal + 15]
    mov [arreglofunciones + si + 15], al
    mov al, [funciontemporal + 16]
    mov [arreglofunciones + si + 16], al
    mov al, [funciontemporal + 17]
    mov [arreglofunciones + si + 17], al
    xor eax, eax
    mov eax, [numerofunciones]           ;Se aumenta el numero de funciones guardadas
    inc eax
    mov [numerofunciones], eax
    pop si

    mov eax, [numerofunciones]
    dec eax
    mov [numerorecorrer], eax
    
    call mostrarfuncion

    mov ah, 08
    int 21h
    jmp menu

iniciointegral:
    call limpiar                        ;Se limpia la pantalla

    call reiniciartemporal
    call pedirfuncion
                                        ;Se hace la integral
    mov al, [funciontemporal + 12]
    mov [funciontemporal + 15], al
    mov al, [funciontemporal + 13]
    mov [funciontemporal + 16], al
    mov al, 5
    mov [funciontemporal + 17], al

    mov al, [funciontemporal + 9]
    mov [funciontemporal + 12], al
    mov al, [funciontemporal + 10]
    mov [funciontemporal + 13], al
    mov al, 4
    mov [funciontemporal + 14], al

    mov al, [funciontemporal + 6]
    mov [funciontemporal + 9], al
    mov al, [funciontemporal + 7]
    mov [funciontemporal + 10], al
    mov al, 3
    mov [funciontemporal + 11], al

    mov al, [funciontemporal + 3]
    mov [funciontemporal + 6], al
    mov al, [funciontemporal + 4]
    mov [funciontemporal + 7], al
    mov al, 2
    mov [funciontemporal + 8], al

    mov al, [funciontemporal]
    mov [funciontemporal + 3], al
    mov al, [funciontemporal + 1]
    mov [funciontemporal + 4], al
    mov al, 1
    mov [funciontemporal + 5], al

    mov al, [cero]
    mov [funciontemporal], al
    mov [funciontemporal + 1], al
    mov al, [uno]
    mov [funciontemporal + 2], al

    xor eax, eax
    xor ebx, ebx
    mov eax, [numerofunciones]
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
 
    push si

    mov si, [numerofuncionespor]        ;Si todo esta bien se guarda la temporal en 
    mov al, [funciontemporal]           ;el arreglo de funciones
    mov [arreglofunciones + si], al
    mov al, [funciontemporal + 1]
    mov [arreglofunciones + si + 1], al
    mov al, [funciontemporal + 2]
    mov [arreglofunciones + si + 2], al
    mov al, [funciontemporal + 3]
    mov [arreglofunciones + si + 3], al
    mov al, [funciontemporal + 4]
    mov [arreglofunciones + si + 4], al
    mov al, [funciontemporal + 5]
    mov [arreglofunciones + si + 5], al
    mov al, [funciontemporal + 6]
    mov [arreglofunciones + si + 6], al
    mov al, [funciontemporal + 7]
    mov [arreglofunciones + si + 7], al
    mov al, [funciontemporal + 8]
    mov [arreglofunciones + si + 8], al
    mov al, [funciontemporal + 9]
    mov [arreglofunciones + si + 9], al
    mov al, [funciontemporal + 10]
    mov [arreglofunciones + si + 10], al
    mov al, [funciontemporal + 11]
    mov [arreglofunciones + si + 11], al
    mov al, [funciontemporal + 12]
    mov [arreglofunciones + si + 12], al
    mov al, [funciontemporal + 13]
    mov [arreglofunciones + si + 13], al
    mov al, [funciontemporal + 14]
    mov [arreglofunciones + si + 14], al
    mov al, [funciontemporal + 15]
    mov [arreglofunciones + si + 15], al
    mov al, [funciontemporal + 16]
    mov [arreglofunciones + si + 16], al
    mov al, [funciontemporal + 17]
    mov [arreglofunciones + si + 17], al
    xor eax, eax
    mov eax, [numerofunciones]           ;Se aumenta el numero de funciones guardadas
    inc eax
    mov [numerofunciones], eax
    pop si

    mov eax, [numerofunciones]
    dec eax
    mov [numerorecorrer], eax
    
    call mostrarfuncion

    mov ah, 02h
    mov dl, 43
    int 21h
	
    mov ah, 02h
    mov dl, 67
    int 21h
	

    mov ah, 08
    int 21h
    jmp menu

inicioingresar:
    call limpiar                        ;Se limpia la pantalla
    mov dx, menuingreso
    call escribir
    mov ah, 01                          ;mover a ah 01 para usar la int 21h
    int 21h                             ;leer un carecter con echo

    cmp al, 49                          ;opcion 01 ingreso manual de la funcion
    je inicioingresomanual

    cmp al, 50                          ;opcion 02 ingreso por archivo de la funciones
    je inicioingresoarchivo

    cmp al, 51
    je menu
    jne inicioingresar

noesnumero:
    call limpiar                        ;Se limpia la pantalla
    mov dx, msjnoesnumero               ;Se mueve a dx el mensaje no es numero
    call escribir                       ;Se escribe en pantalla el mensaje
    mov ah, 02h                         ;Se imprime en pantalla el digito
    xor dx, dx
    mov dl, al
    int 21h
    mov ah, 08                          ;Se espera que presione algo para regresar al inicio ingresar
    int 21h
    jmp menu

inicioingresomanual:
    call limpiar                        ;Se limpia la pantalla
    call pedirfuncion                   ;Se pide la funcion
    mov dx, msjfuncioningresado         ;Mensaje de funcion ingresada
    call escribir
    mov ah, 08
    int 21h
    jmp inicioingresar

pedirfuncion:
    mov dx, msjgradocero                ;Se piede el grado cero
    call escribir
    mov ah, 01h                         ;Se pide un caracter
    int 21h

    cmp al, 45                          ;Si es signo menos salta a ponermenos
    je ponermenos
    xor bl, bl                          ;Si no es menos el signo del numero es positivo
    mov bl, 0
    mov [signonumero], bl                ;Se mueve a signonumero un cero
    jmp ingresonumero                   ;Continua con el ingreso del numero

ponermenos:
    xor bl, bl
    mov bl, 1                           ;Para negativo se usa el un uno
    mov [signonumero], bl                ;Se mueve a signo numero un uno
    mov ah, 01h                         ;Se pide otro caracter
    int 21h
    jmp ingresonumero                   ;Continua con el ingreso del numero 

ingresonumero:
    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringreso                 ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringreso
    cmp al, 50
    je continuaringreso
    cmp al, 51
    je continuaringreso
    cmp al, 52
    je continuaringreso
    cmp al, 53
    je continuaringreso
    cmp al, 54
    je continuaringreso
    cmp al, 55
    je continuaringreso
    cmp al, 56
    je continuaringreso
    cmp al, 57
    je continuaringreso
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringreso:
    sub al, 30h                         ;Se le resta 30h que es 48 para obtener el numero 
    mov [decenas], al                   ;Se mueve a las decenas el numeor
    mov ah, 01h                         ;Se piede el siguiente numero
    int 21h

    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringreso2                ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringreso2
    cmp al, 50
    je continuaringreso2
    cmp al, 51
    je continuaringreso2
    cmp al, 52
    je continuaringreso2
    cmp al, 53
    je continuaringreso2
    cmp al, 54
    je continuaringreso2
    cmp al, 55
    je continuaringreso2
    cmp al, 56
    je continuaringreso2
    cmp al, 57
    je continuaringreso2
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringreso2:
    sub al, 30h                         ;Se resta 30h para obtener el numero
    mov [unidades], al                  ;Se mueve a las unidades el numero

    mov al, [decenas]                   ;Se mueve al las decenas
    mul dword [diez]                    ;Se multiplica por 10 al
    add al, [unidades]                  ;Se le suman las unidades a al
    mov [numero], al                    ;Se guarda el numero

    mov bl, [signonumero]               ;Se mueve a bl el signo
    mov [funciontemporal], bl           ;Se mueve la funcion temporal bl
    mov bl, [numero]                    ;Se mueve a bl el numero
    mov [funciontemporal + 1], bl       ;Se mueve a la funcion temporal bl
    mov bl, byte[uno]                           ;Se mueve a bl uno
    mov [funciontemporal + 2], bl       ;Se mueve a la funcion temporal bl

    mov dx, msjgradouno                 ;Se piede el grado uno
    call escribir

    mov ah, 01h                         ;Se pide un caracter
    int 21h

    cmp al, 45                          ;Si es signo menos salta a ponermenos
    je ponermenosuno
    xor bl, bl                          ;Si no es menos el signo del numero es positivo
    mov bl, 0
    mov [signonumero], bl                ;Se mueve a signonumero un cero
    jmp ingresonumerouno                ;Continua con el ingreso del numero

ponermenosuno:
    xor bl, bl
    mov bl, byte[uno]                           ;Para negativo se usa el un uno
    mov [signonumero], bl                ;Se mueve a signo numero un uno
    mov ah, 01h                         ;Se pide otro caracter
    int 21h
    jmp ingresonumerouno                ;Continua con el ingreso del numero 

ingresonumerouno:
    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresouno              ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresouno
    cmp al, 50
    je continuaringresouno
    cmp al, 51
    je continuaringresouno
    cmp al, 52
    je continuaringresouno
    cmp al, 53
    je continuaringresouno
    cmp al, 54
    je continuaringresouno
    cmp al, 55
    je continuaringresouno
    cmp al, 56
    je continuaringresouno
    cmp al, 57
    je continuaringresouno
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresouno:
    sub al, 30h                         ;Se le resta 30h que es 48 para obtener el numero 
    mov [decenas], al                   ;Se mueve a las decenas el numeor
    mov ah, 01h                         ;Se piede el siguiente numero
    int 21h

    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresouno2             ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresouno2
    cmp al, 50
    je continuaringresouno2
    cmp al, 51
    je continuaringresouno2
    cmp al, 52
    je continuaringresouno2
    cmp al, 53
    je continuaringresouno2
    cmp al, 54
    je continuaringresouno2
    cmp al, 55
    je continuaringresouno2
    cmp al, 56
    je continuaringresouno2
    cmp al, 57
    je continuaringresouno2
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresouno2:
    sub al, 30h                         ;Se resta 30h para obtener el numero
    mov [unidades], al                  ;Se mueve a las unidades el numero

    mov al, [decenas]                   ;Se mueve al las decenas
    mul dword [diez]                    ;Se multiplica por 10 al
    add al, [unidades]                  ;Se le suman las unidades a al
    mov [numero], al                    ;Se guarda el numero

    mov bl, [signonumero]               ;Se mueve a bl el signo
    mov [funciontemporal + 3], bl       ;Se mueve la funcion temporal bl
    mov bl, [numero]                    ;Se mueve a bl el numero
    mov [funciontemporal + 4], bl       ;Se mueve a la funcion temporal bl
    mov bl, byte[uno]                           ;Se mueve a bl uno
    mov [funciontemporal + 5], bl       ;Se mueve a la funcion temporal bl

    mov dx, msjgradodos                 ;Se piede el grado dos
    call escribir

    mov ah, 01h                         ;Se pide un caracter
    int 21h

    cmp al, 45                          ;Si es signo menos salta a ponermenos
    je ponermenosdos
    xor bl, bl                          ;Si no es menos el signo del numero es positivo
    mov bl, 0
    mov [signonumero], bl                ;Se mueve a signonumero un cero
    jmp ingresonumerodos                ;Continua con el ingreso del numero

ponermenosdos:
    xor bl, bl
    mov bl, byte[uno]                           ;Para negativo se usa el un uno
    mov [signonumero], bl                ;Se mueve a signo numero un uno
    mov ah, 01h                         ;Se pide otro caracter
    int 21h
    jmp ingresonumerodos                   ;Continua con el ingreso del numero 

ingresonumerodos:
    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresodos              ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresodos
    cmp al, 50
    je continuaringresodos
    cmp al, 51
    je continuaringresodos
    cmp al, 52
    je continuaringresodos
    cmp al, 53
    je continuaringresodos
    cmp al, 54
    je continuaringresodos
    cmp al, 55
    je continuaringresodos
    cmp al, 56
    je continuaringresodos
    cmp al, 57
    je continuaringresodos
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresodos:
    sub al, 30h                         ;Se le resta 30h que es 48 para obtener el numero 
    mov [decenas], al                   ;Se mueve a las decenas el numeor
    mov ah, 01h                         ;Se piede el siguiente numero
    int 21h

    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresodos2             ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresodos2
    cmp al, 50
    je continuaringresodos2
    cmp al, 51
    je continuaringresodos2
    cmp al, 52
    je continuaringresodos2
    cmp al, 53
    je continuaringresodos2
    cmp al, 54
    je continuaringresodos2
    cmp al, 55
    je continuaringresodos2
    cmp al, 56
    je continuaringresodos2
    cmp al, 57
    je continuaringresodos2
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresodos2:
    sub al, 30h                         ;Se resta 30h para obtener el numero
    mov [unidades], al                  ;Se mueve a las unidades el numero

    mov al, [decenas]                   ;Se mueve al las decenas
    mul dword [diez]                    ;Se multiplica por 10 al
    add al, [unidades]                  ;Se le suman las unidades a al
    mov [numero], al                    ;Se guarda el numero

    mov bl, [signonumero]               ;Se mueve a bl el signo
    mov [funciontemporal + 6], bl       ;Se mueve la funcion temporal bl
    mov bl, [numero]                    ;Se mueve a bl el numero
    mov [funciontemporal + 7], bl       ;Se mueve a la funcion temporal bl
    mov bl, byte[uno]                           ;Se mueve a bl uno
    mov [funciontemporal + 8], bl       ;Se mueve a la funcion temporal bl

    mov dx, msjgradotres                ;Se piede el grado tres
    call escribir

    mov ah, 01h                         ;Se pide un caracter
    int 21h

    cmp al, 45                          ;Si es signo menos salta a ponermenos
    je ponermenostres
    xor bl, bl                          ;Si no es menos el signo del numero es positivo
    mov bl, 0
    mov [signonumero], bl                ;Se mueve a signonumero un cero
    jmp ingresonumerotres               ;Continua con el ingreso del numero

ponermenostres:
    xor bl, bl
    mov bl, byte[uno]                           ;Para negativo se usa el un uno
    mov [signonumero], bl                ;Se mueve a signo numero un uno
    mov ah, 01h                         ;Se pide otro caracter
    int 21h
    jmp ingresonumerotres               ;Continua con el ingreso del numero 

ingresonumerotres:
    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresotres             ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresotres
    cmp al, 50
    je continuaringresotres
    cmp al, 51
    je continuaringresotres
    cmp al, 52
    je continuaringresotres
    cmp al, 53
    je continuaringresotres
    cmp al, 54
    je continuaringresotres
    cmp al, 55
    je continuaringresotres
    cmp al, 56
    je continuaringresotres
    cmp al, 57
    je continuaringresotres
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresotres:
    sub al, 30h                         ;Se le resta 30h que es 48 para obtener el numero 
    mov [decenas], al                   ;Se mueve a las decenas el numeor
    mov ah, 01h                         ;Se piede el siguiente numero
    int 21h

    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresotres2            ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresotres2
    cmp al, 50
    je continuaringresotres2
    cmp al, 51
    je continuaringresotres2
    cmp al, 52
    je continuaringresotres2
    cmp al, 53
    je continuaringresotres2
    cmp al, 54
    je continuaringresotres2
    cmp al, 55
    je continuaringresotres2
    cmp al, 56
    je continuaringresotres2
    cmp al, 57
    je continuaringresotres2
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresotres2:
    sub al, 30h                         ;Se resta 30h para obtener el numero
    mov [unidades], al                  ;Se mueve a las unidades el numero

    mov al, [decenas]                   ;Se mueve al las decenas
    mul dword [diez]                    ;Se multiplica por 10 al
    add al, [unidades]                  ;Se le suman las unidades a al
    mov [numero], al                    ;Se guarda el numero

    mov bl, [signonumero]               ;Se mueve a bl el signo
    mov [funciontemporal + 9], bl           ;Se mueve la funcion temporal bl
    mov bl, [numero]                    ;Se mueve a bl el numero
    mov [funciontemporal + 10], bl      ;Se mueve a la funcion temporal bl
    mov bl, 1                           ;Se mueve a bl uno
    mov [funciontemporal + 11], bl      ;Se mueve a la funcion temporal bl

    mov dx, msjgradocuatro              ;Se piede el grado cuatro
    call escribir

    mov ah, 01h                         ;Se pide un caracter
    int 21h

    cmp al, 45                          ;Si es signo menos salta a ponermenos
    je ponermenoscuatro
    xor bl, bl                          ;Si no es menos el signo del numero es positivo
    mov bl, 0
    mov [signonumero], bl                ;Se mueve a signonumero un cero
    jmp ingresonumerocuatro             ;Continua con el ingreso del numero

ponermenoscuatro:
    xor bl, bl
    mov bl, 1                           ;Para negativo se usa el un uno
    mov [signonumero], bl                ;Se mueve a signo numero un uno
    mov ah, 01h                         ;Se pide otro caracter
    int 21h
    jmp ingresonumerocuatro             ;Continua con el ingreso del numero 

ingresonumerocuatro:
    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresocuatro           ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresocuatro
    cmp al, 50
    je continuaringresocuatro
    cmp al, 51
    je continuaringresocuatro
    cmp al, 52
    je continuaringresocuatro
    cmp al, 53
    je continuaringresocuatro
    cmp al, 54
    je continuaringresocuatro
    cmp al, 55
    je continuaringresocuatro
    cmp al, 56
    je continuaringresocuatro
    cmp al, 57
    je continuaringresocuatro
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresocuatro:
    sub al, 30h                         ;Se le resta 30h que es 48 para obtener el numero 
    mov [decenas], al                   ;Se mueve a las decenas el numeor
    mov ah, 01h                         ;Se piede el siguiente numero
    int 21h

    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresocuatro2                ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresocuatro2
    cmp al, 50
    je continuaringresocuatro2
    cmp al, 51
    je continuaringresocuatro2
    cmp al, 52
    je continuaringresocuatro2
    cmp al, 53
    je continuaringresocuatro2
    cmp al, 54
    je continuaringresocuatro2
    cmp al, 55
    je continuaringresocuatro2
    cmp al, 56
    je continuaringresocuatro2
    cmp al, 57
    je continuaringresocuatro2
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresocuatro2:
    sub al, 30h                         ;Se resta 30h para obtener el numero
    mov [unidades], al                  ;Se mueve a las unidades el numero

    mov al, [decenas]                   ;Se mueve al las decenas
    mul dword [diez]                    ;Se multiplica por 10 al
    add al, [unidades]                  ;Se le suman las unidades a al
    mov [numero], al                    ;Se guarda el numero

    mov bl, [signonumero]               ;Se mueve a bl el signo
    mov [funciontemporal + 12], bl      ;Se mueve la funcion temporal bl
    mov bl, [numero]                    ;Se mueve a bl el numero
    mov [funciontemporal + 13], bl      ;Se mueve a la funcion temporal bl
    mov bl, 1                           ;Se mueve a bl uno
    mov [funciontemporal + 14], bl      ;Se mueve a la funcion temporal bl
    mov bl, 0                           ;Se mueve a bl uno
    mov [funciontemporal + 15], bl      ;Se mueve a la funcion temporal bl
    mov bl, 0                           ;Se mueve a bl uno
    mov [funciontemporal + 16], bl      ;Se mueve a la funcion temporal bl
    mov bl, 1                           ;Se mueve a bl uno
    mov [funciontemporal + 17], bl      ;Se mueve a la funcion temporal bl
    xor eax, eax
    xor ebx, ebx
    mov eax, [numerofunciones]
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
 
    push si

    mov si, [numerofuncionespor]        ;Si todo esta bien se guarda la temporal en 
    mov bl, [funciontemporal]           ;el arreglo de funciones
    mov [arreglofunciones + si], bl
    mov bl, [funciontemporal + 1]
    mov [arreglofunciones + si + 1], bl
    mov bl, [funciontemporal + 2]
    mov [arreglofunciones + si + 2], bl
    mov bl, [funciontemporal + 3]
    mov [arreglofunciones + si + 3], bl
    mov bl, [funciontemporal + 4]
    mov [arreglofunciones + si + 4], bl
    mov bl, [funciontemporal + 5]
    mov [arreglofunciones + si + 5], bl
    mov bl, [funciontemporal + 6]
    mov [arreglofunciones + si + 6], bl
    mov bl, [funciontemporal + 7]
    mov [arreglofunciones + si + 7], bl
    mov bl, [funciontemporal + 8]
    mov [arreglofunciones + si + 8], bl
    mov bl, [funciontemporal + 9]
    mov [arreglofunciones + si + 9], bl
    mov bl, [funciontemporal + 10]
    mov [arreglofunciones + si + 10], bl
    mov bl, [funciontemporal + 11]
    mov [arreglofunciones + si + 11], bl
    mov bl, [funciontemporal + 12]
    mov [arreglofunciones + si + 12], bl
    mov bl, [funciontemporal + 13]
    mov [arreglofunciones + si + 13], bl
    mov bl, [funciontemporal + 14]
    mov [arreglofunciones + si + 14], bl
    mov bl, [funciontemporal + 15]
    mov [arreglofunciones + si + 15], bl
    mov bl, [funciontemporal + 16]
    mov [arreglofunciones + si + 16], bl
    mov bl, [funciontemporal + 17]
    mov [arreglofunciones + si + 17], bl
    xor ebx, ebx
    mov ebx, [numerofunciones]           ;Se aumenta el numero de funciones guardadas
    inc ebx
    mov [numerofunciones], ebx
    pop si
    ret

reiniciartemporal:
    mov al, [cero]
    mov [funciontemporal], al
    mov [funciontemporal + 1], al
    mov [funciontemporal + 3], al
    mov [funciontemporal + 4], al
    mov [funciontemporal + 6], al
    mov [funciontemporal + 7], al
    mov [funciontemporal + 9], al
    mov [funciontemporal + 10], al
    mov [funciontemporal + 12], al
    mov [funciontemporal + 13], al
    mov [funciontemporal + 15], al
    mov [funciontemporal + 16], al
    mov al, [uno]
    mov [funciontemporal + 2], al
    mov [funciontemporal + 5], al
    mov [funciontemporal + 8], al
    mov [funciontemporal + 11], al
    mov [funciontemporal + 14], al
    mov [funciontemporal + 17], al
    ret

comprobararchivo:
    lodsb
    cmp al, 32                          ;Espacio
    je repetircomprobacion
    cmp al, 10                          ;Salto de linea
    je repetircomprobacion
    cmp al, 43                          ;Mas +
    je repetircomprobacion
    cmp al, 45                          ;Menos -
    je repetircomprobacion
    cmp al, 48                          ;Cero 0
    je repetircomprobacion
    cmp al, 49                          ;Uno 1
    je repetircomprobacion
    cmp al, 50                          ;Dos 2
    je repetircomprobacion
    cmp al, 51                          ;Tres 3
    je repetircomprobacion
    cmp al, 52                          ;Cuatro 4
    je repetircomprobacion
    cmp al, 53                          ;Cinco 5
    je repetircomprobacion
    cmp al, 54                          ;Seis 6
    je repetircomprobacion
    cmp al, 55                          ;Siete 7
    je repetircomprobacion
    cmp al, 56                          ;Ocho 8
    je repetircomprobacion
    cmp al, 57                          ;Nueve 9
    je repetircomprobacion  
    cmp al, 59                          ;Punto y coma ;
    je repetircomprobacion
    cmp al, 120                         ;x minuscula
    je repetircomprobacion
    cmp al, 94                          ;Exponente ^
    je repetircomprobacion
    cmp al, 13                          ;Enter
    je repetircomprobacion
    jne caracternovalido

caracternovalido:
    mov [carac], al                     ;Se guarda el caracter invalido
    mov dx, msjcaracterinvalido         ;Se muestra mensaje de caracter invalido
    call escribir

    mov ah, 02h                         ;Se imprime el caracter invalid
    mov dl, [carac]
    int 21h

    mov al, [uno]                       ;Se pone un uno en sinerror
    mov [sinerror], al
    jmp repetircomprobacion             ;Se continua analizando

repetircomprobacion:
    mov dl, [numcar]                    ;Se incrementa el valor de numcar en uno
    add dl, [uno]
    mov [numcar], dl
    
    mov al, [numcar]                    ;Se compara nunmcar con los caracteres leidos
    mov bl, [numcarleido]
    cmp al, bl
    je cargarfunciones
    jne comprobararchivo
    
cargarfunciones:
    mov ah, 08                          ;Se espera que que se presione una tecla para continuar
    int 21h

    mov al, [sinerror]                  ;Se compara sinerror con cero
    cmp al, [cero]                      ;Si es cero se prosede a guardar las funciones
    je iniciocargarfuncion              ;Si no es cero se regresa al menu ingreso
    jne inicioingresar

iniciocargarfuncion:
    mov dl, [cero]
    mov [numcar], dl
    xor si, si
    mov si, [textoleido]
    jmp cargarfuncion

cargarfuncion:
    lodsb
    cmp al, 13                          ;Enter
    je cargarsiguiete
    cmp al, 32                          ;Espacio
    je cargarsiguiete
    cmp al, 10                          ;Salto de linea
    je cargarsiguiete
    cmp al, 43                          ;Mas +
    je cargarpositivomas
    cmp al, 45                          ;Menos -
    je cargarnegativo
    cmp al, 48                          ;Cero 0
    je cargarpositivo
    cmp al, 49                          ;Uno 1
    je cargarpositivo
    cmp al, 50                          ;Dos 2
    je cargarpositivo
    cmp al, 51                          ;Tres 3
    je cargarpositivo
    cmp al, 52                          ;Cuatro 4
    je cargarpositivo
    cmp al, 53                          ;Cinco 5
    je cargarpositivo
    cmp al, 54                          ;Seis 6
    je cargarpositivo
    cmp al, 55                          ;Siete 7
    je cargarpositivo
    cmp al, 56                          ;Ocho 8
    je cargarpositivo
    cmp al, 57                          ;Nueve 9
    je cargarpositivo  
    cmp al, 59                          ;Punto y coma ;
    je guardarfuincion

cargarpositivomas:
    lodsb
    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl
    jmp cargarpositivo

cargarnegativo:
    mov bl, [uno]
    mov [signonumero], bl
    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl
    lodsb
    jmp ponernumero

cargarpositivo:
    mov bl, [cero]
    mov [signonumero], bl
    ponernumero:
    sub al, 30h
    mov [decenas], al
    lodsb
    sub al, 30h
    mov [unidades], al
    xor eax, eax
    mov al, [decenas]
    mul dword [diez]
    add al, [unidades]
    mov [numero], al

    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl
    
    lodsb
    cmp al, 120                         ;x minuscula
    jne ponergradocero

    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl

    lodsb
    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl

    lodsb
    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl
    cmp al, 49
    je ponergradouno
    cmp al, 50
    je ponergradodos
    cmp al, 51
    je ponergradotres
    jne ponergradocuatro

ponergradocero:
    mov bl, [signonumero]
    mov [funciontemporal], bl
    mov bl, [numero]
    mov [funciontemporal + 1], bl
    mov bl, [uno]
    mov [funciontemporal + 2], bl
    jmp cargarfuncion2

cargarfuncion2:
    cmp al, 13                          ;Enter
    je cargarsiguiete
    cmp al, 32                          ;Espacio
    je cargarsiguiete
    cmp al, 10                          ;Salto de linea
    je cargarsiguiete
    cmp al, 43                          ;Mas +
    je cargarpositivomas
    cmp al, 45                          ;Menos -
    je cargarnegativo
    cmp al, 48                          ;Cero 0
    je cargarpositivo
    cmp al, 49                          ;Uno 1
    je cargarpositivo
    cmp al, 50                          ;Dos 2
    je cargarpositivo
    cmp al, 51                          ;Tres 3
    je cargarpositivo
    cmp al, 52                          ;Cuatro 4
    je cargarpositivo
    cmp al, 53                          ;Cinco 5
    je cargarpositivo
    cmp al, 54                          ;Seis 6
    je cargarpositivo
    cmp al, 55                          ;Siete 7
    je cargarpositivo
    cmp al, 56                          ;Ocho 8
    je cargarpositivo
    cmp al, 57                          ;Nueve 9
    je cargarpositivo  
    cmp al, 59                          ;Punto y coma ;
    je guardarfuincion

ponergradouno:
    mov bl, [signonumero]
    mov [funciontemporal + 3], bl
    mov bl, [numero]
    mov [funciontemporal + 4], bl
    mov bl, [uno]
    mov [funciontemporal + 5], bl
    jmp cargarsiguiete

ponergradodos:
    mov bl, [signonumero]
    mov [funciontemporal + 6], bl
    mov bl, [numero]
    mov [funciontemporal + 7], bl
    mov bl, [uno]
    mov [funciontemporal + 8], bl
    jmp cargarsiguiete

ponergradotres:
    mov bl, [signonumero]
    mov [funciontemporal + 9], bl
    mov bl, [numero]
    mov [funciontemporal + 10], bl
    mov bl, [uno]
    mov [funciontemporal + 11], bl
    jmp cargarsiguiete

ponergradocuatro:
    mov bl, [signonumero]
    mov [funciontemporal + 12], bl
    mov bl, [numero]
    mov [funciontemporal + 13], bl
    mov bl, [uno]
    mov [funciontemporal + 14], bl
    jmp cargarsiguiete

guardarfuincion:
    xor eax, eax
    xor ebx, ebx
    mov eax, [numerofunciones]
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
    push si
    mov si, [numerofuncionespor]        ;Si todo esta bien se guarda la temporal en 
    mov al, [funciontemporal]           ;el arreglo de funciones
    mov [arreglofunciones + si], al
    mov al, [funciontemporal + 1]
    mov [arreglofunciones + si + 1], al
    mov al, [funciontemporal + 2]
    mov [arreglofunciones + si + 2], al
    mov al, [funciontemporal + 3]
    mov [arreglofunciones + si + 3], al
    mov al, [funciontemporal + 4]
    mov [arreglofunciones + si + 4], al
    mov al, [funciontemporal + 5]
    mov [arreglofunciones + si + 5], al
    mov al, [funciontemporal + 6]
    mov [arreglofunciones + si + 6], al
    mov al, [funciontemporal + 7]
    mov [arreglofunciones + si + 7], al
    mov al, [funciontemporal + 8]
    mov [arreglofunciones + si + 8], al
    mov al, [funciontemporal + 9]
    mov [arreglofunciones + si + 9], al
    mov al, [funciontemporal + 10]
    mov [arreglofunciones + si + 10], al
    mov al, [funciontemporal + 11]
    mov [arreglofunciones + si + 11], al
    mov al, [funciontemporal + 12]
    mov [arreglofunciones + si + 12], al
    mov al, [funciontemporal + 13]
    mov [arreglofunciones + si + 13], al
    mov al, [funciontemporal + 14]
    mov [arreglofunciones + si + 14], al
    mov al, [funciontemporal + 15]
    mov [arreglofunciones + si + 15], al
    mov al, [funciontemporal + 16]
    mov [arreglofunciones + si + 16], al
    mov al, [funciontemporal + 17]
    mov [arreglofunciones + si + 17], al
    xor eax, eax
    mov eax, [numerofunciones]           ;Se aumenta el numero de funciones guardadas
    inc eax
    mov [numerofunciones], eax
    
    pop si
    call reiniciartemporal
    jmp cargarsiguiete

cargarsiguiete:
    mov dl, [numcar]
    add dl, [uno]
    mov [numcar], dl
    
    mov al, [numcar]
    mov bl, [numcarleido]
    cmp al, bl
    je finingresoarchivo
    jne cargarfuncion

finingresoarchivo:
    pop edi
    pop si
    pop edx
    pop ebx
    pop eax
    pop ecx
    mov ah, 08
    int 21h
    jmp inicioingresar

inicioimprimir:
    push ecx
    push eax
    push ebx
    push edx
    push esi
    push edi 

    call limpiar                        ;Se limpia la pantalla
    mov bl, [numerofunciones]
    cmp bl, 0                           ;Se verifica que existan funciones guardadas
    je nohayfunciones
    xor ebx, ebx
    mov ebx, 0                           ;Se pasa a cero el numero recorrer
    mov [numerorecorrer], ebx
    
    call mostrarfuncion
    

    mov ah, 08
    int 21h

    pop edi
    pop esi
    pop edx
    pop ebx
    pop eax
    pop ecx
    jmp menu
    
mostrarfuncion:
    
    xor eax, eax
    xor ebx, ebx
    mov eax, [numerorecorrer]           ;Se multiplica por 18 el valor que lleva el recorrer
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
    mov si, [numerofuncionespor]        ;Se pasa a si la posicion del inicio de la funcion
    mov dx, msjfuncion
    call escribir

    xor ax, ax
    mov al, byte[arreglofunciones + si + 16]    ;Se mira si el valor es cero del coeeficiente
    cmp al, 0
    je mostrargradocuatro                   ;Si el valor es sero se pasa al otro grado
    xor al, al
    mov al, byte[arreglofunciones + si + 15]    ;Se mira el signo del numero
    cmp al, 0
    je mostrarcinco                         ;Si es positivo salta
    mov ah, 02h                             ;Se imprime signo menos
    mov dl, 45
    int 21h
    mostrarcinco:
        mov al, byte[arreglofunciones + si + 16]   ;Se obtiene el numeroador
        mov [valor], al
        mov edi, 0
        call separarnumero                      ;Se separa el numero
        call imprimirnumero                     ;Se imprime el numero

        xor al, al
        mov al, byte[arreglofunciones + si + 17]    ;Si el obtiene el numerodor 
        cmp al, byte[uno]                               ;Si es uno se salta al grado
        je imprimirgradocinco
        mov ah, 02h                             ;Se imprime signo de division
        mov dl, 47
        int 21h
        mov al, byte[arreglofunciones + si + 17]   ;Se obtiene el denominador
        mov [valor], al                        ;Se imprime el denomidadot
        mov edi, 0
        call separarnumero
        call imprimirnumero
    imprimirgradocinco:
        mov ah, 02h                             ;Se imprime x^grado
        mov dl, 120
        int 21h
        mov ah, 02h
        mov dl, 94
        int 21h
        mov ah, 02h
        mov dl, 53
        int 21h
    mostrargradocuatro:
        xor ax, ax
        mov al, byte[arreglofunciones + si + 13]    ;Se mira si el valor es cero del coeeficiente
        cmp al, 0
        je mostrargradotres                   ;Si el valor es sero se pasa al otro grado
        xor al, al
        mov al, byte[arreglofunciones + si + 12]    ;Se mira el signo del numero
        cmp al, 0
        je mostrarcuatromas                         ;Si es positivo salta
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 45
        int 21h
        jmp mostrarcuatro
    mostrarcuatromas:
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 43
        int 21h
    mostrarcuatro:
        mov al, byte[arreglofunciones + si + 13]   ;Se obtiene el numeroador
        mov [valor], al
        mov edi, 0
        call separarnumero                      ;Se separa el numero
        call imprimirnumero                     ;Se imprime el numero

        xor al, al
        mov al, byte[arreglofunciones + si + 14]    ;Si el obtiene el numerodor 
        cmp al, byte[uno]                               ;Si es uno se salta al grado
        je imprimirgradocuatro
        mov ah, 02h                             ;Se imprime signo de division
        mov dl, 47
        int 21h
        mov al, byte[arreglofunciones + si + 14]   ;Se obtiene el denominador
        mov [valor], al                        ;Se imprime el denomidadot
        mov edi, 0
        call separarnumero
        call imprimirnumero
    imprimirgradocuatro:
        mov ah, 02h                             ;Se imprime x^grado
        mov dl, 120
        int 21h
        mov ah, 02h
        mov dl, 94
        int 21h
        mov ah, 02h
        mov dl, 52
        int 21h
    mostrargradotres:
        xor ax, ax
        mov al, byte[arreglofunciones + si + 10]    ;Se mira si el valor es cero del coeeficiente
        cmp al, 0
        je mostrargradodos                   ;Si el valor es sero se pasa al otro grado
        xor al, al
        mov al, byte[arreglofunciones + si + 9]    ;Se mira el signo del numero
        cmp al, 0
        je mostrartresmas                         ;Si es positivo salta
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 45
        int 21h
        jmp mostrartres
    mostrartresmas:
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 43
        int 21h
    mostrartres:
        mov al, byte[arreglofunciones + si + 10]   ;Se obtiene el numeroador
        mov [valor], al
        mov edi, 0
        call separarnumero                      ;Se separa el numero
        call imprimirnumero                     ;Se imprime el numero

        xor al, al
        mov al, byte[arreglofunciones + si + 11]    ;Si el obtiene el numerodor 
        cmp al, byte[uno]                               ;Si es uno se salta al grado
        je imprimirgradotres
        mov ah, 02h                             ;Se imprime signo de division
        mov dl, 47
        int 21h
        mov al, byte[arreglofunciones + si + 11]   ;Se obtiene el denominador
        mov [valor], al                        ;Se imprime el denomidadot
        mov edi, 0
        call separarnumero
        call imprimirnumero
    imprimirgradotres:
        mov ah, 02h                             ;Se imprime x^grado
        mov dl, 120
        int 21h
        mov ah, 02h
        mov dl, 94
        int 21h
        mov ah, 02h
        mov dl, 51
        int 21h
    mostrargradodos:
        xor al, al
        mov al, byte[arreglofunciones + si + 7]    ;Se mira si el valor es cero del coeeficiente
        cmp al, 0
        je mostrargradouno                   ;Si el valor es sero se pasa al otro grado
        xor al, al
        mov al, byte[arreglofunciones + si + 6]    ;Se mira el signo del numero
        cmp al, 0
        je mostrardosmas                         ;Si es positivo salta
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 45
        int 21h
        jmp mostrardos
    mostrardosmas:
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 43
        int 21h
    mostrardos:
        mov al, byte[arreglofunciones + si + 7]   ;Se obtiene el numeroador
        mov [valor], al
        mov edi, 0
        call separarnumero                      ;Se separa el numero
        call imprimirnumero                     ;Se imprime el numero

        xor al, al
        mov al, byte[arreglofunciones + si + 8]    ;Si el obtiene el numerodor 
        cmp al, byte[uno]                               ;Si es uno se salta al grado
        je imprimirgradodos
        mov ah, 02h                             ;Se imprime signo de division
        mov dl, 47
        int 21h
        mov al, byte[arreglofunciones + si + 8]   ;Se obtiene el denominador
        mov [valor], al                        ;Se imprime el denomidadot
        mov edi, 0
        call separarnumero
        call imprimirnumero
    imprimirgradodos:
        mov ah, 02h                             ;Se imprime x^grado
        mov dl, 120
        int 21h
        mov ah, 02h
        mov dl, 94
        int 21h
        mov ah, 02h
        mov dl, 50
        int 21h
    mostrargradouno:
        xor al, al
        mov al, byte[arreglofunciones + si + 4]    ;Se mira si el valor es cero del coeeficiente
        cmp al, 0
        je mostrargradocero                   ;Si el valor es sero se pasa al otro grado
        xor al, al
        mov al, byte[arreglofunciones + si + 3]    ;Se mira el signo del numero
        cmp al, 0
        je mostrarunomas                         ;Si es positivo salta
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 45
        int 21h
        jmp mostraruno
    mostrarunomas:
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 43
        int 21h
    mostraruno:
        mov al, byte[arreglofunciones + si + 4]   ;Se obtiene el numeroador
        mov [valor], al
        mov edi, 0
        call separarnumero                      ;Se separa el numero
        call imprimirnumero                     ;Se imprime el numero

        xor al, al
        mov al, byte[arreglofunciones + si + 5]    ;Si el obtiene el numerodor 
        cmp al, byte[uno]                               ;Si es uno se salta al grado
        je imprimirgradouno
        mov ah, 02h                             ;Se imprime signo de division
        mov dl, 47
        int 21h
        mov al, byte[arreglofunciones + si + 5]   ;Se obtiene el denominador
        mov [valor], al                        ;Se imprime el denomidadot
        mov edi, 0
        call separarnumero
        call imprimirnumero
    imprimirgradouno:
        mov ah, 02h                             ;Se imprime x^grado
        mov dl, 120
        int 21h
        mov ah, 02h
        mov dl, 94
        int 21h
        mov ah, 02h
        mov dl, 49
        int 21h
    mostrargradocero:
        xor ax, ax
        mov al, byte[arreglofunciones + si + 1]    ;Se mira si el valor es cero del coeeficiente
        cmp al, 0
        je repetirmostrar                   ;Si el valor es sero se pasa al otro grado
        xor al, al
        mov al, byte[arreglofunciones + si]    ;Se mira el signo del numero
        cmp al, 0
        je mostrarceromas                         ;Si es positivo salta
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 45
        int 21h
        jmp mostrarcero
    mostrarceromas:
        mov ah, 02h                             ;Se imprime signo menos
        mov dl, 43
        int 21h
    mostrarcero:
        mov al, byte[arreglofunciones + si + 1]   ;Se obtiene el numeroador
        mov [valor], al
        mov edi, 0
        call separarnumero                      ;Se separa el numero
        call imprimirnumero                     ;Se imprime el numero

        xor al, al
        mov al, byte[arreglofunciones + si + 2]    ;Si el obtiene el numerodor 
        cmp al, byte[uno]                               ;Si es uno se salta al grado
        je repetirmostrar
        mov ah, 02h                             ;Se imprime signo de division
        mov dl, 47
        int 21h
        mov al, byte[arreglofunciones + si + 2]   ;Se obtiene el denominador
        mov [valor], al                        ;Se imprime el denomidadot
        mov edi, 0
        call separarnumero
        call imprimirnumero
    repetirmostrar:
        mov dl, [numerorecorrer]
        inc dl
        mov [numerorecorrer], dl
        mov al, [numerofunciones]
        mov dl, [numerorecorrer]
        cmp al, dl
        jne mostrarfuncion
        ret 


nohayfunciones:
    mov dx, msjnohayfunciones           ;Se muestra mensaje que no hay funciones guardadas
    call escribir
    mov ah, 08                          ;Se espera que presione una tecla para regresar al menu
    int 21h
    pop edi
    pop esi
    pop edx
    pop ebx
    pop eax
    pop ecx
    jmp menu


iniciograficar:
    call limpiar                        ;Se limpia la pantalla
    mov bl, [numerofunciones]
    cmp bl, 0                           ;Se verifica que existan funciones guardadas
    je nohayfunciones                   ;Saltga a no hay funciones
    xor ebx, ebx                        ;Se limpia ebx
    mov ebx, 0                          ;Se pasa 0 a ebx
    mov [numerorecorrer], ebx           ;Se reinicia el numero recorre
    call pantallagrande                 ;Se llama a pantalla grande
    call pintarejes                     ;Se llama a pintar ejes
    jmp pintarfuncion                   ;Salto a pintar funcio

pintarejes:
    xor bx, bx                          ;Se limpia bx
    mov bx, 0                           ;Se pasa 0 a bx
    mov [numcar], bx                    ;Se reinicia numcar con 0
    ciclox:                             ;Inicio ciclo para pintar eje y
        pintar_pixel 6, 160, [numcar]   ;Se pinta un pixel de color 6 en las cordenadas x = 160, y = numcar
        mov bx, [numcar]                ;Se mueve a bx numcar
        inc bx                          ;Se incrementa bx
        mov [numcar], bx                ;Se mueve a numcar bx
        cmp bx, 200                     ;Se compara si ya llego al tope
        jne ciclox                      ;Si no es igual se repite el cilos
    mov bx, 0                           ;Se mueve a bx u cero
    mov [numcar], bx                    ;Se mueve a numcar bx
    cicloy: 
        pintar_pixel 6, [numcar], 100   ;Se pinta un pixel en la coordenada x = numcar, y = 100
        mov bx, [numcar]                ;Se mueve a bx numcar
        inc bx                          ;Se incrementa bx
        mov [numcar], bx                ;Se mueve a numcar bx
        cmp bx, 320                     ;Se compara si ya llego al tope
        jne cicloy                      ;Si no es igual se repite el cilos
    ret

pintarfuncion:
    call pantallpequena
    call limpiar
    call pantallagrande
    
    call pintarejes
    call evaluarpintarfuncion
    call evaluarpintarfuncionnegativo
    jmp ciclolectura

ciclolectura:
    call leerteclado
    jmp ciclolectura

evaluarpintarfuncion:
    xor eax, eax
    xor ebx, ebx
    mov eax, [numerorecorrer]           ;Se multiplica por 18 el valor que lleva el recorrer
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
    
    mov si, [numerofuncionespor]        ;Se pasa a si la posicion del inicio de la funcion
   

    xor eax, eax                        ;Se reinician limpia eax
    mov eax, 0                          ;Se pasa 0 a eax
    mov [numx], eax                     ;Se mueve a esta varianñe eax
    mov [sigx], al                      ;Se mueve a esta varianñe al
    mov [resultadogrado0], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado1], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado2], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado3], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado4], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado5], eax          ;Se mueve a esta varianñe eax
    mov [resultadofinal], eax           ;Se mueve a esta varianñe eax
valordexpintar:
    xor eax, eax                        ;Se limpian los registros eax, ebx
    xor ebx, ebx 
    xor eax, eax
    mov eax, 0                          ;Se pasa 0 a eax
    mov [resultadogrado0], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado1], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado2], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado3], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado4], eax          ;Se mueve a esta varianñe eax
    mov [resultadogrado5], eax          ;Se mueve a esta varianñe eax
    mov [resultadofinal], eax           ;Se mueve a esta varianñe eax
    call valoresdex

    mov al, [arreglofunciones + si]     ;Se optiene el signo del grado 
    mov [sigresgrado0], al              ;Se guarda el signo del grado 
    mov al, [arreglofunciones + si + 1] ;Se obtiene el valor del numerador
    mov [resultadogrado0], al           ;Se guarda el valor del numerador
    
    xor al, al

    mov al, [arreglofunciones + si + 3] ;Se optiene el signo del grado 
    mov [signum1], al                   ;Se guarda el signo del grado 
    mov al, [arreglofunciones + si + 4] ;Se obtiene el valor del numerador
    mov [num1], al                      ;Se guarda el valor del numerador
    
    mov eax, [numx]                     ;Se optiene el valor de x
    mov [num2], eax                     ;Se pasa a num dos
    mov al, [sigx]                      ;Se obtinee el signo de numx
    mov [signum2], al                   ;Se guarda en signum

    call multiplicacion                 ;Se llama a multiplicacion
    xor eax, eax
    mov eax, [resultado]                ;Se guarda el resultado
    mov [resultadogrado1], eax
    xor al, al
    mov al, [sigres]
    
    mov [sigresgrado1], al
    xor al, al
    mov al, [arreglofunciones + si + 6] ;Se optiene el signo del grado 
    mov [signum1], al                   ;Se guarda el signo del grado 
    xor al, al                          ;Se obtiene el valor del numerador
    mov al, [arreglofunciones + si + 7] ;Se guarda el valor del numerador
    mov [num1], al
    
    
    xor al, al                          ;Se pasa a num dos y sig dos los resultados de 
    mov al, [sigresgrado2]              ;la operacion echa antes
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado2]
    
    mov [num2], eax

    call multiplicacion                 ;Se llama a multipliacion
                                        ;Se realiza lo mismo que en losotros grados 
                                        ;Hasta llegar a grado 5
    xor al, al
    mov al, [sigres]
    mov [sigresgrado2], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado2], eax

    xor al, al
    mov al, [arreglofunciones + si + 9]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 10]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado3]
    mov [signum2], al

    xor eax, eax
    mov eax, [resultadogrado3]
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado3], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado3], eax
    
    xor al, al
    mov al, [arreglofunciones + si + 12]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 13]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado4]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado4]
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado4], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado4], eax
    
    xor al, al
    mov al, [arreglofunciones + si + 15]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 16]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado5]
    mov [signum2], al

    xor eax, eax
    mov eax, [resultadogrado5]
    mov [num2], eax

    call multiplicacion

    mov al, [sigres]
    mov [sigresgrado5], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado5], eax
    
                                        ;SUMA INICIO    
    xor eax, eax                        ;Se pasan los valorea a sumar 
    mov al, [sigresgrado0]              ;valor de num1
    mov [signum1], al
    xor eax, eax
    mov eax, [resultadogrado0]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado1]              ;valor de num2
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado1]
    mov [num2], eax
    
    
    call suma                           ;sE SUMA LOS DOS NUMEROS        
    xor al, al                          ;Se guarda los valores
    mov al, [sigres]
    mov [signum1], al                   ;Se ponen los valotrs de nnum1
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    xor al, al                          ;Se le pone valor a num dos
    mov al, [sigresgrado2]              
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado2]
    mov [num2], eax
    
    
    call suma                           ;Se suma y se realiza lo mismo con los otros resultados
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado3]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado3]
    mov [num2], eax
    
    
    call suma
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    mov al, [sigresgrado4]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado4]
    mov [num2], eax

    call suma
    
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    mov al, [sigresgrado5]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado5]
    mov [num2], eax
    
    call suma
    
    xor al, al
    
    mov al, [sigres]
    mov [sigresfinal], al

    xor eax, eax                            ;Se guardan el valor final de la funcion
    mov eax, [resultado]
    mov [resultadofinal], eax

    jmp continuarotroxpintar

continuarotroxpintar:
    cmp eax, 100                            ;Si el valor pasa de 100 no se muestra
    ja continuarevaluacionpintar            
    call pintarvalor                        ;Se pinta el pixel

    mov dl, [numx]                          ;Se aumenta el valor de numx
    inc dl
    mov [numx], dl
    mov al, [numx]

    cmp al, 159                             ;Valor maximo de x 159
    jne valordexpintar                      ;PiNTA OTRO PIXEL
    je continuarevaluacionpintar            

evaluarpintarfuncionnegativo:
    xor eax, eax
    xor ebx, ebx
    mov eax, [numerorecorrer]           ;Se multiplica por 18 el valor que lleva el recorrer
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
    
    mov si, [numerofuncionespor]        ;Se pasa a si la posicion del inicio de la funcion
   
                                        ;Se hace lo mismo que en el antgerio solo que enste los valores de x son negativos
    xor eax, eax
    mov eax, 0  
    mov [numx], eax
    
    mov [resultadogrado0], eax
    mov [resultadogrado1], eax
    mov [resultadogrado2], eax
    mov [resultadogrado3], eax
    mov [resultadogrado4], eax
    mov [resultadogrado5], eax
    mov [resultadofinal], eax
    xor al, al
    mov al, 1
    mov [sigx], al
valordexpintarnegativo:
    xor eax, eax
    xor ebx, ebx 
    xor eax, eax
    mov eax, 0  
    mov [resultadogrado0], eax
    mov [resultadogrado1], eax
    mov [resultadogrado2], eax
    mov [resultadogrado3], eax
    mov [resultadogrado4], eax
    mov [resultadogrado5], eax
    mov [resultadofinal], eax
    call valoresdex

    mov al, [arreglofunciones + si]
    mov [sigresgrado0], al
    mov al, [arreglofunciones + si + 1]
    mov [resultadogrado0], al
    
    xor al, al

    mov al, [arreglofunciones + si + 3]
    mov [signum1], al
    mov al, [arreglofunciones + si + 4]
    mov [num1], al
    
    mov eax, [numx]
    mov [num2], eax
    mov al, [sigx]
    mov [signum2], al

    call multiplicacion
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado1], eax
    xor al, al
    mov al, [sigres]
    
    mov [sigresgrado1], al
    xor al, al
    mov al, [arreglofunciones + si + 6]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 7]
    mov [num1], al
    
    
    xor al, al
    mov al, [sigresgrado2]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado2]
    
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado2], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado2], eax

    xor al, al
    mov al, [arreglofunciones + si + 9]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 10]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado3]
    mov [signum2], al

    xor eax, eax
    mov eax, [resultadogrado3]
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado3], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado3], eax
    
    xor al, al
    mov al, [arreglofunciones + si + 12]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 13]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado4]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado4]
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado4], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado4], eax
    
    xor al, al
    mov al, [arreglofunciones + si + 15]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 16]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado5]
    mov [signum2], al

    xor eax, eax
    mov eax, [resultadogrado5]
    mov [num2], eax

    call multiplicacion

    mov al, [sigres]
    mov [sigresgrado5], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado5], eax
    
    ;SUMA INICIO    
    xor eax, eax
    mov al, [sigresgrado0]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultadogrado0]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado1]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado1]
    mov [num2], eax
    
    
    call suma
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado2]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado2]
    mov [num2], eax
    
    
    call suma
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado3]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado3]
    mov [num2], eax
    
    
    call suma
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    mov al, [sigresgrado4]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado4]
    mov [num2], eax

    call suma
    
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    mov al, [sigresgrado5]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado5]
    mov [num2], eax
    
    call suma
    
    xor al, al
    
    mov al, [sigres]
    mov [sigresfinal], al

    xor eax, eax
    mov eax, [resultado]
    mov [resultadofinal], eax

    jmp continuarotroxpintarnegativo

continuarotroxpintarnegativo:
    cmp eax, 100                            ;Si el valor pasa de 100 no se muestra
    ja continuarevaluacionpintar
    call pintarvalor                        ;Se pinta el pixel
    mov dl, [numx]
    inc dl                                  ;Se aumenta el valor de numx
    mov [numx], dl
    mov al, [numx]

    cmp al, 159
    jne valordexpintarnegativo               ;Valor maximo de x 159
    je continuarevaluacionpintar            ;PiNTA OTRO PIXEL

continuarevaluacionpintar:
   ret                                      ;Se retorna 

siguientegrafica:                   
    mov dl, [numerorecorrer]                ;Se incrementa el valor 
    inc dl                          
    mov [numerorecorrer], dl            
    mov al, [numerofunciones]
    mov dl, [numerorecorrer]
    cmp al, dl                             ;Si no es igual se pinta la funcion
    jne pintarfuncion

pintarvalor:
    xor eax, eax                        ;Se pasa el num x a num dos
    mov eax, 160                        ;Se pasa a num 1 160
    mov [num1], eax                     ;Se le suma y se obtiene el valor de x
    xor al, al                          ;Se guarda el valor de x
    mov al, 0
    mov [signum1], al
    xor al, al
    mov al, [sigx]
    mov [signum2], al 
    xor eax, eax
    mov eax, [numx]
    mov [num2], eax
    call suma
    xor eax, eax
    mov eax, [resultado]
    mov [pintarx], eax

    mov eax, 100                          ;Se pasa a num 1 100
    mov [num1], eax                       ;Se pasa a num2 el valor obtenido
    xor al, al                            ;Se resta el valor a num
    mov al, 0                             ;Se Guarda el valor 
    mov [signum1], al
    xor al, al
    mov al, [sigresfinal]
    mov [signum2], al 
    xor eax, eax
    mov eax, [resultadofinal]
    mov [num2], eax
    call resta
    xor eax, eax
    mov eax, [resultado]
    mov [pintary], eax

    pintar_pixel 15, [pintarx], [pintary]   ;Se Pinta el pixel de color blanco en esas cooordenadas
    ret

leerteclado:
    mov ah, 01h
    int 16h

    jz nopintar                     ;ninguna tecla se presiono

    mov ah, 0
    int 16h

    cmp al, 0
    jne nopintar                    ; por si se presiono un ascii


    cmp ah, 4dh                     ;flecha de la derecha presionada
    je derecha

    cmp ah, 4bh
    je izquierda                    ;Flecha de la izquierda preionada
    jne nopintar

derecha:
    mov dl, [numerorecorrer]        ;Se aumeta el valor
    inc dl                          ;Si es igual al numero de funciones se regresa al menu
    mov [numerorecorrer], dl        ;Si no se pinta la funcion
    mov al, [numerofunciones]
    mov dl, [numerorecorrer]
    cmp al, dl
    jne pintarfuncion
    je fingraficar

izquierda:
    mov dl, [numerorecorrer]        ;Se reduce el numero en el que esta
    cmp dl, 0                       ;Si es cero no se reduce
    je nopintar                     ;Se llama a pintar funcion
    dec dl
    mov [numerorecorrer], dl
    mov al, [numerofunciones]
    mov dl, [numerorecorrer]
    cmp al, dl
    jne pintarfuncion
    je fingraficar

nopintar:
    ret                             ;Regtorna

fingraficar:
    call pantallpequena             ;Se cambia a pantalla peqeña y se regresa al menu
    mov ah, 08
    int 21h
    jmp menu


inicioresolver:
    call limpiar                        ;Se limpia la pantalla

    call reiniciartemporal
    call pedirfuncionresolver

    mov al, byte[funciontemporal+4]
    cmp al, 0
    je notienesolucion

    mov [denominadorresolver], al

    mov al, byte[funciontemporal + 1]
    mov [numresolver], al

    mov al, byte[funciontemporal]
    cmp al, 0
    je cambiarsigno
    mov al, 0
    jmp continuarresolver
    cambiarsigno:
    mov al, 1
    continuarresolver:
    mov bl, byte[funciontemporal + 3]
    xor al, bl
    mov [signonumresolver], al

    mov dx, msjsolucion
    call escribir

    mov ah, 02h
    mov dl, 120
    int 21h
    mov ah, 02h
    mov dl, 61
    int 21h

    mov al, [signonumresolver]
    cmp al, 0
    je continuarmuestraresultado
    mov ah, 02h
    mov dl, 45
    int 21h
    continuarmuestraresultado:
    mov al, [numresolver]
    mov [valor], al
    mov edi, 0
    call separarnumero                      ;Se separa el numero
    call imprimirnumero                     ;Se imprime el numero
    mov ah, 02h
    mov dl, 32
    int 21h
    mov ah, 02h
    mov dl, 47
    int 21h
    mov al, [denominadorresolver]
    mov [valor], al
    mov edi, 0
    call separarnumero                      ;Se separa el numero
    call imprimirnumero                     ;Se imprime el numero
    jmp resolverconcatenarrespuesta

notienesolucion:
    mov dx, msjnotienesolucion
    call escribir
    call concatenarrespuesta
    call concatenarnotienesolucion
    jmp finresolver

resolverconcatenarrespuesta:
    call concatenarrespuesta
    call concatenarsolucion


    
    jmp finresolver

finresolver:
    mov ah, 08
    int 21h
    jmp menu

concatenarrespuesta:
    mov bx, 0
    mov [connum], bx
    mov si, concatenarresolver 
    mov di, msjfuncion  
    mov bx, [numresolvercon]
    jmp concatenarrespuestaparteuno

concatenarrespuestaparteuno:
    mov [numresolvercon], bx
    mov cl, [connum]
    cmp cl, 10
    jne continuaconcatenarrespuestaparteuno
    je concatenarnum1

continuaconcatenarrespuestaparteuno:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatenarrespuestaparteuno

concatenarnum1:
    mov al, byte[funciontemporal + 3]
    cmp al, [uno]
    je concatmenos

    mov edi, [cero]
    mov al, byte[funciontemporal + 4]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumero

concatmenos:
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov al, byte[funciontemporal + 4]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumero

concatnumero:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumero
	je concatenarrespuestapartedos

concatenarrespuestapartedos:
    mov dl, 120
    mov [si + bx], dl
    inc bx
    mov [numresolvercon], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatenarresolver
    mov bx, [numresolvercon]
    jmp concatenarnumdos

concatenarnumdos:
    mov al, byte[funciontemporal]
    cmp al, [uno]
    je concatmenosdos
    mov dl, 43
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov al, byte[funciontemporal + 1]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerodos

concatmenosdos:
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov al, byte[funciontemporal + 1]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerodos

concatnumerodos:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi,edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerodos
    mov [numresolvercon], bx
	ret

concatenarsolucion:
    mov bx, 0
    mov [connum], bx
    mov si, concatenarresolver 
    mov di, msjsolucion  
    mov bx, [numresolvercon]
    jmp concatenarsolucioncont

concatenarsolucioncont:
    mov [numresolvercon], bx
    mov cl, [connum]
    cmp cl, 12
    jne continuaconcatenarsolucioncont
    je concatenarnumerorespuesta

continuaconcatenarsolucioncont:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatenarsolucioncont

concatenarnumerorespuesta:
    mov dl, 120
    mov [si + bx], dl
    inc bx
    mov dl, 61
    mov [si + bx], dl
    inc bx
    mov al, byte[signonumresolver]
    cmp al, [uno]
    je concatmenosresp

    mov edi, [cero]
    mov al, byte[funciontemporal + 1]
    mov [numresolver], al
    mov al, [numresolver]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerorespuesta

concatmenosresp:
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov al, byte[funciontemporal + 1]
    mov [numresolver], al
    mov al, [numresolver]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerorespuesta

concatnumerorespuesta:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax	
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerorespuesta
	je concatenardenominador

concatenardenominador:
    mov dl, 47
    mov [si + bx], dl
    inc bx
    mov [numresolvercon], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatenarresolver
    mov bx, [numresolvercon]
    jmp concatenarnumdenominador


concatenarnumdenominador:
    mov edi, [cero]
    mov al, [denominadorresolver]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerodosdenominador

concatnumerodosdenominador:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi,edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerodosdenominador
    mov [numresolvercon], bx
	ret

concatenarnotienesolucion:
    mov bx, 0
    mov [connum], bx
    mov si, concatenarresolver 
    mov di, msjnotienesolucion  
    mov bx, [numresolvercon]
    jmp concatenarnotienesolucioncont

concatenarnotienesolucioncont:
    mov [numresolvercon], bx
    mov cl, [connum]
    cmp cl, 20
    jne continuaconcatenarnotienesolucioncont
    mov [numresolvercon], bx
    ret

continuaconcatenarnotienesolucioncont:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatenarnotienesolucioncont

pedirfuncionresolver:
    mov dx, msjgradocero                ;Se piede el grado cero
    call escribir
    mov ah, 01h                         ;Se pide un caracter
    int 21h

    cmp al, 45                          ;Si es signo menos salta a ponermenos
    je ponermenosres
    xor bl, bl                          ;Si no es menos el signo del numero es positivo
    mov bl, 0
    mov [signonumero], bl                ;Se mueve a signonumero un cero
    jmp ingresonumerores                 ;Continua con el ingreso del numero

ponermenosres:
    xor bl, bl
    mov bl, 1                           ;Para negativo se usa el un uno
    mov [signonumero], bl                ;Se mueve a signo numero un uno
    mov ah, 01h                         ;Se pide otro caracter
    int 21h
    jmp ingresonumerores                   ;Continua con el ingreso del numero 

ingresonumerores:
    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresores                 ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresores
    cmp al, 50
    je continuaringresores
    cmp al, 51
    je continuaringresores
    cmp al, 52
    je continuaringresores
    cmp al, 53
    je continuaringresores
    cmp al, 54
    je continuaringresores
    cmp al, 55
    je continuaringresores
    cmp al, 56
    je continuaringresores
    cmp al, 57
    je continuaringresores
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresores:
    sub al, 30h                         ;Se le resta 30h que es 48 para obtener el numero 
    mov [decenas], al                   ;Se mueve a las decenas el numeor
    mov ah, 01h                         ;Se piede el siguiente numero
    int 21h

    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresores2                ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresores2
    cmp al, 50
    je continuaringresores2
    cmp al, 51
    je continuaringresores2
    cmp al, 52
    je continuaringresores2
    cmp al, 53
    je continuaringresores2
    cmp al, 54
    je continuaringresores2
    cmp al, 55
    je continuaringresores2
    cmp al, 56
    je continuaringresores2
    cmp al, 57
    je continuaringresores2
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresores2:
    sub al, 30h                         ;Se resta 30h para obtener el numero
    mov [unidades], al                  ;Se mueve a las unidades el numero

    mov al, [decenas]                   ;Se mueve al las decenas
    mul dword [diez]                    ;Se multiplica por 10 al
    add al, [unidades]                  ;Se le suman las unidades a al
    mov [numero], al                    ;Se guarda el numero

    mov bl, [signonumero]               ;Se mueve a bl el signo
    mov [funciontemporal], bl           ;Se mueve la funcion temporal bl
    mov bl, [numero]                    ;Se mueve a bl el numero
    mov [funciontemporal + 1], bl       ;Se mueve a la funcion temporal bl
    mov bl, byte[uno]                           ;Se mueve a bl uno
    mov [funciontemporal + 2], bl       ;Se mueve a la funcion temporal bl

    mov dx, msjgradouno                 ;Se piede el grado uno
    call escribir

    mov ah, 01h                         ;Se pide un caracter
    int 21h

    cmp al, 45                          ;Si es signo menos salta a ponermenos
    je ponermenosunores
    xor bl, bl                          ;Si no es menos el signo del numero es positivo
    mov bl, 0
    mov [signonumero], bl                ;Se mueve a signonumero un cero
    jmp ingresonumerounores                ;Continua con el ingreso del numero

ponermenosunores:
    xor bl, bl
    mov bl, byte[uno]                           ;Para negativo se usa el un uno
    mov [signonumero], bl                ;Se mueve a signo numero un uno
    mov ah, 01h                         ;Se pide otro caracter
    int 21h
    jmp ingresonumerounores                ;Continua con el ingreso del numero 

ingresonumerounores:
    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresounores              ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresounores
    cmp al, 50
    je continuaringresounores
    cmp al, 51
    je continuaringresounores
    cmp al, 52
    je continuaringresounores
    cmp al, 53
    je continuaringresounores
    cmp al, 54
    je continuaringresounores
    cmp al, 55
    je continuaringresounores
    cmp al, 56
    je continuaringresounores
    cmp al, 57
    je continuaringresounores
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresounores:
    sub al, 30h                         ;Se le resta 30h que es 48 para obtener el numero 
    mov [decenas], al                   ;Se mueve a las decenas el numeor
    mov ah, 01h                         ;Se piede el siguiente numero
    int 21h

    cmp al, 48                          ;Se comprueba que sea un numero el caracter ingresado
    je continuaringresounores2             ;Si es un numero entre 0 - 9 se continua el ingreso del numero
    cmp al, 49
    je continuaringresounores2
    cmp al, 50
    je continuaringresounores2
    cmp al, 51
    je continuaringresounores2
    cmp al, 52
    je continuaringresounores2
    cmp al, 53
    je continuaringresounores2
    cmp al, 54
    je continuaringresounores2
    cmp al, 55
    je continuaringresounores2
    cmp al, 56
    je continuaringresounores2
    cmp al, 57
    je continuaringresounores2
    jne noesnumero                      ;Si no es numero termina el ingreso del numero

continuaringresounores2:
    sub al, 30h                         ;Se resta 30h para obtener el numero
    mov [unidades], al                  ;Se mueve a las unidades el numero

    mov al, [decenas]                   ;Se mueve al las decenas
    mul dword [diez]                    ;Se multiplica por 10 al
    add al, [unidades]                  ;Se le suman las unidades a al
    mov [numero], al                    ;Se guarda el numero

    mov bl, [signonumero]               ;Se mueve a bl el signo
    mov [funciontemporal + 3], bl       ;Se mueve la funcion temporal bl
    mov bl, [numero]                    ;Se mueve a bl el numero
    mov [funciontemporal + 4], bl       ;Se mueve a la funcion temporal bl
    mov bl, byte[uno]                           ;Se mueve a bl uno
    mov [funciontemporal + 5], bl       ;Se mueve a la funcion temporal bl
    ret

inicioreporte:
    call limpiar                        ;limpia la pantalla
    mov dx, menureporte                 ;mueve a dx el contenido menu
    call escribir                       ;llama a escribi par imprimir en pantalla 

    mov ah, 01                          ;mover a ah 01 para usar la int 21h
    int 21h                             ;leer un carecter con echo

    cmp al, 49                          ;opcion 01 reporte funciones
    je reportefunciones

    cmp al, 50                          ;opcion 02 reporte ecuaciones
    je reporteecuadiones

    cmp al, 51                          ;opcion 03 regresa menu
    je menu
    jne inicioreporte                   ;opcion invalida

reporteecuadiones:
    escribir_archivo rutareporteecuaciones, numresolvercon,  concatenarresolver
    mov ah, 08
    int 21h
    jmp inicioreporte

reportefunciones:
    mov bx, 0
    mov [numreporteuno], bx
    call inicioevaluarfuncion
    escribir_archivo rutareportefunciones, numreporteuno,  concatenarreportefun
    mov ah, 08
    int 21h
    jmp inicioreporte


inicioevaluarfuncion:
    mov bl, [numerofunciones]
    cmp bl, 0                           ;Se verifica que existan funciones guardadas
    je nohayfunciones
    xor ebx, ebx
    mov ebx, 0                           
    mov [numerorecorrer], ebx
    push si
    mov [numx], ebx
    mov [sigx], bl
    jmp evaluar

evaluar:
    xor eax, eax
    xor ebx, ebx
    mov eax, [numerorecorrer]           ;Se multiplica por 18 el valor que lleva el recorrer
    mov ebx, 18
    mul ebx
    mov [numerofuncionespor], eax
    
    mov si, [numerofuncionespor]        ;Se pasa a si la posicion del inicio de la funcion
   
    mov [siactuall], si
    call concatenarfuncionreporteuno
    mov si, [siactuall]

    xor eax, eax
    mov eax, 0  
    mov [numx], eax
    mov [sigx], al
    mov [resultadogrado0], eax
    mov [resultadogrado1], eax
    mov [resultadogrado2], eax
    mov [resultadogrado3], eax
    mov [resultadogrado4], eax
    mov [resultadogrado5], eax
    mov [resultadofinal], eax
valordex:
    xor eax, eax
    xor ebx, ebx 
    xor eax, eax
    mov eax, 0  
    mov [resultadogrado0], eax
    mov [resultadogrado1], eax
    mov [resultadogrado2], eax
    mov [resultadogrado3], eax
    mov [resultadogrado4], eax
    mov [resultadogrado5], eax
    mov [resultadofinal], eax
    call valoresdex

    mov al, [arreglofunciones + si]
    mov [sigresgrado0], al
    mov al, [arreglofunciones + si + 1]
    mov [resultadogrado0], al
    
    xor al, al

    mov al, [arreglofunciones + si + 3]
    mov [signum1], al
    mov al, [arreglofunciones + si + 4]
    mov [num1], al
    
    mov eax, [numx]
    mov [num2], eax
    mov al, [sigx]
    mov [signum2], al

    call multiplicacion
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado1], eax
    xor al, al
    mov al, [sigres]
    
    mov [sigresgrado1], al
    xor al, al
    mov al, [arreglofunciones + si + 6]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 7]
    mov [num1], al
    
    
    xor al, al
    mov al, [sigresgrado2]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado2]
    
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado2], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado2], eax

    xor al, al
    mov al, [arreglofunciones + si + 9]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 10]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado3]
    mov [signum2], al

    xor eax, eax
    mov eax, [resultadogrado3]
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado3], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado3], eax
    
    xor al, al
    mov al, [arreglofunciones + si + 12]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 13]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado4]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado4]
    mov [num2], eax

    call multiplicacion

    xor al, al
    mov al, [sigres]
    mov [sigresgrado4], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado4], eax
    
    xor al, al
    mov al, [arreglofunciones + si + 15]
    mov [signum1], al
    xor al, al
    mov al, [arreglofunciones + si + 16]
    mov [num1], al
    
    xor al, al
    mov al, [sigresgrado5]
    mov [signum2], al

    xor eax, eax
    mov eax, [resultadogrado5]
    mov [num2], eax

    call multiplicacion

    mov al, [sigres]
    mov [sigresgrado5], al
    xor eax, eax
    mov eax, [resultado]
    mov [resultadogrado5], eax
    
    ;SUMA INICIO    
    xor eax, eax
    mov al, [sigresgrado0]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultadogrado0]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado1]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado1]
    mov [num2], eax
    
    
    call suma
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado2]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado2]
    mov [num2], eax
    
    
    call suma
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    xor al, al
    mov al, [sigresgrado3]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado3]
    mov [num2], eax
    
    
    call suma
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    mov al, [sigresgrado4]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado4]
    mov [num2], eax

    call suma
    
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax

    mov al, [sigresgrado5]
    mov [signum2], al
    xor eax, eax
    mov eax, [resultadogrado5]
    mov [num2], eax
    
    call suma
    
    xor al, al
    
    mov al, [sigres]
    mov [sigresfinal], al

    xor eax, eax
    mov eax, [resultado]
    mov [resultadofinal], eax

    jmp continuarotrox

continuarotrox:
    mov [siactuall], si
    call concatenarvalordefuncion
    mov si, [siactuall]
    mov dl, [numx]
    inc dl
    mov [numx], dl
    mov al, [numx]

    cmp al, 5
    jne valordex
    je continuarevaluacion

continuarevaluacion:
    mov dl, [numerorecorrer]
    inc dl
    mov [numerorecorrer], dl
    mov al, [numerofunciones]
    mov dl, [numerorecorrer]
    cmp al, dl
    jne evaluar
    pop si
    ret

concatenarfuncionreporteuno:
    mov bx, 0
    mov [connum], bx
    
    mov si, concatenarreportefun 
    mov di, msjfuncion  
    mov bx, [numreporteuno]
    jmp concatenarecuacionparteuno

concatenarecuacionparteuno:
    mov [numreporteuno], bx
    mov cl, [connum]
    cmp cl, 10
    jne continuaconcatenarecuacionparteuno
    je concatenargrado5reporteuno

continuaconcatenarecuacionparteuno:
    mov dl, [di]
    mov [si + bx], dl
    inc bx
    inc di
    mov cl, [connum]
    add cl, 1
    mov [connum], cl
    jmp concatenarecuacionparteuno

concatenargrado5reporteuno:
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 16]
    mov si, concatenarreportefun
    cmp al, 0
    je concatenargrado4reporteuno
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 15]
    mov si, concatenarreportefun
    cmp al, [uno]
    je concatmenosgrado5

    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 16]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado5

concatmenosgrado5:
    mov si, concatenarreportefun 
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 16]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    mov si, concatenarreportefun 
    jmp concatnumerogrado5

concatnumerogrado5:
    
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerogrado5
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 17]
    mov si, concatenarreportefun
    cmp al, 1
    jne concatenardenominadorgrado5
	je concatenarxgrado5

concatenardenominadorgrado5:
    
    mov si, concatenarreportefun 
    mov dl, 47
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 17]
    mov si, concatenarreportefun 
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    
    jmp concatdenominadorgrado5

concatdenominadorgrado5:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatdenominadorgrado5
	jne concatenarxgrado5

concatenarxgrado5:
    mov si, concatenarreportefun 
    mov [numreporteuno], bx
    mov dl, 120
    mov [si + bx], dl
    inc bx
    mov dl, 94
    mov [si + bx], dl
    inc bx
    mov dl, 53
    mov [si + bx], dl
    inc bx
    mov [numreporteuno], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatenarreportefun
    mov bx, [numreporteuno]
    jmp concatenargrado4reporteuno

concatenargrado4reporteuno:
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 13]
    mov si, concatenarreportefun
    cmp al, 0
    je concatenargrado3reporteuno
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 12]
    mov si, concatenarreportefun
    cmp al, 1
    je concatmenosgrado4
    mov dl, 43
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 13]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado4

concatmenosgrado4:
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 13]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado4

concatnumerogrado4:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerogrado4
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 14]
    mov si, concatenarreportefun

    cmp al, 1
    jne concatenardenominadorgrado4
	je concatenarxgrado4

concatenardenominadorgrado4:
    mov dl, 47
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 14]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    
    jmp concatdenominadorgrado4

concatdenominadorgrado4:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatdenominadorgrado4
	jne concatenarxgrado4

concatenarxgrado4:
    mov si, concatenarreportefun
    mov [numreporteuno], bx
    mov dl, 120
    mov [si + bx], dl
    inc bx
    mov dl, 94
    mov [si + bx], dl
    inc bx
    mov dl, 52
    mov [si + bx], dl
    inc bx
    mov [numreporteuno], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatenarreportefun
    mov bx, [numreporteuno]
    jmp concatenargrado3reporteuno

concatenargrado3reporteuno:
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 10]
    mov si, concatenarreportefun
    cmp al, 0
    je concatenargrado2reporteuno
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 9]
    mov si, concatenarreportefun
    cmp al, [uno]
    je concatmenosgrado3
    mov dl, 43
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 10]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    
    jmp concatnumerogrado3

concatmenosgrado3:
    mov si, concatenarreportefun
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 10]
    mov si, concatenarreportefun
    call separarnumero
    mov [valor], al
    
    mov [numedi], edi
    
    jmp concatnumerogrado3

concatnumerogrado3:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi, 1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerogrado3

    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 11]
    mov si, concatenarreportefun
    cmp al, 1
    jne concatenardenominadorgrado3
	je concatenarxgrado3

concatenardenominadorgrado3:
    mov dl, 47
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 11]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatdenominadorgrado3

concatdenominadorgrado3:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatdenominadorgrado3
	jne concatenarxgrado3

concatenarxgrado3:
    mov [numreporteuno], bx
    mov dl, 120
    mov [si + bx], dl
    inc bx
    mov dl, 94
    mov [si + bx], dl
    inc bx
    mov dl, 51
    mov [si + bx], dl
    inc bx
    mov [numreporteuno], bx
    mov bx, 0
    mov [connum], bx
    mov si, [siactuall]
    mov bx, [numreporteuno]
    jmp concatenargrado2reporteuno

concatenargrado2reporteuno:
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 7]
    mov si, concatenarreportefun
    cmp al, 0
    je concatenargrado1reporteuno
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 6]
    mov si, concatenarreportefun
    cmp al, [uno]
    je concatmenosgrado2
    mov dl, 43
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 7]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado2

concatmenosgrado2:
    mov si, concatenarreportefun
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 7]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado2

concatnumerogrado2:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerogrado2
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 8]
    mov si, concatenarreportefun
    cmp al, 1
    jne concatenardenominadorgrado2
	je concatenarxgrado2

concatenardenominadorgrado2:
    mov dl, 47
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 8]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatdenominadorgrado2

concatdenominadorgrado2:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatdenominadorgrado2
	jne concatenarxgrado2

concatenarxgrado2:
    mov [numreporteuno], bx
    mov dl, 120
    mov [si + bx], dl
    inc bx
    mov dl, 94
    mov [si + bx], dl
    inc bx
    mov dl, 50
    mov [si + bx], dl
    inc bx
    mov [numreporteuno], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatenarreportefun
    mov bx, [numreporteuno]
    jmp concatenargrado1reporteuno

concatenargrado1reporteuno:
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 4]
    mov si, concatenarreportefun
    cmp al, 0
    je concatenargrado0reporteuno
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 3]
    mov si, concatenarreportefun
    cmp al, [uno]
    je concatmenosgrado1
    mov dl, 43
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 4]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado1

concatmenosgrado1:
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 4]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado1

concatnumerogrado1:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerogrado1

    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 5]
    mov si, concatenarreportefun
    cmp al, 1
    jne concatenardenominadorgrado1
	je concatenarxgrado1

concatenardenominadorgrado1:
    mov dl, 47
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 5]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatdenominadorgrado1

concatdenominadorgrado1:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi, 1
    mov [numedi], edi

	cmp edi ,0
	jge concatdenominadorgrado1
	jne concatenarxgrado1

concatenarxgrado1:
    mov [numreporteuno], bx
    mov dl, 120
    mov [si + bx], dl
    inc bx

    mov [numreporteuno], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatenarreportefun
    mov bx, [numreporteuno]
    jmp concatenargrado0reporteuno

concatenargrado0reporteuno:
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 1]
    mov si, concatenarreportefun
    cmp al, 0
    je finconcatenarecuacion
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si]
    mov si, concatenarreportefun
    cmp al, [uno]
    je concatmenosgrado0
    mov dl, 43
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 1]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado0

concatmenosgrado0:
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 1]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumerogrado0

concatnumerogrado0:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumerogrado0

    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 2]
    mov si, concatenarreportefun
    cmp al, 1
    jne concatenardenominadorgrado0
	je concatenarxgrado0

concatenardenominadorgrado0:
    mov dl, 47
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov si, [siactuall]
    mov al, byte[arreglofunciones + si + 2]
    mov si, concatenarreportefun
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatdenominadorgrado0

concatdenominadorgrado0:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi, 1
    mov [numedi], edi

	cmp edi ,0
	jge concatdenominadorgrado0
	jne concatenarxgrado0

concatenarxgrado0:

    mov [numreporteuno], bx
    mov bx, 0
    mov [connum], bx
    mov si, concatenarreportefun
    mov bx, [numreporteuno]
    jmp finconcatenarecuacion

finconcatenarecuacion:
    mov bx, [numreporteuno]
    mov dl, 13
    mov [si + bx], dl
    inc bx
    mov dl, 10
    mov [si + bx], dl
    inc bx
    mov dl, 120
    mov [si + bx], dl
    inc bx
    mov dl, 44
    mov [si + bx], dl
    inc bx
    mov dl, 121
    mov [si + bx], dl
    inc bx
    mov dl, 13
    mov [si + bx], dl
    inc bx
    mov dl, 10
    mov [si + bx], dl
    inc bx
    mov [numreporteuno], bx
ret
;Se encarga de cocatenar el para el reporte 2
concatenarvalordefuncion:
    mov bx, 0
    mov [connum], bx
    mov si, concatenarreportefun 
    mov di, msjfuncion  
    mov bx, [numreporteuno]
    mov dl, [numx]
    add dl, 30h
    mov [si + bx], dl
    inc bx
    mov dl, 44
    mov [si + bx], dl
    inc bx

    mov al, [sigresfinal]
    cmp al, [uno]
    je concatmenosresultadofinal

    mov edi, [cero]
    xor eax, eax
    mov eax, [resultadofinal]
    mov [valor], eax
    call separarnumero
    mov [numedi], edi
    jmp concatnumeroresultadofinal

concatmenosresultadofinal:
    mov dl, 45
    mov [si + bx], dl
    inc bx
    mov edi, [cero]
    mov al, [resultadofinal]
    mov [valor], al
    call separarnumero
    mov [numedi], edi
    jmp concatnumeroresultadofinal

concatnumeroresultadofinal:
    mov edi, [numedi]
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
	
    mov dl, [digt]
    
    mov [si + bx], dl
    inc bx

    xor edi, edi
    mov edi, [numedi]

	sub edi,1
    mov [numedi], edi

	cmp edi ,0
	jge concatnumeroresultadofinal
	je finconcatenarresultadofinal

finconcatenarresultadofinal:
    mov dl, 13
    mov [si + bx], dl
    inc bx
    mov dl, 10
    mov [si + bx], dl
    inc bx
    mov [numreporteuno], bx
    ret

valoresdex:
    xor eax, eax                            ;Realiza la muntiplicacion de x varias veces
    mov eax, [numx]
    mov [num1], eax
    mov [num2], eax
    xor al, al
    mov al, [sigx]
    mov [signum1], al
    mov [signum2], al

    ;cuadrado

    call multiplicacion                     ;Se guarda el valor al cuadrado
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax
    mov [resultadogrado2], eax
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    mov [sigresgrado2], al
    ;cubico
    call multiplicacion                 ;Se guarda el calor al cubo
    xor eax, eax
    mov eax, [resultado]
    mov [num1], eax
    mov [resultadogrado3], eax
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    mov [sigresgrado3], al
    ;al cuarta
    call multiplicacion
    xor eax, eax                        ;SE GUARDA EL VALRO ALA 4
    mov eax, [resultado]
    mov [num1], eax
    mov [resultadogrado4], eax
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    mov [sigresgrado4], al
    ;al quinta
    call multiplicacion
    xor eax, eax                        ;Guarda el valro ala 5
    mov [num1], eax
    mov eax, [resultado]
    mov [resultadogrado5], eax
    xor al, al
    mov al, [sigres]
    mov [signum1], al
    mov [sigresgrado5], al
    ret
;SE realiza la suma de num1 y num2
suma:
    xor eax, eax
    xor edx, edx
    mov bl, [signum1]
    cmp bl, [uno]
    je sumapmenos
    
    mov bl, [signum2]
    cmp bl, [uno]
    je sumasmenos

    mov eax, [num1]
    mov edx, [num2]
    add eax, edx
    mov [resultado], eax
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    jmp continuarcal

sumapmenos:
    xor bx, bx
    mov bl, [signum2]
    cmp bl, [uno]
    je sumapmesme
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    cmp eax, edx
    je numerosigualesresta
    ja sprmensegmas
    jb ssegmaspmenos

sprmensegmas:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    sub eax, edx
    mov [resultado], eax
    xor ax, ax
    mov al, [uno]
    mov [sigres], al
    jmp continuarcal

ssegmaspmenos:
    xor eax, eax
    xor edx, edx
    mov eax, [num2]
    mov edx, [num1]
    sub eax, edx
    mov [resultado], eax
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    jmp continuarcal

numerosigualesresta:
    xor eax, eax
    xor edx, edx
    mov eax, [cero]
    mov [resultado], eax
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    jmp continuarcal

sumapmesme:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    add eax, edx
    mov [resultado], eax
    xor ax, ax
    mov al, [uno]
    mov [sigres], al
    jmp continuarcal

sumasmenos:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    cmp eax, edx
    je numerosigualesresta
    ja ssegmemenpmas
    jb ssegmemaypmas
    

ssegmemaypmas:
    xor eax, eax
    xor edx, edx
    mov eax, [num2]
    mov edx, [num1]
    sub eax, edx
    mov [resultado], eax
    xor ax, ax
    mov al, [uno]
    mov [sigres], al
    jmp continuarcal

ssegmemenpmas:
    xor eax, eax
    xor edx, edx
    mov eax, [num1]
    mov edx, [num2]
    sub eax, edx
    mov [resultado], eax
    xor ax, ax
    mov al, [cero]
    mov [sigres], al
    jmp continuarcal
;Se encarga de la multiplicacion de num1 y num2
multiplicacion:
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    mov eax, [num1]
    mov ebx, [num2]
    mul ebx
    mov [resultado], eax

    xor al, al
    xor bl, bl
    mov al, [signum1]
    mov bl, [signum2]
    xor al, bl
    mov [sigres], al
    
    jmp continuarcal

;Le cambia el signoa num 2 y llama a suma
resta:
    mov al, [signum2]
    mov bl, [uno]
    xor al, bl
    mov [signum2], al
    jmp suma

continuarcal:
    ret
;Se muestra el mensaje de no archivp
noarchivo:
    mov dx, msjnoarchivo
    call escribir
    mov ah, 08
    int 21h
    jmp menu

escribir:
    mov ah, 09h                         ;Mueve a ah 09 luego con la interrupcion 21h
    int 21h                             ;Se escribe en pantalla el contenido de dx 
    ret                                 ;lo qu eeste en dx debe de finalizar con $

;Se encarga de dividir de diez en diez el valor y guardarlo
separarnumero:
    mov edx,0
    mov eax, [valor]
    div dword [diez]
    mov [digt], edx
    mov [valor], eax

    mov eax, [digt]
    add eax, 48

    mov [valormostrar + edi], eax

    inc edi

    mov eax, [valor]
    cmp eax, 0
    jnz separarnumero
    ret
;Se encarga de mostrar los numeros que antes fueron separados
imprimirnumero:
	mov eax, [valormostrar  + edi]
	mov [digt], eax
	
	mov ah, 02h
    mov dl, [digt]
    int 21h
	
	sub edi,1

	cmp edi,0
	jge imprimirnumero
	ret

;Se limpia la pantla
limpiar:
    mov ax, 0600h           ;limpiar pantalla
    mov bh, 0fh             ;0 color de fondo negro, f color de letra blanco
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

    mov ah, 02h
    mov bh, 00
    mov dh, 00
    mov dl, 00
    int 10h
    ret 

;Se sale del programa
salir:
    mov ah, 4Ch
    int 21h
;Se cambia el tamaño de la pantalla
pantallagrande:
    mov ah, 00h
    mov al, 13h
    int 10h
    ret
;Se cambia el tamaño de la pantalla
pantallpequena:
    mov ah, 00h
    mov al, 3h
    int 10h
    ret
;Muestra el valor del reultado obtenido
mostrarresultado:
    mov dx, msjresultado
    call escribir

    mov edi, [cero]
    mov bl, [sigres]
    cmp bl, [uno]
    je imprimirmenos
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    call imprimirnumero
    ret
;Impime un menos antes:
imprimirmenos:
    mov dx, menos
    call escribir
    mov eax, [resultado]
    mov [valor],eax
    call separarnumero
    call imprimirnumero
    ret 

section .data

menuinicio:             db '|---------------Menu---------------|',13,10 ;menu de inicio
                        db '|1. Derivar Funcion                |',13,10
                        db '|2. Integrar Funcion               |',13,10
                        db '|3. Ingresar Funciones             |',13,10
                        db '|4. Imprimir Funciones             |',13,10
                        db '|5. Graficar                       |',13,10
                        db '|6. Resolver Ecuacion              |',13,10
                        db '|7. Reporte                        |',13,10
                        db '|8. Salir                          |',13,10
                        db '|----------------------------------|',13,10
                        db 'Ingrese una opcion: $',13,10

menuingreso:            db '|-------------Ingresar-------------|',13,10 ;menu de ingreso de datos
                        db '|1. Ingresar Funcion               |',13,10
                        db '|2. Cargar Archivo                 |',13,10
                        db '|3. Regresar                       |',13,10
                        db '|----------------------------------|',13,10
                        db 'Ingrese una opcion: $',13,10 

menureporte:            db '|-------------Ingresar-------------|',13,10 ;menu de reporte de funciones
                        db '|1. Reporte de funciones           |',13,10
                        db '|2. Reporte de ecuaciones          |',13,10
                        db '|3. Regresar                       |',13,10
                        db '|----------------------------------|',13,10
                        db 'Ingrese una opcion: $',13,10 
menos:                  db '-','$'
msjgradocero:           db 'Ingrese coeficiente grado 0: $',13,10
msjgradouno:            db 13,10,'Ingrese coeficiente grado 1: $',13,10
msjgradodos:            db 13,10,'Ingrese coeficiente grado 2: $',13,10
msjgradotres:           db 13,10,'Ingrese coeficiente grado 3: $',13,10
msjgradocuatro:         db 13,10,'Ingrese coeficiente grado 4: $',13,10
msjresultado:           db 13,10,' Resultado: $',13,10
msjfuncioningresado:    db 13,10,'Funcion Ingresada Correctamente $',13,10

msjnoesnumero:          db 'No es un numero el caracter ingresado: $',13,10
msjnohayfunciones:      db 'No hay funciones guardadas $',13,10
msjsolucion:            db 13,10,'Solucion: ',13,10,'$'

msjfuncion:             db 13,10,'Funcion: ',13,10,'$'

cero:                   dd 0
diez:                   dd 10
uno:                    db 1
siactuall:              dw 0

numerorecorrer:         db 0
rutaarchivo:            dw "funcion.txt",0
rutareporteecuaciones:  dw "reporte2.txt",0
rutareportefunciones:   dw "reporte1.txt",0
textoleido:             times 1000 db "$"

textoentrada:           times 100 dw '$', 00h
msjcaracterinvalido:    db 13,10,'Caracter invalido: $',13,10

msjpedirruta:           db 'Ingresar ruta del archivo: $',13,10
msjnoarchivo:           db 'Error en la lectura del archivo',13,10,'$'
msjnotienesolucion:     db 13,10,'No tiene solucion',13,10,'$'

concatenarresolver:     times 500 db '',13,10,'$'
concatenarreportefun:   times 1500 db '',13,10,'$'
connum:                 db 0
numresolver:            db 0
denominadorresolver:    db 1
signonumresolver:       db 0
                        ;grado cero
funciontemporal:        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 0 
arreglofunciones:       db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 1    
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 2     
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 3      
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 4      
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 5      
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 6      
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 7      
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 8     
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 9     
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 10     
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 11     
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 12    
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 13   
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 14 
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        ;grado cero pos 15    
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado uno
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado dos
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado tres
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cuatro
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador
                        ;grado cinco
                        db 0                                            ;signo
                        db 0                                            ;numerador
                        db 1                                            ;denominador

                        
section .bss
numero:                 resb 16
resultado:              resb 16
signonumero:            resb 1
decenas:                resb 8
unidades:               resb 8
numerofuncionespor:     resb 16
valormostrar:           resd 20
valor:                  resd 16
digt:                   resd 1
numerofunciones:        resb 16
numcarleido:            resb 15
numcar:                 resb 16
sinerror:               resb 1
carac:                  resd 1
numresolvercon:         resb 16
numedi:                 resb 16
signum1:                resb 1
signum2:                resb 1
sigres:                 resb 1
num1:                   resb 16
num2:                   resb 16
resultadogrado0:        resb 16
resultadogrado1:        resb 16
resultadogrado2:        resb 16
resultadogrado3:        resb 16
resultadogrado4:        resb 16
resultadogrado5:        resb 16
resultadofinal:         resb 16
sigresgrado0:           resb 1
sigresgrado1:           resb 1
sigresgrado2:           resb 1
sigresgrado3:           resb 1
sigresgrado4:           resb 1
sigresgrado5:           resb 1
sigresfinal:            resb 1
numx:                   resb 16
sigx:                   resb 1
numreporteuno:          resb 16
pintarx:                resb 16
pintary:                resb 16