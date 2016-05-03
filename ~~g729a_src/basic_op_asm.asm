	.mmregs
FP	.set	AR7
	.sect	".text"
	.global	_L_sub
;----------------------------------------------------------------------
;  52 | Word32 L_sub(Word32 L_var1, Word32 L_var2)                             
;----------------------------------------------------------------------
_L_sub:
        SSBX      SXM
        RSBX      OVM
        NOP
        SFTA      A,8
        SFTA      A,-8
        SSBX      OVM
        DLD       *SP(1),B                            
        SUB       B,A                                   
        RET 	       
        
	.sect	".text"
	.global	_L_shl
;----------------------------------------------------------------------
; 109 | Word32 L_shl(Word32 L_var1, Word16 var2)                               
;----------------------------------------------------------------------
_L_shl:
        FRAME     #-3
        SSBX      SXM
        RSBX      OVM        
        LD        *SP(4),B
        BC        L8,BLEQ 
        SFTA      A,8
        SFTA      A,-8              
        SUB       #1,B,B
        STLM      B,BRC
        SSBX      OVM
        RSBX      OVA
        RPTB      L7-1                 
        SFTA     A,#1       
        BC       L9,AOV        
L7:    
        B         L9                   
L8:    
        NEG       B,B                   ; |115| 
        STL       B,*SP(0)
        CALL      #_L_shr               ; |115|       
L9:      
        FRAME     #3                    
        RET 
                         
	.sect	".text"
	.global	_L_shr
;----------------------------------------------------------------------
; 176 | Word32 L_shr(Word32 L_var1, Word16 var2)                               
;----------------------------------------------------------------------
_L_shr:

        FRAME     #-5
        SSBX      SXM
        RSBX      OVM
        LD        *SP(6),B
        DST       A,*SP(2)              
        BC        L11,BGEQ              

        NEG       B,B                   
        STL       B,*SP(0)
        CALL      #_L_shl                
        B         L15                        
L11:    
        LD        *(BL),A               
        SUB       #31,A,A                
        BC        L13,ALT               

        DLD       *SP(2),A
        BC        L12,AGEQ              
        LD        #-1,16,A               
        BD        L15                   
        OR        #65535,A,A             
L12:    
        BD        L15                   
        NOP
        LD        #0,A
L13:    
        DLD       *SP(2),A                    
		BITF    *(BL),0x10
		BC      JP1,NTC
		SFTA    A,-16,A
		ANDM     0x0F,*(BL)	
JP1:     
		NEG     B,B
		LD      *(BL),ASM
		LD      A,ASM,A                                  
L15:    
        FRAME     #5                    
        RET 

	.sect	".text"
	.global	_shl
;----------------------------------------------------------------------
; 176 | Word32 L_shr(Word32 L_var1, Word16 var2)                               
;----------------------------------------------------------------------
_shl:        
		FRAME  -3
		SSBX   OVM
		SSBX   SXM
		BC     END_SHL,AEQ
		STL    A,*SP(2)
		LD     *SP(4),B
		STL    B,*SP(1)
	    BC     SHL_J1,BGEQ
	    
	    NEG    B,B
	    STL    B,*SP(0)
	    CALL   _shr
	    B      END_SHL	    
SHL_J1:
	    SUB    #15,0,B,B
	    NOP
	    BC     SHL_J2,BGT
	    LD     *SP(1),T
	    LD     *SP(2),TS,A
	    SFTA   A,8
	    SFTA   A,8
	    SFTA   A,-16
	    B      END_SHL
SHL_J2:
	    LD     *SP(2),16,A
	    SFTA   A,8
	    SFTA   A,8
	    SFTA   A,-16,A
END_SHL:
	    FRAME  3
	    RET   

	.sect	".text"
	.global	_shr
;----------------------------------------------------------------------
; 176 | Word32 L_shr(Word32 L_var1, Word16 var2)                               
;----------------------------------------------------------------------
_shr:  	    
		FRAME -3
		SSBX  OVM
		SSBX  SXM
		BC    END_SHR,AEQ
		STL   A,*SP(2)
		LD    *SP(4),B
		STL   B,*SP(1)
		BC    SHR_J1,BGEQ
		
		NEG   B,B
		STL   B,*SP(0)
		CALL  _shl
		B     END_SHR
SHR_J1:
		SUB   #15,0,B,B
    	BC    SHR_J2,BGEQ
		LD    *SP(1),B
    	NEG   B,B
		LD    *(BL),T
		LD    *SP(2),TS,a
		B     END_SHR
SHR_J2:
		LD     *SP(2),-16,A
		SFTA   A,-16,A
END_SHR:
		FRAME 3
		RET 		
		
	.sect	".text"
	.global	_Verifi_Overflow
;----------------------------------------------------------------------
; 294 | Word16  Verifi_Overflow(Word16 init, Word16  signal[], Word16 scal_sig[
;     | ] ,Word16 lp1,Word16 lp2,Word16 lp3,Word32 *s)                         
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Verifi_Overflow                              *
;***************************************************************

_Verifi_Overflow:
        PSHM      AR1
        FRAME     #-6
        NOP
        MVDK      *SP(8),*(AR1)      ; (ar1) = signal
        MVDK      *SP(9),*(AR2)      ; (ar2) = scal_sig
        MVDK      *SP(12),*(AR4)     ; (ar4) = lp3
        MVDK      *SP(10),*(AR3)     ; (ar3) = lp1
        MVDK      *SP(11),*(BK)      ; (bk) = lp2
        MVDK      *SP(13),*(AR0)     ; (ar0) = &s

        SSBX      SXM
        LD        *(AL),A               
        DST       A,*SP(0)            ; sp(0) = sum = init  

        STM       #0,AR5              ; Flag_over = 0             

        LDM       AR3,B
        ADD       *(AR1),B            ; b = signal[lp1]
        STLM      B,AR1               ; ar1 = signal[lp1]
        LDM       AR3,B
        ADD       *(AR2),B
        STLM      B,AR2               ; ar2 = scal_sig[lp1]
        NOP
        NOP
        SSBX      FRCT         ; d.l.b
        SSBX      OVM
L1:    
        RSBX      OVB          ; d.l.b
        LD        *AR2,T
        NOP
        MPY       *AR1,B       ; b = (Word32)signal[i] * (Word32)scal_sig[i]          
        DST       B,*SP(2)     ; sp(2) = L_produit          
        BC        L2,BNOV              
        STM       #1,AR5       ; Flag_Over = 1             
 
L2:    
        RSBX      OVB
        DADD      *SP(0),B,B             ; b = temp = sum + L_produit
        DST       B,*SP(4)
        BC        L6,BNOV               
        STM       #1,AR5
L6:    
;----------------------------------------------------------------------
; 324 | sum=temp;                                                              
;----------------------------------------------------------------------
        DLD       *SP(4),B
        DST       B,*SP(0)            

        LDM       AR4,A
        LDM       AR1,B
        ADD       A,B                  
        STLM      B,AR1       ; ar1 = signal[i+lp3]
        LDM       AR2,B
        ADD       A,B                  
        STLM      B,AR2
        LDM       AR3,B
        ADD       A,B                  
        STLM      B,AR3
        LD        *(BL),B              
        SUB       *(BK),B               
        BC        L1,BLT               

    
        DLD       *SP(0),B
        DST       B,*AR0               

        LDM       AR5,A
        FRAME     #6                  
        POPM      AR1                 
        RET       