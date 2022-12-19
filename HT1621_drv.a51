;Das ist der Treiber fuer HT1621. Folgende Kommandos werden bereitgestellt:
;LCD_INIT: Allgemeine System-Initialisierung --> SYS EN, LCD ON, 3COM 1/3 BIAS. Es muss zuerst aufgerufen werden.
;SHOWREDY: "000" wird auf LCD rechtsbuendig ausgegeben
;CHECKZEROANDOUT: Das Ergebnis im OUTBUFFER(BCD-Werte) wird auf LCD ausgegeben.Fuehrende Nulls werden unterdrueckt.     

;Im Hauptprogramm muessen Folgende Deklarationen durchgefuehrt sein
;HT1621_Data   bit	P3.2	;P3.2 --> DATA pin of HT1621
;HT1621_WR     bit	P3.3	;P3.3 --> /WR  pin of HT1621
;HT1621_CS     bit	P3.5	;P3.5 --> /CS  pin of HT1621 
;OUTBUFFER:    DS 8             ;8 Byte fuer die Ausgabe auf LCD
;BUFFER:       DS 1             ;Puffer fuer eine Dezimalstelle(intern verwendet)






;*****************************************************
; OUTPUT "SYS EN" CMD (100 0000-0001 X)                 
;*****************************************************
LCD_INIT:  
   	CLR HT1621_CS			;/CS = LOW
        MOV A,#4H				;ID = 4			
   	LCALL	OUTPUT_ID
        MOV A,#1H				; CMD = 1: SYS EN
   	LCALL	OUTPUT_CMD
   	LCALL	OUTPUT_X			   ;THE 9'th bit 
        SETB	HT1621_CS	
;*****************************************************
; OUTPUT "LCD ON" CMD (100 0000-0011 X)
;*****************************************************
        CLR HT1621_CS			;/CS = LOW
   	MOV A,#4H				; ID = 4
   	LCALL	OUTPUT_ID
        MOV A,#3H				; CMD = 3: LCD ON
   	LCALL	OUTPUT_CMD
  	LCALL	OUTPUT_X			   ; X 
        SETB	HT1621_CS	
;*****************************************************
; OUTPUT 3 COM, 1/3 BIAS
;*****************************************************
  	CLR HT1621_CS			; /CS = LOW
   	MOV A,#4H				; ID = 4
        LCALL	OUTPUT_ID
   	MOV A,#00100101B	
   	LCALL	OUTPUT_CMD			
   	LCALL	OUTPUT_X			; X 
  	SETB HT1621_CS
        RET
;****************************************************
; OUTPUT BIT 7 OF A TO DATA 
;**************************************************
OUTPUT_X:  
 		RLC	A
		CLR	HT1621_WR
  		MOV HT1621_DATA,C
  		SETB  HT1621_WR
 		RET	
;****************************************************
; INPUT: 	A = XXXX XIII, WHERE III = ID
; OUTPUT:	
;**************************************************
OUTPUT_ID:  	
   		SWAP	A		   	; MOVE LOW NIBBLE TO HIGH NIBBLE
 		RL	A					; DISCARD BIT 3
    	        LCALL	OUTPUT_X
  		LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
     	        RET
;****************************************************
;GIBT BITWEISE EIN BYTE AUS, DASS IM AKKU STEHT
; INPUT: 	A = CCCC CCCC, WHERE CCC CCCC = COMMAND
; OUTPUT:	
;**************************************************
OUTPUT_CMD:  
   		LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
    	        LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
   		RET
;****************************************************
; INPUT: 	A = XXAA AAAA, WHERE AA AAAA = ADDRESS
; OUTPUT:	
;**************************************************
OUTPUT_ADDR:  
  		RL	A					; DISCARD BIT 7
   		RL	A					; DISCARD BIT 6
   		LCALL	OUTPUT_X
  		LCALL	OUTPUT_X
    	        LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
  		LCALL	OUTPUT_X
   		LCALL	OUTPUT_X
   		RET
;****************************************************
; INPUT: 	A = DDDD XXXX , WHERE DDDD = DATA
; OUTPUT:	
;**************************************************
OUTPUT_DATA:  
  		LCALL	OUTPUT_X
 		LCALL	OUTPUT_X
  		LCALL	OUTPUT_X
		LCALL	OUTPUT_X
  		RET



;*****************************************************
; 000 RECHTSBUENDIG AUF LCD
;*****************************************************
SHOWREDY:  
   			LCALL OPENHT1621
  			MOV BUFFER,#00
 			LCALL OUTPUT_BUFF			
   			LCALL OUTPUT_BUFF
   			LCALL OUTPUT_BUFF
  			MOV BUFFER,#20
    		        LCALL OUTPUT_BUFF
   			LCALL OUTPUT_BUFF
    		        LCALL OUTPUT_BUFF
   			LCALL OUTPUT_BUFF
  			LCALL OUTPUT_BUFF
   			LCALL CLOSEHT1621
    		        RET
 
