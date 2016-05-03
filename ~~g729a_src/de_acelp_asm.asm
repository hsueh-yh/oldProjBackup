;***************************************************************
;* TMS320C54x C/C++ Codegen                  PC Version 3.831  *
;* Date/Time created: Wed May 11 09:36:25 2005                 *
;***************************************************************
	.mmregs
FP	.set	AR7

;	c:\ti\c5400\cgtools\bin\opt500.exe -i20 -q -s -O3 D:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\TI3584_2 D:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\TI3584_5 -w F:/ATA/Code/g729a_v1.4/G729A/Debug 

	.sect	".text"
	.global	_Decod_ACELP

;----------------------------------------------------------------------
;  20 | void Decod_ACELP(                                                      
;  21 | Word16 sign,      /* (i)     : signs of 4 pulses.
;     |  */                                                                    
;  22 | Word16 index,     /* (i)     : Positions of the 4 pulses.
;     |  */                                                                    
;  23 | Word16 cod[]      /* (o) Q13 : algebraic (fixed) codebook excitation
;     |  */                                                                    
;  24 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Decod_ACELP                                  *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Decod_ACELP:
;* A     assigned to _sign
	.sym	_sign,0, 3, 17, 16
	.sym	_index,12, 3, 9, 16
	.sym	_cod,13, 19, 9, 16
	.sym	_sign,2, 3, 1, 16
	.sym	_i,3, 3, 1, 16
	.sym	_j,4, 3, 1, 16
	.sym	_pos,5, 51, 1, 64,, 4
        PSHM      AR1
        FRAME     #-10
        NOP
        STL       A,*SP(2)

        LD        #7,A
        AND       *SP(12),A             ; |32| 
        STL       A,*SP(3)

        ;;RSBX      FRCT
        ;;RSBX      OVM
        SSBX      OVM;;WLY
        SSBX	  SXM;;WLY
        NOP
        ;;ST        #2,*SP(0)             ; |33| 
        LD        *SP(3),A
        ;;CALL      #_clshft              ; |33| 
        SFTA	A,2;;WLY
        ; call occurs [#_clshft] ; |33| 
        ;;SSBX      SXM
        ;;RSBX      OVM
        ;;NOP
        LD        *SP(3),16,B           ; |33| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |33| 
        STH       A,*SP(5)              ; |33| 
	.line	16
        ;;ST        #3,*SP(0)             ; |35| 
        ;;RSBX      FRCT
        ;;RSBX      OVM
        LD        *SP(12),A
        ;;CALL      #_crshft              ; |35| 
        SFTA	A,-3;;WLY
        ; call occurs [#_crshft] ; |35| 
        STL       A,*SP(12)
	.line	17
        LD        #7,A
        AND       *SP(12),A             ; |36| 
        STL       A,*SP(3)
	.line	18
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ;;ST        #2,*SP(0)             ; |37| 
        LD        *SP(3),A
        ;;CALL      #_clshft              ; |37| ]
        SFTA	A,2;;WLY
        ; call occurs [#_clshft] ; |37| 
        ;;SSBX      SXM
        ;;RSBX      OVM
        ;;NOP
        LD        *SP(3),16,B           ; |37| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |37| 
        STH       A,*SP(3)              ; |37| 
	.line	19
        ;;RSBX      OVM
        NOP
        LD        *SP(3),16,A           ; |38| 
        ;;SSBX      OVM
        NOP
        ADD       #1,16,A,A             ; |38| 
        STH       A,*SP(6)              ; |38| 
	.line	21
        ;;ST        #3,*SP(0)             ; |40| 
        ;;RSBX      OVM
        ;;RSBX      FRCT
        LD        *SP(12),A
        ;;CALL      #_crshft              ; |40| 
        SFTA	A,-3
        ; call occurs [#_crshft] ; |40| 
        STL       A,*SP(12)
	.line	22
        LD        #7,A
        AND       *SP(12),A             ; |41| 
        STL       A,*SP(3)
	.line	23
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ;;ST        #2,*SP(0)             ; |42| 
        LD        *SP(3),A
        ;;CALL      #_clshft              ; |42| 
        SFTA 	A,2;;WLY
        ; call occurs [#_clshft] ; |42| 
        ;;RSBX      OVM
        ;;SSBX      SXM
        ;;NOP
        LD        *SP(3),16,B           ; |42| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |42| 
        STH       A,*SP(3)              ; |42| 
	.line	24
        ;;RSBX      OVM
        NOP
        LD        *SP(3),16,A           ; |43| 
        ;;SSBX      OVM
        NOP
        ADD       #2,16,A,A             ; |43| 
        STH       A,*SP(7)              ; |43| 
	.line	26
        ;;RSBX      OVM
        ;;ST        #3,*SP(0)             ; |45| 
        ;;RSBX      FRCT
        LD        *SP(12),A
        ;;CALL      #_crshft              ; |45| 
        SFTA	A,-3
        ; call occurs [#_crshft] ; |45| 
        STL       A,*SP(12)
	.line	27
        LD        #1,A
        AND       *SP(12),A             ; |46| 
        STL       A,*SP(4)
	.line	28
        ;;ST        #1,*SP(0)             ; |47| 
        ;;RSBX      FRCT
        ;;RSBX      OVM
        LD        *SP(12),A
        ;;CALL      #_crshft              ; |47| 
        SFTA	A,-1;;WLY
        ; call occurs [#_crshft] ; |47| 
        STL       A,*SP(12)
	.line	29
        LD        #7,A
        AND       *SP(12),A             ; |48| 
        STL       A,*SP(3)
	.line	30
        ;;ST        #2,*SP(0)             ; |49| 
        ;;RSBX      FRCT
        ;;RSBX      OVM
        LD        *SP(3),A
        ;;CALL      #_clshft              ; |49| 
        SFTA	A,2;;WLY
        ; call occurs [#_clshft] ; |49| 
        ;;SSBX      SXM
        ;;RSBX      OVM
        ;;NOP
        LD        *SP(3),16,B           ; |49| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |49| 
        STH       A,*SP(3)              ; |49| 
	.line	31
        ;;RSBX      OVM
        NOP
        LD        *SP(3),16,A           ; |50| 
        ;;SSBX      OVM
        NOP
        ADD       #3,16,A,A             ; |50| 
        STH       A,*SP(3)              ; |50| 
	.line	32
        ;;RSBX      OVM
        NOP
        LD        *SP(3),16,A           ; |51| 
        ;;SSBX      OVM
        NOP
        ADD       *SP(4),16,A,A         ; |51| 
        STH       A,*SP(8)              ; |51| 
	.line	36
        ;;RSBX      OVM
        ST        #0,*SP(3)             ; |55| 
        LD        #40,A
        SUB       *SP(3),A              ; |55| 
        BC        L2,ALEQ               ; |55| 
        ; branch occurs ; |55| 
L1:    
	.line	37
        LD        *SP(3),A
        ADD       *SP(13),A             ; |56| 
        STLM      A,AR1
        NOP
        NOP
        ST        #0,*AR1               ; |56| 
	.line	38
        LD        #40,A
        ADDM      #1,*SP(3)             ; |57| 
        SUB       *SP(3),A              ; |57| 
        BC        L1,AGT                ; |57| 
        ; branch occurs ; |57| 
L2:    
	.line	40
        LD        #4,A
        ST        #0,*SP(4)             ; |59| 
        SUB       *SP(4),A              ; |59| 
        BC        L6,ALEQ               ; |59| 
        ; branch occurs ; |59| 
L3:    
	.line	43
        LD        #1,A
        AND       *SP(2),A              ; |62| 
        STL       A,*SP(3)
	.line	44
        ;;RSBX      FRCT
        ;;ST        #1,*SP(0)             ; |63| 
        LD        *SP(2),A
        ;;CALL      #_crshft              ; |63| 
        SFTA	A,-1;;WLY
        ; call occurs [#_crshft] ; |63| 
        STL       A,*SP(2)
	.line	46
        ;;RSBX      OVM
        NOP
        LD        *SP(3),A              ; |65| 
        BC        L4,AEQ                ; |65| 
        ; branch occurs ; |65| 
	.line	47
        LDM       SP,A
        ADD       #5,A
        ADD       *SP(4),A              ; |66| 
        STLM      A,AR1
        NOP
        NOP
        LD        *AR1,A
        ADD       *SP(13),A             ; |66| 
        STLM      A,AR1
        NOP
        NOP
        ST        #8191,*AR1            ; |66| 
	.line	48
        B         L5                    ; |67| 
        ; branch occurs ; |67| 
L4:    
	.line	50
        LDM       SP,A
        ADD       #5,A
        ADD       *SP(4),A              ; |69| 
        STLM      A,AR1
        NOP
        NOP
        LD        *AR1,A
        ADD       *SP(13),A             ; |69| 
        STLM      A,AR1
        NOP
        NOP
        ST        #-8192,*AR1           ; |69| 
L5:    
	.line	52
        ;;SSBX      SXM
        LD        #4,A
        ADDM      #1,*SP(4)             ; |71| 
        SUB       *SP(4),A              ; |71| 
        BC        L3,AGT                ; |71| 
        ; branch occurs ; |71| 
	.line	54
L6:    
	.line	55
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #10
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	74,000000400h,11

;;	.endfunc	74,000018400h,11


;***************************************************************
;* UNDEFINED EXTERNAL REFERENCES                               *
;***************************************************************
	.global	_clshft
	.global	_crshft


