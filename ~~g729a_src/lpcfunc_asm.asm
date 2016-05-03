	.mmregs
FP	.set	AR7

	.sect	".text"
	.global	_Lsp_lsf2
;----------------------------------------------------------------------
; 217 | void Lsp_lsf2(                                                         
; 218 | Word16 lsp[],    /* (i) Q15 : lsp[m] (range: -1<=val<1)   */           
; 219 | Word16 lsf[],    /* (o) Q13 : lsf[m] (range: 0.0<=val<PI) */           
; 220 | Word16 m         /* (i)     : LPC order                   */           
; 221 | )                                                                      
;----------------------------------------------------------------------
_Lsp_lsf2:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-8
;----------------------------------------------------------------------
; 223 | Word16 i, ind;                                                         
; 224 | Word16 offset;   /* in Q15 */                                          
; 225 | Word16 freq;     /* normalized frequency in Q16 */                     
; 226 | Word32 L_tmp;                                                          
; 228 | ind = 63;           /* begin at end of table2 -1 */                    
;----------------------------------------------------------------------
        SSBX      SXM

        LD        *SP(13),B			;B = m
        MVDK      *SP(12),*(AR3)	;AR3 = & lsp

;----------------------------------------------------------------------
; 230 | for(i= m-(Word16)1; i >= 0; i--)                                       
; 233 |   while( sub(table2[ind], lsp[i]) < 0 )                                
; 235 |     ind = sub(ind,1);                                                  
; 236 |     if ( ind <= 0 )                                                    
; 237 |       break;                                                           
;----------------------------------------------------------------------
        BC        L6,BLEQ               ; |230| 循环次数
        ;;RSBX      OVM
        NOP
        SUB       #1,B,B
        STM       #_table2,AR2	;AR2 = #_table2
        ADD       B,A			;A = lsf + B
        ADD       #1,A,A		;A +1
        STLM      A,AR7			;AR7 = A +1
        LDM       AR2,A			;
        ADD       #63,A,A		;A = A+63
        STLM      A,AR1			;AR1 = A
        ADD       *(AR3),B,A	;A = lsp + i
        STL       A,*SP(2)		;*SP(2) = lsp + i
        ADD       #1,B,A		;A = i +1
        STLM      A,AR6			;ar6 = i+1
        LD        #_slope_acos,A	; A = #_slope_acos
        STL       A,*SP(3)		;*SP(3) = #_slope_acos
        MVKD      *(AR2),*SP(4)	;SP(4) = AR2

        LD        #63,A			;A = #63
        STL       A,*SP(5)		;*SP(5) = #63
        SSBX      OVM         ; ****
        SSBX      FRCT        ; ****
        NOP
L3:    
        LD        *+AR7(-1),B	;B = lsf[]
L4:    
;----------------------------------------------------------------------
; 240 | offset = sub(lsp[i], table2[ind]);                                     
;----------------------------------------------------------------------
        ;;RSBX      OVM;;
        ;;NOP
        LD        *AR1,16,A             ; |238| 取TABLE表值
        ;SSBX      OVM   ; ****
        SUB       *(BL),16,A,A          ; |238| 
        SFTA      A,-16,A               ; |238| 
        ;;LD        *(AL),A               ; |238| 
        BC        L5,AGEQ               ; |238| 

        ;;RSBX      OVM
        LD        *SP(5),A
        LD        *(AL),16,A            ; |235| 
        ;;SSBX      OVM
        ;;NOP
        SUB       #1,16,A,A             ; |235| 
        ;;RSBX      OVM
        SFTA      A,-16,A               ; |235| 
        STL       A,*SP(5)
        MVDK      *SP(5),*(AR1)
        LD        *SP(4),A
        ADD       *(AR1),A
        STLM      A,AR1

        LD        *SP(5),A
        BC        L4,AGT                ; |237| 
       
L5:    
;----------------------------------------------------------------------
; 244 | L_tmp  = L_mult( slope_acos[ind], offset );   /* L_tmp in Q28 */       
;----------------------------------------------------------------------
        ;;RSBX      OVM;;
        LD        *(BL),16,A            ; |244| 
        ;SSBX      FRCT
        ;;SSBX      OVM
        LD        *SP(3),B
        SUB       *AR1,16,A,A           ; |244| 
        ;;RSBX      OVM;;
        STH       A,*(T)
        LD        *SP(5),A
        ADD       B,A                   ; |244| 
        STLM      A,AR2
        ;SSBX      OVM
        NOP
        NOP
        MPY       *AR2,A                ; |244| 

