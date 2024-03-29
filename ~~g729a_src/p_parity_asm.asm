	.mmregs
FP	.set	AR7

	.sect	".text"
	.global	_Parity_Pitch
;----------------------------------------------------------------------
;  18 | Word16 Parity_Pitch(    /* output: parity bit (XOR of 6 MSB bits)    */
;  19 | Word16 pitch_index   /* input : index for which parity to compute */   
;  20 | )                                                                      
;----------------------------------------------------------------------

_Parity_Pitch:

        PSHM      AR1
        PSHM      AR6
        FRAME     #-5
;----------------------------------------------------------------------
;  24 | temp = shr(pitch_index, 1);                                            
;----------------------------------------------------------------------
		SSBX      SXM
		SSBX      OVM
		NOP
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #1,*SP(0)             ; |24| 
        ;CALL      #_crshft              ; |24| 
        SFTA       A,-1
;----------------------------------------------------------------------
;  26 | sum = 1;                                                               
;  27 | for (i = 0; i <= 5; i++) {                                             
;----------------------------------------------------------------------
        STM       #1,AR1
        STM       #6,AR6
L1:    
;----------------------------------------------------------------------
;  28 | temp = shr(temp, 1);                                                   
;  29 | bit = temp & (Word16)1;                                                
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #1,*SP(0)             ; |28| 
        ;CALL      #_crshft              ; |28| 
        SFTA       A,-1
;----------------------------------------------------------------------
;  30 | sum = add(sum, bit);                                                   
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;SSBX      SXM
        LD        *(AR1),16,B           ; |30| 
        DST       B,*SP(2)              ; |30| 
        AND       #1,A,B                ; |30| 
        STLM      B,AR1
        DLD       *SP(2),B              ; |30| 
        ;SSBX      OVM
        ADD       *(AR1),16,B,B         ; |30| 
        SFTA      B,-16,B               ; |30| 
        STLM      B,AR1

;----------------------------------------------------------------------
;  32 | sum = sum & (Word16)1;                                                 
;----------------------------------------------------------------------
        BANZ      L1,*+AR6(-1)          ; |31| 
;----------------------------------------------------------------------
;  35 | return sum;                                                            
;----------------------------------------------------------------------
        LDM       AR1,A
        AND       #1,A,A                
        ANDM      #-833,*(ST1)          
        ANDM      #-4,*(PMST)           
        FRAME     #5                   
        POPM      AR6                   
        POPM      AR1                   
        RET       




	.sect	".text"
	.global	_Check_Parity_Pitch
;----------------------------------------------------------------------
;  42 | Word16  Check_Parity_Pitch( /* output: 0 = no error, 1= error */       
;  43 | Word16 pitch_index,       /* input : index of parameter     */         
;  44 | Word16 parity             /* input : parity bit             */         
;  45 | )                                                                      
;----------------------------------------------------------------------
_Check_Parity_Pitch:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-4
        NOP
;----------------------------------------------------------------------
;  47 | Word16 temp, sum, i, bit;                                              
;----------------------------------------------------------------------
        MVDK      *SP(8),*(AR7)
;----------------------------------------------------------------------
;  49 | temp = shr(pitch_index, 1);                                            
;----------------------------------------------------------------------
		SSBX      SXM
		SSBX      OVM
		NOP
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #1,*SP(0)             ; |49| 
        ;CALL      #_crshft              ; |49| 
        SFTA      A,-1
;----------------------------------------------------------------------
;  51 | sum = 1;                                                               
;  52 | for (i = 0; i <= 5; i++) {                                             
;----------------------------------------------------------------------
        STM       #1,AR1
        STM       #6,AR6
L2:    
;----------------------------------------------------------------------
;  53 | temp = shr(temp, 1);                                                   
;  54 | bit = temp & (Word16)1;                                                
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #1,*SP(0)             ; |53| 
        ;CALL      #_crshft              ; |53| 
        SFTA       A,-1
;----------------------------------------------------------------------
;  55 | sum = add(sum, bit);                                                   
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;SSBX      SXM
        LD        *(AR1),16,B           ; |55| 
        DST       B,*SP(2)              ; |55| 
        AND       #1,A,B                ; |55| 
        STLM      B,AR1
        DLD       *SP(2),B              ; |55| 
        ;SSBX      OVM
        ADD       *(AR1),16,B,B         ; |55| 
        SFTA      B,-16,B               ; |55| 
        STLM      B,AR1

        BANZ      L2,*+AR6(-1)          ; |56| 

;----------------------------------------------------------------------
;  57 | sum = add(sum, parity);                                                
;  58 | sum = sum & (Word16)1;                                                 
;----------------------------------------------------------------------
        ;RSBX      OVM
        LD        *(AR1),16,A           ; |57| 
        ;SSBX      OVM
        ADD       *(AR7),16,A,A         ; |57| 
        SFTA      A,-16,A               ; |57| 
        AND       #1,A,A                ; |57| 

;----------------------------------------------------------------------
;  60 | return sum;                                                            
;----------------------------------------------------------------------

        ANDM      #-833,*(ST1)         
        ANDM      #-4,*(PMST)          
        FRAME     #4                    
        POPM      AR7                   
        POPM      AR6                   
        POPM      AR1                   
        RET       

