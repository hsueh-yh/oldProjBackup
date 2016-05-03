	.mmregs
FP	.set	AR7
	.sect	".text"
	.global	_Mpy_32_16
;----------------------------------------------------------------------
; 113 | Word32 Mpy_32_16(Word16 hi, Word16 lo, Word16 n)                       
;----------------------------------------------------------------------

_Mpy_32_16:
        LD        *SP(1),T        ; T = lo
        LD        *SP(2),B        ; B = n
        STLM      A,AR3           ; ar1 = hi
        SSBX      SXM
        SSBX      FRCT
        SSBX      OVM
        LD        *(BL),16,A       ; ah = n   
        NOP
        MPYA      A                ; a = L_mult(lo, n)  
        STLM      B,T              ; T = n
        STH       A,*(AR2)         ; (ar2) = L_mult(lo, n)  
        MPY       *(AR3),A         ; a = L_mult(hi, n)           
        MVMD      AR2,T            
        MAC       #1, A              
        ANDM      #-833,*(ST1)                                     
        RET       




	.sect	".text"
	.global	_Mpy_32
;----------------------------------------------------------------------
;  82 | Word32 Mpy_32(Word16 hi1, Word16 lo1, Word16 hi2, Word16 lo2)          
;----------------------------------------------------------------------
_Mpy_32:

        LD        A,B              ; b = hi1
        MVDK      *SP(2),*(AR3)    ; ar1 = hi2
        LD        *SP(3),A         ; a = lo2
        MVDK      *SP(1),*(AR2)    ; ar2 = lo1 
        SSBX      SXM
        SSBX      FRCT
        STLM      B,T              ; T = hi1
        LD        *(AL),16,A           
        SSBX      OVM
        MPYA      A                ; a = mult(hi1, lo2)      
        MVMD      AR3,T            ; T = hi2
        MPY       *(BL),B          ; b = L_mult(hi1, hi2)     
        SFTA      A,#-16,A         ; a = mult(hi1, lo2)                  
        STLM      A,T              ; T = mult(hi1, lo2)             
        MAC       #1, B                 
        LD        *(AR3),16,A       ; ah = hi2  
        MVMD      AR2,T             ; T = lo1
        MPYA      A                 ; a = mult(hi2,lo1)    
        SFTA      A,#-16,A                 
        STLM      A,T
        MAC       #1, B             ; b = L_mac(L_32, mult(lo1, hi2) , 1) ;rewrite by d.l.b            
        LD        B,A                   
        ANDM      #-833,*(ST1)                                        
        RET       


	.sect	".text"
	.global	_L_Extract
;***************************************************************
;* FUNCTION DEF: _L_Extract                                    *
;***************************************************************
_L_Extract:

        SSBX      SXM             ; ****
        RSBX      OVM
        SSBX      FRCT
        SFTA      A,8
        SFTA      A,-8
        SSBX      OVM

        MVDK      *SP(2),*(AR4)
        MVDK      *SP(1),*(AR2)
        
        LD        A,B                   
        SFTL      B,#-16,B              
        STLM      B,AR3
        MVKD      *(AR3),*AR2

        SFTA      A,-1              
        
        MVMD      AR3,T
        LD        #16384,B
        ORM       #2,*(PMST)
        MAS       *(BL), A              
        STL       A,*AR4                 
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        RET


	.sect	".text"
	.global	_Div_32

;----------------------------------------------------------------------
; 167 | Word32 Div_32(Word32 L_num, Word16 denom_hi, Word16 denom_lo)          
;----------------------------------------------------------------------

_Div_32:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-8
        NOP
;----------------------------------------------------------------------
; 169 | Word16 approx, hi, lo, n_hi, n_lo;                                     
; 170 | Word32 L_32;                                                           
;----------------------------------------------------------------------
        MVDK      *SP(13),*(AR1)
        MVDK      *SP(12),*(AR7)
        DST       A,*SP(6)              ; |168| 

;----------------------------------------------------------------------
; 175 | approx = div_s( (Word16)0x3fff, denom_hi);    /* result in Q14 */      
; 180 | L_32 = Mpy_32_16(denom_hi, denom_lo, approx); /* result in Q30 */      
;----------------------------------------------------------------------
        RSBX      FRCT
        RSBX      OVM
        MVKD      *(AR7),*SP(0)
        CALLD     #_divs                ; |175| 
        LD        #16383,A
   
        STLM      A,AR6

