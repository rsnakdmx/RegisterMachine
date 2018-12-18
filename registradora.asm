;Registros del SCI
BAUD   EQU $2B
SCCR1  EQU $2C
SCCR2  EQU $2D
SCSR   EQU $2E
SCDR   EQU $2F

;Memoria para el monto generado por producto
TA     EQU $00
TB     EQU $02
TC     EQU $04
TD     EQU $06
TE     EQU $08

;Memoria para la cantidad de producto
CA     EQU $16
CB     EQU $17
CC     EQU $18
CD     EQU $19
CE     EQU $1A
TOTAL  EQU $1B

       ORG $000A
       LDX #$1000    ;Acceso a la memoria

;Inicializar SCI
       LDAA #$30
       STAA BAUD,X  ;Velocidad de transmision
       LDAA #$00
       STAA SCCR1,X ;8 bits de datos
       LDAA #$0C
       STAA SCCR2,X  ;Activa transmisor y receptor

;Inicializa la cantidad de producto en 0
cero   LDD  #0000
       STAB CA,X
       STAB CB,X
       STAB CC,X
       STAB CD,X       
       STAB CE,X
       STD TA
       STD TB
       STD TC
       STD TD
       STD TE
       STD TOTAL,X

       BRA bucle

;Reinicia el programa cuando el monto supera los 10000
rebot  LDY #diez
       BSR cadena
       BSR lee
       BRA cero

;Mensaje que indica la direccion del total en hexadecimal
tot    LDY #tickt
       BSR cadena
       BSR leer
       BRA bucle                   

lee    BSR leer
       RTS
 
;Cuerpo principal	   
bucle  BSR salta
       LDD #$0000
       ADDD TA
       ADDD TB
       ADDD TC
       ADDD TD
       ADDD TE
       STD TOTAL,X
       CPD #10000
       BGE rebot
       LDY #msg
       BSR cadena
       BSR leer
       LDY #err
       CMPA #'A'
       BEQ proda
       CMPA #'a'
       BEQ proda
       CMPA #'B'
       BEQ prodb
       CMPA #'b'
       BEQ prodb
       CMPA #'C'
       BEQ prodc
       CMPA #'c'
       BEQ prodc
       CMPA #'D'
       BEQ prodd
       CMPA #'d'
       BEQ prodd
       CMPA #'E'
       BEQ prode
       CMPA #'e'
       BEQ prode
       CMPA #'#'
       BEQ borra
       CMPA #'='
       BEQ tot
       BNE regr

;Retorna a bucle
regr   BSR leer  ;regresa eliminando caracter
       BSR cadena
       BRA bucle

retrn BRA bucle  ;Debido al offset

;Imprimir al puerto SCI
enviar BRCLR SCSR,X $80 enviar
       STAA SCDR,X
       RTS

;Imprime mensajes
cadena LDAA 0,Y
       CMPA #0
       BEQ fin
       BSR enviar
       INY
       BRA cadena
fin    RTS

salta  BSR salto
       RTS

;Leer del puerto SCI
leer   BRCLR SCSR,X $20 leer
       LDAA SCDR,X
       RTS

;Cuenta la cantidad de productos y los guarda en una localidad de memoria	   
proda  BSR leer
       CMPA #'+'
       BNE salir
       LDAB $1016
       INCB
       STAB CA,X
       BRA retrn

prodb  BSR leer
       CMPA #'+'
       BNE salir
       LDAB $1017
       INCB
       STAB CB,X
       BRA retrn

prodc  BSR leer
       CMPA #'+'
       BNE salir
       LDAB $1018
       INCB
       STAB CC,X
       BRA retrn

prodd  BSR leer
       CMPA #'+'
       BNE salir
       LDAB $1019
       INCB
       STAB CD,X
       BRA retrn

prode  BSR leer
       CMPA #'+'
       BNE salir
       LDAB $101A
       INCB
       STAB CE,X
       BRA retrn

salir  BSR cadena  ;Regresa a bucle sin quitar char
sale   BRA retrn
salto  BRA salt
       RTS  

borra  BSR leer    ;Lee el dato a borrar
       CMPA #'A'
       BEQ resta
       CMPA #'a'
       BEQ resta
       CMPA #'B'
       BEQ restb
       CMPA #'b'
       BEQ restb
       CMPA #'C'
       BEQ restc
       CMPA #'c'
       BEQ restc
       CMPA #'D'
       BEQ restd
       CMPA #'d'
       BEQ restd
       CMPA #'E'
       BEQ reste
       CMPA #'e'
       BEQ reste
       BNE salir

resta  DEC $1016    ;Realiza las restas de los productos
       BRA sale
restb  DEC $1017
       BRA sale
restc  DEC $1018
       BRA sale
restd  DEC $1019
       BRA sale
reste  DEC $101A
       BRA sale

salt   BSR sbt
       RTS	   

;Segun la cantidad encuentra el monto y lo guarda en una localidad de memoria	   
sbt   LDAA CA,X
      CMPA #00
      BEQ nob
      CMPA #01
      BEQ suma1
      CMPA #02
      BEQ suma2
      CMPA #03
      BEQ suma3
      CMPA #04
      BEQ suma4
      CMPA #05
      BEQ suma5
      BNE masa