;----------------------------------------------------------------------
; 245 | freq = add(shl(ind, 9), extract_l(L_shr(L_tmp, 12)));                  
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ;;RSBX      OVM
        ;ST        #12,*SP(0)            ; |245| 
        ;CALL      #_L_shr               ; |245| 
        
        SFTA      A,-12
        ; call occurs [#_L_shr] ; |245| 
        STL       A,*SP(6)
        ;RSBX      FRCT
        ;RSBX      OVM
        ;SSBX      OVM
        NOP
        ;ST        #9,*SP(0)             ; |245| 
        LD        *SP(5),A
        ;CALL      #_clshft              ; |245|
        SFTA      A,9
        ;SFTA      A,9
        ; call occurs [#_clshft] ; |245| 
        ;;RSBX      OVM
        ;;SSBX      SXM
        LD        *(AL),16,B            ; |245| 
        ;SSBX      OVM
        LD        *SP(6),A
        ADD       *(AL),16,B,A          ; |245| 
        SFTA      A,-16,B               ; |245| 

;----------------------------------------------------------------------
; 246 | lsf[i] = mult(freq, 25736);           /* 25736: 2.0*PI in Q12 */       
;----------------------------------------------------------------------
        ;;RSBX      OVM
        NOP
        LD        #25736,16,A           ; |246| 
        ;SSBX      FRCT
        STLM      B,T
        ;;SSBX      OVM
        MVDK      *SP(2),*(AR2)
        MPYA      A                     ; |246| 
        STH       A,*AR2-               ; |246| 
        MVKD      *(AR2),*SP(2)

;----------------------------------------------------------------------
; 249 | return;                                                                
;----------------------------------------------------------------------
        BANZ      L3,*+AR6(-1)          ; |248| 
        ; branch occurs ; |248| 
L6:    

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #8
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET




	.sect	".text"
	.global	_Lsp_lsf

;----------------------------------------------------------------------
; 142 | void Lsp_lsf(                                                          
; 143 | Word16 lsp[],    /* (i) Q15 : lsp[m] (range: -1<=val<1)
;     | */                                                                     
; 144 | Word16 lsf[],    /* (o) Q15 : lsf[m] normalized (range: 0.0<=val<=0.5)
;     | */                                                                     
; 145 | Word16 m         /* (i)     : LPC order
;     | */                                                                     
; 146 | )                                                                      
;----------------------------------------------------------------------
_Lsp_lsf:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-8
;----------------------------------------------------------------------
; 148 | Word16 i, ind, tmp;                                                    
; 149 | Word32 L_tmp;                                                          
; 151 | ind = 63;    /* begin at end of table -1 */                            
;----------------------------------------------------------------------
        SSBX      SXM
        SSBX      OVM ;;add by wly
        NOP
        LD        *SP(13),B
        MVDK      *SP(12),*(AR2)
;----------------------------------------------------------------------
; 153 | for(i= m-(Word16)1; i >= 0; i--)                                       
;----------------------------------------------------------------------
        BC        L10,BLEQ              ; |153| 
        
        ;;RSBX      OVM
        STM       #_table,AR1
        SUB       #1,B,B
        MVKD      *(AR1),*SP(2)
        ADD       B,A
        STM       #_slope,AR1
        ADD       #1,A,A
        STL       A,*SP(4)
        MVKD      *(AR1),*SP(3)
        LD        *SP(2),A
        ADD       #63,A,A
        STLM      A,AR1
        ADD       *(AR2),B,A
        STLM      A,AR7
        ADD       #1,B,A
        STLM      A,AR6

        LD        #63,A
        STL       A,*SP(5)
L7:    
;----------------------------------------------------------------------
; 156 | while( sub(table[ind], lsp[i]) < 0 )                                   
;----------------------------------------------------------------------
        MVDK      *SP(4),*(AR2)
        ;;RSBX      OVM
        MVDK      *+AR2(-1),*(AR3)
        MVKD      *(AR2),*SP(4)
        LD        *AR1,B
        LD        *(BL),16,A            ; |156| 
        ;;SSBX      OVM
        SUB       *(AR3),16,A,A         ; |156| 
        SFTA      A,-16,A               ; |156| 
        LD        *(AL),A               ; |156| 
        BC        L9,AGEQ               ; |156| 
        ; branch occurs ; |156| 
L8:    
;----------------------------------------------------------------------
; 158 | ind = sub(ind,1);                                                      
; 163 | L_tmp  = L_mult( sub(lsp[i], table[ind]) , slope[ind] );               
;----------------------------------------------------------------------
        ;;RSBX      OVM
        LD        *SP(5),A
        LD        *(AL),16,A            ; |158| 
        ;;SSBX      OVM
        NOP
        SUB       #1,16,A,A             ; |158| 
        ;;RSBX      OVM
        SFTA      A,-16,A               ; |158| 
        STL       A,*SP(5)
        LD        *SP(5),B
        LD        *SP(2),A
        ADD       *(BL),A
        STLM      A,AR1
        NOP
        NOP
        LD        *AR1,B
        LD        *(BL),16,A            ; |158| 
        ;;SSBX      OVM
        SUB       *(AR3),16,A,A         ; |158| 
        SFTA      A,-16,A               ; |158| 
        LD        *(AL),A               ; |158| 
        BC        L8,ALT                ; |158| 
        ; branch occurs ; |158| 
L9:    
;----------------------------------------------------------------------
; 164 | tmp = round(L_shl(L_tmp, 3));     /*(lsp[i]-table[ind])*slope[ind])>>12
;     | */                                                                     
;----------------------------------------------------------------------
        ;;RSBX      OVM
        LD        *(AR3),16,A           ; |164| 
       ;; ST        #3,*SP(0)             ; |164| 
        ;;SSBX      OVM
        SUB       *(BL),16,A,A          ; |164| 
        LD        *SP(5),B
        ;;RSBX      OVM
        SFTA      A,-16,A               ; |164| 
        STLM      A,AR3
        LD        *SP(3),A
        ADD       A,B                   ; |164| 
        STLM      B,AR2
        NOP;; THIS CAN'T BE DELETED, WLY
        SSBX      FRCT
        LD        *AR2,T
        ;;SSBX      OVM
        MPY       *(AR3),A              ; |164| 
        RSBX      FRCT
        ;;RSBX      OVM
        NOP
        ;;CALL      #_L_shl               ; |164| 
        SFTA 	A,3,A;;WLY
        ; call occurs [#_L_shl] ; |164| 
        ;;RSBX      OVM
        NOP
        ;;SFTA      A,8                   ; |164| 
        ;;SSBX      SXM
        ;;SSBX      OVM
        ;;SFTA      A,-8                  ; |164| 
        ADD       #1,#15,A,A            ; |164| 
        SFTA      A,-16,A               ; |164| 
        STL       A,*SP(6)

;----------------------------------------------------------------------
; 165 | lsf[i] = add(tmp, shl(ind, 8));                                        
;----------------------------------------------------------------------
        ;;RSBX      FRCT
        ;;ST        #8,*SP(0)             ; |165| 
        ;;RSBX      OVM
        LD        *SP(5),A
        ;;CALL      #_clshft              ; |165| 
        SFTA	A,8,A;;	WLY
        ; call occurs [#_clshft] ; |165| 
        ;;RSBX      OVM
        ;;SSBX      SXM
        LD        *SP(6),B
        LD        *(BL),16,B            ; |165| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |165| 
        STH       A,*AR7-               ; |165| 

;----------------------------------------------------------------------
; 167 | return;                                                                
;----------------------------------------------------------------------
        BANZ      L7,*+AR6(-1)          ; |166| 
        ; branch occurs ; |166| 
L10:    

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #8
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET



	.sect	".text"
	.global	_Lsf_lsp

;----------------------------------------------------------------------
; 119 | void Lsf_lsp(                                                          
; 120 | Word16 lsf[],    /* (i) Q15 : lsf[m] normalized (range: 0.0<=val<=0.5)
;     | */                                                                     
; 121 | Word16 lsp[],    /* (o) Q15 : lsp[m] (range: -1<=val<1)
;     | */                                                                     
; 122 | Word16 m         /* (i)     : LPC order
;     | */                                                                     
; 123 | )                                                                      
;----------------------------------------------------------------------

_Lsf_lsp:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-4
        NOP
;----------------------------------------------------------------------
; 125 | Word16 i, ind, offset;                                                 
; 126 | Word32 L_tmp;                                                          
;----------------------------------------------------------------------
        MVDK      *SP(9),*(AR6)
        MVDK      *SP(8),*(AR2)

;----------------------------------------------------------------------
; 128 | for(i=0; i<m; i++)                                                     
;----------------------------------------------------------------------
        SSBX      SXM
        LD        *(AR6),B              ; |128| 
        BC        L19,BLEQ              ; |128| 

        STLM      A,AR1
        LD        #_table,A
        MVKD      *(AR2),*SP(2)
        STL       A,*SP(3)
        SSBX      OVM;;WLY
        SSBX	  SXM;;
        NOP
L18:    
;----------------------------------------------------------------------
; 130 | ind    = shr(lsf[i], 8);               /* ind    = b8-b15 of lsf[i] */ 
; 131 | offset = lsf[i] & (Word16)0x00ff;      /* offset = b0-b7  of lsf[i] */ 
; 135 | L_tmp   = L_mult(sub(table[ind+1], table[ind]), offset);               
;----------------------------------------------------------------------
        ;ST        #8,*SP(0)             ; |130| 
        ;;RSBX      FRCT
        ;;RSBX      OVM
        
        LD        *AR1,A
        ;CALL      #_crshft              ; |130| 
        ;NOP
        SFTA	  A,-8;;WLY

;----------------------------------------------------------------------
; 136 | lsp[i] = add(table[ind], extract_l(L_shr(L_tmp, 9)));                  
;----------------------------------------------------------------------
        ;;RSBX      OVM
        LD        *SP(3),B
        ;;SSBX      SXM
        ADD       *(AL),B,A
        STLM      A,AR7
        ST        #9,*SP(0)             ; |136| 
        
        LD        *AR7(1),16,A          ; |136| 
        ;;SSBX      OVM
        SSBX      FRCT
        SUB       *AR7,16,A,A           ; |136| 
        SFTA      A,-16,B               ; |136| 
        LD        #255,A
        AND       *AR1+,A               ; |136| 
        STLM      A,T
        MPY       *(BL),A               ; |136| 
        ;RSBX      FRCT
        ;RSBX      OVM
        
        ;;NOP
        ;;CALL      #_L_shr               ; |136| 
        SFTA		A,-9;;WLY
        ; call occurs [#_L_shr] ; |136| 
        ;RSBX      OVM
        ;;SSBX      SXM
        ;;NOP
        LD        *AR7,16,B             ; |136| 
        ;;SSBX      OVM
        MVDK      *SP(2),*(AR2)
        ADD       *(AL),16,B,A          ; |136| 
        STH       A,*AR2+               ; |136| 
        MVKD      *(AR2),*SP(2)

;----------------------------------------------------------------------
; 138 | return;                                                                
;----------------------------------------------------------------------
        BANZ      L18,*+AR6(-1)         ; |137| 

L19:    

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #4
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET



	.sect	".text"
	.global	_Lsf_lsp2

;----------------------------------------------------------------------
; 184 | void Lsf_lsp2(                                                         
; 185 | Word16 lsf[],    /* (i) Q13 : lsf[m] (range: 0.0<=val<PI) */           
; 186 | Word16 lsp[],    /* (o) Q15 : lsp[m] (range: -1<=val<1)   */           
; 187 | Word16 m         /* (i)     : LPC order                   */           
; 188 | )                                                                      
;----------------------------------------------------------------------
_Lsf_lsp2:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-6
        NOP
;----------------------------------------------------------------------
; 190 | Word16 i, ind;                                                         
; 191 | Word16 offset;   /* in Q8 */                                           
; 192 | Word16 freq;     /* normalized frequency in Q15 */                     
; 193 | Word32 L_tmp;                                                          
;----------------------------------------------------------------------
        MVDK      *SP(11),*(AR7)
        MVDK      *SP(10),*(AR6)

;----------------------------------------------------------------------
; 195 | for(i=0; i<m; i++)                                                     
;----------------------------------------------------------------------
        SSBX      SXM
        LD        *(AR7),B              ; |195| 
        BC        L17,BLEQ              ; |195| 

        LD        #_slope_cos,B
        STL       B,*SP(2)
        STL       A,*SP(4)
        LD        #_table2,B
        STL       B,*SP(3)
        SSBX		OVM;;WLY
        SSBX      FRCT;;WLY
L15:    

;----------------------------------------------------------------------
; 198 | freq = mult(lsf[i], 20861);          /* 20861: 1.0/(2.0*PI) in Q17 */  
;----------------------------------------------------------------------
        ;;RSBX      OVM
        NOP
        LD        #20861,16,A           ; |198| 
        ;;SSBX      FRCT
        ;;SSBX      OVM
        MVDK      *SP(4),*(AR1)
        MPYA      *AR1+                 ; |198| 
        SFTA      B,-16,A               ; |198| 
        STL       A,*SP(5)
        MVKD      *(AR1),*SP(4)

;----------------------------------------------------------------------
; 199 | ind    = shr(freq, 8);               /* ind    = b8-b15 of freq */     
;----------------------------------------------------------------------
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ;;ST        #8,*SP(0)             ; |199| 
        ;;CALL      #_crshft              ; |199| 
        SFTA		A,-8,A;;WLY
        ; call occurs [#_crshft] ; |199| 
        STLM      A,AR1

;----------------------------------------------------------------------
; 200 | offset = freq & (Word16)0x00ff;      /* offset = b0-b7  of freq */     
;----------------------------------------------------------------------
        LD        *SP(5),A
        AND       #255,A,A              ; |200| 
        STLM      A,T

;----------------------------------------------------------------------
; 202 | if ( sub(ind, 63)>0 ){                                                 
;----------------------------------------------------------------------
        ;;SSBX      SXM
        ;;RSBX      OVM
        LD        *(AR1),A              ; |202| 
        SUB       #64,A,A               ; |202| 
        BC        L16,ALT               ; |202| 

;----------------------------------------------------------------------
; 203 | ind = 63;                 /* 0 <= ind <= 63 */                         
; 208 | L_tmp   = L_mult(slope_cos[ind], offset);   /* L_tmp in Q28 */         
;----------------------------------------------------------------------
        STM       #63,AR1
L16:    
;----------------------------------------------------------------------
; 209 | lsp[i] = add(table2[ind], extract_l(L_shr(L_tmp, 13)));                
;----------------------------------------------------------------------
        ;;ST        #13,*SP(0)            ; |209| 
        LDM       AR1,A
        LD        *SP(2),B
        ;;SSBX      FRCT
        ADD       B,A                   ; |209| 
        STLM      A,AR2
        ;;SSBX      OVM
        NOP;;
        NOP;;MUST BE 2 NOP HERE
        MPY       *AR2,A                ; |209| 
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ;;NOP
        ;;NOP
        ;;CALL      #_L_shr               ; |209| 
        SFTA		A,-13;WLY
        ; call occurs [#_L_shr] ; |209| 
        STLM      A,AR2
        LDM       AR1,B
        ;;RSBX      OVM
        ;;NOP
        LD        *SP(3),A
        ADD       A,B                   ; |209| 
        STLM      B,AR1
        ;;SSBX      SXM
        NOP
        NOP;;MUST BE 2 NOP HERE
        LD        *AR1,16,B             ; |209| 
        ;;SSBX      OVM
        ADD       *(AR2),16,B,A         ; |209| 
        STH       A,*AR6+               ; |209| 

;----------------------------------------------------------------------
; 212 | return;                                                                
;----------------------------------------------------------------------
        BANZ      L15,*+AR7(-1)         ; |211| 
     
L17:    
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #6
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET




	.sect	".text"
	.global	_Weight_Az

;----------------------------------------------------------------------
; 261 | void Weight_Az(                                                        
; 262 | Word16 a[],      /* (i) Q12 : a[m+1]  LPC coefficients             */  
; 263 | Word16 gamma,    /* (i) Q15 : Spectral expansion factor.           */  
; 264 | Word16 m,        /* (i)     : LPC order.                           */  
; 265 | Word16 ap[]      /* (o) Q12 : Spectral expanded LPC coefficients   */  
; 266 | )                                                                      
;----------------------------------------------------------------------
_Weight_Az:

        PSHM      AR1
        FRAME     #-2
;----------------------------------------------------------------------
; 268 | Word16 i, fac;                                                         
;----------------------------------------------------------------------
        STLM      A,AR3
        NOP
        MVDK      *SP(4),*(BK)
        LD        *SP(5),B
        MVDK      *SP(6),*(AR2)

;----------------------------------------------------------------------
; 270 | ap[0] = a[0];                                                          
;----------------------------------------------------------------------
        MVDD      *AR3,*AR2             ; |270| 

;----------------------------------------------------------------------
; 271 | fac   = gamma;                                                         
;----------------------------------------------------------------------
        MVMD      BK,AR5

;----------------------------------------------------------------------
; 272 | for(i=1; i<m; i++)                                                     
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        LD        B,A
        LD        *(AL),A               ; |272| 
        SUB       #2,A,A                ; |272| 
        BC        L2,ALT                ; |272| 

        LDM       AR3,A
        ADD       #1,A,A
        STLM      A,AR4
        LDM       AR2,A
        ADD       #1,A,A
        STLM      A,AR1
        LD        B,A
        SUB       #2,A,A
        STLM      A,BRC
        NOP
        RPTB      L2-1
        SSBX	OVM;;WLY
        SSBX      FRCT;;WLY
        NOP;;WLY
        
L1:    
;----------------------------------------------------------------------
; 274 | ap[i] = round( L_mult(a[i], fac) );                                    
;----------------------------------------------------------------------
        ;;SSBX      FRCT
        ;;SSBX      OVM
        MVMD      AR5,T
        MPY       *AR4+,A               ; |274| 
        ;;RSBX      OVM
        ;;NOP
        ;;SFTA      A,8                   ; |274| 
        ;;SSBX      OVM
        ;;SFTA      A,-8                  ; |274| 
        ADD       #1,#15,A,A            ; |274| 
        STH       A,*AR1+               ; |274| 

;----------------------------------------------------------------------
; 275 | fac   = round( L_mult(fac, gamma) );                                   
;----------------------------------------------------------------------
        MVMD      BK,T
        LDM       AR5,A
        MPY       *(AL),A               ; |275| 
        ;;RSBX      OVM
        ;;NOP
        ;;SFTA      A,8                   ; |275| 
        ;;SSBX      OVM
        ;;SFTA      A,-8                  ; |275| 
        ADD       #1,#15,A,A            ; |275| 
        SFTA      A,-16,A               ; |275| 
        STLM      A,AR5
        NOP

L2:    

;----------------------------------------------------------------------
; 277 | ap[m] = round( L_mult(a[m], fac) );                                    
;----------------------------------------------------------------------
        LDM       AR3,A
        ;;RSBX      OVM
        ;;SSBX      FRCT
        ADD       B,A                   ; |277| 
        STLM      A,AR1
        ;;SSBX      OVM
        MVMD      AR5,T
        MPY       *AR1,A                ; |277| 
        ;;RSBX      OVM
        ;;NOP
        ;;SFTA      A,8                   ; |277| 
        ;;SSBX      OVM
        ;;SFTA      A,-8                  ; |277| 
        ADD       #1,#15,A,A            ; |277| 
        ;;RSBX      OVM
        DST       A,*SP(0)              ; |277| 
        LDM       AR2,A
        ADD       B,A                   ; |277| 
        STLM      A,AR2
        NOP
        DLD       *SP(0),A              ; |277| 
        STH       A,*AR2                ; |277| 

;----------------------------------------------------------------------
; 279 | return;                                                                
;----------------------------------------------------------------------

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #2
        POPM      AR1
        RET

        
        


	.sect	".text"
;----------------------------------------------------------------------
;  70 | static void Get_lsp_pol(Word16 *lsp, Word32 *f)                        
;----------------------------------------------------------------------

_Get_lsp_pol:

        PSHM      AR1
        FRAME     #-10
        NOP
        STL       A,*SP(2)

	    SSBX      SXM
        SSBX      FRCT
        SSBX      OVM
        NOP
        LD        #4096,A
        MVDK      *SP(12),*(AR1)
        MPY       *(AL),#2048,A         ; |77| 
        DST       A,*AR1                ; |77| 

        ;;RSBX      OVM
        NOP
        ADDM      #2,*SP(12)            ; |78| 

        LD        #512,B
        MVDK      *SP(2),*(AR1)
        LD        #0,A
        LD        *AR1,T
        ;ORM       #2,*(PMST)
        ;;SSBX      OVM
        ORM       #2,*(PMST)
        MVDK      *SP(12),*(AR1)
        MAS       *(BL), A              ; |79| 
        DST       A,*AR1                ; |79| 

        ;;SSBX      OVM
        NOP
        ADDM      #2,*SP(12)            ; |81| 

        ADDM      #2,*SP(2)             ; |82| 

        ;SSBX      SXM
        LD        #5,A
        ST        #2,*SP(3)             ; |84| 
        SUB       *SP(3),A              ; |84| 
        BC        L108,ALT                ; |84| 
        ; branch occurs ; |84| 
L105:    

        MVDK      *SP(12),*(AR1)
        DLD       *AR1(-4),A            ; |86| 
        DST       A,*AR1                ; |86| 

        ST        #1,*SP(4)             ; |88| 
        LD        *SP(3),A              ; |88| 
        SUB       *SP(4),A              ; |88| 
        BC        L107,ALEQ               ; |88| 
        ; branch occurs ; |88| 
L106:    

        LDM       SP,A
        ADD       #5,A
        STL       A,*SP(0)
        RSBX      FRCT
        LDM       SP,A
        ADD       #6,A
        STL       A,*SP(1)
        MVDK      *SP(12),*(AR1)
        DLD       *AR1(-2),A            ; |90| 
        CALL      #_L_Extract           ; |90| 


		;;SSBX		SXM;;WLY
		;;SSBX		OVM;;WLY
        LD        *SP(6),A
        ;;RSBX      FRCT
        RSBX      OVM
        NOP
        STL       A,*SP(0)
        MVDK      *SP(2),*(AR1)
        LD        *AR1,A
        STL       A,*SP(1)
        LD        *SP(5),A
        CALL      #_Mpy_32_16           ; |91| 
        ; call occurs [#_Mpy_32_16] ; |91| 
        DST       A,*SP(8)              ; |91| 

        ;RSBX      OVM
        ;RSBX      FRCT
        ;ST        #1,*SP(0)             ; |92| 
        ;DLD       *SP(8),A              ; |92| 
        ;CALL      #_L_shl               ; |92| 
        SSBX	SXM;;WLY
        SSBX	OVM;;WLY
        NOP
        DLD       *SP(8),A              ; |92| 
        SFTA 	A,1,A;;wly
        NOP
        ; call occurs [#_L_shl] ; |92| 
        DST       A,*SP(8)              ; |92| 

        SSBX      OVM
        SSBX      SXM
        MVDK      *SP(12),*(AR1)
        DLD       *AR1,A
        DADD      *AR1(-4),A,A          ; |93| 
        DST       A,*AR1                ; |93| 

        ;;RSBX      OVM
        NOP
        ;;DLD       *SP(8),A              ; |94| 
        ;;DST       A,*SP(0)              ; |94| 
        DLD		*SP(8),B;;WLY
        MVDK      *SP(12),*(AR1)
        ;;RSBX      FRCT
        DLD       *AR1,A                ; |94| 
        ;;CALL      #_L_sub               ; |94| 
        SUB		B,A;;WLY
        NOP
        ; call occurs [#_L_sub] ; |94| 
        ;;MVDK      *SP(12),*(AR1)
        DST       A,*AR1                ; |94| 

        ;;RSBX      OVM
        ;;SSBX      SXM
        ADDM      #1,*SP(4)             ; |95| 
        ADDM      #-2,*SP(12)           ; |95| 
        LD        *SP(3),A              ; |95| 
        SUB       *SP(4),A              ; |95| 
        BC        L106,AGT                ; |95| 
        ; branch occurs ; |95| 
L107:    

        MVDK      *SP(12),*(AR1)
        DLD       *AR1,A                ; |96| 
        LD        #512,B
        MVDK      *SP(2),*(AR1)
        LD        *AR1,T
        ;ORM       #2,*(PMST)
        SSBX      FRCT
        ;;SSBX      OVM
        ;ORM       #2,*(PMST)
        MVDK      *SP(12),*(AR1)
        MAS       *(BL), A              ; |96| 
        DST       A,*AR1                ; |96| 

        ;;RSBX      OVM
        LD        *SP(3),B
        LD        *SP(12),A
        ADD       B,#1,A                ; |97| 
        STL       A,*SP(12)

        ADDM      #2,*SP(2)             ; |98| 

        LD        #5,A
        ADDM      #1,*SP(3)             ; |99| 
        SUB       *SP(3),A              ; |99| 
        BC        L105,AGEQ               ; |99| 
        ; branch occurs ; |99| 

L108:    

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #10
        POPM      AR1
        RET




	.sect	".text"
	.global	_Lsp_Az

;----------------------------------------------------------------------
;  27 | void Lsp_Az(                                                           
;  28 | Word16 lsp[],    /* (i) Q15 : line spectral frequencies            */  
;  29 | Word16 a[]       /* (o) Q12 : predictor coefficients (order = 10)  */  
;  30 | )                                                                      
;----------------------------------------------------------------------

_Lsp_Az:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-28
;----------------------------------------------------------------------
;  32 | Word16 i, j;                                                           
;  33 | Word32 f1[6], f2[6];                                                   
;  34 | Word32 t0;                                                             
;----------------------------------------------------------------------
        STLM      A,AR1
        LD        *SP(32),A
        STL       A,*SP(26)

;----------------------------------------------------------------------
;  36 | Get_lsp_pol(&lsp[0],f1);                                               
;----------------------------------------------------------------------
        ;;RSBX      OVM
        SSBX	OVM;;WLY
        SSBX	SXM;;WLY
        RSBX      FRCT
        LDM       SP,A
        ADD       #2,A
        STL       A,*SP(0)
        CALLD     #_Get_lsp_pol   ; |36| ;;wly to recover!
        ;;CALLD     #_Get_lsp_pol_asm   ; |36| 
        NOP
        LDM       AR1,A
        ; call occurs [#_Get_lsp_pol] ; |36| 

;----------------------------------------------------------------------
;  37 | Get_lsp_pol(&lsp[1],f2);                                               
;  39 | for (i = 5; i > 0; i--)                                                
;----------------------------------------------------------------------
        ;;RSBX      OVM
        SSBX	OVM;;WLY
        SSBX	SXM;;WLY        
        LDM       SP,A
        ADD       #14,A
        RSBX      FRCT
        STL       A,*SP(0)
        LDM       AR1,A
        CALLD     #_Get_lsp_pol         ; |37| ;;wly to recover!
        ;;CALLD     #_Get_lsp_pol_asm   ; |36| 
        ADD       #1,A,A                ; |37| 
        ; call occurs [#_Get_lsp_pol] ; |37| 
        STM       #5,AR7
        MVMM      SP,AR6
        MVMM      SP,AR1
        MAR       *+AR6(#12)
        MAR       *+AR1(#24)
        
        SSBX      SXM
        SSBX      OVM
L13:    
;----------------------------------------------------------------------
;  41 | f1[i] = L_add(f1[i], f1[i-1]);        /* f1[i] += f1[i-1]; */          
;----------------------------------------------------------------------
        ;;SSBX      SXM
        ;;SSBX      OVM
        DLD       *AR6,A
        DADD      *AR6(-2),A,A          ; |41| 
        DST       A,*AR6-               ; |41| 

;----------------------------------------------------------------------
;  42 | f2[i] = L_sub(f2[i], f2[i-1]);        /* f2[i] -= f2[i-1]; */          
;----------------------------------------------------------------------
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ;;DLD       *AR1(-2),A            ; |42| 
        DLD       *AR1(-2),B;;WLY
        ;;DST       A,*SP(0)              ; |42| 
        DLD       *AR1,A                ; |42| 
        ;;CALL      #_L_sub               ; |42| 
        SUB	B,A;;WLY
        ; call occurs [#_L_sub] ; |42| 
        DST       A,*AR1-               ; |42| 

        BANZ      L13,*+AR7(-1)         ; |43| 

;----------------------------------------------------------------------
;  45 | a[0] = 4096;                                                           
;  46 | for (i = 1, j = 10; i <= 5; i++, j--)                                  
;  48 |   t0   = L_add(f1[i], f2[i]);                 /* f1[i] + f2[i]
;     |     */                                                                 
;----------------------------------------------------------------------
        MVDK      *SP(26),*(AR1)
        ;;RSBX      OVM
        ST        #4096,*AR1            ; |45| 
        MVMM      SP,AR6
        LD        *SP(26),A
        STM       #5,AR7
        MVMM      SP,AR1
        ADD       #1,A,A
        MAR       *+AR6(#4)
        STL       A,*SP(27)
        MAR       *+AR1(#16)
        LD        *SP(26),A
        ADD       #10,A,A
        STL       A,*SP(26)
L14:    

;----------------------------------------------------------------------
;  49 | a[i] = extract_l( L_shr_r(t0, 13) );        /* from Q24 to Q12 and * 0.
;     | 5 */                                                                   
;----------------------------------------------------------------------
        ;;SSBX      SXM
        ST        #13,*SP(0)            ; |49| 
        SSBX      OVM
        ;;RSBX      FRCT
        DLD       *AR6,A
        DADD      *AR1,A,A              ; |49| 
        ;;RSBX      OVM
        ;;NOP
        CALL      #_L_crshft_r          ; |49| 
        ;;SFTA	A,-13,A;;WLY
        ; call occurs [#_L_crshft_r] ; |49| 
        MVDK      *SP(27),*(AR2)
        STL       A,*AR2+
        MVKD      *(AR2),*SP(27)

;----------------------------------------------------------------------
;  51 | t0   = L_sub(f1[i], f2[i]);                 /* f1[i] - f2[i]
;     |   */                                                                   
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;RSBX      FRCT
        ;;DLD       *AR1+,A               ; |51| 
        ;;SSBX	OVM;;WLY
        DLD       *AR1+,B;;WLY 
        ;;DST       A,*SP(0)              ; |51| 
        DLD       *AR6+,A               ; |51| 
        ;;CALL      #_L_sub               ; |51| 
        SSBX	OVM;;WLY
        SUB	B,A
        ; call occurs [#_L_sub] ; |51| 

;----------------------------------------------------------------------
;  52 | a[j] = extract_l( L_shr_r(t0, 13) );        /* from Q24 to Q12 and * 0.
;     | 5 */                                                                   
;----------------------------------------------------------------------
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ST        #13,*SP(0)            ; |52| 
        CALL      #_L_crshft_r          ; |52| 
        ;;SFTA	A,-13,A;;
        ; call occurs [#_L_crshft_r] ; |52| 
        MVDK      *SP(26),*(AR2)
        STL       A,*AR2-
        MVKD      *(AR2),*SP(26)
;----------------------------------------------------------------------
;  56 | return;                                                                
;----------------------------------------------------------------------
        BANZ      L14,*+AR7(-1)         ; |54| 

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #28
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET



	.sect	".text"
	.global	_Int_qlpc
;----------------------------------------------------------------------
; 290 | void Int_qlpc(                                                         
; 291 | Word16 lsp_old[], /* input : LSP vector of past frame              */  
; 292 | Word16 lsp_new[], /* input : LSP vector of present frame           */  
; 293 | Word16 Az[]       /* output: interpolated Az() for the 2 subframes */  
; 294 | )                                                                      
;----------------------------------------------------------------------

_Int_qlpc:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-16
;----------------------------------------------------------------------
; 296 | Word16 i;                                                              
; 297 | Word16 lsp[M];                                                         
; 301 | for (i = 0; i < M; i++) {                                              
;----------------------------------------------------------------------
        MVMM      SP,AR6
        STM       #10,AR7
        LD        *SP(21),B
        MAR       *+AR6(#2)
        STL       B,*SP(12)
        STL       A,*SP(14)
        LD        *SP(20),B
        STLM      B,AR1
        STL       B,*SP(13)
        SSBX      SXM
        SSBX      OVM
L20:    
;----------------------------------------------------------------------
; 302 | lsp[i] = add(shr(lsp_new[i], 1), shr(lsp_old[i], 1));                  
;----------------------------------------------------------------------
        ;ST        #1,*SP(0)             ; |302| 
        ;RSBX      FRCT
        MVDK      *SP(14),*(AR2)
        ;RSBX      OVM
        LD        *AR2+,A
        MVKD      *(AR2),*SP(14)
        ;CALL      #_crshft              ; |302| 
        SFTA      A,-1
        
        STL       A,*SP(15)
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #1,*SP(0)             ; |302| 
        LD        *AR1+,A
        ;CALL      #_crshft              
        SFTA      A,-1
        
        ;RSBX      OVM
        ;SSBX      SXM
        LD        *(AL),16,A            
        LD        *SP(15),B
        ;SSBX      OVM
        ADD       *(BL),16,A,A          
        STH       A,*AR6+               
        BANZ      L20,*+AR7(-1)         

;----------------------------------------------------------------------
; 305 | Lsp_Az(lsp, Az);              /* Subframe 1 */                         
;----------------------------------------------------------------------
        LD        *SP(12),A
        RSBX      FRCT
        RSBX      OVM
        STL       A,*SP(0)
        LDM       SP,A
        CALLD     #_Lsp_Az              ; |305| 
        ADD       #2,A

;----------------------------------------------------------------------
; 307 | Lsp_Az(lsp_new, &Az[MP1]);    /* Subframe 2 */                         
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *SP(12),A
        RSBX      FRCT
        ADD       #11,A,A               ; |307| 
        STL       A,*SP(0)
        LD        *SP(13),A
        CALL      #_Lsp_Az              ; |307| 

;----------------------------------------------------------------------
; 309 | return;                                                                
;----------------------------------------------------------------------
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #16
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET




;***************************************************************
;* UNDEFINED EXTERNAL REFERENCES                               *
;***************************************************************
	.global	_L_Extract
	.global	_Mpy_32_16
	.global	_L_crshft_r
	.global	_table
	.global	_slope
	.global	_table2
	.global	_slope_cos
	.global	_slope_acos		

	
