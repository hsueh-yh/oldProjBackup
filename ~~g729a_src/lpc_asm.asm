;***************************************************************
;* TMS320C54x C/C++ Codegen                  PC Version 3.831  *
;* Date/Time created: Mon Aug 22 11:50:38 2005                 *
;***************************************************************
	.mmregs
FP	.set	AR7
	.c_mode
	.file	"LPC.C"

	.sect	".cinit"
	.align	1
	.field  	IR_1,16
	.field  	_old_A+0,16
	.field  	4096,16			; _old_A[0] @ 0
	.field  	0,16			; _old_A[1] @ 16
	.field  	0,16			; _old_A[2] @ 32
	.field  	0,16			; _old_A[3] @ 48
	.field  	0,16			; _old_A[4] @ 64
	.field  	0,16			; _old_A[5] @ 80
	.field  	0,16			; _old_A[6] @ 96
	.field  	0,16			; _old_A[7] @ 112
	.field  	0,16			; _old_A[8] @ 128
	.field  	0,16			; _old_A[9] @ 144
	.field  	0,16			; _old_A[10] @ 160
IR_1:	.set	11

	.sect	".text"
	.bss	_old_A,11,0,0
	.sym	_old_A,_old_A, 51, 3, 176,, 11

	.sect	".cinit"
	.align	1
	.field  	IR_2,16
	.field  	_old_rc+0,16
	.field  	0,16			; _old_rc[0] @ 0
	.field  	0,16			; _old_rc[1] @ 16
IR_2:	.set	2

	.sect	".text"
	.bss	_old_rc,2,0,0
	.sym	_old_rc,_old_rc, 51, 3, 32,, 2
;	d:\ti\c5400\cgtools\bin\opt500.exe -i15 -q -O3 C:\DOCUME~1\WANGLA~1\LOCALS~1\Temp\TI1648_2 C:\DOCUME~1\WANGLA~1\LOCALS~1\Temp\TI1648_5 -w F:/CODE/g729a_v1.7/G729A/Debug 

	.sect	".text"
	.global	_Test_Overflow
	.sym	_Test_Overflow,_Test_Overflow, 35, 2, 0
	.func	338

;***************************************************************
;* FUNCTION DEF: _Test_Overflow                                *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Test_Overflow:
;* A     assigned to _a
	.sym	_a,0, 19, 17, 16
	.sym	_f1,2, 19, 9, 16
	.sym	_f2,3, 19, 9, 16
;* BRC   assigned to L$1
;* A     assigned to L$1
;* B     assigned to _temp
	.sym	_temp,6, 5, 4, 32
;* B     assigned to _temp
	.sym	_temp,6, 5, 4, 32
;* A     assigned to _t0
	.sym	_t0,0, 5, 4, 32
;* A     assigned to _t0
	.sym	_t0,0, 5, 4, 32
;* AR3   assigned to _ovf_coef
	.sym	_ovf_coef,12, 3, 4, 16
;* AR1   assigned to _f2
	.sym	_f2,10, 19, 4, 16
;* B     assigned to _f1
	.sym	_f1,6, 19, 4, 16
;* A     assigned to _a
	.sym	_a,0, 19, 4, 16
;* AR1   assigned to U$40
;* AR4   assigned to U$26
;* AR5   assigned to U$17
;* AR2   assigned to U$8
;* A     assigned to C$2
;* A     assigned to C$1
        PSHM      AR1
        STLM      A,AR2
        ADD       #11,A,A
        LD        *SP(2),B
        STLM      A,AR5
        SUB       #1,B,A
        STLM      A,AR4
        NOP
        MVDK      *SP(3),*(AR1)

        STM       #0,AR3
        STM       #4,BRC
        RPTB      L10-1
        ; loop starts
L1:    
	.line	11
        SSBX      SXM
        LD        *+AR2(1),B            ; |348| 
        SFTL      B,#14,A               ; |348| 
	.line	14
        SFTL      A,#1,A                ; |351| 
	.line	23
        LD        *+AR5(-1),B           ; |360| 
        SFTL      B,#14,B               ; |360| 
	.line	34
        SFTL      B,#1,B                ; |371| 
        ADD       B,A                   ; |371| 
	.line	54
        SFTL      A,#-16,B              ; |391| 
        LD        *(BL),B               ; |391| 
        SUB       *+AR4(1),B,A
        LD        A,B                   ; |391| 
        SFTA      B,8                   ; |391| 
        SFTA      B,-8                  ; |391| 
        RSBX      SXM
        NOP
        SUB       #32768,B,B            ; |391| 
        BC        L3,BGEQ               ; |391| 
        ; branch occurs ; |391| 
	.line	59
        LD        A,B                   ; |396| 
        SSBX      SXM
        SFTA      B,8                   ; |396| 
        SFTA      B,-8                  ; |396| 
        SUB       #-32768,B,B           ; |396| 
        BC        L2,BLT                ; |396| 
        ; branch occurs ; |396| 
	.line	67
        BD        L5                    ; |404| 
        STL       A,*AR4(1)             ; |404| 
        ; branch occurs ; |404| 
L2:    
	.line	62
        ST        #-32768,*AR4(1)       ; |399| 
	.line	63
        B         L4                    ; |400| 
        ; branch occurs ; |400| 
L3:    
	.line	57
        ST        #32767,*AR4(1)        ; |394| 
L4:    
	.line	71
        STM       #1,AR3
L5:    
	.line	75
        SSBX      SXM
        NOP
        LD        *AR2,B                ; |412| 
        SFTL      B,#15,A               ; |412| 
	.line	87
        LD        *AR5,B                ; |424| 
        SFTL      B,#15,B               ; |424| 
	.line	97
        SUB       B,A                   ; |434| 
	.line	115
        SFTL      A,#-16,B              ; |452| 
        LD        *(BL),B               ; |452| 
        ADD       *AR1,B,A
        LD        A,B                   ; |452| 
        SFTA      B,8                   ; |452| 
        SFTA      B,-8                  ; |452| 
        RSBX      SXM
        NOP
        SUB       #32768,B,B            ; |452| 
        BC        L7,BGEQ               ; |452| 
        ; branch occurs ; |452| 
	.line	120
        LD        A,B                   ; |457| 
        SSBX      SXM
        SFTA      B,8                   ; |457| 
        SFTA      B,-8                  ; |457| 
        SUB       #-32768,B,B           ; |457| 
        BC        L6,BLT                ; |457| 
        ; branch occurs ; |457| 
	.line	128
        BD        L9                    ; |465| 
        STL       A,*AR1(1)             ; |465| 
        ; branch occurs ; |465| 
L6:    
	.line	123
        ST        #-32768,*AR1(1)       ; |460| 
	.line	124
        B         L8                    ; |461| 
        ; branch occurs ; |461| 
L7:    
	.line	118
        ST        #32767,*AR1(1)        ; |455| 
L8:    
	.line	131
        STM       #1,AR3
L9:    
	.line	132
        MAR       *AR1+
        ; loop ends ; |469| 
L10:    
	.line	134
        LDM       AR3,A
	.line	135
        POPM      AR1                   ; |471| 
        RET       ; |471| 
        ; return occurs ; |471| 
	.endfunc	472,000000400h,1



	.sect	".text"
	.global	_Levinson
	.sym	_Levinson,_Levinson, 32, 2, 0
	.func	201

;***************************************************************
;* FUNCTION DEF: _Levinson                                     *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Levinson:
	.line	7
;* A     assigned to _Rh
	.sym	_Rh,0, 19, 17, 16
	.sym	_Rl,78, 19, 9, 16
	.sym	_A,79, 19, 9, 16
	.sym	_rc,80, 19, 9, 16
;* BRC   assigned to L$4
;* BRC   assigned to L$6
;* A     assigned to L$6
;* A     assigned to L$4
;* A     assigned to _t0
	.sym	_t0,0, 5, 4, 32
;* A     assigned to _t0
	.sym	_t0,0, 5, 4, 32
;* A     assigned to _t0
	.sym	_t0,0, 5, 4, 32
	.sym	_t0,60, 5, 1, 32
	.sym	_t0,60, 5, 1, 32
;* A     assigned to _t0
	.sym	_t0,0, 5, 4, 32
;* A     assigned to _t0
	.sym	_t0,0, 5, 4, 32
	.sym	_t0,60, 5, 1, 32
;* A     assigned to _t1
	.sym	_t1,0, 5, 4, 32
	.sym	_t1,58, 5, 1, 32
;* AR5   assigned to U$83
;* AR6   assigned to U$83
;* AR2   assigned to U$80
;* AR1   assigned to U$80
;* AR3   assigned to U$76
;* AR4   assigned to U$74
;* AR7   assigned to U$74
;* AR1   assigned to U$48
;* AR6   assigned to U$46
	.sym	_Rh,54, 19, 1, 16
	.sym	_Rl,57, 19, 1, 16
	.sym	_A,56, 19, 1, 16
	.sym	_rc,55, 19, 1, 16
	.sym	_i,66, 3, 1, 16
;* AR1   assigned to _j
	.sym	_j,10, 3, 4, 16
	.sym	_hi,4, 3, 1, 16
	.sym	_lo,5, 3, 1, 16
	.sym	_Kh,6, 3, 1, 16
	.sym	_Kl,7, 3, 1, 16
	.sym	_alp_h,8, 3, 1, 16
	.sym	_alp_l,9, 3, 1, 16
	.sym	_alp_exp,62, 3, 1, 16
	.sym	_t2,58, 5, 1, 32