suma1 LDD #0000
      ADDD PA1
      STD TA
      BRA nob
suma2 LDD #0000
      STD TA
      ADDD PA2
      STD TA
      BRA nob
suma3 LDD #0000
      STD TA
      ADDD PA3
      STD TA
      BRA nob
suma4 LDD #0000
      STD TA
      ADDD PA4
      STD TA
      BRA nob
suma5 LDD #0000
      STD TA
      ADDD PA5
      STD TA
      BRA nob
masa  LDD TA
      ADDD PA1
      STD TA
      BRA nob
	  
nob   LDAA CB,X
      CMPA #00
      BEQ noc
      CMPA #01
      BEQ sumb1
      CMPA #02
      BEQ sumb2
      CMPA #03
      BEQ sumb3
      CMPA #04
      BEQ sumb4
      CMPA #05
      BEQ sumb5
      BNE masb
sumb1 LDD #0000
      ADDD PB1
      STD TB
      BRA noc
sumb2 LDD #0000
      STD TB
      ADDD PB2
      STD TB
      BRA noc
sumb3 LDD #0000
      STD TB
      ADDD PB3
      STD TB
      BRA noc
sumb4 LDD #0000
      STD TB
      ADDD PB4
      STD TB
      BRA noc
sumb5 LDD #0000
      STD TB
      ADDD PB5
      STD TB
      BRA noc
masb  LDD TB
      ADDD PB1
      STD TB
      BRA noc
	  
noc   LDAA CC,X
      CMPA #00
      BEQ nod
      CMPA #01
      BEQ sumc1
      CMPA #02
      BEQ sumc2
      CMPA #03
      BEQ sumc3
      CMPA #04
      BEQ sumc4
      CMPA #05
      BEQ sumc5
      BNE masc
sumc1 LDD #0000
      ADDD PC1
      STD TC
      BRA nod
sumc2 LDD #0000
      STD TC
      ADDD PC2
      STD TC
      BRA nod
sumc3 LDD #0000
      STD TC
      ADDD PC3
      STD TC
      BRA nod
sumc4 LDD #0000
      STD TC
      ADDD PC4
      STD TC
      BRA nod
sumc5 LDD #0000
      STD TC
      ADDD PC5
      STD TC
      BRA nod
masc  LDD TC
      ADDD PC1
      STD TC
      BRA nod	  
	  
nod   LDAA CD,X
      CMPA #00
      BEQ noe
      CMPA #01
      BEQ sumd1
      CMPA #02
      BEQ sumd2
      CMPA #03
      BEQ sumd3
      CMPA #04
      BEQ sumd4
      CMPA #05
      BEQ sumd5
      BNE masd
sumd1 LDD #0000
      ADDD PD1
      STD TD
      BRA noe
sumd2 LDD #0000
      STD TD
      ADDD PD2
      STD TD
      BRA noe
sumd3 LDD #0000
      STD TD
      ADDD PD3
      STD TD
      BRA noe
sumd4 LDD #0000
      STD TD
      ADDD PD4
      STD TD
      BRA noe
sumd5 LDD #0000
      STD TD
      ADDD PD5
      STD TD
      BRA noe
masd  LDD TD
      ADDD PD1
      STD TD
      BRA noe	  
	  
noe   LDAA CE,X
      CMPA #00
      BEQ reti
      CMPA #01
      BEQ sume1
      CMPA #02
      BEQ sume2
      CMPA #03
      BEQ sume3
      CMPA #04
      BEQ sume4
      CMPA #05
      BEQ sume5
      BNE mase
sume1 LDD #0000
      ADDD PE1
      STD TE
      BRA reti
sume2 LDD #0000
      STD TE
      ADDD PE2
      STD TE
      BRA reti
sume3 LDD #0000
      STD TE
      ADDD PE3
      STD TE
      BRA reti
sume4 LDD #0000
      STD TE
      ADDD PE4
      STD TE
      BRA reti
sume5 LDD #0000
      STD TE
      ADDD PE5
      STD TE
      BRA reti
mase  LDD TE
      ADDD PE1
      STD TE
      BRA reti	  
reti  RTS

;Cadenas de caracteres y datos

;Declaracion de cadenas
msg    FCC "Ingresa el producto"
       FCB 13
       FCB 10
       FCB 0

err    FCC "Error"
       FCB 13
       FCB 10
       FCB 0

tickt  FCC "El total esta en $101B, presione una tecla para reiniciar"
       FCB 0

diez   FCC "Monto limite, reiniciando programa"
       FCB 0

;Valores constantes de doble byte
PA1    FDB 50
PA2    FDB 80
PA3    FDB 105
PA4    FDB 120
PA5    FDB 125
PB1    FDB 100
PB2    FDB 160
PB3    FDB 210
PB4    FDB 240
PB5    FDB 250
PC1    FDB 200
PC2    FDB 320
PC3    FDB 420
PC4    FDB 480
PC5    FDB 500
PD1    FDB 300
PD2    FDB 480
PD3    FDB 660
PD4    FDB 720
PD5    FDB 750
PE1    FDB 400
PE2    FDB 640
PE3    FDB 840
PE4    FDB 960
PE5    FDB 1000

END