;UNTERDRUECKT AUCH DIE FUEHRENDEN NULLS
CHECKZEROANDOUT: 
        mov DPTR,#pattern
	MOV R0 ,#OUTBUFFER+0
 
        MOV A,OUTBUFFER+7
        CJNE A,#00H,SHOWRESULT
        MOV OUTBUFFER+7,#20
                                    
        MOV A,OUTBUFFER+6
        CJNE A,#00H,SHOWRESULT
        MOV OUTBUFFER+6,#20
                           
        MOV A,OUTBUFFER+5
        CJNE A,#00H,SHOWRESULT
        MOV OUTBUFFER+5,#20
                       
        MOV A,OUTBUFFER+4
        CJNE A,#00H,SHOWRESULT
        MOV OUTBUFFER+4,#20
                                 
        MOV A,OUTBUFFER+3
        CJNE A,#00H,SHOWRESULT
        MOV OUTBUFFER+3,#20
                                
        MOV A,OUTBUFFER+2
        CJNE A,#00H,SHOWRESULT
        MOV OUTBUFFER+2,#20
                            
        MOV A,OUTBUFFER+1
        CJNE A,#00H,SHOWRESULT
        MOV OUTBUFFER+1,#20
                  
        MOV A,OUTBUFFER+0
        CJNE A,#00H,SHOWRESULT
        LCALL SHOWREDY
        LJMP AUSGANG
                      
SHOWRESULT:  
   	    LCALL OPENHT1621 
            
            MOV BUFFER , @ R0 
 	    LCALL OUTPUT_BUFF
                			
            INC R0 
            MOV BUFFER , @ R0 
   	    LCALL OUTPUT_BUFF
                   			
            INC R0 
            MOV BUFFER , @ R0 
  	    LCALL OUTPUT_BUFF
                     			
            INC R0 
            MOV BUFFER , @ R0 
   	    LCALL OUTPUT_BUFF
                        			
            INC R0 
            MOV BUFFER , @ R0 
   	    LCALL OUTPUT_BUFF
                  			
            INC R0 
            MOV BUFFER , @ R0 
	    LCALL OUTPUT_BUFF
                         			
            INC R0 
            MOV BUFFER , @ R0 
    	    LCALL OUTPUT_BUFF
                      			
            INC R0 
            MOV BUFFER , @ R0 
   	    LCALL OUTPUT_BUFF
            
            LCALL CLOSEHT1621
                   			
AUSGANG:  
      	    RET

;*************************************************
OPENHT1621:  
  		CLR HT1621_CS		; /CS = LOW
   		MOV A,#05H			;WRITE MODE
   		LCALL OUTPUT_ID
		MOV A,#00H			;START ADDRESS
  		LCALL OUTPUT_ADDR
       	        RET
         	      
            	      
;*************************************************
CLOSEHT1621:  
  	    SETB HT1621_CS      
            RET
            
;**********************************************
                  		
OUTPUT_BUFF:  
    		MOV A,BUFFER
                MOVC A,@A+DPTR
  		LCALL OUTPUT_DATA
  		MOV A,BUFFER
  		ADD A,#21          ;ABSTAND = ANZAHL DER DEFINIERTEN ZEICHEN
  		MOVC A,@A+DPTR
		LCALL OUTPUT_CMD
                RET

;ALLE 2(DAS 2.BYTE STEHT UNTER ADDR(1.BYTE)+10) BYTES IDENTIFIZIEREN EIN ZEICHEN
PATTERN:   
          DB 11000000B
          DB 11000000B
          DB 10000000B
          DB 11000000B
          DB 11000000B
          DB 01000000B
          DB 01000000B
          DB 11000000B
          DB 11000000B
          DB 11000000B
                          
          DB 11100000B    ;0.
          DB 11100000B    ;1.
          DB 10100000B    ;2.
          DB 11100000B    ;3.
          DB 11100000B    ;4.
          DB 01100000B    ;5.
          DB 01100000B    ;6.
          DB 11100000B    ;7.
          DB 11100000B    ;8.
          DB 11100000B    ;9.
                     
          DB 00000000B    ;BLANK
                      
;*********************************************
          DB 10101100B    ; 7 SEGMENT STEUERUNG FUER 0
          DB 00000000B    ; 7 SEGMENT STEUERUNG FUER 1
          DB 11100100B    ; 7 SEGMENT STEUERUNG FUER 2
          DB 11100000B    ; 7 SEGMENT STEUERUNG FUER 3
          DB 01001000B    ; 7 SEGMENT STEUERUNG FUER 4
          DB 11101000B    ; 7 SEGMENT STEUERUNG FUER 5
          DB 11101100B    ; 7 SEGMENT STEUERUNG FUER 6
          DB 10000000B    ; 7 SEGMENT STEUERUNG FUER 7
          DB 11101100B    ; 7 SEGMENT STEUERUNG FUER 8
          DB 11101000B    ; 7 SEGMENT STEUERUNG FUER 9
                            
          DB 10101100B    ; 7 SEGMENT STEUERUNG FUER 0.
          DB 00000000B    ; 7 SEGMENT STEUERUNG FUER 1.
          DB 11100100B    ; 7 SEGMENT STEUERUNG FUER 2.
          DB 11100000B    ; 7 SEGMENT STEUERUNG FUER 3.
          DB 01001000B    ; 7 SEGMENT STEUERUNG FUER 4.
          DB 11101000B    ; 7 SEGMENT STEUERUNG FUER 5.
          DB 11101100B    ; 7 SEGMENT STEUERUNG FUER 6.
          DB 10000000B    ; 7 SEGMENT STEUERUNG FUER 7.
          DB 11101100B    ; 7 SEGMENT STEUERUNG FUER 8.
          DB 11101000B    ; 7 SEGMENT STEUERUNG FUER 9.
                        
          DB 00000000B    ; BLANK