;* AR7   assigned to L$2
;* AR2   assigned to U$116
;* AR3   assigned to U$114
;* AR7   assigned to U$105
;* AR1   assigned to U$99
;* AR6   assigned to U$97
;* B     assigned to C$4
;* B     assigned to C$3
;* AR2   assigned to C$2
;* AR2   assigned to C$1
	.sym	_Ah,10, 51, 1, 176,, 11
	.sym	_Al,21, 51, 1, 176,, 11
	.sym	_Anh,32, 51, 1, 176,, 11
	.sym	_Anl,43, 51, 1, 176,, 11
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-74
        NOP
        STL       A,*SP(54)
        LD        *SP(80),A
        STL       A,*SP(55)
        LD        *SP(79),A
        STL       A,*SP(56)
        LD        *SP(78),A
        STL       A,*SP(57)
	.line	19
        STLM      A,AR1
        RSBX      FRCT
        RSBX      OVM
        LD        *AR1(1),A
        MVDK      *SP(54),*(AR1)
        STL       A,*SP(0)
        LD        *AR1(1),A
        CALL      #_L_Comp              ; |219| 
        ; call occurs [#_L_Comp] ; |219| 
        DST       A,*SP(58)             ; |219| 
	.line	21
        LD        *AR1,A
        MVDK      *SP(57),*(AR1)
        STL       A,*SP(0)
        LD        *AR1,A
        STL       A,*SP(1)
        SSBX      SXM
        SSBX      OVM
        DLD       *SP(58),A
        ABS       A,A                   ; |221| 
        RSBX      OVM
        RSBX      FRCT
        NOP
        CALL      #_Div_32              ; |221| 
        ; call occurs [#_Div_32] ; |221| 
        DST       A,*SP(60)             ; |221| 
	.line	22
        SSBX      SXM
        NOP
        DLD       *SP(58),A
        BC        L11,ALEQ              ; |222| 
        ; branch occurs ; |222| 
        RSBX      OVM
        NOP
        DLD       *SP(60),A
        SSBX      OVM
        NOP
        NEG       A,A                   ; |222| 
        DST       A,*SP(60)             ; |222| 
L11:    
	.line	23
        RSBX      OVM
        LDM       SP,A
        ADD       #6,A
        RSBX      FRCT
        STL       A,*SP(0)
        LDM       SP,A
        ADD       #7,A
        STL       A,*SP(1)
        DLD       *SP(60),A             ; |223| 
        CALL      #_L_Extract           ; |223| 
        ; call occurs [#_L_Extract] ; |223| 
	.line	24
        MVDK      *SP(55),*(AR1)
        LD        *SP(6),A
        STL       A,*AR1
	.line	25
        RSBX      OVM
        RSBX      FRCT
        DLD       *SP(60),A             ; |225| 
        ST        #4,*SP(0)             ; |225| 
        CALL      #_L_shr               ; |225| 
        ; call occurs [#_L_shr] ; |225| 
        DST       A,*SP(60)             ; |225| 
	.line	26
        RSBX      OVM
        LDM       SP,A
        ADD       #11,A
        STL       A,*SP(0)
        LDM       SP,A
        ADD       #22,A
        STL       A,*SP(1)
        RSBX      FRCT
        DLD       *SP(60),A             ; |226| 
        CALL      #_L_Extract           ; |226| 
        ; call occurs [#_L_Extract] ; |226| 
	.line	30
        LD        *SP(7),A
        STL       A,*SP(0)
        LD        *SP(6),A
        STL       A,*SP(1)
        LD        *SP(7),A
        STL       A,*SP(2)
        RSBX      FRCT
        RSBX      OVM
        LD        *SP(6),A
        CALL      #_Mpy_32              ; |230| 
        ; call occurs [#_Mpy_32] ; |230| 
	.line	31
        RSBX      OVM
        NOP
        SFTA      A,8                   ; |231| 
        SSBX      SXM
        SSBX      OVM
        SFTA      A,-8                  ; |231| 
        ABS       A,A                   ; |231| 
	.line	32
        RSBX      OVM
        DST       A,*SP(0)              ; |232| 
        RSBX      FRCT
        LD        #32767,16,A           ; |232| 
        CALLD     #_L_sub               ; |232| 
        OR        #65535,A,A            ; |232| 
        ; call occurs [#_L_sub] ; |232| 
	.line	33
        RSBX      OVM
        LDM       SP,B
        ADD       #4,B
        STL       B,*SP(0)
        LDM       SP,B
        ADD       #5,B
        RSBX      FRCT
        STL       B,*SP(1)
        CALL      #_L_Extract           ; |233| 
        ; call occurs [#_L_Extract] ; |233| 
	.line	34
        MVDK      *SP(57),*(AR1)
        LD        *AR1,A
        STL       A,*SP(0)
        LD        *SP(4),A
        STL       A,*SP(1)
        RSBX      OVM
        RSBX      FRCT
        LD        *SP(5),A
        MVDK      *SP(54),*(AR1)
        STL       A,*SP(2)
        LD        *AR1,A
        CALL      #_Mpy_32              ; |234| 
        ; call occurs [#_Mpy_32] ; |234| 
	.line	38
        RSBX      OVM
        LD        A,B                   ; |238| 
        SSBX      SXM
        SFTA      B,8                   ; |238| 
        SFTA      B,-8                  ; |238| 
        EXP       B                     ; |238| 
        NOP
        ST        T,*SP(62)
	.line	39
        LD        *SP(62),B
        RSBX      FRCT
        STL       B,*SP(0)
        CALL      #_L_shl               ; |239| 
        ; call occurs [#_L_shl] ; |239| 
	.line	40
        RSBX      OVM
        LDM       SP,B
        ADD       #8,B
        STL       B,*SP(0)
        LDM       SP,B
        ADD       #9,B
        RSBX      FRCT
        STL       B,*SP(1)
        CALL      #_L_Extract           ; |240| 
        ; call occurs [#_L_Extract] ; |240| 
        RSBX      OVM
        LD        *SP(57),A
        ADD       #2,A,A
        STL       A,*SP(63)
        LDM       AR1,A
        ADD       #2,A,A
        STL       A,*SP(64)
        LD        *SP(55),A
        ADD       #1,A,A
        STL       A,*SP(65)
	.line	46
        LD        #2,A
        STL       A,*SP(66)
L12:    
        LD        *SP(66),A
        SUB       #1,A,B
        LDM       SP,A
        ADD       #21,A
        ADD       B,A
        STLM      A,AR6
        LDM       SP,A
        ADD       #10,A
        ADD       B,A
        STLM      A,AR1
        LD        *SP(57),A
        ADD       #1,A,A
        STL       A,*SP(67)
        LD        *SP(54),A
        ADD       #1,A,A
        STL       A,*SP(68)
        LD        *SP(66),A
        SUB       #1,A,A
        STLM      A,AR7
	.line	51
        LD        #0,A
        DST       A,*SP(60)             ; |251| 
L13:    
	.line	53
        MVDK      *SP(67),*(AR2)
        LD        *AR2+,A
        RSBX      FRCT
        RSBX      OVM
        STL       A,*SP(0)
        MVKD      *(AR2),*SP(67)
        LD        *AR1-,A
        MVDK      *SP(68),*(AR2)
        STL       A,*SP(1)
        LD        *AR6-,A
        STL       A,*SP(2)
        LD        *AR2+,A
        MVKD      *(AR2),*SP(68)
        CALL      #_Mpy_32              ; |253| 
        ; call occurs [#_Mpy_32] ; |253| 
        SSBX      SXM
        NOP
        DLD       *SP(60),B
        SSBX      OVM
        RSBX      SXM
        BANZD     L13,*+AR7(-1)         ; |253| 
        ADD       A,B                   ; |253| 
        DST       B,*SP(60)             ; |253| 
        ; branch occurs ; |253| 
	.line	55
        RSBX      FRCT
        RSBX      OVM
        ST        #4,*SP(0)             ; |255| 
        CALLD     #_L_shl               ; |255| 
        NOP
        LD        B,A                   ; |255| 
        ; call occurs [#_L_shl] ; |255| 
        DST       A,*SP(60)             ; |255| 
	.line	57
        MVDK      *SP(63),*(AR1)
        RSBX      FRCT
        RSBX      OVM
        LD        *AR1,A
        MVDK      *SP(64),*(AR1)
        STL       A,*SP(0)
        LD        *AR1,A
        CALL      #_L_Comp              ; |257| 
        ; call occurs [#_L_Comp] ; |257| 
	.line	58
        SSBX      SXM
        SSBX      OVM
        DLD       *SP(60),B
        RSBX      SXM
        NOP
        ADD       A,B                   ; |258| 
        DST       B,*SP(60)             ; |258| 
	.line	63
        LD        *SP(8),A
        STL       A,*SP(0)
        LD        *SP(9),A
        RSBX      OVM
        STL       A,*SP(1)
        LD        B,A
        SFTA      A,8                   ; |263| 
        SSBX      SXM
        SSBX      OVM
        SFTA      A,-8                  ; |263| 
        ABS       A,A                   ; |263| 
        RSBX      FRCT
        RSBX      OVM
        NOP
        CALL      #_Div_32              ; |263| 
        ; call occurs [#_Div_32] ; |263| 
        DST       A,*SP(58)             ; |263| 
	.line	64
        SSBX      SXM
        NOP
        DLD       *SP(60),A
        BC        L14,ALEQ              ; |264| 
        ; branch occurs ; |264| 
        RSBX      OVM
        NOP
        DLD       *SP(58),A
        SSBX      OVM
        NOP
        NEG       A,A                   ; |264| 
        DST       A,*SP(58)             ; |264| 
L14:    
	.line	65
        LD        *SP(62),A
        RSBX      OVM
        RSBX      FRCT
        STL       A,*SP(0)
        DLD       *SP(58),A             ; |265| 
        CALL      #_L_shl               ; |265| 
        ; call occurs [#_L_shl] ; |265| 
        DST       A,*SP(58)             ; |265| 
	.line	66
        RSBX      OVM
        RSBX      FRCT
        LDM       SP,A
        ADD       #6,A
        STL       A,*SP(0)
        LDM       SP,A
        ADD       #7,A
        STL       A,*SP(1)
        DLD       *SP(58),A             ; |266| 
        CALL      #_L_Extract           ; |266| 
        ; call occurs [#_L_Extract] ; |266| 
	.line	67
        MVDK      *SP(65),*(AR1)
        LD        *SP(6),A
        STL       A,*AR1
	.line	71
        SSBX      SXM
        RSBX      OVM
        NOP
        LD        *SP(6),16,A           ; |271| 
        SSBX      OVM
        NOP
        ABS       A,A                   ; |271| 
        SFTA      A,-16,A               ; |271| 
        RSBX      OVM
        LD        *(AL),A               ; |271| 
        SUB       #32750,A,A            ; |271| 
        BC        L19,AGT               ; |271| 
        ; branch occurs ; |271| 
        LD        *SP(66),A
        SUB       #1,A,B
        MVMM      SP,AR6
        LDM       SP,A
        MVMM      SP,AR1
        ADD       #21,A
        MVMM      SP,AR7
        ADD       B,A
        STL       A,*SP(69)
        LDM       SP,A
        ADD       #10,A
        MAR       *+AR6(#33)
        ADD       B,A
        MAR       *+AR1(#44)
        STL       A,*SP(67)
        MAR       *+AR7(#22)
        LDM       SP,A
        ADD       #11,A
        STL       A,*SP(68)
        LDM       SP,A
        LD        *SP(66),B
        ADD       #43,A
        ADD       B,A
        STL       A,*SP(70)
        LDM       SP,A
        ADD       #32,A
        ADD       B,A
        STL       A,*SP(71)
        LD        B,A
        SUB       #1,A,A
        STL       A,*SP(72)
L15:    
	.line	91
        LD        *SP(7),A
        MVDK      *SP(67),*(AR2)
        STL       A,*SP(0)
        RSBX      FRCT
        RSBX      OVM
        LD        *AR2-,A
        MVKD      *(AR2),*SP(67)
        STL       A,*SP(1)
        MVDK      *SP(69),*(AR2)
        LD        *AR2-,A
        STL       A,*SP(2)
        MVKD      *(AR2),*SP(69)
        LD        *SP(6),A
        CALL      #_Mpy_32              ; |291| 
        ; call occurs [#_Mpy_32] ; |291| 
        DST       A,*SP(60)             ; |291| 
	.line	92
        LD        *AR7+,A
        STL       A,*SP(0)
        MVDK      *SP(68),*(AR2)
        LD        *AR2+,A
        RSBX      FRCT
        RSBX      OVM
        MVKD      *(AR2),*SP(68)
        CALL      #_L_Comp              ; |292| 
        ; call occurs [#_L_Comp] ; |292| 
        SSBX      SXM
        NOP
        DLD       *SP(60),B
        RSBX      SXM
        SSBX      OVM
        NOP
        ADD       A,B                   ; |292| 
        DST       B,*SP(60)             ; |292| 
	.line	93
        MVKD      *(AR6),*SP(0)
        RSBX      OVM
        RSBX      FRCT
        MVKD      *(AR1),*SP(1)
        CALLD     #_L_Extract           ; |293| 
        NOP
        LD        B,A
        ; call occurs [#_L_Extract] ; |293| 
        NOP
	.line	94
        MAR       *AR6+
        MVDK      *SP(72),*(AR2)
        MAR       *AR1+
        BANZD     L15,*+AR2(-1)         ; |294| 
        MVKD      *(AR2),*SP(72)
        ; branch occurs ; |294| 
	.line	95
        RSBX      OVM
        RSBX      FRCT
        ST        #4,*SP(0)             ; |295| 
        DLD       *SP(58),A             ; |295| 
        CALL      #_L_shr               ; |295| 
        ; call occurs [#_L_shr] ; |295| 
        DST       A,*SP(58)             ; |295| 
	.line	96
        RSBX      OVM
        RSBX      FRCT
        LD        *SP(71),A
        STL       A,*SP(0)
        LD        *SP(70),A
        STL       A,*SP(1)
        DLD       *SP(58),A             ; |296| 
        CALL      #_L_Extract           ; |296| 
        ; call occurs [#_L_Extract] ; |296| 
	.line	100
        LD        *SP(7),A
        STL       A,*SP(0)
        LD        *SP(6),A
        STL       A,*SP(1)
        RSBX      OVM
        LD        *SP(7),A
        STL       A,*SP(2)
        RSBX      FRCT
        LD        *SP(6),A
        CALL      #_Mpy_32              ; |300| 
        ; call occurs [#_Mpy_32] ; |300| 
	.line	101
        RSBX      OVM
        NOP
        SFTA      A,8                   ; |301| 
        SSBX      SXM
        SSBX      OVM
        SFTA      A,-8                  ; |301| 
        ABS       A,A                   ; |301| 
	.line	102
        DST       A,*SP(0)              ; |302| 
        RSBX      OVM
        RSBX      FRCT
        LD        #32767,16,A           ; |302| 
        CALLD     #_L_sub               ; |302| 
        OR        #65535,A,A            ; |302| 
        ; call occurs [#_L_sub] ; |302| 
	.line	103
        RSBX      OVM
        LDM       SP,B
        ADD       #4,B
        STL       B,*SP(0)
        LDM       SP,B
        RSBX      FRCT
        ADD       #5,B
        STL       B,*SP(1)
        CALL      #_L_Extract           ; |303| 
        ; call occurs [#_L_Extract] ; |303| 
	.line	104
        LD        *SP(9),A
        STL       A,*SP(0)
        LD        *SP(4),A
        RSBX      FRCT
        STL       A,*SP(1)
        RSBX      OVM
        LD        *SP(5),A
        STL       A,*SP(2)
        LD        *SP(8),A
        CALL      #_Mpy_32              ; |304| 
        ; call occurs [#_Mpy_32] ; |304| 
	.line	108
        RSBX      OVM
        LD        A,B                   ; |308| 
        SSBX      SXM
        SFTA      B,8                   ; |308| 
        SFTA      B,-8                  ; |308| 
        EXP       B                     ; |308| 
        NOP
        MVMD      T,AR1
	.line	109
        RSBX      FRCT
        MVKD      *(AR1),*SP(0)
        CALL      #_L_shl               ; |309| 
        ; call occurs [#_L_shl] ; |309| 
	.line	110
        RSBX      OVM
        LDM       SP,B
        ADD       #8,B
        STL       B,*SP(0)
        LDM       SP,B
        ADD       #9,B
        RSBX      FRCT
        STL       B,*SP(1)
        CALL      #_L_Extract           ; |310| 
        ; call occurs [#_L_Extract] ; |310| 
	.line	111
        LD        *SP(62),A
        RSBX      OVM
        SSBX      SXM
        LD        *(AL),16,A            ; |311| 
        SSBX      OVM
        ADD       *(AR1),16,A,A         ; |311| 
        SFTA      A,-16,A               ; |311| 
        MVMM      SP,AR5
        MVMM      SP,AR2
        STL       A,*SP(62)
        MVMM      SP,AR3
        MVMM      SP,AR4
        LD        *SP(66),A
        MAR       *+AR5(#33)
        MAR       *+AR2(#44)
        RSBX      OVM
        MAR       *+AR3(#11)
        SUB       #1,A,A
        STLM      A,BRC
        MAR       *+AR4(#22)
        RPTB      L17-1
        ; loop starts
L16:    
	.line	117
        MVDD      *AR5+,*AR3+           ; |317| 
	.line	118
        MVDD      *AR2+,*AR4+           ; |318| 
	.line	119
        ; loop ends ; |319| 
L17:    
	.line	120
        LD        *SP(63),A
        ADD       #1,A
        STL       A,*SP(63)
        LD        *SP(64),A
        ADD       #1,A
        STL       A,*SP(64)
        LD        *SP(65),A
        ADD       #1,A
        STL       A,*SP(65)
        LD        *SP(66),A
        ADD       #1,A
        STL       A,*SP(66)
        LD        *(AL),A               ; |320| 
        SUB       #10,A,A               ; |320| 
        BC        L12,ALEQ              ; |320| 
        ; branch occurs ; |320| 
	.line	124
        MVDK      *SP(56),*(AR1)
        ST        #4096,*AR1            ; |324| 
        MVMM      SP,AR6
        LD        *SP(56),A
        STM       #_old_A+1,AR7
        ADD       #1,A,A
        MVMM      SP,AR1
        MAR       *+AR6(#22)
        STL       A,*SP(67)
        MAR       *+AR1(#11)
        LD        #10,A
        STL       A,*SP(68)
L18:    
	.line	127
        LD        *AR6+,A
        RSBX      FRCT
        RSBX      OVM
        STL       A,*SP(0)
        LD        *AR1+,A
        CALL      #_L_Comp              ; |327| 
        ; call occurs [#_L_Comp] ; |327| 
	.line	128
        RSBX      FRCT
        RSBX      OVM
        ST        #1,*SP(0)             ; |328| 
        CALL      #_L_shl               ; |328| 
        ; call occurs [#_L_shl] ; |328| 
        RSBX      OVM
        SSBX      SXM
        SFTA      A,8                   ; |328| 
        SFTA      A,-8                  ; |328| 
        SSBX      OVM
        ADD       #1,#15,A,A            ; |328| 
        MVDK      *SP(67),*(AR2)
        SFTA      A,-16,A               ; |328| 
        STL       A,*AR2+
        MVKD      *(AR2),*SP(67)
        STL       A,*AR7+
	.line	129
        MVDK      *SP(68),*(AR2)
        BANZD     L18,*+AR2(-1)         ; |329| 
        MVKD      *(AR2),*SP(68)
        ; branch occurs ; |329| 
	.line	130
        MVDK      *SP(55),*(AR3)
        STM       #_old_rc,AR2
        MVDD      *AR3,*AR2             ; |330| 
	.line	131
        MVMM      AR3,AR1
        LD        *AR1(1),A
        STL       A,*AR2(1)
	.line	133
        B         L22                   ; |333| 
        ; branch occurs ; |333| 
L19:    
        MVDK      *SP(56),*(AR2)
        STM       #_old_A,AR3
        RPT       #10
        ; loop starts
L20:    
	.line	75
        MVDD      *AR3+,*AR2+           ; |275| 
	.line	76
        ; loop ends ; |276| 
L21:    
	.line	77
        STM       #_old_rc,AR2
        MVDK      *SP(55),*(AR3)
        MVDD      *AR2,*AR3             ; |277| 
	.line	78
        MVMM      AR3,AR1
        LD        *AR2(1),A
        STL       A,*AR1(1)
L22:    
	.line	134
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #74
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
	.endfunc	334,000018400h,77



	.sect	".text"
	.global	_Lag_window
	.sym	_Lag_window,_Lag_window, 32, 2, 0
	.func	108

;***************************************************************
;* FUNCTION DEF: _Lag_window                                   *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lag_window:
	.line	6
;* A     assigned to _m
	.sym	_m,0, 3, 17, 16
	.sym	_r_h,10, 19, 9, 16
	.sym	_r_l,11, 19, 9, 16
;* AR7   assigned to U$17
;* AR6   assigned to U$19
;* AR1   assigned to U$21
;* A     assigned to _m
	.sym	_m,0, 3, 4, 16
;* AR1   assigned to _r_h
	.sym	_r_h,10, 19, 4, 16
;* AR6   assigned to _r_l
	.sym	_r_l,15, 19, 4, 16
;* A     assigned to _x
	.sym	_x,0, 5, 4, 32
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-6
        NOP
        MVDK      *SP(10),*(AR1)
        MVDK      *SP(11),*(AR6)
	.line	10
        SSBX      SXM
        LD        *(AL),A               ; |117| 
        BC        L24,ALEQ              ; |117| 
        ; branch occurs ; |117| 
        STL       A,*SP(4)
        LD        #_lag_l,A
        STM       #_lag_h,AR7
        STL       A,*SP(5)
L23:    
	.line	12
        LD        *+AR6(1),A
        STL       A,*SP(0)
        LD        *AR7+,A
        STL       A,*SP(1)
        MVDK      *SP(5),*(AR2)
        LD        *AR2+,A
        MVKD      *(AR2),*SP(5)
        STL       A,*SP(2)
        LD        *+AR1(1),A
        CALL      #_Mpy_32              ; |119| 
        ; call occurs [#_Mpy_32] ; |119| 
	.line	13
        MVKD      *(AR1),*SP(0)
        MVKD      *(AR6),*SP(1)
        CALL      #_L_Extract           ; |120| 
        ; call occurs [#_L_Extract] ; |120| 
	.line	14
        MVDK      *SP(4),*(AR2)
        BANZD     L23,*+AR2(-1)         ; |121| 
        MVKD      *(AR2),*SP(4)
        ; branch occurs ; |121| 
L24:    
	.line	16
        FRAME     #6
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
	.endfunc	123,000018400h,9


	.sect	".text"
	.sym	_Chebps_11,_Chebps_11, 35, 3, 0
	.func	700

;***************************************************************
;* FUNCTION DEF: _Chebps_11                                    *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Chebps_11:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-12
        NOP
        STL       A,*SP(6)          ;sp(6) = x
        LD        *SP(16),A
        STL       A,*SP(7)          ;sp(7) = f
        MVDK      *SP(17),*(AR1)    ;ar1 = n

;----------------------------------------------------------------------
; 693 | L_Extract(t0, &b1_h, &b1_l);          /* b1 = 2*x + f[1]     */        
;----------------------------------------------------------------------
        ;RSBX      OVM
        SSBX      FRCT
        SSBX      SXM
        LD        #4096,B
        LDM       SP,A
        ADD       #3,A
        STL       A,*SP(0)         ;sp(3) = &b1_h
        LDM       SP,A
        ADD       #2,A
        STL       A,*SP(1)         ;sp(2) = &b1_l
        SSBX      OVM
        LD        *SP(6),A         
        MPY       *(AL),#512,A     ;a= t0 = L_mult(x, 512)     
        ;RSBX      OVM
        MVDK      *SP(7),*(AR2)    ;ar2 = f
        ;SFTA      A,8                  
        LD        *AR2(1),T        ;T = f[1]
        ;SFTA      A,-8  
                       
        ;ORM       #2,*(PMST)
        ;SSBX      OVM
        ORM       #2,*(PMST)
        MAC       *(BL), A          ;a = t0 = L_mac(t0, f[1], 4096)  
        ;RSBX      FRCT
        ;RSBX      OVM
        ;NOP
        ;CALL      #_L_Extract           
;------------------  L_Extract inlien  ----------------------------
        ;SSBX      SXM             ; ****
        ;RSBX      OVM
        ;SSBX      FRCT
        ;SFTA      A,8
        ;SFTA      A,-8
        ;SSBX      OVM

        MVDK      *SP(1),*(AR4)
        MVDK      *SP(0),*(AR2)
        
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
;------------------  L_Extract End     ----------------------------
        STM       #256,AR6

        LD        #0,A
        STL       A,*SP(8)          ;sp(8) = b2_l = 0

        ;RSBX      OVM
        ;SSBX      SXM
        LD        *(AR1),A           ;a = n
        SUB       #2,A,A              
        BC        L25,AGT            ;if( n-2 >0) 

        BD        L27
        LD        #2,A
        STL       A,*SP(9)           
        
L25:    
        LD        *SP(7),A
        ADD       #2,A,A
        STLM      A,AR7              ;ar7 = &f[2]

        MVKD      *(AR1),*SP(9)      
        LD        *SP(9),A
        SUB       #2,A,A
        STLM      A,AR1              ;ar1 = loop counter,sub 2 each time
L26:    
        ;LD        *SP(2),A           
        ;RSBX      FRCT
        ;STL       A,*SP(0)
        ;RSBX      OVM
        ;LD        *SP(6),A
        ;STL       A,*SP(1)
        ;LD        *SP(3),A
        ;CALL      #_Mpy_32_16         
;-----------------  Mpy_32_16 inline  ----------------------------------
        LD        *SP(2),T        ; T = lo
        LD        *SP(6),B        ; B = n
        ;STLM      A,AR4           ; ar1 = hi
        MVDK      *SP(3),*(AR4)
        ;SSBX      SXM
        ;SSBX      FRCT
        ;SSBX      OVM
        LD        *(BL),16,A       ; ah = n   
        NOP
        MPYA      A                ; a = L_mult(lo, n)  
        STLM      B,T              ; T = n
        STH       A,*(AR2)         ; (ar2) = L_mult(lo, n)  
        MPY       *(AR4),A         ; a = L_mult(hi, n)           
        MVMD      AR2,T            
        MAC       #1, A   
                   
        ;ANDM      #-833,*(ST1)   
;-----------------  Mpy_32_16 End     ----------------------------------
        ;OVM = SXM = FRCT =0 after calling Mpy_32_16
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #1,*SP(0)             
        ;CALL      #_L_shl 
                      
        ;SSBX      OVM          ;d.l.b
        SFTA      A,1          ;use SFTA instead of L_shl
        
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SSBX      SXM
        MVMD      AR6,T                 ;T = ar6 = b2_h
        LD        #-32768,B
        ;SFTA      A,-8                  ;a = t0
        ;ORM       #2,*(PMST)
        ;SSBX      FRCT
        ;SSBX      OVM
        ORM       #2,*(PMST)
        MAC       *(BL), A              ;a = L_mac(t0,b2_h,(Word16)-32768L)
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SSBX      OVM
        ;SFTA      A,-8        
                      ;SXM = OVM = FRCT =1          
        LD        *SP(8),T              ;sp(8) = b2_l
        LD        #1,B
        MAS       *(BL), A              ;a = L_msu(t0, b2_l, 1)         

        
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                  
        ;SSBX      OVM
        LD        *AR7+,T
        LD        #4096,B
        ;SFTA      A,-8                  
        MAC       *(BL), A              ;a = L_mac(t0, f[i], 4096)

        ;RSBX      OVM
        LDM       SP,B
        ADD       #5,B
        STL       B,*SP(0)              ;sp(5) = b0_h
        LDM       SP,B
        ADD       #4,B
        ;RSBX      FRCT
        STL       B,*SP(1)              ;sp(4) = b0_l
        ;CALL      #_L_Extract  
;-------------------  L_Extract  Inline  -----------------------------
        ;SSBX      SXM             ; ****
        ;RSBX      OVM
        ;SSBX      FRCT
        ;SFTA      A,8
        ;SFTA      A,-8
        ;SSBX      OVM

        MVDK      *SP(1),*(AR4)
        MVDK      *SP(0),*(AR2)
        
        LD        A,B                   
        SFTL      B,#-16,B              
        STLM      B,AR3
        MVKD      *(AR3),*AR2

        SFTA      A,-1              
        
        MVMD      AR3,T
        LD        #16384,B
        ;ORM       #2,*(PMST)
        MAS       *(BL), A              
        STL       A,*AR4  
;-------------------  L_Extract  End     -----------------------------                 
        LD        *SP(2),A
        STL       A,*SP(8)
        MVDK      *SP(3),*(AR6)         ;ar6=&b2_h
        LD        *SP(4),A
        STL       A,*SP(2)
        LD        *SP(5),A
        STL       A,*SP(3)
        BANZ      L26,*+AR1(-1)         
        
L27:    
;----------------------------------------------------------------------
; 711 | t0 = Mpy_32_16(b1_h, b1_l, x);        /* t0 = x*b1;              */    
;----------------------------------------------------------------------
        ;LD        *SP(2),A
        ;RSBX      FRCT
        ;STL       A,*SP(0)
        ;RSBX      OVM
        ;LD        *SP(6),A
        ;STL       A,*SP(1)
        ;LD        *SP(3),A
        ;CALL      #_Mpy_32_16           
;------------------- Mpy_32_16 inline  -------------------------------
        LD        *SP(2),T        ; T = lo
        LD        *SP(6),B        ; B = n
        ;STLM      A,AR3           ; ar1 = hi
        MVDK      *SP(3),*(AR5)
        LD        *(BL),16,A       ; ah = n   
        NOP
        MPYA      A                ; a = L_mult(lo, n)  
        STLM      B,T              ; T = n
        STH       A,*(AR4)         ; (ar2) = L_mult(lo, n)  
        MPY       *(AR5),A         ; a = L_mult(hi, n)           
        MVMD      AR4,T            
        MAC       #1, A  
;------------------- End  --------------------------------------------
;----------------------------------------------------------------------
; 712 | t0 = L_mac(t0, b2_h,(Word16)-32768L); /* t0 = x*b1 - b2          */    
; 713 | t0 = L_msu(t0, b2_l, 1);                                               
; 714 | t0 = L_mac(t0, f[i], 2048);           /* t0 = x*b1 - b2 + f[i]/2 */    
;----------------------------------------------------------------------
        ;SSBX      SXM
        ;RSBX      OVM
        MVMD      AR6,T
        LD        #-32768,B
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        ;ORM       #2,*(PMST)
        ;SSBX      FRCT
        ;SSBX      OVM
        ;ORM       #2,*(PMST)
        NOP
        MAC       *(BL), A              
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                  
        ;SFTA      A,-8                 
        LD        #1,B
        LD        *SP(8),T
        ;SSBX      OVM
        MAS       *(BL), A             
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        DST       A,*SP(10)             
        LD        *SP(9),A
        LD        *SP(7),B
        ADD       A,B                   
        STLM      B,AR1
        NOP
        DLD       *SP(10),A            
        LD        *AR1,T
        ;SSBX      OVM
        LD        #2048,B
        MAC       *(BL), A              
        DST       A,*SP(10)             

;----------------------------------------------------------------------
; 716 | t0 = L_shl(t0, 6);                    /* Q24 to Q30 with saturation */ 
; 717 | cheb = extract_h(t0);                 /* Result in Q14              */ 
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #6,*SP(0)             
        ;CALL      #_L_shl             
        SFTA       A,6
;----------------------------------------------------------------------
; 720 | return(cheb);                                                          
;----------------------------------------------------------------------
        SFTL      A,#-16,A             
        ANDM      #-833,*(ST1)         
        ANDM      #-4,*(PMST)           
        FRAME     #12                   
        POPM      AR7                  
        POPM      AR6                  
        POPM      AR1                 
        RET       
        ; return occurs ; |740| 
	.endfunc	741,000018400h,15



	.sect	".text"
	.sym	_Chebps_10,_Chebps_10, 35, 3, 0
	.func	744

;***************************************************************
;* FUNCTION DEF: _Chebps_10                                    *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Chebps_10:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-12
        NOP
        STL       A,*SP(6)
        LD        *SP(16),A
        STL       A,*SP(7)
        MVDK      *SP(17),*(AR1)

;----------------------------------------------------------------------
; 737 | L_Extract(t0, &b1_h, &b1_l);          /* b1 = 2*x + f[1]     */        
;----------------------------------------------------------------------
        ;RSBX      OVM
        SSBX      FRCT
        SSBX      SXM
        LD        #4096,B
        LDM       SP,A
        ADD       #3,A
        STL       A,*SP(0)
        LDM       SP,A
        ADD       #2,A
        STL       A,*SP(1)
        SSBX      OVM
        LD        *SP(6),A
        MPY       *(AL),#256,A          ; |737| 
        ;RSBX      OVM
        MVDK      *SP(7),*(AR2)
        ;SFTA      A,8                   ; |737| 
        LD        *AR2(1),T
        ;SFTA      A,-8                  ; |737| 
        ;ORM       #2,*(PMST)
        ;SBX      OVM
        ORM       #2,*(PMST)
        MAC       *(BL), A              ; |737| 
        ;RSBX      FRCT
        ;RSBX      OVM
        ;NOP
        ;CALL      #_L_Extract           ; |737| 
;------------------  L_Extract inlien  ----------------------------
        ;SSBX      SXM             ; ****
        ;RSBX      OVM
        ;SSBX      FRCT
        ;SFTA      A,8
        ;SFTA      A,-8
        ;SSBX      OVM

        MVDK      *SP(1),*(AR4)
        MVDK      *SP(0),*(AR2)
        
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
;------------------  L_Extract End     ----------------------------
        STM       #128,AR6

        LD        #0,A
        STL       A,*SP(8)

        ;RSBX      OVM
        ;SSBX      SXM
        LD        *(AR1),A              ; |739| 
        SUB       #2,A,A                ; |739| 
        BC        L28,AGT               ; |739| 

        BD        L30
        LD        #2,A
        STL       A,*SP(9)
  
L28:    

        LD        *SP(7),A
        ADD       #2,A,A
        STLM      A,AR7

        MVKD      *(AR1),*SP(9)
        LD        *SP(9),A
        SUB       #2,A,A
        STLM      A,AR1
L29:    

        ;LD        *SP(2),A
        ;RSBX      FRCT
        ;STL       A,*SP(0)
        ;RSBX      OVM
        ;LD        *SP(6),A
        ;STL       A,*SP(1)
        ;LD        *SP(3),A
        ;CALL      #_Mpy_32_16           
;-----------------  Mpy_32_16 inline  ----------------------------------
        LD        *SP(2),T        ; T = lo
        LD        *SP(6),B        ; B = n
        ;STLM      A,AR4           ; ar1 = hi
        MVDK      *SP(3),*(AR4)
        SSBX      SXM
        SSBX      FRCT
        SSBX      OVM
        LD        *(BL),16,A       ; ah = n   
        NOP
        MPYA      A                ; a = L_mult(lo, n)  
        STLM      B,T              ; T = n
        STH       A,*(AR2)         ; (ar2) = L_mult(lo, n)  
        MPY       *(AR4),A         ; a = L_mult(hi, n)           
        MVMD      AR2,T            
        MAC       #1, A   
                   
        ;ANDM      #-833,*(ST1)   
;-----------------  Mpy_32_16 End     ----------------------------------        

        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #1,*SP(0)             
        ;CALL      #_L_shl               
        SFTA      A,1

        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SSBX      SXM
        MVMD      AR6,T
        LD        #-32768,B
        ;SFTA      A,-8                  
        ;ORM       #2,*(PMST)
        ;SSBX      FRCT
        ;SSBX      OVM
        ORM       #2,*(PMST)
        MAC       *(BL), A             
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SSBX      OVM
        ;SFTA      A,-8                  
        LD        *SP(8),T
        LD        #1,B
        MAS       *(BL), A              
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SSBX      OVM
        LD        *AR7+,T
        LD        #4096,B
        ;SFTA      A,-8                  
        MAC       *(BL), A             

        ;RSBX      OVM
        LDM       SP,B
        ADD       #5,B
        ;STL       B,*SP(0)
        STLM      B,AR2
        LDM       SP,B
        ADD       #4,B
        ;RSBX      FRCT
        ;STL       B,*SP(1)
        STLM      B,AR4
        ;CALL      #_L_Extract          
;-------------------  L_Extract  Inline  -----------------------------
        ;SSBX      SXM             ; ****
        ;RSBX      OVM
        ;SSBX      FRCT
        ;SFTA      A,8
        ;SFTA      A,-8
        ;SSBX      OVM

        ;MVDK      *SP(1),*(AR4)
        ;MVDK      *SP(0),*(AR2)
        
        LD        A,B                   
        SFTL      B,#-16,B              
        STLM      B,AR3
        MVKD      *(AR3),*AR2

        SFTA      A,-1              
        
        MVMD      AR3,T
        LD        #16384,B
        ;ORM       #2,*(PMST)
        MAS       *(BL), A              
        STL       A,*AR4  
;-------------------  L_Extract  End     ----------------------------- 
        LD        *SP(2),A
        STL       A,*SP(8)

        MVDK      *SP(3),*(AR6)

        LD        *SP(4),A
        STL       A,*SP(2)

        LD        *SP(5),A
        STL       A,*SP(3)

        BANZ      L29,*+AR1(-1)         
 
L30:    
;----------------------------------------------------------------------
; 755 | t0 = Mpy_32_16(b1_h, b1_l, x);        /* t0 = x*b1;              */    
;----------------------------------------------------------------------
        ;LD        *SP(2),A
        ;RSBX      FRCT
        ;STL       A,*SP(0)
        ;RSBX      OVM
        ;LD        *SP(6),A
        ;STL       A,*SP(1)
        ;LD        *SP(3),A
        ;CALL      #_Mpy_32_16          
;------------------- Mpy_32_16 inline  -------------------------------
        LD        *SP(2),T        ; T = lo
        LD        *SP(6),B        ; B = n
        ;STLM      A,AR3           ; ar1 = hi
        MVDK      *SP(3),*(AR5)
        LD        *(BL),16,A       ; ah = n   
        NOP
        MPYA      A                ; a = L_mult(lo, n)  
        STLM      B,T              ; T = n
        STH       A,*(AR4)         ; (ar2) = L_mult(lo, n)  
        MPY       *(AR5),A         ; a = L_mult(hi, n)           
        MVMD      AR4,T            
        MAC       #1, A  
;------------------- End  --------------------------------------------
;----------------------------------------------------------------------
; 756 | t0 = L_mac(t0, b2_h,(Word16)-32768L); /* t0 = x*b1 - b2          */    
; 757 | t0 = L_msu(t0, b2_l, 1);                                               
; 758 | t0 = L_mac(t0, f[i], 2048);           /* t0 = x*b1 - b2 + f[i]/2 */    
;----------------------------------------------------------------------
        ;SSBX      SXM
        ;RSBX      OVM
        MVMD      AR6,T
        LD        #-32768,B
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        ;ORM       #2,*(PMST)
        ;SSBX      FRCT
        ;SSBX      OVM
        ;ORM       #2,*(PMST)
        MAC       *(BL), A              
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        LD        #1,B
        LD        *SP(8),T
        ;SSBX      OVM
        MAS       *(BL), A              
        ;RSBX      OVM
        ;NOP
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        DST       A,*SP(10)             
        LD        *SP(9),A
        LD        *SP(7),B
        ADD       A,B                   
        STLM      B,AR1
        NOP
        DLD       *SP(10),A             
        LD        *AR1,T
        ;SSBX      OVM
        LD        #2048,B
        MAC       *(BL), A              
        DST       A,*SP(10)             

;----------------------------------------------------------------------
; 760 | t0 = L_shl(t0, 7);                    /* Q23 to Q30 with saturation */ 
; 761 | cheb = extract_h(t0);                 /* Result in Q14              */ 
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #7,*SP(0)            
        ;CALL      #_L_shl              
		SFTA       A,7
;----------------------------------------------------------------------
; 764 | return(cheb);                                                          
;----------------------------------------------------------------------
        SFTL      A,#-16,A             

        ANDM      #-833,*(ST1)        
        ANDM      #-4,*(PMST)           
        FRAME     #12                   
        POPM      AR7                   
        POPM      AR6                   
        POPM      AR1                 
        RET       
        ; return occurs ; |784| 
	.endfunc	785,000018400h,15



	.sect	".text"
	.global	_Az_lsp
	.sym	_Az_lsp,_Az_lsp, 32, 2, 0
	.func	486

;***************************************************************
;* FUNCTION DEF: _Az_lsp                                       *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Az_lsp:
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-28
        STLM      A,AR1            ;ar1 = a
        LD        *SP(33),A
        STL       A,*SP(14)        ;sp(14) = old_lsp
        LD        *SP(32),A
        STL       A,*SP(15)        ;sp(15) = lsp

;----------------------------------------------------------------------
; 498 | f1[0] = 2048;          /* f1[0] = 1.0 is in Q11 */                     
;----------------------------------------------------------------------
        ST        #2048,*SP(2)          

;----------------------------------------------------------------------
; 499 | f2[0] = 2048;          /* f2[0] = 1.0 is in Q11 */                     
; 528 | //if ( ovf_coef ) {                                                    
;----------------------------------------------------------------------
        ST        #2048,*SP(8)             
;----------------------------------------------------------------------
; 529 | if(Test_Overflow(a, f1, f2)) {                                         
; 532 |   pChebps = Chebps_10;                                                 
;----------------------------------------------------------------------
        RSBX      OVM
        RSBX      FRCT
        LDM       SP,A
        ADD       #2,A
        STL       A,*SP(0)           ;first par f1=sp(2)
        LDM       SP,A
        ADD       #8,A
        STL       A,*SP(1)
        CALLD     #_Test_Overflow       
        NOP
        LDM       AR1,A
        

        STLM      A,AR2              
        NOP
        NOP
        BANZ      L31,*AR2            ;if( Overflow happend ) goto L31

        LD        #_Chebps_11,A
        BD        L33
        NOP
        STL       A,*SP(16)           ;sp(16) = pChebps 

L31:    
        ST        #1024,*SP(2)        ;f1[0] = 1024
        RSBX      OVM
        LDM       AR1,A
        ADD       #10,A,A
        STLM      A,AR2                ;ar2 = &a[M]
        MVMM      SP,AR3
        LDM       AR1,A
        MVMM      SP,AR1
        MAR       *+AR3(#2)            ;ar3 = f1
        MAR       *+AR1(#8)            ;ar1 = f2
        ADD       #1,A,A
        STLM      A,AR4                ;ar4 = &a[1]
        ST        #1024,*SP(8)         ;f2[0] = 1024

        STM       #4,BRC
        LD        #_Chebps_10,A
        STL       A,*SP(16)            ;update pChebps
        RPTB      L33-1
L32:    

;----------------------------------------------------------------------
; 542 | f1[i+1] = sub(x, f1[i]);            /* f1[i+1] = a[i+1] + a[M-i] - f1[i
;     | ] */                                                                   
; 544 | t0 = L_mult(a[i+1], 8192);          /* x = (a[i+1] - a[M-i]) >> 1
;     |   */                                                                   
; 545 | t0 = L_msu(t0, a[M-i], 8192);       /*    -> From Q11 to Q10
;     |   */                                                                   
; 546 | x  = extract_h(t0);                                                    
;----------------------------------------------------------------------
        SSBX      SXM
        SSBX      FRCT
        SSBX      OVM
        NOP
        MPY       *AR4,#8192,A          ; a = L_mult(a[i+1], 8192)
        SSBX      SXM
        RSBX      OVM
        LD        #8192,B
        SFTA      A,8                   
        LD        *AR2,T                ; T = a[M-i]
        SFTA      A,-8                   
        ORM       #2,*(PMST)
        SSBX      OVM
        ORM       #2,*(PMST)
        MAC       *(BL), A              ; a = t0 = L_mac(t0, a[M-i], 8192) 
        RSBX      OVM
        SFTL      A,#-16,A              ; a = x = extract_h(t0)
        LD        *(AL),16,A            
        SSBX      OVM
        NOP

        SUB       *AR3,16,A,A           ; a = sub(x, f1[i]) 
        SFTA      A,-16,A                
        STL       A,*+AR3               ;fl[i+1] = sub(x, f1[i]) 

;----------------------------------------------------------------------
; 547 | f2[i+1] = add(x, f2[i]);            /* f2[i+1] = a[i+1] - a[M-i] + f2[i
;     | ] */                                                                   
;----------------------------------------------------------------------
        MPY       *AR4+,#8192,A         
        RSBX      OVM
        NOP
        SFTA      A,8                    
        LD        *AR2-,T
        LD        #8192,B
        SSBX      OVM
        SFTA      A,-8                  
        MAS       *(BL), A              
        RSBX      OVM
        SFTL      A,#-16,A              
        LD        *(AL),16,A            
        SSBX      OVM
        NOP
        ADD       *AR1,16,A,A           
        SFTA      A,-16,A               
        STL       A,*+AR1

;----------------------------------------------------------------------
; 555 | nf=0;          /* number of found frequencies */                       
; 556 | ip=0;          /* indicator for f1 or f2      */                       
; 558 | coef = f1;                                                             
;----------------------------------------------------------------------
L33:    
;----------------------------------------------------------------------
; 560 | xlow = grid[0];                                                        
;----------------------------------------------------------------------
        STM       #_grid,AR7
        MVDK      *AR7,*(AR1)
;----------------------------------------------------------------------
; 561 | ylow = (*pChebps)(xlow, coef, NC);                                     
;----------------------------------------------------------------------
        RSBX      OVM
        LDM       SP,A
        ADD       #2,A
        RSBX      FRCT
        STL       A,*SP(0)       ;coef = f1
        ST        #5,*SP(1)             
        LD        *SP(16),B
        LD        *AR7,A         ;a = xlow = grid[0]
        CALA      B                     

        STLM      A,AR6          ;ar6 = ylow = (*pChebps)(xlow, coef, NC)
        LD        #0,A
        STL       A,*SP(17)      ;sp(17) = nf
        LD        #0,A
        STL       A,*SP(18)      ;sp(18) = ip
        RSBX      OVM
        LDM       SP,A
        ADD       #2,A
        STL       A,*SP(19)      

;----------------------------------------------------------------------
; 563 | j = 0;                                                                 
; 564 | while ( (nf < M) && (j < GRID_POINTS) )                                
;----------------------------------------------------------------------
        LD        #0,A
        STL       A,*SP(20)

        MVKD      *(AR7),*SP(21) ;sp(21) = grid
L34:    

;----------------------------------------------------------------------
; 566 | j =add(j,1);                                                           
;----------------------------------------------------------------------
        SSBX      SXM
        LD        *SP(20),A
        ;LD        *(AL),16,A      
        ;SSBX      OVM
        ;NOP
        ;ADD       #1,16,A,A            
        ;SFTA      A,-16,A   
        ADD       #1,A,A    
        STL       A,*SP(20)        ;j = add(j,1)
        ;j no overflow

;----------------------------------------------------------------------
; 567 | xhigh = xlow;                                                          
;----------------------------------------------------------------------
        MVKD      *(AR1),*SP(22)   ;sp(22) = xhigh

;----------------------------------------------------------------------
; 568 | yhigh = ylow;                                                          
;----------------------------------------------------------------------
        MVKD      *(AR6),*SP(23)   ;sp(23) = yhigh

;----------------------------------------------------------------------
; 569 | xlow  = grid[j];                                                       
;----------------------------------------------------------------------
        RSBX      OVM
        LD        A,B
        LD        *SP(21),A
        ADD       A,B                   ; b = grid[i]
        STLM      B,AR1                 ; ar1 = grid[i]
        NOP
        NOP
        MVDK      *AR1,*(AR1)           ; ar1 = xlow = grid[i]

;----------------------------------------------------------------------
; 570 | ylow  = (*pChebps)(xlow,coef,NC);                                      
; 572 | L_temp = L_mult(ylow ,yhigh);                                          
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ; FRCT = OVM =0, SXM = 1
        LD        *SP(19),A             ;sp(19) = coef
        STL       A,*SP(0)
        ST        #5,*SP(1)             
        LD        *SP(16),B
        CALAD     B                     
        NOP
        LDM       AR1,A
        
        STLM      A,AR6                 ;ar6 = ylow = (*pChebps)(xlow,coef,NC)

;----------------------------------------------------------------------
; 573 | if ( L_temp <= (Word32)0)                                              
; 578 |   for (i = 0; i < 2; i++)                                              
;----------------------------------------------------------------------
        LD        *SP(23),T             ;T = yhigh
        SSBX      FRCT
        SSBX      OVM
        MPY       *(AR6),A              ; a = L_temp
        ;RSBX      OVM
        ;SSBX      SXM
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        BC        L43,AGT        ;if ( L_temp > (Word32)0)    goto L43   

        STM       #2,AR7
L35:    

;----------------------------------------------------------------------
; 580 | xmid = add( shr(xlow, 1) , shr(xhigh, 1)); /* xmid = (xlow + xhigh)/2 *
;     | /                                                                      
;----------------------------------------------------------------------
        SSBX       SXM           ;****
        RSBX       OVM           ;****
        RSBX       FRCT          ;****
        ;RSBX      FRCT
        ;ST        #1,*SP(0)             
        ;CALLD     #_crshft               
        ;NOP
        ;LDM       AR1,A
        LD         *(AR1),-1,A         ;**** a= xlow >> 1
        
        ;SSBX      SXM
        ;RSBX      OVM
        ;RSBX      FRCT
        ;ST        #1,*SP(0)             
        LD        *(AL),16,A            
        DST       A,*SP(24)             
        ;LD        *SP(22),A
        ;CALL      #_crshft               
        LD         *SP(22),-1,A        ;****
        
        ;RSBX      OVM
        ;NOP
        DLD       *SP(24),B             
        SSBX      OVM
        ;SSBX      SXM
        ADD       *(AL),16,B,A           
        SFTA      A,-16,A               
        STL       A,*SP(26)           ;sp(26) = xmid

;----------------------------------------------------------------------
; 582 | ymid = (*pChebps)(xmid,coef,NC);                                       
; 584 | L_temp = L_mult(ylow,ymid);                                            
;----------------------------------------------------------------------
        LD        *SP(19),A
        STL       A,*SP(0)
        ST        #5,*SP(1)            
        LD        *SP(16),B
        ;RSBX      FRCT
        ;RSBX      OVM
        LD        *SP(26),A
        CALA      B                    
        ; FRCT = OVM = SXM = 0
;----------------------------------------------------------------------
; 585 | if ( L_temp <= (Word32)0)                                              
; 587 |   yhigh = ymid;                                                        
; 588 |   xhigh = xmid;                                                        
; 590 | else                                                                   
;----------------------------------------------------------------------
        SSBX      SXM                   ;****
        STLM      A,T                   ;a = ymid
        SSBX      FRCT
        SSBX      OVM
        MPY       *(AR6),B              ;b = L_mult(ylow,ymid)
        ;RSBX      OVM
        ;SSBX      SXM
        ;SFTA      B,8                   
        ;SFTA      B,-8                   
        BC        L36,BLEQ              ;if( L_temp <=0) goto L36       

;----------------------------------------------------------------------
; 592 | ylow = ymid;                                                           
;----------------------------------------------------------------------
        STLM      A,AR6                 ;ylow = ymid

;----------------------------------------------------------------------
; 593 | xlow = xmid;                                                           
;----------------------------------------------------------------------
        BD        L37                   
        MVDK      *SP(26),*(AR1)
       
L36:    

        STL       A,*SP(23)
        LD        *SP(26),A
        STL       A,*SP(22)
L37:    
;----------------------------------------------------------------------
; 602 | x   = sub(xhigh, xlow);                                                
; 603 | y   = sub(yhigh, ylow);                                                
;----------------------------------------------------------------------
        
        BANZ      L35,*+AR7(-1)         ;End of for (i = 0; i < 2; i++)

;----------------------------------------------------------------------
; 605 | if(y == 0)                                                             
; 607 |   xint = xlow;                                                         
; 609 | else                                                                   
; 611 |   sign= y;                                                             
; 612 |   y   = abs_s(y);                                                      
; 613 |   exp = norm_s(y);                                                     
;----------------------------------------------------------------------
        LD        *SP(23),A             
        LD        *(AL),16,A           ;a = yhigh 
        ;SSBX      OVM
        SUB       *(AR6),16,A,A        ;a = yhigh-xlow
        ;RSBX      OVM
        SFTA      A,-16,A               
        STL       A,*SP(23)
        LD        *(AL),A               
        BC        L39,AEQ              

;----------------------------------------------------------------------
; 614 | y   = shl(y, exp);                                                     
;----------------------------------------------------------------------
        LD        *SP(23),A
        LD        *(AL),16,A            
        SSBX      OVM
        NOP
        ABS       A,A                   ; y = abs_s(y)
        RSBX      OVM
        SFTA      A,-16,A               ; |614| 
        LD        *(AL),16,B            ; |614| 
        EXP       B                     ; |614| 
        RSBX      FRCT
        MVMD      T,AR7
        MVKD      *(AR7),*SP(0)
        CALL      #_shl              
       
        
        STLM      A,T

;----------------------------------------------------------------------
; 615 | y   = div_s( (Word16)16383, y);                                        
; 616 | t0  = L_mult(x, y);                                                    
;----------------------------------------------------------------------
        RSBX      FRCT
        RSBX      OVM
        ST        T,*SP(0)
        CALLD     #_divs                
        LD        #16383,A
        
        STLM      A,T

;----------------------------------------------------------------------
; 617 | t0  = L_shr(t0, sub(20, exp) );                                        
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;NOP
        LD        #20,16,B             
        SSBX      OVM
        SSBX      SXM
        SUB       *(AR7),16,B,B         ; |617| 
        LD        *SP(22),A
        RSBX      OVM
        STH       B,*SP(0)              ; |617| 
        LD        *(AL),16,B            ; |617| 
        SSBX      OVM
        SUB       *(AR1),16,B,B         ; |617| 
        SFTA      B,-16,B               ; |617| 
        SSBX      FRCT
        MPY       *(BL),A               ; |617| 
        RSBX      OVM
        RSBX      FRCT
        NOP
        CALL      #_L_shr               ; |617| 

;----------------------------------------------------------------------
; 618 | y   = extract_l(t0);            /* y= (xhigh-xlow)/(yhigh-ylow) in Q11
;     | */                                                                     
;----------------------------------------------------------------------

;----------------------------------------------------------------------
; 620 | if(sign < 0) y = negate(y);                                            
; 622 | t0   = L_mult(ylow, y);                  /* result in Q26 */           
;----------------------------------------------------------------------
        SSBX      SXM
        NOP
        LD        *SP(23),B
        BC        L38,BGEQ              ; |620| 
        ; branch occurs ; |620| 
;** 620	-----------------------    y = _sneg(y);
        RSBX      OVM
        LD        *(AL),16,A            ; |620| 
        SSBX      OVM
        NOP
        NEG       A,A                   ; |620| 
        SFTA      A,-16,A               ; |620| 
L38:    

;----------------------------------------------------------------------
; 623 | t0   = L_shr(t0, 11);                    /* result in Q15 */           
;----------------------------------------------------------------------
        SSBX      SXM
        SSBX      FRCT
        SSBX      OVM
        STLM      A,T
        MPY       *(AR6),A              ; |623| 
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #11,*SP(0)            ; |623| 
        ;CALL      #_L_shr               ; |623| 
        NOP
        SFTA      A,-11
        ; call occurs [#_L_shr] ; |623| 

;----------------------------------------------------------------------
; 624 | xint = sub(xlow, extract_l(t0));         /* xint = xlow - ylow*y */    
;----------------------------------------------------------------------
        ;SSBX      SXM
        RSBX      OVM
        LD        *(AR1),16,B           ; |624| 
        SSBX      OVM
        SUB       *(AL),16,B,A          ; |624| 
        BD        L40                   ; |624| 
        SFTA      A,-16,A               ; |624| 
        STLM      A,AR1

L39:    

L40:    

;----------------------------------------------------------------------
; 627 | lsp[nf] = xint;                                                        
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *SP(17),B
        LD        *SP(15),A
        ADD       B,A                   ; |627| 
        STLM      A,AR2
        NOP
        MVKD      *(AR1),*AR2

;----------------------------------------------------------------------
; 628 | xlow    = xint;                                                        
;----------------------------------------------------------------------

;----------------------------------------------------------------------
; 629 | nf =add(nf,1);                                                         
;----------------------------------------------------------------------
        LD        B,A
        LD        *(AL),16,A            
        SSBX      OVM
        NOP
        ADD       #1,16,A,A              
        SFTA      A,-16,A               
        STL       A,*SP(17)

;----------------------------------------------------------------------
; 631 | if(ip == 0)                                                            
;----------------------------------------------------------------------
        MVDK      *SP(18),*(AR2)
        BANZ      L41,*AR2              ; |631| 

;----------------------------------------------------------------------
; 633 | ip = 1;                                                                
;----------------------------------------------------------------------
        LD        #1,A
        STL       A,*SP(18)

;----------------------------------------------------------------------
; 634 | coef = f2;                                                             
;----------------------------------------------------------------------
        RSBX      OVM
        LDM       SP,A
        ADD       #8,A
        STL       A,*SP(19)

;----------------------------------------------------------------------
; 636 | else                                                                   
;----------------------------------------------------------------------
        B         L42                   ; |635| 
        ; branch occurs ; |635| 
L41:    

;----------------------------------------------------------------------
; 638 | ip = 0;                                                                
;----------------------------------------------------------------------
        LD        #0,A
        STL       A,*SP(18)

;----------------------------------------------------------------------
; 639 | coef = f1;                                                             
;----------------------------------------------------------------------
        RSBX      OVM
        LDM       SP,A
        ADD       #2,A
        STL       A,*SP(19)
L42:    

;----------------------------------------------------------------------
; 641 | ylow = (*pChebps)(xlow,coef,NC);                                       
;----------------------------------------------------------------------
        STL       A,*SP(0)
        RSBX      FRCT
        ST        #5,*SP(1)             ; |641| 
        LD        *SP(16),B
        CALAD     B                     ; |641| 
        NOP
        LDM       AR1,A
        
        STLM      A,AR6
L43:    

        SSBX      SXM
        RSBX      OVM
        LD        *SP(17),A
        SUB       #10,A,A               
        BC        L44,AGEQ             ;if(nf-10 >0) goto L44            
    
        LD        *SP(20),A
        SUB       #50,A,A               
        BC        L34,ALT              ;if(j-50 <0) goto L34
    
L44:    

;----------------------------------------------------------------------
; 648 | if( sub(nf, M) < 0)                                                    
; 650 |    for(i=0; i<M; i++)                                                  
;----------------------------------------------------------------------
        LD        *SP(17),A
        SUB       #10,A,A               ; |648| 
        BC        L46,AGEQ              ; |648| 

        MVDK      *SP(14),*(AR2)
        MVDK      *SP(15),*(AR3)
        RPT       #9
 
L45:    

;----------------------------------------------------------------------
; 652 | lsp[i] = old_lsp[i];                                                   
;----------------------------------------------------------------------
        MVDD      *AR2+,*AR3+           ; |652| 
L46:    
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #28
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
	.endfunc	679,000018400h,31



	.sect	".text"
	.global	_Autocorr
	.sym	_Autocorr,_Autocorr, 32, 2, 0
	.func	24

;***************************************************************
;* FUNCTION DEF: _Autocorr                                     *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Autocorr:

        PSHM      AR1
        ;RSBX      OVM
        PSHM      AR6
        PSHM      FP
        ADDM      #-252,*(SP)
        NOP
        NOP
        MVMM      SP,FP
;----------------------------------------------------------------------
;  31 | Word16 i, j, norm;                                                     
;  32 | Word16 y[L_WINDOW];                                                    
;  33 | Word32 sum;                                                            
;  34 | Word16 flagover;                                                       
;  35 | extern Flag Overflow;                                                  
;  39 | for(i=0; i<L_WINDOW; i++)                                              
;----------------------------------------------------------------------
        STM       #_hamwindow,AR3
        STLM      A,AR4
        STM       #239,BRC
        LD        *FP(258),B
        MVMM      SP,AR2
        STL       B,*FP(248)        ; fp(248) = r_l
        MAR       *+AR2(#8)         ; ar2 = y = sp+8
        LD        *FP(257),B
        STL       B,*FP(249)        ; fp(249) = r_h
        LD        *FP(256),B        
        STL       B,*FP(250)        ; fp(250) = m
        SSBX      FRCT
        SSBX      OVM
        RPTB      L48-1
;----------------------------------------------------------------------
;  41 | y[i] = mult_r(x[i], hamwindow[i]);                                     
;----------------------------------------------------------------------
        LD        *AR3+,T
        NOP
        MPYR      *AR4+,A               
        STH       A,*AR2+               
L48:    
;----------------------------------------------------------------------
;  46 | flagover = Verifi_Overflow(1,y,y,0,L_WINDOW,1,&sum);                   
;  47 | if( flagover !=0)                                                      
;  49 |   for(i=0; i<L_WINDOW; i++)                                            
;  51 |     y[i] = shr(y[i], 2);                                               
;  54 | }while (flagover != 0);                                                
;----------------------------------------------------------------------
        RSBX      OVM
        LDM       SP,A
        ADD       #8,A
        STL       A,*SP(0)     ; sp(0) = y
        RSBX      FRCT
        LDM       SP,A
        ADD       #8,A
        STL       A,*SP(1)
        ST        #0,*SP(2)             
        LDM       SP,A
        ST        #240,*SP(3)           
        ADD       #6,A
        ST        #1,*SP(4)              
        STL       A,*SP(5)
        CALLD     #_Verifi_Overflow    
        NOP
        LD        #1,A

        STLM      A,AR2
        NOP
        NOP
        BANZ      L52,*AR2             

;----------------------------------------------------------------------
;  59 | norm = norm_l(sum);                                                    
;----------------------------------------------------------------------
        SSBX      SXM
        NOP
        DLD       *SP(6),A     ; sp(6) = sum
        EXP       A                     
        NOP
        MVMD      T,AR6        ; ar6 = norm_l(sum)

;----------------------------------------------------------------------
;  60 | sum  = L_shl(sum, norm);                                               
;----------------------------------------------------------------------
        RSBX      OVM
        RSBX      FRCT
        MVKD      *(AR6),*SP(0)
        DLD       *SP(6),A              
        CALL      #_L_shl               
        DST       A,*SP(6)             

;----------------------------------------------------------------------
;  61 | L_Extract(sum, &r_h[0], &r_l[0]);     /* Put in DPF format (see oper_32
;     | b) */                                                                  
;----------------------------------------------------------------------
        RSBX      OVM
        RSBX      FRCT
        LD        *FP(249),A
        STL       A,*SP(0)
        LD        *FP(248),A
        STL       A,*SP(1)
        DLD       *SP(6),A              ; |61| 
        CALL      #_L_Extract           ; |61| 

;----------------------------------------------------------------------
;  65 | for (i = 1; i <= m; i++)                                               
;----------------------------------------------------------------------
        SSBX      SXM
        LD        *FP(250),A
        BC        L54,ALEQ              
        RSBX      OVM
        LD        *FP(248),A
        ADD       #1,A,A
        MVDK      *FP(250),*(AR1)
        STL       A,*FP(248)
        LD        *FP(249),A
        ADD       #1,A,A
        STL       A,*FP(249)
        LD        #1,A
        STL       A,*FP(250)      ; fp(250) = i = 1
        
L49:    
;----------------------------------------------------------------------
;  67 | sum = 0;                                                               
;----------------------------------------------------------------------
        LD        #0,A
        DST       A,*SP(6)            

;----------------------------------------------------------------------
;  68 | for(j=0; j<L_WINDOW-i; j++)                                            
;----------------------------------------------------------------------
        LD        *FP(250),B          ; fp(250) = i
        SSBX      SXM
        LD        #240,A              
        SUB       B,A                  
        LD        *(AL),A             ; a = L_WINDOW - i 
        BC        L51,ALEQ              

        LDM       SP,A
        ADD       #8,A
        ADD       B,A
        MVMM      SP,AR2
        STLM      A,AR3
        LD        #239,A
        SUB       B,A
        STLM      A,BRC
        MAR       *+AR2(#8)
        
        SSBX      FRCT            ;added by d.l.b
        SSBX      OVM             ;added by d.l.b
        DLD       *SP(6),A
        ORM       #2,*(PMST)      ;added by d.l.b   
        RPTB      LOOP1-1

L50:    
;----------------------------------------------------------------------
;  69 | sum = L_mac(sum, y[j], y[j+i]);                                        
;----------------------------------------------------------------------
        ;DLD       *SP(6),A              ; |69| 
        ;ORM       #2,*(PMST)
        ;SSBX      FRCT
        ;SSBX      OVM
        ;ORM       #2,*(PMST)
        ;NOP
        MAC       *AR3+, *AR2+, A, A    ; |69| 
        ;DST       A,*SP(6)              ; |69| 
LOOP1: 
		DST       A,*SP(6)
L51:    
        
;----------------------------------------------------------------------
;  71 | sum = L_shl(sum, norm);                                                
;----------------------------------------------------------------------
        RSBX      OVM
        MVKD      *(AR6),*SP(0)
        ;RSBX      FRCT
        DLD       *SP(6),A              
        CALL      #_L_shl               

        DST       A,*SP(6)              
;----------------------------------------------------------------------
;  72 | L_Extract(sum, &r_h[i], &r_l[i]);                                      
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;RSBX      FRCT
        LD        *FP(249),A
        STL       A,*SP(0)
        LD        *FP(248),A
        STL       A,*SP(1)
        DLD       *SP(6),A              ; |72| 
        CALL      #_L_Extract           ; |72| 

;----------------------------------------------------------------------
;  74 | return;                                                                
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *FP(248),A
        ADD       #1,A
        STL       A,*FP(248)            ; fp(248) = r_l++
        LD        *FP(249),A
        ADD       #1,A
        STL       A,*FP(249)            ; fp(249) = r_h++
        LD        *FP(250),A
        ADD       #1,A
        BANZD     L49,*+AR1(-1)         
        STL       A,*FP(250)            

        B         L54
L52:
        MVMM      SP,AR6
        STM       #240,AR1
        MAR       *+AR6(#8)
L53:    
        SSBX      SXM            
        SSBX      OVM
        NOP
        ;ST        #2,*SP(0)             ; |51| 
        ;RSBX      FRCT
        ;RSBX      OVM
        LD        *AR6,A
        ;CALL      #_crshft              ; |51| 
        SFTA      A,-2
        
        NOP
        STL       A,*AR6+

        RSBX      OVM
        NOP
        NOP
        MAR       *AR1-
        LD        *(AR1),A              ; |52| 
        BC        L48,AEQ               ; |52| 
        B         L53                   ; |52| 

L54:    

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        ;RSBX      OVM
        ADDM      #252,*(SP)
        NOP
        NOP
        POPM      FP
        POPM      AR6
        POPM      AR1
        RET

        ; return occurs
	.endfunc	93,000048400h,255


;***************************************************************
;* UNDEFINED EXTERNAL REFERENCES                               *
;***************************************************************
	.global	_Verifi_Overflow
	.global	_L_sub
	.global	_L_shl
	.global	_L_shr
	.global	_shl
	.global	_shr
	.global	_L_Extract
	.global	_L_Comp
	.global	_Mpy_32
	.global	_Mpy_32_16
	.global	_Div_32
	.global	_divs
	.global	_hamwindow
	.global	_lag_h
	.global	_lag_l
	.global	_grid

;***************************************************************
;* TYPE INFORMATION                                            *
;***************************************************************
	.sym	_Word16, 0, 3, 13, 16
	.sym	_Word16, 0, 3, 13, 16
	.sym	_Word32, 0, 5, 13, 32
