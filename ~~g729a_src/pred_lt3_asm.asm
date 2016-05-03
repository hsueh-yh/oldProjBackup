    .mmregs
FP	.set	AR7
	.sect	".text"
	.global	_Pred_lt_3
    .ref _inter_3l
;***************************************************************
;* FUNCTION DEF: _Pred_lt_3                                    *
;***************************************************************

_Pred_lt_3:

        PSHM      AR1
        PSHM      AR6
        STLM      A,AR6                ; (ar6) = exc
        NOP
        MVDK      *SP(4),*(AR4)        ; (ar4) = frac
        LD        *SP(3),A             ; (a) = T0
        MVDK      *SP(5),*(AR2)        ; (ar2)= L_subfr
        SSBX      FRCT 
               
        LDM       AR6,B
        SUB       A,B                   
        STLM      B,AR1                ; (ar1) = x0 = &exc[-T0]

        SSBX      SXM
        LD        *(AR4),16,A            
        SSBX      OVM
        NOP
        NEG       A,A                  ; frac = -frac
        SFTA      A,-16,A               
        STLM      A,AR4                ; (ar4) = -frac
        LD        *(AL),A              
        BC        L1,AGEQ              ; if (frac>=0) goto L1  


        LD        *(AR4),16,A           

        ADD       #3,16,A,A            ; (a)= 3+frac
        SFTA      A,-16,A              
        STLM      A,AR4                ; (ar4) = 3+frac
                        
        NOP                            ; (ar1) = x0--
        MAR       *AR1-
L1:    
        LDM       AR2,A                 ; (ar2) = L_subfr
        LD        *(AL),A               
        BC        L5,ALEQ               ; if( L_subfr =0) goto L5 
        
        LDM       AR2,A

        STM       #_inter_3l,AR3
        SUB       #1,A,A                ; (a) = L_subfr-1
        STLM      A,AR0
        LD        #3,16,A            

        SUB       *(AR4),16,A,A         ;(a) = 3-frac
        SFTA      A,-16,B               ;(bl) = (ah) = 3-frac
        LDM       AR3,A
        ADD       A,B                   ;(b) = &_inter_31[3-frac]
        STLM      B,AR2                 ;(ar2) = c2 = &_inter_31[3-frac]
        ADD       *(AR4),A              ;(ar4) = frac
        STLM      A,AR3                 ;(ar3) = c1 = &_inter_31[frac]
        ORM       #2,*(PMST)            ; ***
L2:           
        MVMM      AR1,AR4               ;(ar4) = x2 = x0
        MAR       *AR1+                 
        MVMM      AR1,AR5               ;(ar5) = x1 = x0++   

        LD        #0,A
        STM       #9,BRC
        RPTB      L4-1      
L3:    
        MAC       *AR3, *AR4-, A, A                   
        NOP               
        MAC       *AR2, *AR5+, A, A     

        MAR       *+AR3(#3)
        MAR       *+AR2(#3)
L4:    
        MAR       *+AR2(#-30)
        MAR       *+AR3(#-30)               
        ADD       #1,#15,A,A            ; (a) = round(a) 
        STH       A,*AR6+               ; exc(j) = (a)

        MAR       *AR0-
        BANZ      L2,*AR0(1)            
        
L5:    
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        POPM      AR6
        POPM      AR1
        RET
