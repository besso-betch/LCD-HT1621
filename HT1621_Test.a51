;Programm zum LCD Test mit HT1621
;*********************************
;Verwendete Hardware:
;Testboard mit 80C32
;Verwendete Software: 
;Reads51
;getestet mit 12MHz Quarz 
;Erstellt: April 2004, Besik Betchvaia
;****************************************


#include <sfr52.inc>

HT1621_Data bit	P3.2	;P3.2 --> DATA pin of HT1621
HT1621_WR	bit	P3.3	;P3.3 --> /WR  pin of HT1621
HT1621_CS	bit	P3.5	;P3.5 --> /CS  pin of HT1621

;PROG        EQU     2000H 	;STARTING ADDRESS FOR THE PROGRAM
  
;BUFINDEX   EQU  0h
   
DSEG AT 8h 
OUTBUFFER:       DS 8
BUFFER:  	 DS 1    ;PUFFER FUER EINE DEZIMAHLSTELLE
                            
CSEG AT 2000h 
;----------------------------
ljmp start
;----------------------------
#include "HT1621.inc"

start:
     mov SP,#2Fh   ;Stack setzen
     lcall LCD_Init
     mov OUTBUFFER+0,#8  ;8 Byte im RAM mit BCD-Werten fuellen
     mov OUTBUFFER+1,#7
     mov OUTBUFFER+2,#6
     mov OUTBUFFER+3,#5
     mov OUTBUFFER+4,#4
     mov OUTBUFFER+5,#3
     mov OUTBUFFER+6,#2
     mov OUTBUFFER+7,#1
     
     lcall CHECKZEROANDOUT

     ljmp $
END
 