;----------------------------------------------------------------------
; 183 | L_32 = L_sub( (Word32)0x7fffffffL, L_32);      /* result in Q30 */     
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        SSBX      FRCT
        LD        *(AR6),16,A           ; |183| 
        SSBX      OVM
        MVMD      AR1,T
        MPYA      A                     ; |183| 
        MVMD      AR6,T
        SFTA      A,#-16,B
        MPY       *(AR7),A              ; |183| 
        RSBX      OVM
        NOP
        SFTA      A,8                   ; |183| 
        STM       #1,AR1
        SFTA      A,-8                  ; |183| 
        STLM      B,T
        ORM       #2,*(PMST)
        SSBX      OVM
        ORM       #2,*(PMST)
        MAC       *(AR1), A             ; |183| 
        RSBX      FRCT
        RSBX      OVM
        DST       A,*SP(0)              ; |183| 
        LD        #32767,16,A           ; |183| 
        CALLD     #_L_sub               ; |183| 
        OR        #65535,A,A            ; |183| 

;----------------------------------------------------------------------
; 185 | L_Extract(L_32, &hi, &lo);                                             
; 187 | L_32 = Mpy_32_16(hi, lo, approx);             /* = 1/L_denom in Q29 */ 
;----------------------------------------------------------------------
        RSBX      OVM
        LDM       SP,B
        ADD       #5,B
        STL       B,*SP(0)
        LDM       SP,B
        ADD       #4,B
        RSBX      FRCT
        STL       B,*SP(1)
        CALL      #_L_Extract           ; |185| 

;----------------------------------------------------------------------
; 191 | L_Extract(L_32, &hi, &lo);                                             
;----------------------------------------------------------------------
        SSBX      FRCT
        RSBX      OVM
        LDM       SP,A
        ADD       #5,A
        STL       A,*SP(0)
        LDM       SP,A
        ADD       #4,A
        SSBX      SXM
        STL       A,*SP(1)
        LD        *(AR6),16,A           ; |191| 
        SSBX      OVM
        NOP
        MPYA      *SP(4)                ; |191| 
        MVMD      AR6,T
        MPY       *SP(5),A              ; |191| 
        RSBX      OVM
        NOP
        SFTA      A,8                   ; |191| 
        SFTA      B,#-16,B
        SFTA      A,-8                  ; |191| 
        STLM      B,T
        ORM       #2,*(PMST)
        SSBX      OVM
        ORM       #2,*(PMST)
        MAC       *(AR1), A             ; |191| 
        RSBX      OVM
        RSBX      FRCT
        NOP
        CALL      #_L_Extract           ; |191| 

;----------------------------------------------------------------------
; 192 | L_Extract(L_num, &n_hi, &n_lo);                                        
; 193 | L_32 = Mpy_32(n_hi, n_lo, hi, lo);            /* result in Q29   */    
;----------------------------------------------------------------------
        RSBX      OVM
        LDM       SP,A
        ADD       #3,A
        STL       A,*SP(0)
        LDM       SP,A
        ADD       #2,A
        STL       A,*SP(1)
        RSBX      FRCT
        DLD       *SP(6),A              ; |192| 
        CALL      #_L_Extract           ; |192| 

;----------------------------------------------------------------------
; 194 | L_32 = L_shl(L_32, 2);                        /* From Q29 to Q31 */    
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        ST        #2,*SP(0)             ; |194| 
        LD        *SP(4),16,A           ; |194| 
        SSBX      OVM
        SSBX      FRCT
        NOP
        MPYA      *SP(3)                ; |194| 
        LD        *SP(5),T
        NOP
        MPY       *SP(3),A              ; |194| 
        SFTA      B,#-16,B
        RSBX      OVM
        STLM      B,T
        SFTA      A,8                   ; |194| 
        SFTA      A,-8                  ; |194| 
        SSBX      OVM
        ORM       #2,*(PMST)
        MAC       *(AR1), A             ; |194| 
        RSBX      OVM
        NOP
        SFTA      A,8                   ; |194| 
        SFTA      A,-8                  ; |194| 
        DST       A,*SP(6)              ; |194| 
        LD        *SP(5),16,A           ; |194| 
        SSBX      OVM
        NOP
        MPYA      *SP(2)                ; |194| 
        SFTA      B,#-16,B
        RSBX      OVM
        STLM      B,T
        DLD       *SP(6),A              ; |194| 
        SSBX      OVM
        MAC       *(AR1), A             ; |194| 
        RSBX      OVM
        RSBX      FRCT
        DST       A,*SP(6)              ; |194| 
        CALL      #_L_shl               ; |194| 

        ANDM      #-833,*(ST1)          ; |196| 
        ANDM      #-4,*(PMST)           ; |196| 
        FRAME     #8                    ; |196| 
        POPM      AR7                   ; |196| 
        POPM      AR6                   ; |196| 
        POPM      AR1                   ; |196| 
        RET       



;***************************************************************
;* UNDEFINED EXTERNAL REFERENCES                               *
;***************************************************************
	.global	_L_sub
	.global	_L_shl
	.global	_divs

