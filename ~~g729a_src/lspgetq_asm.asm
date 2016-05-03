;***************************************************************
;* TMS320C54x C/C++ Codegen                  PC Version 3.831  *
;* Date/Time created: Wed May 11 09:36:39 2005                 *
;***************************************************************
	.mmregs
FP	.set	AR7

;	c:\ti\c5400\cgtools\bin\opt500.exe -i20 -q -s -O3 D:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\TI3856_2 D:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\TI3856_5 -w F:/ATA/Code/g729a_v1.4/G729A/Debug 

	.sect	".text"
	.global	_Lsp_stability
;----------------------------------------------------------------------
; 191 | void Lsp_stability(                                                    
; 192 | Word16 buf[]       /* (i/o) Q13 : quantized LSP parameters      */     
; 193 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_stability                                *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_stability:
;* A     assigned to _buf
	.sym	_buf,0, 19, 17, 16
;* A     assigned to _L_diff
	.sym	_L_diff,0, 5, 4, 32
;* A     assigned to _L_diff
	.sym	_L_diff,0, 5, 4, 32
;* AR1   assigned to U$3
	.sym	U$3,10, 19, 4, 16
;* AR1   assigned to U$3
	.sym	U$3,10, 19, 4, 16
;* AR6   assigned to _buf
	.sym	_buf,15, 19, 4, 16
;* B     assigned to _tmp
	.sym	_tmp,6, 3, 4, 16
;* AR7   assigned to L$2
	.sym	L$2,16, 4, 4, 16
;* AR7   assigned to L$1
	.sym	L$1,16, 4, 4, 16
;**  	-----------------------    #pragma MUST_ITERATE(9, 9, 9)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$3 = buf;
;**  	-----------------------    L$1 = 9;
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-2
;----------------------------------------------------------------------
; 195 | Word16 j;                                                              
; 196 | Word16 tmp;                                                            
; 197 | Word32 L_diff;                                                         
; 198 | Word32 L_acc, L_accb;                                                  
; 200 | for(j=0; j<M-1; j++) {                                                 
; 201 |   L_acc = L_deposit_l( buf[j+1] );                                     
; 202 |   L_accb = L_deposit_l( buf[j] );                                      
;----------------------------------------------------------------------
        STLM      A,AR6
        NOP
        NOP
        MVMM      AR6,AR1
        STM       #9,AR7
L1:    
;**	-----------------------g2:
;** 203	-----------------------    if ( (L_diff = L_sub((long)U$3[1], (long)*U$3)) >= 0L ) goto g4;

;----------------------------------------------------------------------
; 203 | L_diff = L_sub( L_acc, L_accb );                                       
; 205 | if( L_diff < 0L ) {                                                    
;----------------------------------------------------------------------
        ;;RSBX      OVM
        SSBX	OVM;;WLY
        SSBX      SXM
        RSBX      FRCT
        ;;LD        *AR1,A                ; |203| 
        ;;DST       A,*SP(0)              ; |203| 
        LD		*AR1,B;;WLY
        LD        *AR1(1),A             ; |203| 
        ;;CALL      #_L_sub               ; |203| 
        NOP;;
        SUB 	B,A;;WLY
        ; call occurs [#_L_sub] ; |203| 
        ;;RSBX      OVM
        ;;SSBX      SXM
        ;;SFTA      A,8                   ; |203| 
        ;;SFTA      A,-8                  ; |203| 
        BC        L2,AGEQ               ; |203| 
        ; branch occurs ; |203| 
;** 207	-----------------------    tmp = U$3[1];
;** 208	-----------------------    U$3[1] = *U$3;
;** 209	-----------------------    *U$3 = tmp;
	.line	17
;----------------------------------------------------------------------
; 207 | tmp      = buf[j+1];                                                   
;----------------------------------------------------------------------
        LD        *AR1(1),B
	.line	18
;----------------------------------------------------------------------
; 208 | buf[j+1] = buf[j];                                                     
;----------------------------------------------------------------------
        LD        *AR1,A
        STL       A,*AR1(1)
	.line	19
;----------------------------------------------------------------------
; 209 | buf[j]   = tmp;                                                        
;----------------------------------------------------------------------
        STL       B,*AR1
L2:    
;**	-----------------------g4:
;** 211	-----------------------    ++U$3;
;** 211	-----------------------    if ( --L$1 ) goto g2;
	.line	21
        BANZD     L1,*+AR7(-1)          ; |211| 
        NOP
        MAR       *AR1+
        ; branch occurs ; |211| 
;** 214	-----------------------    if ( *buf >= 40 ) goto g7;
	.line	24
;----------------------------------------------------------------------
; 214 | if( sub(buf[0], L_LIMIT) <0 ) {                                        
;----------------------------------------------------------------------
        LD        #40,A
        SUB       *AR6,A                ; |214| 
        BC        L3,ALEQ               ; |214| 
        ; branch occurs ; |214| 
;** 215	-----------------------    *buf = 40;
;** 216	-----------------------    printf((char *)"lsp_stability warning Low \n");
	.line	25
;----------------------------------------------------------------------
; 215 | buf[0] = L_LIMIT;                                                      
;----------------------------------------------------------------------
        ST        #40,*AR6              ; |215| 
	.line	26
;----------------------------------------------------------------------
; 216 | printf("lsp_stability warning Low \n");                                
; 218 | for(j=0; j<M-1; j++) {                                                 
; 219 | L_acc = L_deposit_l( buf[j+1] );                                       
; 220 | L_accb = L_deposit_l( buf[j] );                                        
;----------------------------------------------------------------------
        RSBX      FRCT
        ST        #SL1,*SP(0)           ; |216| 
        CALL      #_printf              ; |216| 
        ; call occurs [#_printf] ; |216| 
L3:    
;**	-----------------------g7:
;**  	-----------------------    #pragma MUST_ITERATE(9, 9, 9)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$3 = buf;
;**  	-----------------------    L$2 = 9;
        NOP
        NOP
        NOP
        NOP
        STM       #9,AR7
        MVMM      AR6,AR1
L4:    
;**	-----------------------g9:
;** 221	-----------------------    L_diff = L_sub((long)U$3[1], (long)*U$3);
;** 223	-----------------------    if ( L_sub(L_diff, 321L) >= 0L ) goto g11;
	.line	31
;----------------------------------------------------------------------
; 221 | L_diff = L_sub( L_acc, L_accb );                                       
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;SSBX      SXM
        ;;RSBX      FRCT
        ;;LD        *AR1,A                ; |221| 
        ;;DST       A,*SP(0)              ; |221| 
        LD 		*AR1,B;;WLY
        LD        *AR1(1),A             ; |221| 
        ;;CALL      #_L_sub               ; |221| 
        NOP;;
        SUB 	B,A;;WLY
        ; call occurs [#_L_sub] ; |221| 
	.line	33
;----------------------------------------------------------------------
; 223 | if( L_sub(L_diff, GAP3)<0L ) {                                         
;----------------------------------------------------------------------
        LD        #321,B
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ;;DST       B,*SP(0)              ; |223| 
        ;;CALL      #_L_sub               ; |223| 
        ; call occurs [#_L_sub] ; |223| 
        SUB 	B,A;;WLY
        ;;RSBX      OVM
        ;;SSBX      SXM
        ;;SFTA      A,8                   ; |223| 
        ;;SFTA      A,-8                  ; |223| 
        BC        L5,AGEQ               ; |223| 
        ; branch occurs ; |223| 
;** 224	-----------------------    U$3[1] = _sadd(*U$3, 321);
	.line	34
;----------------------------------------------------------------------
; 224 | buf[j+1] = add( buf[j], GAP3 );                                        
;----------------------------------------------------------------------
        LD        *AR1,16,A             ; |224| 
        ;;SSBX      OVM
        NOP
        ADD       #321,16,A,A           ; |224| 
        STH       A,*AR1(1)             ; |224| 
L5:    
;**	-----------------------g11:
;** 226	-----------------------    ++U$3;
;** 226	-----------------------    if ( --L$2 ) goto g9;
	.line	36
        BANZD     L4,*+AR7(-1)          ; |226| 
        NOP
        MAR       *AR1+
        ; branch occurs ; |226| 
;** 228	-----------------------    if ( buf[9] < 25682 ) goto g14;
	.line	38
;----------------------------------------------------------------------
; 228 | if( sub(buf[M-1],M_LIMIT)>0 ) {                                        
;----------------------------------------------------------------------
        ;;RSBX      OVM
        LD        #25682,A
        SUB       *AR6(9),A             ; |228| 
        BC        L6,AGT                ; |228| 
        ; branch occurs ; |228| 
;** 229	-----------------------    buf[9] = 25681;
;** 230	-----------------------    printf((char *)"lsp_stability warning High \n");
;**	-----------------------g14:
;**  	-----------------------    return;
	.line	39
;----------------------------------------------------------------------
; 229 | buf[M-1] = M_LIMIT;                                                    
;----------------------------------------------------------------------
        ST        #25681,*AR6(9)        ; |229| 
	.line	40
;----------------------------------------------------------------------
; 230 | printf("lsp_stability warning High \n");                               
; 232 | return;                                                                
;----------------------------------------------------------------------
        RSBX      FRCT
        ST        #SL2,*SP(0)           ; |230| 
        CALL      #_printf              ; |230| 
        ; call occurs [#_printf] ; |230| 
L6:    
	.line	43
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #2
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	233,000018400h,5



	.sect	".text"
	.global	_Lsp_prev_update

;----------------------------------------------------------------------
; 177 | void Lsp_prev_update(                                                  
; 178 | Word16 lsp_ele[M],             /* (i)   Q13 : LSP vectors           */ 
; 179 | Word16 freq_prev[MA_NP][M]     /* (i/o) Q13 : previous LSP vectors  */ 
; 180 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_prev_update                              *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_prev_update:
	.line	5
;* A     assigned to _lsp_ele
	.sym	_lsp_ele,0, 19, 17, 16
	.sym	_freq_prev,8, 211, 9, 16,, 10
	.sym	U$6,3, 20, 1, 16
;* AR1   assigned to U$8
	.sym	U$8,10, 20, 4, 16
;* AR6   assigned to L$1
	.sym	L$1,15, 4, 4, 16
	.sym	_freq_prev,2, 211, 1, 16,, 10
;* AR7   assigned to _lsp_ele
	.sym	_lsp_ele,16, 19, 4, 16
;**  	-----------------------    #pragma MUST_ITERATE(3, 3, 3)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$6 = &freq_prev[30];
;**  	-----------------------    U$8 = &freq_prev[20];
;**  	-----------------------    L$1 = 3;
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-4
;----------------------------------------------------------------------
; 182 | Word16 k;                                                              
; 184 | for ( k = MA_NP-1 ; k > 0 ; k-- )                                      
;----------------------------------------------------------------------
        STLM      A,AR7
        NOP
        STM       #3,AR6
        LD        *SP(8),A
        STL       A,*SP(2)
        ADD       #30,A,A
        STL       A,*SP(3)
        LD        *SP(2),A
        ADD       #20,A,A
        STLM      A,AR1
        SSBX      SXM;;wly
L7:    
;**	-----------------------g2:
;** 185	-----------------------    Copy(U$8, U$6, 10);
;** 185	-----------------------    U$6 -= 10;
;** 185	-----------------------    U$8 -= 10;
;** 185	-----------------------    if ( --L$1 ) goto g2;
	.line	9
;----------------------------------------------------------------------
; 185 | Copy(freq_prev[k-1], freq_prev[k], M);                                 
;----------------------------------------------------------------------
        LD        *SP(3),A
        STL       A,*SP(0)
        ST        #10,*SP(1)            ; |185| 
        CALLD     #_Copy                ; |185| 
        NOP
        LDM       AR1,A
        ; call occurs [#_Copy] ; |185| 
        MAR       *+AR1(#-10)
        ;;SSBX      SXM
        LD        *SP(3),A
        ADD       #-10,A
        BANZD     L7,*+AR6(-1)          ; |185| 
        NOP
        STL       A,*SP(3)
        ; branch occurs ; |185| 
;** 187	-----------------------    Copy(lsp_ele, (int * const)freq_prev, 10);
;** 188	-----------------------    return;
	.line	11
;----------------------------------------------------------------------
; 187 | Copy(lsp_ele, freq_prev[0], M);                                        
;----------------------------------------------------------------------
        LD        *SP(2),A
        STL       A,*SP(0)
        ST        #10,*SP(1)            ; |187| 
        CALLD     #_Copy                ; |187| 
        NOP
        LDM       AR7,A
        ; call occurs [#_Copy] ; |187| 
	.line	12
;----------------------------------------------------------------------
; 188 | return;                                                                
;----------------------------------------------------------------------
	.line	13
        FRAME     #4
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	189,000018400h,7



	.sect	".text"
	.global	_Lsp_prev_extract

;----------------------------------------------------------------------
; 147 | void Lsp_prev_extract(                                                 
; 148 | Word16 lsp[M],                /* (i) Q13 : unquantized LSP parameters
;     | */                                                                     
; 149 | Word16 lsp_ele[M],            /* (o) Q13 : target vector
;     | */                                                                     
; 150 | Word16 fg[MA_NP][M],          /* (i) Q15 : MA prediction coef.
;     | */                                                                     
; 151 | Word16 freq_prev[MA_NP][M],   /* (i) Q13 : previous LSP vector
;     | */                                                                     
; 152 | Word16 fg_sum_inv[M]          /* (i) Q12 : inverse previous LSP vector
;     | */                                                                     
; 153 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_prev_extract                             *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_prev_extract:
	.line	8
;* A     assigned to _lsp
	.sym	_lsp,0, 19, 17, 16
	.sym	_lsp_ele,10, 19, 9, 16
	.sym	_fg,11, 211, 9, 16,, 10
	.sym	_freq_prev,12, 211, 9, 16,, 10
	.sym	_fg_sum_inv,13, 19, 9, 16
;
; BRC	assigned to temp var  L$2
;
;* BRC   assigned to L$2
	.sym	L$2,25, 4, 4, 16
;* A     assigned to L$2
	.sym	L$2,0, 4, 4, 16
	.sym	U$7,2, 19, 1, 16
	.sym	U$17,3, 20, 1, 16
	.sym	U$19,4, 20, 1, 16
;* AR7   assigned to U$27
	.sym	U$27,16, 19, 4, 16
;* AR6   assigned to U$34
	.sym	U$34,15, 19, 4, 16
;* A     assigned to _L_temp
	.sym	_L_temp,0, 5, 4, 32
;* AR1   assigned to _j
	.sym	_j,10, 3, 4, 16
;* AR7   assigned to _fg_sum_inv
	.sym	_fg_sum_inv,16, 19, 4, 16
;* B     assigned to _freq_prev
	.sym	_freq_prev,6, 211, 4, 16,, 10
;* AR1   assigned to _fg
	.sym	_fg,10, 211, 4, 16,, 10
;* AR6   assigned to _lsp_ele
	.sym	_lsp_ele,15, 19, 4, 16
;* A     assigned to _lsp
	.sym	_lsp,0, 19, 4, 16
;**  	-----------------------    #pragma MUST_ITERATE(10, 10, 10)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$7 = &lsp[-1];
;**  	-----------------------    U$27 = fg_sum_inv;
;**  	-----------------------    U$34 = lsp_ele;
;**  	-----------------------    U$17 = (int * const)fg;
;**  	-----------------------    U$19 = (int * const)freq_prev;
;** 160	-----------------------    j = 0;
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-6
;----------------------------------------------------------------------
; 155 | Word16 j, k;                                                           
; 156 | Word32 L_temp;                /* Q19 */                                
; 157 | Word16 temp;                  /* Q13 */                                
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *SP(12),B
        SUB       #1,A,A
        MVDK      *SP(10),*(AR6)
        STL       B,*SP(4)
        STL       A,*SP(2)
        MVDK      *SP(11),*(AR1)
        MVKD      *(AR1),*SP(3)
        MVDK      *SP(13),*(AR7)
	.line	14
;----------------------------------------------------------------------
; 160 | for ( j = 0 ; j < M ; j++ ) {                                          
;----------------------------------------------------------------------
        STM       #0,AR1
L8:    
;**	-----------------------g2:
;** 161	-----------------------    L_temp = (long)*(++U$7)<<16;
;**  	-----------------------    #pragma MUST_ITERATE(4, 4, 4)
;**  	-----------------------    #pragma LOOP_FLAGS(4096u)
;**	-----------------------g4:
;**  	-----------------------    L$2 = 3;
;**	-----------------------g7:
	.line	15
;----------------------------------------------------------------------
; 161 | L_temp = L_deposit_h(lsp[j]);                                          
; 162 | for ( k = 0 ; k < MA_NP ; k++ )                                        
;----------------------------------------------------------------------
        SSBX      SXM
        ;;SSBX      OVM;;wly
        NOP
        MVDK      *SP(2),*(AR2)
        STM       #3,BRC
        ;LD        *+AR2(1),A            ; |161|
        LD        *+AR2(1),16,A 
        MVKD      *(AR2),*SP(2)
        ;SFTL      A,#15,A               ; |161| 
        ;SFTL      A,#1,A                ; |161| 
		SSBX      FRCT;;wly
        ;RSBX      OVM;;wly
        SSBX      OVM
        ORM       #2,*(PMST);wly 
        ;;;MVDK      *SP(4),*(AR3)
        ;;;MVDK      *SP(3),*(AR2)       
        RPTB      LOOP_1-1
        ; loop starts
L9:    
;** 163	-----------------------    L_temp = _smas(L_temp, *U$19, *U$17);
;** 163	-----------------------    U$17 += 10;
;** 163	-----------------------    U$19 += 10;
;** 163	-----------------------    if ( --L$2 != -1 ) goto g7;
	.line	17
;----------------------------------------------------------------------
; 163 | L_temp = L_msu( L_temp, freq_prev[k][j], fg[k][j] );                   
; 165 | temp = extract_h(L_temp);                                              
;----------------------------------------------------------------------
        ;;RSBX      OVM;;wly
        ;SFTA      A,8                   ; |163| 
        MVDK      *SP(4),*(AR3)
        MVDK      *SP(3),*(AR2)
        ;SFTA      A,-8                  ; |163| 
        ;;SSBX      OVM;;wly
        ;;ORM       #2,*(PMST)
        ;;SSBX      FRCT
        ;;SSBX      OVM
        ;;ORM       #2,*(PMST)
        NOP
        MAS       *AR2, *AR3, A, A      ; |163| 
        ;;RSBX      OVM
        LDM       AR2,B
        ADD       #10,B
        STL       B,*SP(3)
        ;;;MAR       *+AR2(10)
        LDM       AR3,B
        ADD       #10,B
        STL       B,*SP(4)
        ;;;MAR        *+AR3(10)
        ; loop ends ; |163| 
LOOP_1:
		;;;MVKD      *(AR2),*SP(3)
		;;;MVKD      *(AR3),*SP(4)
L10:    
;**  	-----------------------    U$19 -= 39;
;**  	-----------------------    U$17 -= 39;
;** 166	-----------------------    L_temp = _lsmpy((int)(L_temp>>16), *U$27++);
;** 167	-----------------------    *U$34++ = (unsigned long)L_shl(L_temp, 3)>>16;
;** 169	-----------------------    if ( (++j) < 10 ) goto g2;
;**  	-----------------------    return;
        LD        *SP(4),B
        ADD       #-39,B
        STL       B,*SP(4)
        LD        *SP(3),B
        ADD       #-39,B
        STL       B,*SP(3)
	.line	20
;----------------------------------------------------------------------
; 166 | L_temp = L_mult( temp, fg_sum_inv[j] );                                
;----------------------------------------------------------------------
        ;;SSBX      FRCT
        SFTL      A,#-16,A              ; |166| 
        SSBX      OVM
        LD        *AR7+,T
        MPY       *(AL),A               ; |166| 
	.line	21
;----------------------------------------------------------------------
; 167 | lsp_ele[j] = extract_h( L_shl( L_temp, 3 ) );                          
;----------------------------------------------------------------------
        ;;RSBX      FRCT
        ;;RSBX      OVM
        ;;ST        #3,*SP(0)             ; |167| 
        ;;CALL      #_L_shl               ; |167| 
        SFTA	A,3
        ; call occurs [#_L_shl] ; |167| 
        SFTL      A,#-16,A              ; |167| 
        STL       A,*AR6+               ; |167| 
	.line	23
;----------------------------------------------------------------------
; 170 | return;                                                                
;----------------------------------------------------------------------
        MAR       *AR1+
        ;;SSBX      SXM
        ;RSBX      OVM
        LD        *(AR1),A              ; |169| 
        SUB       #10,A,A               ; |169| 
        BC        L8,ALT                ; |169| 
        ; branch occurs ; |169| 
	.line	25
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #6
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	171,000018400h,9



	.sect	".text"
	.global	_Lsp_prev_compose

;----------------------------------------------------------------------
; 122 | void Lsp_prev_compose(                                                 
; 123 | Word16 lsp_ele[],             /* (i) Q13 : LSP vectors
;     | */                                                                     
; 124 | Word16 lsp[],                 /* (o) Q13 : quantized LSP parameters
;     | */                                                                     
; 125 | Word16 fg[][M],               /* (i) Q15 : MA prediction coef.
;     | */                                                                     
; 126 | Word16 freq_prev[][M],        /* (i) Q13 : previous LSP vector
;     | */                                                                     
; 127 | Word16 fg_sum[]               /* (i) Q15 : present MA prediction coef.
;     | */                                                                     
; 128 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_prev_compose                             *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_prev_compose:
	.line	8
;* A     assigned to _lsp_ele
	.sym	_lsp_ele,0, 19, 17, 16
	.sym	_lsp,2, 19, 9, 16
	.sym	_fg,3, 211, 9, 16,, 10
	.sym	_freq_prev,4, 211, 9, 16,, 10
	.sym	_fg_sum,5, 19, 9, 16
;
; BRC	assigned to temp var  L$2
;
;* BRC   assigned to L$2
	.sym	L$2,25, 4, 4, 16
;* A     assigned to L$2
	.sym	L$2,0, 4, 4, 16
;* AR4   assigned to L$1
	.sym	L$1,13, 4, 4, 16
;* AR5   assigned to U$7
	.sym	U$7,14, 19, 4, 16
;* AR0   assigned to U$9
	.sym	U$9,9, 19, 4, 16
;* AR3   assigned to U$17
	.sym	U$17,12, 20, 4, 16
;* AR2   assigned to U$19
	.sym	U$19,11, 20, 4, 16
;* AR1   assigned to U$30
	.sym	U$30,10, 19, 4, 16
;* A     assigned to _L_acc
	.sym	_L_acc,0, 5, 4, 32
;* B     assigned to _fg_sum
	.sym	_fg_sum,6, 19, 4, 16
;* AR2   assigned to _freq_prev
	.sym	_freq_prev,11, 211, 4, 16,, 10
;* AR3   assigned to _fg
	.sym	_fg,12, 211, 4, 16,, 10
;* AR1   assigned to _lsp
	.sym	_lsp,10, 19, 4, 16
;* A     assigned to _lsp_ele
	.sym	_lsp_ele,0, 19, 4, 16
;**  	-----------------------    #pragma MUST_ITERATE(10, 10, 10)
;**  	-----------------------    #pragma LOOP_FLAGS(4096u)
;**  	-----------------------    U$7 = &fg_sum[-1];
;**  	-----------------------    U$9 = &lsp_ele[-1];
;**  	-----------------------    U$30 = lsp;
;**  	-----------------------    U$17 = (int * const)fg;
;**  	-----------------------    U$19 = (int * const)freq_prev;
;**  	-----------------------    L$1 = 9;
        PSHM      AR1
;----------------------------------------------------------------------
; 130 | Word16 j, k;                                                           
; 131 | Word32 L_acc;                 /* Q29 */                                
; 133 | for ( j = 0 ; j < M ; j++ ) {                                          
;----------------------------------------------------------------------
        RSBX      OVM
        NOP
        SUB       #1,A,A
        STM       #9,AR4
        STLM      A,AR0
        LD        *SP(5),B
        MVDK      *SP(3),*(AR3)
        MVDK      *SP(4),*(AR2)
        SUB       #1,B,B
        MVDK      *SP(2),*(AR1)
        STLM      B,AR5
L11:    
;**	-----------------------g2:
;** 134	-----------------------    L_acc = _lsmpy(*(++U$9), *(++U$7));
;**  	-----------------------    #pragma MUST_ITERATE(4, 4, 4)
;**  	-----------------------    #pragma LOOP_FLAGS(4096u)
;**	-----------------------g4:
;**  	-----------------------    L$2 = 3;
;**	-----------------------g7:
	.line	13
;----------------------------------------------------------------------
; 134 | L_acc = L_mult( lsp_ele[j], fg_sum[j] );                               
; 135 | for ( k = 0 ; k < MA_NP ; k++ )                                        
;----------------------------------------------------------------------
        SSBX      FRCT
        SSBX      OVM
        LD        *+AR5(1),T
        STM       #3,BRC
        MPY       *+AR0(1),A            ; |134|
        ORM       #2,*(PMST);;wly 
        SSBX 	SXM;;WLY
        RPTB      L13-1
        ; loop starts
L12:    
;** 136	-----------------------    L_acc = _smac(L_acc, *U$19, *U$17);
;** 136	-----------------------    U$17 += 10;
;** 136	-----------------------    U$19 += 10;
;** 136	-----------------------    if ( --L$2 != -1 ) goto g7;
	.line	15
;----------------------------------------------------------------------
; 136 | L_acc = L_mac( L_acc, freq_prev[k][j], fg[k][j] );                     
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;SSBX      SXM
        ;;SFTA      A,8                   ; |136| 
        ;;SFTA      A,-8                  ; |136| 
        ;;ORM       #2,*(PMST)
        ;;SSBX      OVM
        ;;ORM       #2,*(PMST)
        NOP
        MAC       *AR3, *AR2, A, A      ; |136| 
        MAR       *+AR2(#10)
        MAR       *+AR3(#10)
        ; loop ends ; |136| 
L13:    
;**  	-----------------------    U$19 -= 39;
;**  	-----------------------    U$17 -= 39;
;** 138	-----------------------    *U$30++ = L_acc>>16;
;** 139	-----------------------    if ( (--L$1) != (-1) ) goto g2;
;**  	-----------------------    return;
        MAR       *+AR3(#-39)
        MAR       *+AR2(#-39)
	.line	17
;----------------------------------------------------------------------
; 138 | lsp[j] = extract_h(L_acc);                                             
;----------------------------------------------------------------------
        SFTL      A,#-16,A              ; |138| 
        STL       A,*AR1+               ; |138| 
	.line	18
;----------------------------------------------------------------------
; 140 | return;                                                                
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;NOP
        NOP
        MAR       *AR4-
        BANZ      L11,*AR4(1)           ; |139| 
        ; branch occurs ; |139| 
	.line	20
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	141,000000400h,1



	.sect	".text"
	.global	_Lsp_expand_1_2

;----------------------------------------------------------------------
;  93 | void Lsp_expand_1_2(                                                   
;  94 | Word16 buf[],       /* (i/o) Q13 : LSP vectors */                      
;  95 | Word16 gap          /* (i)   Q13 : gap         */                      
;  96 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_expand_1_2                               *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_expand_1_2:
	.line	5
;* A     assigned to _buf
	.sym	_buf,0, 19, 17, 16
	.sym	_gap,6, 3, 9, 16
;* AR1   assigned to U$4
	.sym	U$4,10, 19, 4, 16
;* AR6   assigned to L$1
	.sym	L$1,15, 4, 4, 16
;* A     assigned to _tmp
	.sym	_tmp,0, 3, 4, 16
;* AR7   assigned to _gap
	.sym	_gap,16, 3, 4, 16
;* A     assigned to _buf
	.sym	_buf,0, 19, 4, 16
;**  	-----------------------    #pragma MUST_ITERATE(9, 9, 9)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$4 = buf;
;**  	-----------------------    L$1 = 9;
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-2
;----------------------------------------------------------------------
;  98 | Word16 j, tmp;                                                         
;  99 | Word16 diff;        /* Q13 */                                          
; 101 | for ( j = 1 ; j < M ; j++ ) {                                          
; 102 |   diff = sub( buf[j-1], buf[j] );                                      
;----------------------------------------------------------------------
        STLM      A,AR1
        NOP
        STM       #9,AR6
        MVDK      *SP(6),*(AR7)
L14:    
;**	-----------------------g2:
;** 103	-----------------------    if ( (tmp = crshft(_sadd(_ssub(*U$4, U$4[1]), gap), 1)) <= 0 ) goto g4;
	.line	11
;----------------------------------------------------------------------
; 103 | tmp = shr( add( diff, gap), 1 );                                       
; 105 | if ( tmp > 0 ) {                                                       
;----------------------------------------------------------------------
        RSBX      OVM
        SSBX      SXM
        ;;ST        #1,*SP(0)             ; |103| 
        RSBX      FRCT
        LD        *AR1,16,A             ; |103| 
        SSBX      OVM
        SUB       *AR1(1),16,A,A        ; |103| 
        ADD       *(AR7),16,A,A         ; |103| 
        ;;RSBX      OVM
        NOP
        ;;CALLD     #_crshft              ; |103| 
        SFTA      A,-1;;WLY
        NOP
        SFTA      A,-16,A               ; |103| 
        ; call occurs [#_crshft] ; |103| 
        ;;SSBX      SXM
        LD        *(AL),A               ; |103| 
        BC        L15,ALEQ              ; |103| 
        ; branch occurs ; |103| 
;** 106	-----------------------    *U$4 = _ssub(*U$4, tmp);
;** 107	-----------------------    U$4[1] = _sadd(U$4[1], tmp);
	.line	14
;----------------------------------------------------------------------
; 106 | buf[j-1] = sub( buf[j-1], tmp );                                       
;----------------------------------------------------------------------
        ;;RSBX      OVM
        NOP
        LD        *AR1,16,B             ; |106| 
        ;;SSBX      OVM
        SUB       *(AL),16,B,B          ; |106| 
        STH       B,*AR1                ; |106| 
	.line	15
;----------------------------------------------------------------------
; 107 | buf[j]   = add( buf[j], tmp );                                         
;----------------------------------------------------------------------
        ;;RSBX      OVM
        LD        *AR1(1),16,B          ; |107| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |107| 
        STH       A,*AR1(1)             ; |107| 
L15:    
;**	-----------------------g4:
;** 109	-----------------------    ++U$4;
;** 109	-----------------------    if ( --L$1 ) goto g2;
;**  	-----------------------    return;
	.line	17
;----------------------------------------------------------------------
; 110 | return;                                                                
;----------------------------------------------------------------------
        BANZD     L14,*+AR6(-1)         ; |109| 
        NOP
        MAR       *AR1+
        ; branch occurs ; |109| 
	.line	19
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #2
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	111,000018400h,5



	.sect	".text"
	.global	_Lsp_get_quant

;----------------------------------------------------------------------
;  16 | void Lsp_get_quant(                                                    
;  17 | Word16 lspcb1[][M],      /* (i) Q13 : first stage LSP codebook      */ 
;  18 | Word16 lspcb2[][M],      /* (i) Q13 : Second stage LSP codebook     */ 
;  19 | Word16 code0,            /* (i)     : selected code of first stage  */ 
;  20 | Word16 code1,            /* (i)     : selected code of second stage */ 
;  21 | Word16 code2,            /* (i)     : selected code of second stage */ 
;  22 | Word16 fg[][M],          /* (i) Q15 : MA prediction coef.           */ 
;  23 | Word16 freq_prev[][M],   /* (i) Q13 : previous LSP vector           */ 
;  24 | Word16 lspq[],           /* (o) Q13 : quantized LSP parameters      */ 
;  25 | Word16 fg_sum[]          /* (i) Q15 : present MA prediction coef.   */ 
;  26 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_get_quant                                *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_get_quant:
	.line	12
;* A     assigned to _lspcb1
	.sym	_lspcb1,0, 211, 17, 16,, 10
	.sym	_lspcb2,20, 211, 9, 16,, 10
	.sym	_code0,21, 3, 9, 16
	.sym	_code1,22, 3, 9, 16
	.sym	_code2,23, 3, 9, 16
	.sym	_fg,24, 211, 9, 16,, 10
	.sym	_freq_prev,25, 211, 9, 16,, 10
	.sym	_lspq,26, 19, 9, 16
	.sym	_fg_sum,27, 19, 9, 16
;
; BRC	assigned to temp var  L$1
; BRC	assigned to temp var  L$2
;
;* BRC   assigned to L$1
	.sym	L$1,25, 4, 4, 16
;* BRC   assigned to L$2
	.sym	L$2,25, 4, 4, 16
;* A     assigned to L$2
	.sym	L$2,0, 4, 4, 16
;* A     assigned to L$1
	.sym	L$1,0, 4, 4, 16
;* AR2   assigned to U$23
	.sym	U$23,11, 20, 4, 16
;* AR4   assigned to U$23
	.sym	U$23,13, 20, 4, 16
;* AR3   assigned to U$18
	.sym	U$18,12, 20, 4, 16
;* AR5   assigned to U$18
	.sym	U$18,14, 20, 4, 16
;* AR3   assigned to _lspcb1
	.sym	_lspcb1,12, 211, 4, 16,, 10
;* BK    assigned to _lspcb2
	.sym	_lspcb2,19, 211, 4, 16,, 10
;* A     assigned to _code0
	.sym	_code0,0, 3, 4, 16
;* AR2   assigned to _code1
	.sym	_code1,11, 3, 4, 16
;* AR0   assigned to _code2
	.sym	_code2,9, 3, 4, 16
;* AR7   assigned to _fg
	.sym	_fg,16, 211, 4, 16,, 10
;* AR1   assigned to _freq_prev
	.sym	_freq_prev,10, 211, 4, 16,, 10
;* AR6   assigned to _lspq
	.sym	_lspq,15, 19, 4, 16
	.sym	_fg_sum,14, 19, 1, 16
;* B     assigned to K$16
	.sym	K$16,6, 4, 4, 16
;* AR4   assigned to U$32
	.sym	U$32,13, 20, 4, 16
;* AR2   assigned to U$14
	.sym	U$14,11, 20, 4, 16
	.sym	_buf,4, 51, 1, 160,, 10
;**  	-----------------------    #pragma MUST_ITERATE(5, 5, 5)
;**  	-----------------------    #pragma LOOP_FLAGS(4096u)
;**  	-----------------------    U$14 = &lspcb2[10*code1];
;**  	-----------------------    K$16 = code0*10;
;**  	-----------------------    U$18 = &lspcb1[K$16];
;**  	-----------------------    U$23 = &buf[0];
;**	-----------------------g2:
;**  	-----------------------    L$1 = 4;
;**	-----------------------g8:
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-16
;----------------------------------------------------------------------
;  28 | Word16 j;                                                              
;  29 | Word16 buf[M];           /* Q13 */                                     
;  32 | for ( j = 0 ; j < NC ; j++ )                                           
;----------------------------------------------------------------------
        SSBX      SXM;;
        SSBX      OVM;;
        STLM      A,AR3
        STM       #10,T
        MVDK      *SP(20),*(BK)
        LD        *SP(27),A
        MVDK      *SP(22),*(AR2)
        MVDK      *SP(23),*(AR0)
        MVDK      *SP(25),*(AR1)
        LDM       BK,B
        MVDK      *SP(26),*(AR6)
        STL       A,*SP(14)
        MVDK      *SP(24),*(AR7)
        LD        *SP(21),A
        ANDM      #65533,*(PMST)
        RSBX      FRCT
        ;;RSBX      OVM
        ANDM      #65533,*(PMST)
        MVMM      SP,AR4
        MAC       *(AR2), B
        STM       #4,BRC
        STLM      A,T
        STLM      B,AR2
        MAR       *+AR4(#4)
        MPY       #10,B
        ADD       *(AR3),B,A
        STLM      A,AR5

        RPTB      L17-1
        ; loop starts
L16:    
;** 33	-----------------------    *U$23++ = _sadd(*U$18++, *U$14++);
;** 33	-----------------------    if ( --L$1 != -1 ) goto g8;
	.line	18
;----------------------------------------------------------------------
;  33 | buf[j] = add( lspcb1[code0][j], lspcb2[code1][j] );                    
;  35 | for ( j = NC ; j < M ; j++ )                                           
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;SSBX      SXM
        ;;NOP
        LD        *AR5+,16,A            ; |33| 
        ;;SSBX      OVM
        NOP
        ADD       *AR2+,16,A,A          ; |33| 
        STH       A,*AR4+               ; |33| 
        ; loop ends ; |33| 
L17:    
;**  	-----------------------    #pragma MUST_ITERATE(5, 5, 5)
;**  	-----------------------    #pragma LOOP_FLAGS(4096u)
;**  	-----------------------    U$18 = &lspcb1[K$16+5];
;**  	-----------------------    U$23 = &buf[5];
;**  	-----------------------    U$32 = &lspcb2[10*code2+5];
;**	-----------------------g5:
;**  	-----------------------    L$2 = 4;
;**	-----------------------g7:
        ;;RSBX      OVM
        LDM       AR3,A
        MVMM      SP,AR2
        STM       #10,T
        ADD       B,A
        STM       #4,BRC
        ADD       #5,A,A
        STLM      A,AR3
        MAR       *+AR2(#9)
        LDM       BK,A
        MAC       *(AR0), A
        ADD       #5,A,A
        STLM      A,AR4
        RPTB      L19-1
        ; loop starts
L18:    
;** 36	-----------------------    *U$23++ = _sadd(*U$18++, *U$32++);
;** 36	-----------------------    if ( --L$2 != -1 ) goto g7;
	.line	21
;----------------------------------------------------------------------
;  36 | buf[j] = add( lspcb1[code0][j], lspcb2[code2][j] );                    
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;SSBX      SXM
        ;;NOP
        LD        *AR3+,16,A            ; |36| 
        ;;SSBX      OVM
        NOP
        ADD       *AR4+,16,A,A          ; |36| 
        STH       A,*AR2+               ; |36| 
        ; loop ends ; |36| 
L19:    
;** 38	-----------------------    Lsp_expand_1_2(&buf, 10);
;** 39	-----------------------    Lsp_expand_1_2(&buf, 5);
;** 41	-----------------------    Lsp_prev_compose(&buf, lspq, fg, freq_prev, fg_sum);
;** 43	-----------------------    Lsp_prev_update(&buf, freq_prev);
;** 45	-----------------------    Lsp_stability(lspq);
;** 47	-----------------------    return;
	.line	23
;----------------------------------------------------------------------
;  38 | Lsp_expand_1_2(buf, GAP1);                                             
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ST        #10,*SP(0)            ; |38| 
        LDM       SP,A
        CALLD     #_Lsp_expand_1_2      ; |38| 
        ADD       #4,A
        ; call occurs [#_Lsp_expand_1_2] ; |38| 
	.line	24
;----------------------------------------------------------------------
;  39 | Lsp_expand_1_2(buf, GAP2);                                             
;----------------------------------------------------------------------
        ;;RSBX      FRCT
        ST        #5,*SP(0)             ; |39| 
        ;;RSBX      OVM
        LDM       SP,A
        CALLD     #_Lsp_expand_1_2      ; |39| 
        ADD       #4,A
        ; call occurs [#_Lsp_expand_1_2] ; |39| 
	.line	26
;----------------------------------------------------------------------
;  41 | Lsp_prev_compose(buf, lspq, fg, freq_prev, fg_sum);                    
;----------------------------------------------------------------------
        MVKD      *(AR6),*SP(0)
        MVKD      *(AR7),*SP(1)
        RSBX      FRCT
        MVKD      *(AR1),*SP(2)
        LD        *SP(14),A
        STL       A,*SP(3)
        ;;RSBX      OVM
        LDM       SP,A
        CALLD     #_Lsp_prev_compose    ; |41| 
        ADD       #4,A
        ; call occurs [#_Lsp_prev_compose] ; |41| 
	.line	28
;----------------------------------------------------------------------
;  43 | Lsp_prev_update(buf, freq_prev);                                       
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;RSBX      FRCT
        MVKD      *(AR1),*SP(0)
        LDM       SP,A
        CALLD     #_Lsp_prev_update     ; |43| 
        ADD       #4,A
        ; call occurs [#_Lsp_prev_update] ; |43| 
	.line	30
;----------------------------------------------------------------------
;  45 | Lsp_stability( lspq );                                                 
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;RSBX      FRCT
        ;;NOP
        CALLD     #_Lsp_stability       ; |45| 
        NOP
        LDM       AR6,A
        ; call occurs [#_Lsp_stability] ; |45| 
	.line	32
;----------------------------------------------------------------------
;  47 | return;                                                                
;----------------------------------------------------------------------
	.line	33
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #16
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	48,000018400h,19




	.sect	".text"
	.global	_Lsp_expand_2

;----------------------------------------------------------------------
;  72 | void Lsp_expand_2(                                                     
;  73 | Word16 buf[],       /* (i/o) Q13 : LSP vectors */                      
;  74 | Word16 gap          /* (i)   Q13 : gap         */                      
;  75 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_expand_2                                 *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_expand_2:
	.line	5
;* A     assigned to _buf
	.sym	_buf,0, 19, 17, 16
	.sym	_gap,6, 3, 9, 16
;* AR1   assigned to U$5
	.sym	U$5,10, 19, 4, 16
;* AR6   assigned to L$1
	.sym	L$1,15, 4, 4, 16
;* A     assigned to _tmp
	.sym	_tmp,0, 3, 4, 16
;* AR7   assigned to _gap
	.sym	_gap,16, 3, 4, 16
;* A     assigned to _buf
	.sym	_buf,0, 19, 4, 16
;**  	-----------------------    #pragma MUST_ITERATE(5, 5, 5)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$5 = &buf[4];
;**  	-----------------------    L$1 = 5;
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-2
;----------------------------------------------------------------------
;  77 | Word16 j, tmp;                                                         
;  78 | Word16 diff;        /* Q13 */                                          
;  80 | for ( j = NC ; j < M ; j++ ) {                                         
;  81 |   diff = sub( buf[j-1], buf[j] );                                      
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;NOP
        ADD       #4,A,A
        STLM      A,AR1
        ;;NOP
        STM       #5,AR6
        MVDK      *SP(6),*(AR7)
L20:    
;**	-----------------------g2:
;** 82	-----------------------    if ( (tmp = crshft(_sadd(_ssub(*U$5, U$5[1]), gap), 1)) <= 0 ) goto g4;
	.line	11
;----------------------------------------------------------------------
;  82 | tmp = shr( add( diff, gap), 1 );                                       
;  84 | if ( tmp > 0 ) {                                                       
;----------------------------------------------------------------------
        ;;RSBX      OVM
        SSBX      SXM
        ;;ST        #1,*SP(0)             ; |82| 
        ;;RSBX      FRCT
        LD        *AR1,16,A             ; |82| 
        SSBX      OVM
        SUB       *AR1(1),16,A,A        ; |82| 
        ADD       *(AR7),16,A,A         ; |82| 
        ;;RSBX      OVM
        ;;NOP
        ;;CALLD     #_crshft              ; |82| 
        SFTA	A,-1;;
        NOP
        SFTA      A,-16,A               ; |82| 
        ; call occurs [#_crshft] ; |82| 
        ;;SSBX      SXM
        LD        *(AL),A               ; |82| 
        BC        L21,ALEQ              ; |82| 
        ; branch occurs ; |82| 
;** 85	-----------------------    *U$5 = _ssub(*U$5, tmp);
;** 86	-----------------------    U$5[1] = _sadd(U$5[1], tmp);
	.line	14
;----------------------------------------------------------------------
;  85 | buf[j-1] = sub( buf[j-1], tmp );                                       
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;NOP
        LD        *AR1,16,B             ; |85| 
        ;;SSBX      OVM
        SUB       *(AL),16,B,B          ; |85| 
        STH       B,*AR1                ; |85| 
	.line	15
;----------------------------------------------------------------------
;  86 | buf[j]   = add( buf[j], tmp );                                         
;----------------------------------------------------------------------
        ;;RSBX      OVM
        LD        *AR1(1),16,B          ; |86| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |86| 
        STH       A,*AR1(1)             ; |86| 
L21:    
;**	-----------------------g4:
;** 88	-----------------------    ++U$5;
;** 88	-----------------------    if ( --L$1 ) goto g2;
;**  	-----------------------    return;
	.line	17
;----------------------------------------------------------------------
;  89 | return;                                                                
;----------------------------------------------------------------------
        BANZD     L20,*+AR6(-1)         ; |88| 
        ;;NOP
        MAR       *AR1+
        ; branch occurs ; |88| 
	.line	19
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #2
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
;;endfunc	90,000018400h,5



	.sect	".text"
	.global	_Lsp_expand_1

;----------------------------------------------------------------------
;  51 | void Lsp_expand_1(                                                     
;  52 | Word16 buf[],        /* (i/o) Q13 : LSP vectors */                     
;  53 | Word16 gap           /* (i)   Q13 : gap         */                     
;  54 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Lsp_expand_1                                 *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Lsp_expand_1:
	.line	5
;* A     assigned to _buf
	.sym	_buf,0, 19, 17, 16
	.sym	_gap,6, 3, 9, 16
;* AR1   assigned to U$4
	.sym	U$4,10, 19, 4, 16
;* AR6   assigned to L$1
	.sym	L$1,15, 4, 4, 16
;* A     assigned to _tmp
	.sym	_tmp,0, 3, 4, 16
;* AR7   assigned to _gap
	.sym	_gap,16, 3, 4, 16
;* A     assigned to _buf
	.sym	_buf,0, 19, 4, 16
;**  	-----------------------    #pragma MUST_ITERATE(4, 4, 4)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$4 = buf;
;**  	-----------------------    L$1 = 4;
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-2
;----------------------------------------------------------------------
;  56 | Word16 j, tmp;                                                         
;  57 | Word16 diff;        /* Q13 */                                          
;  59 | for ( j = 1 ; j < NC ; j++ ) {                                         
;  60 |   diff = sub( buf[j-1], buf[j] );                                      
;----------------------------------------------------------------------
        STLM      A,AR1
        ;;NOP
        STM       #4,AR6
        MVDK      *SP(6),*(AR7)
L22:    
;**	-----------------------g2:
;** 61	-----------------------    if ( (tmp = crshft(_sadd(_ssub(*U$4, U$4[1]), gap), 1)) <= 0 ) goto g4;
	.line	11
;----------------------------------------------------------------------
;  61 | tmp = shr( add( diff, gap), 1 );                                       
;  63 | if ( tmp >  0 ) {                                                      
;----------------------------------------------------------------------
        ;;RSBX      OVM
        SSBX      SXM
        ;;ST        #1,*SP(0)             ; |61| 
        RSBX      FRCT
        LD        *AR1,16,A             ; |61| 
        SSBX      OVM
        SUB       *AR1(1),16,A,A        ; |61| 
        ADD       *(AR7),16,A,A         ; |61| 
        ;;RSBX      OVM
        ;;NOP
        ;;CALLD     #_crshft              ; |61| 
        SFTA	A,-1;;WLY
        NOP
        SFTA      A,-16,A               ; |61| 
        ; call occurs [#_crshft] ; |61| 
        ;;SSBX      SXM
        LD        *(AL),A               ; |61| 
        BC        L23,ALEQ              ; |61| 
        ; branch occurs ; |61| 
;** 64	-----------------------    *U$4 = _ssub(*U$4, tmp);
;** 65	-----------------------    U$4[1] = _sadd(U$4[1], tmp);
	.line	14
;----------------------------------------------------------------------
;  64 | buf[j-1] = sub( buf[j-1], tmp );                                       
;----------------------------------------------------------------------
        ;;RSBX      OVM
        ;;NOP
        LD        *AR1,16,B             ; |64| 
        ;;SSBX      OVM
        SUB       *(AL),16,B,B          ; |64| 
        STH       B,*AR1                ; |64| 
	.line	15
;----------------------------------------------------------------------
;  65 | buf[j]   = add( buf[j], tmp );                                         
;----------------------------------------------------------------------
        ;;RSBX      OVM
        LD        *AR1(1),16,B          ; |65| 
        ;;SSBX      OVM
        ADD       *(AL),16,B,A          ; |65| 
        STH       A,*AR1(1)             ; |65| 
L23:    
;**	-----------------------g4:
;** 67	-----------------------    ++U$4;
;** 67	-----------------------    if ( --L$1 ) goto g2;
;**  	-----------------------    return;
	.line	17
;----------------------------------------------------------------------
;  68 | return;                                                                
;----------------------------------------------------------------------
        BANZD     L22,*+AR6(-1)         ; |67| 
       ;; NOP
        MAR       *AR1+
        ; branch occurs ; |67| 
	.line	19
        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #2
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET
        ; return occurs
;;	.endfunc	69,000018400h,5


;***************************************************************
;* STRINGS                                                     *
;***************************************************************
	.sect	".const"
SL1:	.string	"lsp_stability warning Low ",10,0
SL2:	.string	"lsp_stability warning High ",10,0
;***************************************************************
;* UNDEFINED EXTERNAL REFERENCES                               *
;***************************************************************
	.global	_printf
	.global	_L_shl
	.global	_Copy	
	.global	_Lsp_stability
	.global	_Lsp_prev_compose
	.global	_Lsp_expand_1_2	
	.global	_Lsp_prev_update	