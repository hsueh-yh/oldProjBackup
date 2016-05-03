	.mmregs
FP	.set	AR7
	.sect	".text"
	.global	_Syn_filt
;----------------------------------------------------------------------
;  53 | void Syn_filt(                                                         
;  54 | Word16 a[],     /* (i) Q12 : a[m+1] prediction coefficients   (m=10)  *
;     | /                                                                      
;  55 | Word16 x[],     /* (i)     : input signal                             *
;     | /                                                                      
;  56 | Word16 y[],     /* (o)     : output signal                            *
;     | /                                                                      
;  57 | Word16 lg,      /* (i)     : size of filtering                        *
;     | /                                                                      
;  58 | Word16 mem[],   /* (i/o)   : memory associated with this filtering.   *
;     | /                                                                      
;  59 | Word16 update   /* (i)     : 0=no update, 1=update of memory.         *
;     | /                                                                      
;  60 | )                                                                      
;----------------------------------------------------------------------
_Syn_filt:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-112
;----------------------------------------------------------------------
;  62 | Word16 i, j;                                                           
;  63 | Word32 s;                                                              
;  64 | Word16 tmp[100];     /* This is usually done by memory allocation (lg+M
;     | ) */                                                                   
;  65 | Word16 *yy;                                                            
;----------------------------------------------------------------------
        STLM      A,AR7                ; (ar7)=a
        LD        *SP(120),A
        STL       A,*SP(102)           ; (sp(102)) = update
        LD        *SP(119),A           
        STL       A,*SP(103)           ; (sp(103) = mem
        LD        *SP(118),A           ; (a) = lg;
        STL       A,*SP(104)           ; (sp(104)) = lg
        LD        *SP(117),A           ; (a) = y
        STL       A,*SP(105)           ; (sp(105)) = y
        LD        *SP(116),A           ; (a) = x
        MVDK      *SP(103),*(AR3)      ; (ar3) = mem

        ;RSBX      OVM
        ;STM       #9,BRC
        LDM       SP,B
        ADD       #2,B
        STL       B,*SP(106)           ; tmp = sp+2
        MVDK      *SP(106),*(AR2)      ; d.l.b
        RPT       #9     
        MVDD      *AR3+,*AR2+                   
L2:    
        MVKD      *(AR2),*SP(106)      ; (sp(106)) = yy
        
        SSBX      SXM
        NOP
        LD        *SP(104),B
        BC        L6,BLEQ               
        

        SUB       #1,A,A
        STLM      A,AR6            ; (ar6) = &x[-1]
        LDM       SP,A
        ADD       #12,A            ; (a) = sp+12
        STL       A,*SP(107)       ; sp(107) = sp+M+2 = &tmp[M]
        
        LD        *SP(104),A
        SUB       #1,A
        STL       A,*(BRC)
        
        LD        *SP(105),A       ; (a) = y
        STL       A,*SP(108)       ; (sp(108)) = y = (sp(105))
        LD        *SP(106),A
        SUB       #1,A,A           ; (a) = &yy[-1]
        STL       A,*SP(109)       ; (sp(109)) = &yy[-1] 
        LDM       AR7,A
        ADD       #1,A,A           ; (a) = &a[1]
        STL       A,*SP(110)       ; (sp(110)) = &a[1]
        SSBX      FRCT
        SSBX      OVM
        MVDK      *SP(107),*(AR5)       ; ****
        MVDK      *SP(108),*(AR4)       ; **** 

        MVDK      *SP(106),*(AR1)
        ORM       #2,*(PMST)  
        RSBX      OVA               ; OVERFLOW BIT  
        RPTB      L6-1              ; ****
L3:    
;----------------------------------------------------------------------
;  80 | s = L_mult(x[i], a[0]);                                                
;  81 | for (j = 1; j <= M; j++)                                               
;----------------------------------------------------------------------
        LD        *AR7,T                ; *ar7 = a[0]

        MPY       *+AR6(1),A            ; (a) = L_mult(x[i], a[0]) 
        MVDK      *SP(110),*(AR2)       ; (ar2) = &a[1]  line-106
        MVDK      *SP(109),*(AR3)       ; (ar3) = &yy[-1] line-107

        RPT        #9
;----------------------------------------------------------------------
;  82 | s = L_msu(s, a[j], yy[-j]);                                            
;----------------------------------------------------------------------
        MAS       *AR3-, *AR2+, A, A    

        LD        *SP(109),B

        ADD       #1,B
        STL       B,*SP(109)             ;(sp(109)) ++

;----------------------------------------------------------------------
;  84 | s = L_shl(s, 3);                                                       
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ;ST        #3,*SP(0)              ; |84| 
        ;CALL      #_L_shl                ; |84| 
        SFTA       A,3
        

;----------------------------------------------------------------------
;  85 | *yy++ = round(s);                                                      
;----------------------------------------------------------------------
        ADD       #1,#15,A,A            ; (a) = s 
        STH       A,*AR1+               ; *yy++ = round(s) (ar2) = yy
;----------------------------------------------------------------------
;  86 | y[i] = tmp[i+M];                                                       
;----------------------------------------------------------------------      
        MVDD      *AR5+,*AR4+                 
L6:    
       STM       #0,AR5                 ; ****
       BC        IF_OVM,ANOV            ; ****
       STM       #1,AR5
IF_OVM:
;----------------------------------------------------------------------
;  92 | if(update != 0)                                                        
;  93 |    for (i = 0; i < M; i++)                                             
;----------------------------------------------------------------------
        LD        *SP(102),A
        LD        *(AL),A              
        BC        L8,AEQ                 

        LD        *SP(104),B          ; (b) = lg
        LD        *SP(105),A          ; (a) = y
        ADD       B,A                 ; (a) = &y[lg]
        SUB       #10,A,A             ; (a) = &y[lg-M]
        STLM      A,AR3
        NOP
        MVDK      *SP(103),*(AR2)
        RPT       #9
L7:    
        MVDD      *AR3+,*AR2+          

L8:    
        ;ANDM      #-833,*(ST1)
        ;ANDM      #-4,*(PMST)
        LDM       AR5,A
        FRAME     #112
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET


	.sect	".text"
	.global	_Residu
;----------------------------------------------------------------------
; 107 | void Residu(                                                           
; 108 | Word16 a[],    /* (i) Q12 : prediction coefficients
;     |  */                                                                    
; 109 | Word16 x[],    /* (i)     : speech (values x[-m..-1] are needed
;     |  */                                                                    
; 110 | Word16 y[],    /* (o)     : residual signal
;     |  */                                                                    
; 111 | Word16 lg      /* (i)     : size of filtering
;     |  */                                                                    
; 112 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Residu                                       *
;***************************************************************

_Residu:
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-6
        NOP
        STL       A,*SP(2)             ; sp(2) = a
        LD        *SP(10),A            ; (a) = x
        MVDK      *SP(12),*(AR6)       ; (ar6) = lg
        STL       A,*SP(3)             ; sp(3) = x
        MVDK      *SP(11),*(AR1)       ; (ar1) = y

;----------------------------------------------------------------------
; 117 | for (i = 0; i < lg; i++)                                               
;----------------------------------------------------------------------
        SSBX      SXM
        SSBX      FRCT                 ; added by d.l.b
        LD        *(AR6),A             ; (a) = lg
        BC        L12,ALEQ             
 
 
        SSBX      OVM
        LD        *SP(2),A
        LD        *SP(3),B
        ADD       #1,A,A               ; (a) = &a[1]
        SUB       #1,B,B               ; (b) = &x[-1]
        STL       A,*SP(4)             ; sp(4) = &a[1]
        ORM       #2,*(PMST)
        STLM      B,AR7                ; (ar7) = &x[-1]
        LD        #-1,A
        STL       A,*SP(5)             ; sp(5) = -1

L9:    
;----------------------------------------------------------------------
; 119 | s = L_mult(x[i], a[0]);                                                
; 120 | for (j = 1; j <= M; j++)                                               
;----------------------------------------------------------------------
        MVDK      *SP(2),*(AR2)        ; (ar2) = a 
        LD        *SP(5),B 
        LD        *AR2,T               ; (T)= a[0]

        MPY       *+AR7(1),A           ; (a) = L_mult(x[i], a[0])
        MVDK      *SP(3),*(AR2)        ; (ar2) = x
                
        ADD       *(AR2),B             ; (b) = &x[-1]
        STLM      B,AR3                ; (ar3) = &x[-1]
        MVDK      *SP(4),*(AR2)        ; added by d.l.b

        RPT       #9 
        MAC       *AR3-, *AR2+, A, A     
L11:     
;----------------------------------------------------------------------
; 123 | s = L_shl(s, 3);                                                       
;----------------------------------------------------------------------
        SFTA       A,3
                    
        ADD       #1,#15,A,A           
        STH       A,*AR1+               ; (ar1) = y
        LD        *SP(5),A
        ADD       #1,A
        BANZD     L9,*+AR6(-1)                      
        NOP
        STL       A,*SP(5)      
L12:    
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #6
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET