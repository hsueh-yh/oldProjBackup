;***************************************************************
;* TMS320C54x C/C++ Codegen                  PC Version 3.831  *
;* Date/Time created: Wed May 11 09:36:47 2005                 *
;***************************************************************
	.mmregs
FP	.set	AR7
	.c_mode
	.file	"QUA_GAIN.C"

	.sect	".cinit"
	.align	1
	.field  	IR_1,16
	.field  	_past_qua_en$1+0,16
	.field  	-14336,16			; _past_qua_en$1[0] @ 0
	.field  	-14336,16			; _past_qua_en$1[1] @ 16
	.field  	-14336,16			; _past_qua_en$1[2] @ 32
	.field  	-14336,16			; _past_qua_en$1[3] @ 48
IR_1:	.set	4

	.sect	".text"
	.bss	_past_qua_en$1,4,0,0
	.sym	_past_qua_en,_past_qua_en$1, 51, 3, 64,, 4
;	c:\ti\c5400\cgtools\bin\opt500.exe -i20 -q -s -O3 D:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\TI3928_2 D:\DOCUME~1\ADMINI~1\LOCALS~1\Temp\TI3928_5 -w F:/ATA/Code/g729a_v1.4/G729A/Debug 

	.sect	".text"
	.sym	_Gbk_presel,_Gbk_presel, 32, 3, 0
	.func	345
;----------------------------------------------------------------------
; 345 | static void Gbk_presel(                                                
; 346 | Word16 best_gain[],     /* (i) [0] Q9 : unquantized pitch gain     */  
; 348 | Word16 *cand1,          /* (o)    : index of best 1st stage vector */  
; 349 | Word16 *cand2,          /* (o)    : index of best 2nd stage vector */  
; 350 | Word16 gcode0           /* (i) Q4 : presearch for gain codebook    */  
; 351 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Gbk_presel                                   *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Gbk_presel:

        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-12
        NOP

        MVDK      *SP(18),*(AR1)          ; ar1 = gcode0
        MVDK      *SP(17),*(AR6)          ; ar6 = *cand2
        MVDK      *SP(16),*(AR7)          ; ar7 = *cand1
        STL       A,*SP(2)                ; sp(2) = best_gain[]

;----------------------------------------------------------------------
; 361 | L_cfbg = L_mult( coef[0][0], best_gain[0] );        /* L_cfbg:Q20 -> !!
;     | y */                                                                   
;----------------------------------------------------------------------
        SSBX      SXM
        SSBX      FRCT
        LD        #_coef,A
        STLM      A,AR2                ; ar2 = coef
        SSBX      OVM
        MVDK      *SP(2),*(AR3)        ; ar3 = best_gain[]
        STL       A,*SP(3)
        MPY       *AR2,*AR3,A          
        DST       A,*SP(4)             ; sp(4) = L_cfbg

;----------------------------------------------------------------------
; 362 | L_acc = L_shr( L_coef[1][1], 15 );                  /* L_acc:Q20     */
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;RSBX      FRCT
        LD        #_L_coef,A
        STL       A,*SP(6)
        STLM      A,AR2
        ;ST        #15,*SP(0)            
        DLD       *AR2(6),A             
        ;CALL      #_L_shr   
        SFTA      A,-15            

;----------------------------------------------------------------------
; 363 | L_acc = L_add( L_cfbg , L_acc );                                       
; 364 | acc_h = extract_h( L_acc );                         /* acc_h:Q4      */
; 365 | L_preg = L_mult( acc_h, gcode0 );                   /* L_preg:Q9     */
;----------------------------------------------------------------------
        ;SSBX      SXM
        ;NOP
        DLD       *SP(4),B
        ;RSBX      SXM
        ;SSBX      OVM
        ;NOP
        ADD       A,B           
        DST       B,*SP(8)              ; SP(8) = L_acc 

;----------------------------------------------------------------------
; 366 | L_acc = L_shl( L_deposit_l( best_gain[1] ), 7 );    /* L_acc:Q9      */
;----------------------------------------------------------------------
        ;ST        #7,*SP(0)            
        ;RSBX      OVM
        MVDK      *SP(2),*(AR2)
        ;SSBX      SXM
        ;RSBX      FRCT
        LD        *AR2(1),A             
        ;CALL      #_L_shl 
        SFTA      A,7              

;----------------------------------------------------------------------
; 367 | L_acc = L_sub( L_acc, L_preg );                                        
;----------------------------------------------------------------------
        ;RSBX      SXM
        ;NOP
        DLD       *SP(8),B
        ;SSBX      FRCT
        ;SSBX      OVM
        SFTL      B,#-16,B              
        MVMD      AR1,T
        MPY       *(BL),B               ; L_preg = L_mult( acc_h, gcode0 )
        ;RSBX      FRCT
        ;RSBX      OVM
        ;DST       B,*SP(0)             
        ;CALL      #_L_sub               
        SUB        B,A                   ; a = L_acc = L_sub( L_acc, L_preg )
;----------------------------------------------------------------------
; 368 | acc_h = extract_h( L_shl( L_acc,2 ) );              /* L_acc_h:Q[-5] */
;----------------------------------------------------------------------
        ;RSBX      FRCT
        ;RSBX      OVM
        ;ST        #2,*SP(0)             
        ;CALL      #_L_shl  
        SFTA       A,2             
        SFTL      A,#-16,A              

;----------------------------------------------------------------------
; 369 | L_tmp_x = L_mult( acc_h, INV_COEF );                /* L_tmp_x:Q15   */
;----------------------------------------------------------------------
        ;SSBX      FRCT
        ;SSBX      OVM
        MPY       *(AL),#-17103,A        
        DST       A,*SP(10)             ; sp(10) = L_tmp_X

;----------------------------------------------------------------------
; 375 | L_acc = L_shr( L_coef[0][1], 10 );                  /* L_acc:Q20   */  
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;RSBX      FRCT
        ;ST        #10,*SP(0)            
        MVDK      *SP(6),*(AR2)
        DLD       *AR2(2),A              
        ;CALL      #_L_shr              
        SFTA      A,-10                 ; a = L_acc

        LD        A,B                   
;----------------------------------------------------------------------
; 376 | L_acc = L_sub( L_cfbg, L_acc );                     /* !!x -> L_cfbg:Q2
;     | 0 */                                                                   
; 377 | acc_h = extract_h( L_acc );                         /* acc_h:Q4    */  
; 378 | acc_h = mult( acc_h, gcode0 );                      /* acc_h:Q[-7] */  
;----------------------------------------------------------------------
        ;DST       B,*SP(0)                 
        ;RSBX      OVM                   
        ;RSBX      FRCT
        DLD       *SP(4),A              
        ;CALL      #_L_sub      
        SUB       B,A         
        NOP
        LD        A,B                   
;----------------------------------------------------------------------
; 379 | L_tmp = L_mult( acc_h, coef[1][0] );                /* L_tmp:Q10   */  
; 381 | L_preg = L_mult( coef[0][0], best_gain[1] );        /* L_preg:Q13  */  
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;SSBX      SXM
        LD        *(AR1),16,A           
        DST       A,*SP(8)               
        LD        B,A                   
        SFTL      A,#-16,B               
        DLD       *SP(8),A              
        ;SSBX      OVM
        ;SSBX      FRCT
        STLM      B,T
        NOP
        MPYA      A                      
        MVDK      *SP(3),*(AR2)
        LD        *AR2(2),T
        SFTA      A,-16,A               
        MPY       *(AL),A                
        DST       A,*SP(8)              
;----------------------------------------------------------------------
; 382 | L_acc = L_sub( L_tmp, L_shr(L_preg,3) );            /* L_acc:Q10   */  
;----------------------------------------------------------------------
        ;ST        #3,*SP(0)             
        MVDK      *SP(2),*(AR2)
        LD        *AR2(1),T
        MPY       *(_coef),A            
        ;RSBX      OVM
        ;RSBX      FRCT
        ;NOP
        ;CALL      #_L_shr               
        SFTA      A,-3
        
        ;RSBX      OVM
        ;RSBX      FRCT
        ;DST       A,*SP(0)              ; |382| 
        LD        A,B
        DLD       *SP(8),A              ; |382| 
        ;CALL      #_L_sub               ; |382| 
        SUB       B,A
        NOP
;----------------------------------------------------------------------
; 384 | acc_h = extract_h( L_shl( L_acc,2 ) );              /* acc_h:Q[-4] */  
;----------------------------------------------------------------------
        ;RSBX      OVM
        ;RSBX      FRCT
        ;ST        #2,*SP(0)              
        ;CALL      #_L_shl                
        SFTA      A,2        
        SFTL      A,#-16,A              
;----------------------------------------------------------------------
; 385 | L_tmp_y = L_mult( acc_h, INV_COEF );                /* L_tmp_y:Q16 */  
; 387 | sft_y = (14+4+1)-16;         /* (Q[thr1]+Q[gcode0]+1)-Q[L_tmp_y] */    
; 388 | sft_x = (15+4+1)-15;         /* (Q[thr2]+Q[gcode0]+1)-Q[L_tmp_x] */    
;----------------------------------------------------------------------
        ;SSBX      FRCT
        ;SSBX      OVM
        MPY       *(AL),#-17103,A       
        DST       A,*SP(8)              

        ;SSBX      SXM
        LD        *(AR1),A              
        BC        L4,AGT                

;----------------------------------------------------------------------
; 412 | *cand1 = 0 ;                                                           
; 413 | do{                                                                    
;----------------------------------------------------------------------
        LD        #_thr1,A
        ST        #0,*AR7               
        STM       #0,AR2
        STL       A,*SP(2)
L1:    
;----------------------------------------------------------------------
; 414 | L_temp = L_sub(L_tmp_y ,L_shr(L_mult(thr1[*cand1],gcode0),sft_y));     
; 415 |  if( L_temp <0L){                                                      
;----------------------------------------------------------------------
        ;ST        #3,*SP(0)            
        ;RSBX      OVM
        LDM       AR2,A
        LD        *SP(2),B
        ;SSBX      FRCT
        ADD       A,B                    
        ;SSBX      OVM
        STLM      B,AR2
        MVMD      AR1,T
        MPY       *AR2,A                
        ;RSBX      FRCT
        ;RSBX      OVM
        ;NOP
        ;CALL      #_L_shr               
        SFTA      A,-3              ; ****
        
        ;RSBX      OVM
        ;RSBX      FRCT
        ;DST       A,*SP(0)
        LD        A,B               ; ****              
        DLD       *SP(8),A              
        ;CALL      #_L_sub
        SUB       B,A               

        ;RSBX      OVM
        ;SSBX      SXM
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        BC        L2,AGEQ               
;----------------------------------------------------------------------
; 416 | (*cand1) =add(*cand1,1);                                               
;----------------------------------------------------------------------
        LD        *AR7,16,A             
        ;SSBX      OVM
        ;NOP
        ADD       #1,16,A,A             
        SFTA      A,-16,A               
        STL       A,*AR7
;----------------------------------------------------------------------
; 418 | else               break ;                                             
; 419 | } while(sub((*cand1),(NCODE1-NCAN1))) ;                                
;----------------------------------------------------------------------
        STLM      A,AR2
        NOP
        NOP
        BANZ      L1,*AR2(-4)           
L2:    
;----------------------------------------------------------------------
; 421 | *cand2 = 0 ;                                                           
; 422 | do{                                                                    
;----------------------------------------------------------------------
        STM       #0,AR2
        STM       #_thr2,AR7
        ST        #0,*AR6               
L3:     
;----------------------------------------------------------------------
; 423 | L_temp =L_sub(L_tmp_x ,L_shr(L_mult(thr2[*cand2],gcode0),sft_x));      
; 424 | if( L_temp <0L){                                                       
;----------------------------------------------------------------------
        ;RSBX      OVM
        LDM       AR2,A
        LDM       AR7,B
        ;SSBX      FRCT
        MVMD      AR1,T
        ADD       A,B                   
        ;SSBX      OVM
        STLM      B,AR2
        ;ST        #5,*SP(0)             
        MPY       *AR2,A                 
        ;RSBX      FRCT
        ;RSBX      OVM
        NOP
        ;CALL      #_L_shr               
        SFTA      A,-5             ; ****
        
        ;RSBX      OVM
        ;RSBX      FRCT
        ;DST       A,*SP(0)              
        LD        A,B                   ; ****
        DLD       *SP(10),A           
        ;CALL      #_L_sub            
        SUB       B,A
        
        ;RSBX      OVM
        ;SSBX      SXM
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        BC        L8,AGEQ               
;----------------------------------------------------------------------
; 425 | (*cand2) =add(*cand2,1);                                               
;----------------------------------------------------------------------
        LD        *AR6,16,A             
        ;SSBX      OVM
        ;NOP
        ADD       #1,16,A,A             
        SFTA      A,-16,A               
        STL       A,*AR6

;----------------------------------------------------------------------
; 427 | else               break ;                                             
; 428 | } while(sub( (*cand2),(NCODE2-NCAN2))) ;                               
; 431 | return ;                                                               
;----------------------------------------------------------------------
        STLM      A,AR2
        NOP
        NOP
        BANZ      L3,*AR2(-8)            
        B         L8                     
L4:    
        LD        #_thr1,A
        ST        #0,*AR7               
        STL       A,*SP(2)
        LD        #0,A
L5:    
        ;ST        #3,*SP(0)             
        ;RSBX      OVM
        LD        *SP(2),B
        ;SSBX      FRCT
        ADD       A,B                   
        STLM      B,AR2
        ;SSBX      OVM
        MVMD      AR1,T
        MPY       *AR2,A                
        ;RSBX      FRCT
        ;RSBX      OVM
        NOP
        ;CALL      #_L_shr    
        SFTA      A,-3          

        ;RSBX      OVM
        ;RSBX      FRCT
        ;DST       A,*SP(0)              
        LD        A,B
        DLD       *SP(8),A              
        ;CALL      #_L_sub               
        SUB       B,A         
        
        ;RSBX      OVM
        ;SSBX      SXM
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        BC        L6,ALEQ               

        LD        *AR7,16,A             
        ;SSBX      OVM
        ;NOP
        ADD       #1,16,A,A            
        SFTA      A,-16,A               
        STL       A,*AR7

        ;RSBX      OVM
        LD        *(AL),B                
        SUB       #4,B,B                 
        BC        L5,BLT                
 
L6:    
        LD        #0,A
        STM       #_thr2,AR7
        ST        #0,*AR6               
L7:    

        LDM       AR7,B
        ;SSBX      FRCT
        ADD       A,B                  
        MVMD      AR1,T
        ;SSBX      OVM
        STLM      B,AR2
        ;ST        #5,*SP(0)    
        NOP   ; ****   
        NOP      
        MPY       *AR2,A                
        ;RSBX      FRCT
        ;RSBX      OVM
        ;NOP
        ;CALL      #_L_shr               
        SFTA     A,-5
        
        ;RSBX      OVM
        ;RSBX      FRCT
        ;DST       A,*SP(0)              ; |403| 
        LD        A,B
        DLD       *SP(10),A             ; |403| 
        ;CALL      #_L_sub               ; |403| 
        SUB       B,A              
  
        ;RSBX      OVM
        ;SSBX      SXM
        ;SFTA      A,8                   
        ;SFTA      A,-8                  
        BC        L8,ALEQ               

        LD        *AR6,16,A            
        ;SSBX      OVM
        ;NOP
        ADD       #1,16,A,A             ; |405| 
        SFTA      A,-16,A               ; |405| 
        STL       A,*AR6

        ;RSBX      OVM
        LD        *(AL),B               
        SUB       #8,B,B                
        BC        L7,BLT                
L8:    

        ANDM      #-833,*(ST1)
        ANDM      #-4,*(PMST)
        FRAME     #12
        POPM      AR7
        POPM      AR6
        POPM      AR1
        RET



	.sect	".text"
	.global	_Qua_gain
	.sym	_Qua_gain,_Qua_gain, 35, 2, 0
	.func	42
;----------------------------------------------------------------------
;  42 | Word16 Qua_gain(                                                       
;  43 | Word16 code[],       /* (i) Q13 :Innovative vector.             */     
;  44 | Word16 g_coeff[],    /* (i)     :Correlations <xn y1> -2<y1 y1> */     
;  46 | Word16 exp_coeff[],  /* (i)     :Q-Format g_coeff[]             */     
;  47 | Word16 L_subfr,      /* (i)     :Subframe length.               */     
;  48 | Word16 *gain_pit,    /* (o) Q14 :Pitch gain.                    */     
;  49 | Word16 *gain_cod,    /* (o) Q1  :Code gain.                     */     
;  50 | Word16 tameflag      /* (i)     : set to 1 if taming is needed  */     
;  51 | )                                                                      
;----------------------------------------------------------------------

;***************************************************************
;* FUNCTION DEF: _Qua_gain                                     *
;***************************************************************

;***************************************************************
;*                                                             *
;* Using -g (debug) with optimization (-o3) may disable key op *
;*                                                             *
;***************************************************************
_Qua_gain:
;* A     assigned to _code
	.sym	_code,0, 19, 17, 16
	.sym	_g_coeff,46, 19, 9, 16
	.sym	_exp_coeff,47, 19, 9, 16
	.sym	_L_subfr,48, 3, 9, 16
	.sym	_gain_pit,49, 19, 9, 16
	.sym	_gain_cod,50, 19, 9, 16
	.sym	_tameflag,51, 3, 9, 16
;
; BRC	assigned to temp var  L$1
;
;* BRC   assigned to L$1
	.sym	L$1,25, 4, 4, 16
;* A     assigned to L$1
	.sym	L$1,0, 4, 4, 16
	.sym	_i,30, 3, 1, 16
	.sym	_i,30, 3, 1, 16
;* AR6   assigned to _j
	.sym	_j,15, 3, 4, 16
;* AR1   assigned to _j
	.sym	_j,10, 3, 4, 16
	.sym	_exp,30, 3, 1, 16
	.sym	_exp,30, 3, 1, 16
	.sym	_exp,30, 3, 1, 16
;* A     assigned to _nume
	.sym	_nume,0, 3, 4, 16
;* A     assigned to _nume
	.sym	_nume,0, 3, 4, 16
	.sym	_exp1,30, 3, 1, 16
	.sym	_exp1,30, 3, 1, 16
	.sym	_exp1,30, 3, 1, 16
;* AR6   assigned to _exp2
	.sym	_exp2,15, 3, 4, 16
;* AR6   assigned to _exp2
	.sym	_exp2,15, 3, 4, 16
;* AR6   assigned to _exp2
	.sym	_exp2,15, 3, 4, 16
;* A     assigned to _tmp
	.sym	_tmp,0, 3, 4, 16
;* A     assigned to _tmp
	.sym	_tmp,0, 3, 4, 16
;* A     assigned to _tmp
	.sym	_tmp,0, 3, 4, 16
	.sym	_g_pitch,25, 3, 1, 16
	.sym	_g_pitch,25, 3, 1, 16
	.sym	_g_pit_cod,34, 3, 1, 16
	.sym	_g_pit_cod,34, 3, 1, 16
	.sym	_L_tmp,28, 5, 1, 32
	.sym	_L_tmp,28, 5, 1, 32
;* A     assigned to _L_tmp
	.sym	_L_tmp,0, 5, 4, 32
;* A     assigned to _L_tmp
	.sym	_L_tmp,0, 5, 4, 32
;* A     assigned to _L_tmp
	.sym	_L_tmp,0, 5, 4, 32
;* A     assigned to _L_tmp
	.sym	_L_tmp,0, 5, 4, 32
;* A     assigned to _L_temp
	.sym	_L_temp,0, 5, 4, 32
;* A     assigned to _L_temp
	.sym	_L_temp,0, 5, 4, 32
;* A     assigned to _L_tmp1
	.sym	_L_tmp1,0, 5, 4, 32
;* A     assigned to _L_tmp1
	.sym	_L_tmp1,0, 5, 4, 32
	.sym	_L_tmp1,28, 5, 1, 32
	.sym	_L_tmp2,28, 5, 1, 32
	.sym	_L_tmp2,28, 5, 1, 32
	.sym	_L_tmp2,32, 5, 1, 32
;* A     assigned to _L_acc
	.sym	_L_acc,0, 5, 4, 32
;* A     assigned to _L_acc
	.sym	_L_acc,0, 5, 4, 32
;* A     assigned to _L_acc
	.sym	_L_acc,0, 5, 4, 32
;* A     assigned to _L_acc
	.sym	_L_acc,0, 5, 4, 32
	.sym	U$164,35, 4, 1, 16
	.sym	U$164,35, 4, 1, 16
;* AR7   assigned to U$176
	.sym	U$176,16, 20, 4, 16
;* AR7   assigned to U$176
	.sym	U$176,16, 20, 4, 16
;* AR1   assigned to U$169
	.sym	U$169,10, 20, 4, 16
;* AR6   assigned to U$169
	.sym	U$169,15, 20, 4, 16
	.sym	U$139,30, 20, 1, 16
;* AR6   assigned to U$139
	.sym	U$139,15, 20, 4, 16
;* A     assigned to _code
	.sym	_code,0, 19, 4, 16
;* AR1   assigned to _g_coeff
	.sym	_g_coeff,10, 19, 4, 16
;* AR7   assigned to _exp_coeff
	.sym	_exp_coeff,16, 19, 4, 16
;* B     assigned to _L_subfr
	.sym	_L_subfr,6, 3, 4, 16
	.sym	_gain_pit,27, 19, 1, 16
	.sym	_gain_cod,26, 19, 1, 16
	.sym	_tameflag,25, 3, 1, 16
	.sym	_index1,37, 3, 1, 16
	.sym	_index2,38, 3, 1, 16
	.sym	_cand1,4, 3, 1, 16
	.sym	_cand2,5, 3, 1, 16
	.sym	_gcode0,6, 3, 1, 16
	.sym	_exp_gcode0,7, 3, 1, 16
;* A     assigned to _gcode0_org
	.sym	_gcode0_org,0, 3, 4, 16
;* AR7   assigned to _e_min
	.sym	_e_min,16, 3, 4, 16
;* A     assigned to _denom
	.sym	_denom,0, 3, 4, 16
	.sym	_inv_denom,34, 3, 1, 16
	.sym	_exp_inv_denom,35, 3, 1, 16
	.sym	_L_gbk12,28, 5, 1, 32
	.sym	_L_dist_min,32, 5, 1, 32
	.sym	L$2,34, 4, 1, 16
	.sym	K$12,36, 20, 1, 16
	.sym	K$175,39, 212, 1, 16,, 2
	.sym	K$168,40, 212, 1, 16,, 2
;* AR1   assigned to U$158
	.sym	U$158,10, 20, 4, 16
;* AR6   assigned to U$155
	.sym	U$155,15, 20, 4, 16
	.sym	U$148,35, 19, 1, 16
	.sym	U$113,30, 4, 1, 16
;* A     assigned to C$13
	.sym	C$13,0, 4, 4, 16
;* B     assigned to C$12
	.sym	C$12,6, 4, 4, 16
;* AR6   assigned to C$11
	.sym	C$11,15, 4, 4, 16
;* AR6   assigned to C$10
	.sym	C$10,15, 4, 4, 16
;* AR6   assigned to C$9
	.sym	C$9,15, 4, 4, 16
;* AR6   assigned to C$8
	.sym	C$8,15, 20, 4, 16
;* B     assigned to C$7
	.sym	C$7,6, 4, 4, 16
;* AR1   assigned to C$6
	.sym	C$6,10, 212, 4, 16,, 2
	.sym	C$5,41, 4, 1, 16
;* A     assigned to C$4
	.sym	C$4,0, 212, 4, 16,, 2
	.sym	C$3,41, 4, 1, 16
;* AR2   assigned to C$2
	.sym	C$2,11, 20, 4, 16
;* AR1   assigned to C$1
	.sym	C$1,10, 20, 4, 16
	.sym	_coeff,8, 51, 1, 80,, 5
	.sym	_coeff_lsf,13, 51, 1, 80,, 5
	.sym	_exp_min,18, 51, 1, 80,, 5
	.sym	_best_gain,23, 51, 1, 32,, 2
;** 75	-----------------------    Gain_predict(&past_qua_en, code, L_subfr, &gcode0, &exp_gcode0);
;** 93	-----------------------    L_tmp1 = _lsmpy(*g_coeff, g_coeff[2]);
;** 94	-----------------------    exp1 = _sadd(_sadd(*exp_coeff, exp_coeff[2]), (-1));
;** 95	-----------------------    C$13 = g_coeff[4];
;** 95	-----------------------    L_tmp2 = _lsmpy(C$13, C$13);
;** 96	-----------------------    C$12 = exp_coeff[4];
;** 96	-----------------------    exp2 = _sadd(_sadd(C$12, C$12), 1);
;** 98	-----------------------    if ( _ssub(exp1, exp2) > 0 ) goto g2;
        PSHM      AR1
        PSHM      AR6
        PSHM      AR7
        FRAME     #-42
        NOP
;----------------------------------------------------------------------
;  53 | Word16  i, j, index1, index2;                                          
;  54 | Word16  cand1, cand2;                                                  
;  55 | Word16  exp, gcode0, exp_gcode0, gcode0_org, e_min ;                   
;  56 | Word16  nume, denom, inv_denom;                                        
;  57 | Word16  exp1,exp2,exp_nume,exp_denom,exp_inv_denom,sft,tmp;            
;  58 | Word16  g_pitch, g2_pitch, g_code, g2_code, g_pit_cod;                 
;  59 | Word16  coeff[5], coeff_lsf[5];                                        
;  60 | Word16  exp_min[5];                                                    
;  61 | Word32  L_gbk12;                                                       
;  62 | Word32  L_tmp, L_dist_min, L_temp, L_tmp1, L_tmp2, L_acc, L_accb;      
;  63 | Word16  best_gain[2];                                                  
;  67 | static Word16 past_qua_en[4] = { -14336, -14336, -14336, -14336 };     
;----------------------------------------------------------------------
        LD        *SP(51),B
        STL       B,*SP(25)
        LD        *SP(50),B
        STL       B,*SP(26)
        MVDK      *SP(47),*(AR7)
        LD        *SP(49),B
        STL       B,*SP(27)
        LD        *SP(48),B
        MVDK      *SP(46),*(AR1)
	.line	34
;----------------------------------------------------------------------
;  75 | Gain_predict( past_qua_en, code, L_subfr, &gcode0, &exp_gcode0 );      
;----------------------------------------------------------------------
        RSBX      OVM
        RSBX      FRCT
        STL       A,*SP(0)
        LDM       SP,A
        ADD       #6,A
        STL       B,*SP(1)
        STL       A,*SP(2)
        LDM       SP,A
        ADD       #7,A
        STL       A,*SP(3)
        CALLD     #_Gain_predict        ; |75| 
        LD        #_past_qua_en$1,A
        ; call occurs [#_Gain_predict] ; |75| 
	.line	52
;----------------------------------------------------------------------
;  93 | L_tmp1 = L_mult( g_coeff[0], g_coeff[2] );                             
;----------------------------------------------------------------------
        LD        *AR1(2),T
        SSBX      FRCT
        SSBX      OVM
        NOP
        MPY       *AR1,A                ; |93| 
        DST       A,*SP(28)             ; |93| 
	.line	53
;----------------------------------------------------------------------
;  94 | exp1   = add( add( exp_coeff[0], exp_coeff[2] ), 1-2 );                
;----------------------------------------------------------------------
        RSBX      OVM
        SSBX      SXM
        NOP
        LD        *AR7,16,A             ; |94| 
        SSBX      OVM
        ADD       *AR7(2),16,A,A        ; |94| 
        ADD       #-1,16,A,A            ; |94| 
        SFTA      A,-16,A               ; |94| 
        STL       A,*SP(30)
	.line	54
;----------------------------------------------------------------------
;  95 | L_tmp2 = L_mult( g_coeff[4], g_coeff[4] );                             
;----------------------------------------------------------------------
        LD        *AR1(4),A
        STLM      A,T
        MPY       *(AL),A               ; |95| 
        DST       A,*SP(32)             ; |95| 
	.line	55
;----------------------------------------------------------------------
;  96 | exp2   = add( add( exp_coeff[4], exp_coeff[4] ), 1 );                  
;----------------------------------------------------------------------
        LD        *AR7(4),B
        RSBX      OVM
        LD        *(BL),16,A            ; |96| 
        SSBX      OVM
        ADD       *(BL),16,A,A          ; |96| 
        ADD       #1,16,A,A             ; |96| 
        SFTA      A,-16,A               ; |96| 
        STLM      A,AR6
	.line	57
;----------------------------------------------------------------------
;  98 | if( sub(exp1, exp2)>0 ){                                               
;  99 |    L_tmp = L_sub( L_shr( L_tmp1, sub(exp1,exp2) ), L_tmp2 );           
; 100 |    exp = exp2;                                                         
; 102 | else{                                                                  
;----------------------------------------------------------------------
        LD        *SP(30),A
        RSBX      OVM
        LD        *(AL),16,A            ; |98| 
        SSBX      OVM
        SUB       *(AR6),16,A,A         ; |98| 
        SFTA      A,-16,A               ; |98| 
        LD        *(AL),A               ; |98| 
        BC        L9,AGT                ; |98| 
        ; branch occurs ; |98| 
;** 103	-----------------------    L_tmp = L_sub(L_tmp1, L_shr(L_tmp2, _ssub(exp2, exp1)));
;** 104	-----------------------    exp = exp1;
;** 104	-----------------------    goto g3;
	.line	62
;----------------------------------------------------------------------
; 103 | L_tmp = L_sub( L_tmp1, L_shr( L_tmp2, sub(exp2,exp1) ) );              
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *(AR6),16,A           ; |103| 
        LD        *SP(30),B
        SSBX      OVM
        RSBX      FRCT
        SUB       *(BL),16,A,A          ; |103| 
        RSBX      OVM
        STH       A,*SP(0)              ; |103| 
        DLD       *SP(32),A             ; |103| 
        CALL      #_L_shr               ; |103| 
        ; call occurs [#_L_shr] ; |103| 
        RSBX      OVM
        RSBX      FRCT
        DST       A,*SP(0)              ; |103| 
        DLD       *SP(28),A             ; |103| 
        CALL      #_L_sub               ; |103| 
        ; call occurs [#_L_sub] ; |103| 
	.line	63
;----------------------------------------------------------------------
; 104 | exp = exp1;                                                            
; 106 | sft = norm_l( L_tmp );                                                 
;----------------------------------------------------------------------
        B         L10                   ; |104| 
        ; branch occurs ; |104| 
L9:    
;**	-----------------------g2:
;** 99	-----------------------    L_tmp = L_sub(L_shr(L_tmp1, _ssub(exp1, exp2)), L_tmp2);
;** 100	-----------------------    exp = exp2;
	.line	58
        RSBX      OVM
        LD        *SP(30),A
        LD        *(AL),16,A            ; |99| 
        RSBX      FRCT
        SSBX      OVM
        SUB       *(AR6),16,A,A         ; |99| 
        RSBX      OVM
        STH       A,*SP(0)              ; |99| 
        DLD       *SP(28),A             ; |99| 
        CALL      #_L_shr               ; |99| 
        ; call occurs [#_L_shr] ; |99| 
        RSBX      OVM
        RSBX      FRCT
        DLD       *SP(32),B             ; |99| 
        DST       B,*SP(0)              ; |99| 
        CALL      #_L_sub               ; |99| 
        ; call occurs [#_L_sub] ; |99| 
	.line	59
        MVKD      *(AR6),*SP(30)
L10:    
;**	-----------------------g3:
;** 107	-----------------------    C$11 = _lnorm(L_tmp);
;** 107	-----------------------    denom = (unsigned long)L_shl(L_tmp, C$11)>>16;
;** 110	-----------------------    inv_denom = divs(16384, denom);
;** 111	-----------------------    inv_denom = _sneg(inv_denom);
;** 112	-----------------------    exp_inv_denom = _ssub(29, _ssub(_sadd(exp, C$11), 16));
;** 117	-----------------------    L_tmp1 = _lsmpy(g_coeff[2], g_coeff[1]);
;** 118	-----------------------    exp1 = _sadd(exp_coeff[2], exp_coeff[1]);
;** 119	-----------------------    L_tmp2 = _lsmpy(g_coeff[3], g_coeff[4]);
;** 120	-----------------------    exp2 = _sadd(_sadd(exp_coeff[3], exp_coeff[4]), 1);
;** 122	-----------------------    if ( _ssub(exp1, exp2) > 0 ) goto g5;
	.line	66
;----------------------------------------------------------------------
; 107 | denom = extract_h( L_shl(L_tmp, sft) );                                
; 108 | exp_denom = sub( add( exp, sft ), 16 );                                
;----------------------------------------------------------------------
        RSBX      OVM
        LD        A,B                   ; |107| 
        SSBX      SXM
        SFTA      B,8                   ; |107| 
        SFTA      B,-8                  ; |107| 
        EXP       B                     ; |107| 
        RSBX      FRCT
        MVMD      T,AR6
        MVKD      *(AR6),*SP(0)
        CALL      #_L_shl               ; |107| 
        ; call occurs [#_L_shl] ; |107| 
        SFTL      A,#-16,A              ; |107| 
	.line	69
;----------------------------------------------------------------------
; 110 | inv_denom = div_s(16384,denom);                                        
;----------------------------------------------------------------------
        RSBX      FRCT
        RSBX      OVM
        STL       A,*SP(0)
        CALLD     #_divs                ; |110| 
        LD        #16384,A
        ; call occurs [#_divs] ; |110| 
	.line	70
;----------------------------------------------------------------------
; 111 | inv_denom = negate( inv_denom );                                       
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        LD        *(AL),16,A            ; |111| 
        SSBX      OVM
        NOP
        NEG       A,A                   ; |111| 
        SFTA      A,-16,A               ; |111| 
        STL       A,*SP(34)
	.line	71
;----------------------------------------------------------------------
; 112 | exp_inv_denom = sub( 14+15, exp_denom );                               
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *SP(30),A
        LD        *(AL),16,A            ; |112| 
        SSBX      OVM
        ADD       *(AR6),16,A,A         ; |112| 
        SUB       #16,16,A,A            ; |112| 
        RSBX      OVM
        SFTA      A,-16,A               ; |112| 
        LD        #29,16,B              ; |112| 
        SSBX      OVM
        SUB       *(AL),16,B,A          ; |112| 
        SFTA      A,-16,A               ; |112| 
        STL       A,*SP(35)
	.line	76
;----------------------------------------------------------------------
; 117 | L_tmp1 = L_mult( g_coeff[2], g_coeff[1] );                             
;----------------------------------------------------------------------
        LD        *AR1(1),T
        SSBX      FRCT
        MPY       *AR1(2),A             ; |117| 
	.line	77
;----------------------------------------------------------------------
; 118 | exp1   = add( exp_coeff[2], exp_coeff[1] );                            
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *AR7(2),16,B          ; |118| 
        SSBX      OVM
        ADD       *AR7(1),16,B,B        ; |118| 
        SFTA      B,-16,B               ; |118| 
        STL       B,*SP(30)
	.line	78
;----------------------------------------------------------------------
; 119 | L_tmp2 = L_mult( g_coeff[3], g_coeff[4] );                             
;----------------------------------------------------------------------
        LD        *AR1(4),T
        MPY       *AR1(3),B             ; |119| 
        DST       B,*SP(28)             ; |119| 
	.line	79
;----------------------------------------------------------------------
; 120 | exp2   = add( add( exp_coeff[3], exp_coeff[4] ), 1 );                  
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *AR7(3),16,B          ; |120| 
        SSBX      OVM
        ADD       *AR7(4),16,B,B        ; |120| 
        ADD       #1,16,B,B             ; |120| 
        SFTA      B,-16,B               ; |120| 
        STLM      B,AR6
	.line	81
;----------------------------------------------------------------------
; 122 | if( sub(exp1, exp2)>0 ){                                               
; 123 |    L_tmp = L_sub( L_shr( L_tmp1, add(sub(exp1,exp2),1 )), L_shr( L_tmp2
;     | ,1 ) );                                                                
; 124 |    exp = sub(exp2,1);                                                  
; 126 | else{                                                                  
;----------------------------------------------------------------------
        LD        *SP(30),B
        RSBX      OVM
        LD        *(BL),16,B            ; |122| 
        SSBX      OVM
        SUB       *(AR6),16,B,B         ; |122| 
        SFTA      B,-16,B               ; |122| 
        LD        *(BL),B               ; |122| 
        BC        L11,BGT               ; |122| 
        ; branch occurs ; |122| 
;** 127	-----------------------    L_tmp = L_sub(L_shr(L_tmp1, 1), L_shr(L_tmp2, _sadd(_ssub(exp2, exp1), 1)));
;** 128	-----------------------    exp = _ssub(exp1, 1);
;** 128	-----------------------    goto g6;
	.line	86
;----------------------------------------------------------------------
; 127 | L_tmp = L_sub( L_shr( L_tmp1,1 ), L_shr( L_tmp2, add(sub(exp2,exp1),1 )
;     | ) );                                                                   
;----------------------------------------------------------------------
        RSBX      FRCT
        RSBX      OVM
        ST        #1,*SP(0)             ; |127| 
        CALL      #_L_shr               ; |127| 
        ; call occurs [#_L_shr] ; |127| 
        SSBX      SXM
        RSBX      OVM
        DST       A,*SP(32)             ; |127| 
        LD        *SP(30),B
        RSBX      FRCT
        LD        *(AR6),16,A           ; |127| 
        SSBX      OVM
        SUB       *(BL),16,A,A          ; |127| 
        ADD       #1,16,A,A             ; |127| 
        RSBX      OVM
        STH       A,*SP(0)              ; |127| 
        DLD       *SP(28),A             ; |127| 
        CALL      #_L_shr               ; |127| 
        ; call occurs [#_L_shr] ; |127| 
        RSBX      OVM
        RSBX      FRCT
        DST       A,*SP(0)              ; |127| 
        DLD       *SP(32),A             ; |127| 
        CALL      #_L_sub               ; |127| 
        ; call occurs [#_L_sub] ; |127| 
	.line	87
;----------------------------------------------------------------------
; 128 | exp = sub(exp1,1);                                                     
; 130 | sft = norm_l( L_tmp );                                                 
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *SP(30),B
        SSBX      SXM
        LD        *(BL),16,B            ; |128| 
        SSBX      OVM
        NOP
        SUB       #1,16,B,B             ; |128| 
        BD        L12                   ; |128| 
        SFTA      B,-16,B               ; |128| 
        STL       B,*SP(30)
        ; branch occurs ; |128| 
L11:    
;**	-----------------------g5:
;** 123	-----------------------    L_tmp = L_sub(L_shr(L_tmp1, _sadd(_ssub(exp1, exp2), 1)), L_shr(L_tmp2, 1));
;** 124	-----------------------    exp = _ssub(exp2, 1);
	.line	82
        RSBX      OVM
        LD        *SP(30),B
        LD        *(BL),16,B            ; |123| 
        RSBX      FRCT
        SSBX      OVM
        SUB       *(AR6),16,B,B         ; |123| 
        ADD       #1,16,B,B             ; |123| 
        RSBX      OVM
        STH       B,*SP(0)              ; |123| 
        CALL      #_L_shr               ; |123| 
        ; call occurs [#_L_shr] ; |123| 
        DST       A,*SP(32)             ; |123| 
        RSBX      OVM
        RSBX      FRCT
        ST        #1,*SP(0)             ; |123| 
        DLD       *SP(28),A             ; |123| 
        CALL      #_L_shr               ; |123| 
        ; call occurs [#_L_shr] ; |123| 
        RSBX      OVM
        DST       A,*SP(0)              ; |123| 
        RSBX      FRCT
        DLD       *SP(32),A             ; |123| 
        CALL      #_L_sub               ; |123| 
        ; call occurs [#_L_sub] ; |123| 
	.line	83
        SSBX      SXM
        RSBX      OVM
        LD        *(AR6),16,B           ; |124| 
        SSBX      OVM
        NOP
        SUB       #1,16,B,B             ; |124| 
        SFTA      B,-16,B               ; |124| 
        STL       B,*SP(30)
L12:    
;**	-----------------------g6:
;** 131	-----------------------    C$10 = _lnorm(L_tmp);
;** 131	-----------------------    nume = (unsigned long)L_shl(L_tmp, C$10)>>16;
;** 135	-----------------------    L_acc = L_shr(_lsmpy(nume, inv_denom), _ssub(_sadd(_ssub(_sadd(exp, C$10), 16), exp_inv_denom), 24));
;** 136	-----------------------    best_gain[0] = L_acc>>16;
;** 75	-----------------------    K$12 = &past_qua_en[0];
;** 138	-----------------------    if ( tameflag != 1 || (int)(L_acc>>16) < 482 ) goto g8;
	.line	90
;----------------------------------------------------------------------
; 131 | nume = extract_h( L_shl(L_tmp, sft) );                                 
; 132 | exp_nume = sub( add( exp, sft ), 16 );                                 
; 134 | sft = sub( add( exp_nume, exp_inv_denom ), (9+16-1) );                 
;----------------------------------------------------------------------
        RSBX      OVM
        LD        A,B                   ; |131| 
        SFTA      B,8                   ; |131| 
        SFTA      B,-8                  ; |131| 
        EXP       B                     ; |131| 
        RSBX      FRCT
        MVMD      T,AR6
        MVKD      *(AR6),*SP(0)
        CALL      #_L_shl               ; |131| 
        ; call occurs [#_L_shl] ; |131| 
        SFTL      A,#-16,A              ; |131| 
	.line	94
;----------------------------------------------------------------------
; 135 | L_acc = L_shr( L_mult( nume,inv_denom ), sft );                        
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        LD        *SP(30),B
        SSBX      FRCT
        MVDK      *SP(35),*(AR2)
        LD        *(BL),16,B            ; |135| 
        SSBX      OVM
        ADD       *(AR6),16,B,B         ; |135| 
        LD        *SP(34),T
        SUB       #16,16,B,B            ; |135| 
        ADD       *(AR2),16,B,B         ; |135| 
        MPY       *(AL),A               ; |135| 
        SUB       #24,16,B,B            ; |135| 
        RSBX      FRCT
        RSBX      OVM
        STH       B,*SP(0)              ; |135| 
        CALL      #_L_shr               ; |135| 
        ; call occurs [#_L_shr] ; |135| 
	.line	95
;----------------------------------------------------------------------
; 136 | best_gain[0] = extract_h( L_acc );             /*-- best_gain[0]:Q9 --*
;     | /                                                                      
;----------------------------------------------------------------------
        LD        A,B                   ; |136| 
        SFTL      B,#-16,B              ; |136| 
        STL       B,*SP(23)             ; |136| 
	.line	34
        LD        #_past_qua_en$1,B
        STL       B,*SP(36)
	.line	97
;----------------------------------------------------------------------
; 138 | if (tameflag == 1){                                                    
;----------------------------------------------------------------------
        MVDK      *SP(25),*(AR2)
        BANZ      L13,*AR2(-1)          ; |138| 
        ; branch occurs ; |138| 
        SSBX      SXM
        SFTL      A,#-16,A              ; |138| 
        RSBX      OVM
        LD        *(AL),A               ; |138| 
        SUB       #482,A,A              ; |138| 
        BC        L13,ALT               ; |138| 
        ; branch occurs ; |138| 
;** 139	-----------------------    best_gain[0] = 481;
	.line	98
;----------------------------------------------------------------------
; 139 | if(sub(best_gain[0], GPCLIP2) > 0) best_gain[0] = GPCLIP2;             
;----------------------------------------------------------------------
        ST        #481,*SP(23)          ; |139| 
L13:    
;**	-----------------------g8:
;** 145	-----------------------    L_tmp1 = _lsmpy(*g_coeff, g_coeff[3]);
;** 146	-----------------------    exp1 = _sadd(*exp_coeff, exp_coeff[3]);
;** 147	-----------------------    L_tmp2 = _lsmpy(g_coeff[1], g_coeff[4]);
;** 148	-----------------------    exp2 = _sadd(_sadd(exp_coeff[1], exp_coeff[4]), 1);
;** 150	-----------------------    if ( _ssub(exp1, exp2) > 0 ) goto g10;
	.line	104
;----------------------------------------------------------------------
; 145 | L_tmp1 = L_mult( g_coeff[0], g_coeff[3] );                             
;----------------------------------------------------------------------
        SSBX      FRCT
        SSBX      OVM
        LD        *AR1(3),T
        NOP
        MPY       *AR1,A                ; |145| 
	.line	105
;----------------------------------------------------------------------
; 146 | exp1   = add( exp_coeff[0], exp_coeff[3] ) ;                           
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        NOP
        LD        *AR7,16,B             ; |146| 
        SSBX      OVM
        ADD       *AR7(3),16,B,B        ; |146| 
        SFTA      B,-16,B               ; |146| 
        STL       B,*SP(30)
	.line	106
;----------------------------------------------------------------------
; 147 | L_tmp2 = L_mult( g_coeff[1], g_coeff[4] );                             
;----------------------------------------------------------------------
        LD        *AR1(4),T
        MPY       *AR1(1),B             ; |147| 
        DST       B,*SP(28)             ; |147| 
	.line	107
;----------------------------------------------------------------------
; 148 | exp2   = add( add( exp_coeff[1], exp_coeff[4] ), 1 );                  
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *AR7(1),16,B          ; |148| 
        SSBX      OVM
        ADD       *AR7(4),16,B,B        ; |148| 
        ADD       #1,16,B,B             ; |148| 
        SFTA      B,-16,B               ; |148| 
        STLM      B,AR6
	.line	109
;----------------------------------------------------------------------
; 150 | if( sub(exp1, exp2)>0 ){                                               
; 151 |    L_tmp = L_sub( L_shr( L_tmp1, add(sub(exp1,exp2),1) ), L_shr( L_tmp2
;     | ,1 ) );                                                                
; 152 |    exp = sub(exp2,1);                                                  
; 154 | else{                                                                  
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *SP(30),B
        LD        *(BL),16,B            ; |150| 
        SSBX      OVM
        SUB       *(AR6),16,B,B         ; |150| 
        SFTA      B,-16,B               ; |150| 
        LD        *(BL),B               ; |150| 
        BC        L14,BGT               ; |150| 
        ; branch occurs ; |150| 
;** 155	-----------------------    L_tmp = L_sub(L_shr(L_tmp1, 1), L_shr(L_tmp2, _sadd(_ssub(exp2, exp1), 1)));
;** 156	-----------------------    exp = _ssub(exp1, 1);
;** 156	-----------------------    goto g11;
	.line	114
;----------------------------------------------------------------------
; 155 | L_tmp = L_sub( L_shr( L_tmp1,1 ), L_shr( L_tmp2, add(sub(exp2,exp1),1)
;     | ) );                                                                   
;----------------------------------------------------------------------
        RSBX      FRCT
        RSBX      OVM
        ST        #1,*SP(0)             ; |155| 
        CALL      #_L_shr               ; |155| 
        ; call occurs [#_L_shr] ; |155| 
        SSBX      SXM
        RSBX      OVM
        DST       A,*SP(32)             ; |155| 
        LD        *SP(30),B
        RSBX      FRCT
        LD        *(AR6),16,A           ; |155| 
        SSBX      OVM
        SUB       *(BL),16,A,A          ; |155| 
        ADD       #1,16,A,A             ; |155| 
        RSBX      OVM
        STH       A,*SP(0)              ; |155| 
        DLD       *SP(28),A             ; |155| 
        CALL      #_L_shr               ; |155| 
        ; call occurs [#_L_shr] ; |155| 
        RSBX      OVM
        RSBX      FRCT
        DST       A,*SP(0)              ; |155| 
        DLD       *SP(32),A             ; |155| 
        CALL      #_L_sub               ; |155| 
        ; call occurs [#_L_sub] ; |155| 
	.line	115
;----------------------------------------------------------------------
; 156 | exp = sub(exp1,1);                                                     
; 158 | sft = norm_l( L_tmp );                                                 
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *SP(30),B
        SSBX      SXM
        LD        *(BL),16,B            ; |156| 
        SSBX      OVM
        NOP
        SUB       #1,16,B,B             ; |156| 
        BD        L15                   ; |156| 
        SFTA      B,-16,B               ; |156| 
        STL       B,*SP(30)
        ; branch occurs ; |156| 
L14:    
;**	-----------------------g10:
;** 151	-----------------------    L_tmp = L_sub(L_shr(L_tmp1, _sadd(_ssub(exp1, exp2), 1)), L_shr(L_tmp2, 1));
;** 152	-----------------------    exp = _ssub(exp2, 1);
	.line	110
        RSBX      OVM
        LD        *SP(30),B
        LD        *(BL),16,B            ; |151| 
        RSBX      FRCT
        SSBX      OVM
        SUB       *(AR6),16,B,B         ; |151| 
        ADD       #1,16,B,B             ; |151| 
        RSBX      OVM
        STH       B,*SP(0)              ; |151| 
        CALL      #_L_shr               ; |151| 
        ; call occurs [#_L_shr] ; |151| 
        DST       A,*SP(32)             ; |151| 
        RSBX      OVM
        RSBX      FRCT
        ST        #1,*SP(0)             ; |151| 
        DLD       *SP(28),A             ; |151| 
        CALL      #_L_shr               ; |151| 
        ; call occurs [#_L_shr] ; |151| 
        RSBX      OVM
        DST       A,*SP(0)              ; |151| 
        RSBX      FRCT
        DLD       *SP(32),A             ; |151| 
        CALL      #_L_sub               ; |151| 
        ; call occurs [#_L_sub] ; |151| 
	.line	111
        SSBX      SXM
        RSBX      OVM
        LD        *(AR6),16,B           ; |152| 
        SSBX      OVM
        NOP
        SUB       #1,16,B,B             ; |152| 
        SFTA      B,-16,B               ; |152| 
        STL       B,*SP(30)
L15:    
;**	-----------------------g11:
;** 159	-----------------------    C$9 = _lnorm(L_tmp);
;** 159	-----------------------    nume = (unsigned long)L_shl(L_tmp, C$9)>>16;
;** 163	-----------------------    L_acc = L_shr(_lsmpy(nume, inv_denom), _ssub(_sadd(_ssub(_sadd(exp, C$9), 16), exp_inv_denom), 17));
;** 164	-----------------------    best_gain[1] = L_acc>>16;
;** 167	-----------------------    if ( exp_gcode0 >= 4 ) goto g13;
	.line	118
;----------------------------------------------------------------------
; 159 | nume = extract_h( L_shl(L_tmp, sft) );                                 
; 160 | exp_nume = sub( add( exp, sft ), 16 );                                 
; 162 | sft = sub( add( exp_nume, exp_inv_denom ), (2+16-1) );                 
;----------------------------------------------------------------------
        RSBX      OVM
        LD        A,B                   ; |159| 
        SFTA      B,8                   ; |159| 
        SFTA      B,-8                  ; |159| 
        EXP       B                     ; |159| 
        RSBX      FRCT
        MVMD      T,AR6
        MVKD      *(AR6),*SP(0)
        CALL      #_L_shl               ; |159| 
        ; call occurs [#_L_shl] ; |159| 
        SFTL      A,#-16,A              ; |159| 
	.line	122
;----------------------------------------------------------------------
; 163 | L_acc = L_shr( L_mult( nume,inv_denom ), sft );                        
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        LD        *SP(30),B
        SSBX      FRCT
        MVDK      *SP(35),*(AR2)
        LD        *(BL),16,B            ; |163| 
        SSBX      OVM
        ADD       *(AR6),16,B,B         ; |163| 
        LD        *SP(34),T
        SUB       #16,16,B,B            ; |163| 
        ADD       *(AR2),16,B,B         ; |163| 
        MPY       *(AL),A               ; |163| 
        SUB       #17,16,B,B            ; |163| 
        RSBX      FRCT
        RSBX      OVM
        STH       B,*SP(0)              ; |163| 
        CALL      #_L_shr               ; |163| 
        ; call occurs [#_L_shr] ; |163| 
	.line	123
;----------------------------------------------------------------------
; 164 | best_gain[1] = extract_h( L_acc );             /*-- best_gain[1]:Q2 --*
;     | /                                                                      
;----------------------------------------------------------------------
        SFTL      A,#-16,A              ; |164| 
        STL       A,*SP(24)             ; |164| 
	.line	126
;----------------------------------------------------------------------
; 167 | if( sub(exp_gcode0,4) >= 0 ){                                          
; 168 |    gcode0_org = shr( gcode0, sub(exp_gcode0,4) );                      
; 170 | else{                                                                  
; 171 |    L_acc = L_deposit_l( gcode0 );                                      
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        LD        #4,A
        SUB       *SP(7),A              ; |167| 
        BC        L16,ALEQ              ; |167| 
        ; branch occurs ; |167| 
;** 172	-----------------------    L_acc = L_shl((long)gcode0, _ssub(20, exp_gcode0));
;** 173	-----------------------    gcode0_org = L_acc>>16;
;**  	-----------------------    U$113 = _ssub(exp_gcode0, 4);
;** 173	-----------------------    goto g14;
	.line	131
;----------------------------------------------------------------------
; 172 | L_acc = L_shl( L_acc, sub( (4+16), exp_gcode0 ) );                     
;----------------------------------------------------------------------
        LD        #20,16,A              ; |172| 
        SSBX      OVM
        RSBX      FRCT
        SUB       *SP(7),16,A,A         ; |172| 
        RSBX      OVM
        STH       A,*SP(0)              ; |172| 
        LD        *SP(6),A              ; |172| 
        CALL      #_L_shl               ; |172| 
        ; call occurs [#_L_shl] ; |172| 
	.line	132
;----------------------------------------------------------------------
; 173 | gcode0_org = extract_h( L_acc );              /*-- gcode0_org:Q4 --*/  
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        NOP
        LD        *SP(7),16,B
        SSBX      OVM
        NOP
        SUB       #4,16,B,B
        SFTA      B,-16,B
        BD        L17                   ; |173| 
        STL       B,*SP(30)
        SFTL      A,#-16,A              ; |173| 
        ; branch occurs ; |173| 
L16:    
;**	-----------------------g13:
;** 168	-----------------------    gcode0_org = crshft(gcode0, U$113 = _ssub(exp_gcode0, 4));
	.line	127
        LD        *SP(7),16,A           ; |168| 
        SSBX      OVM
        RSBX      FRCT
        SUB       #4,16,A,A             ; |168| 
        RSBX      OVM
        SFTA      A,-16,A               ; |168| 
        STL       A,*SP(30)
        STL       A,*SP(0)
        LD        *SP(6),A
        CALL      #_crshft              ; |168| 
        ; call occurs [#_crshft] ; |168| 
L17:    
;**	-----------------------g14:
;** 180	-----------------------    Gbk_presel(&best_gain, &cand1, &cand2, gcode0_org);
;** 219	-----------------------    exp_min[0] = _sadd(*exp_coeff, 13);
;** 220	-----------------------    C$8 = &exp_min[1];
;** 220	-----------------------    *C$8 = _sadd(exp_coeff[1], 14);
;** 221	-----------------------    exp_min[2] = _sadd(exp_coeff[2], _ssub(clshft(exp_gcode0, 1), 21));
;** 222	-----------------------    exp_min[3] = _sadd(exp_coeff[3], _ssub(exp_gcode0, 3));
;** 223	-----------------------    exp_min[4] = _sadd(exp_coeff[4], U$113);
;** 225	-----------------------    e_min = exp_min[0];
;**  	-----------------------    #pragma MUST_ITERATE(4, 4, 4)
;**  	-----------------------    #pragma LOOP_FLAGS(4096u)
;**  	-----------------------    U$139 = C$8;
;**	-----------------------g16:
;**  	-----------------------    L$1 = 3;
;**	-----------------------g41:
	.line	139
;----------------------------------------------------------------------
; 180 | Gbk_presel(best_gain, &cand1, &cand2, gcode0_org );                    
;----------------------------------------------------------------------
        RSBX      OVM
        LDM       SP,B
        ADD       #4,B
        RSBX      FRCT
        STL       B,*SP(0)
        LDM       SP,B
        ADD       #5,B
        STL       B,*SP(1)
        STL       A,*SP(2)
        LDM       SP,A
        CALLD     #_Gbk_presel          ; |180| 
        ADD       #23,A
        ; call occurs [#_Gbk_presel] ; |180| 
	.line	178
;----------------------------------------------------------------------
; 219 | exp_min[0] = add( exp_coeff[0], 13 );                                  
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        NOP
        LD        *AR7,16,A             ; |219| 
        SSBX      OVM
        NOP
        ADD       #13,16,A,A            ; |219| 
        STH       A,*SP(18)             ; |219| 
	.line	179
;----------------------------------------------------------------------
; 220 | exp_min[1] = add( exp_coeff[1], 14 );                                  
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *AR7(1),16,A          ; |220| 
        SSBX      OVM
        MVMM      SP,AR6
        ADD       #14,16,A,A            ; |220| 
        MAR       *+AR6(#19)
        STH       A,*AR6                ; |220| 
	.line	180
;----------------------------------------------------------------------
; 221 | exp_min[2] = add( exp_coeff[2], sub( shl( exp_gcode0, 1 ), 21 ) );     
;----------------------------------------------------------------------
        RSBX      FRCT
        ST        #1,*SP(0)             ; |221| 
        RSBX      OVM
        LD        *SP(7),A
        CALL      #_clshft              ; |221| 
        ; call occurs [#_clshft] ; |221| 
        RSBX      OVM
        SSBX      SXM
        LD        *(AL),16,A            ; |221| 
        SSBX      OVM
        NOP
        SUB       #21,16,A,A            ; |221| 
        SFTA      A,-16,A               ; |221| 
        RSBX      OVM
        LD        *AR7(2),16,B          ; |221| 
        SSBX      OVM
        ADD       *(AL),16,B,A          ; |221| 
        STH       A,*SP(20)             ; |221| 
	.line	181
;----------------------------------------------------------------------
; 222 | exp_min[3] = add( exp_coeff[3], sub( exp_gcode0, 3 ) );                
;----------------------------------------------------------------------
        RSBX      OVM
        NOP
        LD        *SP(7),16,A           ; |222| 
        SSBX      OVM
        NOP
        SUB       #3,16,A,A             ; |222| 
        RSBX      OVM
        LD        *AR7(3),16,B          ; |222| 
        SSBX      OVM
        SFTA      A,-16,A               ; |222| 
        ADD       *(AL),16,B,A          ; |222| 
        STH       A,*SP(21)             ; |222| 
	.line	182
;----------------------------------------------------------------------
; 223 | exp_min[4] = add( exp_coeff[4], sub( exp_gcode0, 4 ) );                
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *AR7(4),16,A          ; |223| 
        LD        *SP(30),B
        SSBX      OVM
        ADD       *(BL),16,A,A          ; |223| 
        STH       A,*SP(22)             ; |223| 
	.line	184
;----------------------------------------------------------------------
; 225 | e_min = exp_min[0];                                                    
; 226 | for(i=1; i<5; i++){                                                    
;----------------------------------------------------------------------
        STM       #3,BRC
        MVDK      *SP(18),*(AR7)
        RPTB      L20-1
        ; loop starts
L18:    
;** 227	-----------------------    C$7 = *U$139++;
;** 227	-----------------------    if ( _ssub(C$7, e_min) >= 0 ) goto g18;
	.line	186
;----------------------------------------------------------------------
; 227 | if( sub(exp_min[i], e_min) < 0 ){                                      
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *AR6+,B
        LD        *(BL),16,A            ; |227| 
        SSBX      OVM
        SUB       *(AR7),16,A,A         ; |227| 
        SFTA      A,-16,A               ; |227| 
        LD        *(AL),A               ; |227| 
        BC        L19,AGEQ              ; |227| 
        ; branch occurs ; |227| 
;** 228	-----------------------    e_min = C$7;
	.line	187
;----------------------------------------------------------------------
; 228 | e_min = exp_min[i];                                                    
;----------------------------------------------------------------------
        STLM      B,AR7
L19:    
;**	-----------------------g18:
;** 230	-----------------------    if ( --L$1 != -1 ) goto g41;
        NOP
	.line	189
;----------------------------------------------------------------------
; 234 | for(i=0; i<5; i++){                                                    
; 235 |   j = sub( exp_min[i], e_min );                                        
; 236 |   L_tmp = L_deposit_h( g_coeff[i] );                                   
;----------------------------------------------------------------------
        ; loop ends ; |230| 
L20:    
;**  	-----------------------    #pragma MUST_ITERATE(5, 5, 5)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$148 = g_coeff;
;**  	-----------------------    U$158 = &coeff[0];
;**  	-----------------------    U$155 = &coeff_lsf[0];
;**  	-----------------------    U$139 = &exp_min[0];
;**  	-----------------------    L$2 = 5;
        MVKD      *(AR1),*SP(35)
        RSBX      OVM
        LDM       SP,A
        MVMM      SP,AR6
        MVMM      SP,AR1
        ADD       #18,A
        MAR       *+AR6(#13)
        STL       A,*SP(30)
        MAR       *+AR1(#8)
        LD        #5,A
        STL       A,*SP(34)
L21:    
;**	-----------------------g21:
;** 237	-----------------------    L_tmp = L_shr((long)*U$148++<<16, _ssub(*U$139++, e_min));
;** 238	-----------------------    L_Extract(L_tmp, U$158, U$155);
;** 239	-----------------------    ++U$155;
;** 239	-----------------------    ++U$158;
;** 239	-----------------------    if ( --L$2 ) goto g21;
	.line	196
;----------------------------------------------------------------------
; 237 | L_tmp = L_shr( L_tmp, j );          /* L_tmp:Q[exp_g_coeff[i]+16-j] */ 
;----------------------------------------------------------------------
        RSBX      OVM
        SSBX      SXM
        MVDK      *SP(30),*(AR2)
        LD        *AR2+,16,A            ; |237| 
        RSBX      FRCT
        SSBX      OVM
        MVKD      *(AR2),*SP(30)
        SUB       *(AR7),16,A,A         ; |237| 
        MVDK      *SP(35),*(AR2)
        RSBX      OVM
        STH       A,*SP(0)              ; |237| 
        LD        *AR2+,A               ; |237| 
        MVKD      *(AR2),*SP(35)
        CALLD     #_L_shr               ; |237| 
        SFTL      A,#15,A               ; |237| 
        SFTL      A,#1,A                ; |237| 
        ; call occurs [#_L_shr] ; |237| 
	.line	197
;----------------------------------------------------------------------
; 238 | L_Extract( L_tmp, &coeff[i], &coeff_lsf[i] );          /* DPF */       
;----------------------------------------------------------------------
        MVKD      *(AR1),*SP(0)
        RSBX      FRCT
        RSBX      OVM
        MVKD      *(AR6),*SP(1)
        CALL      #_L_Extract           ; |238| 
        ; call occurs [#_L_Extract] ; |238| 
	.line	198
;----------------------------------------------------------------------
; 243 | L_dist_min = MAX_32;                                                   
;----------------------------------------------------------------------
        MVDK      *SP(34),*(AR2)
        MAR       *AR1+
        MAR       *AR6+
        BANZD     L21,*+AR2(-1)         ; |239| 
        MVKD      *(AR2),*SP(34)
        ; branch occurs ; |239| 
;** 246	-----------------------    index1 = cand1;
;** 247	-----------------------    index2 = cand2;
;** 243	-----------------------    L_dist_min = 2147483647L;
;** 249	-----------------------    if ( tameflag == 1 ) goto g31;
	.line	205
;----------------------------------------------------------------------
; 246 | index1 = cand1;                                                        
;----------------------------------------------------------------------
        LD        *SP(4),A
        STL       A,*SP(37)
	.line	206
;----------------------------------------------------------------------
; 247 | index2 = cand2;                                                        
;----------------------------------------------------------------------
        LD        *SP(5),A
        STL       A,*SP(38)
	.line	202
        RSBX      OVM
        NOP
        LD        #32767,16,A           ; |243| 
        OR        #65535,A,A            ; |243| 
        DST       A,*SP(32)             ; |243| 
	.line	208
;----------------------------------------------------------------------
; 249 | if(tameflag == 1){                                                     
; 250 | for(i=0; i<NCAN1; i++){                                                
; 251 |    for(j=0; j<NCAN2; j++){                                             
; 252 |       g_pitch = add( gbk1[cand1+i][0], gbk2[cand2+j][0] );     /* Q14 *
;     | /                                                                      
; 253 |       if(g_pitch < GP0999) {                                           
; 254 |       L_acc = L_deposit_l( gbk1[cand1+i][1] );                         
; 255 |       L_accb = L_deposit_l( gbk2[cand2+j][1] );                /* Q13 *
;     | /                                                                      
; 256 |       L_tmp = L_add( L_acc,L_accb );                                   
; 257 |       tmp = extract_l( L_shr( L_tmp,1 ) );                     /* Q12 *
;     | /                                                                      
; 259 |       g_code   = mult( gcode0, tmp );         /*  Q[exp_gcode0+12-15] *
;     | /                                                                      
; 260 |       g2_pitch = mult(g_pitch, g_pitch);                       /* Q13 *
;     | /                                                                      
; 261 |       g2_code  = mult(g_code,  g_code);       /* Q[2*exp_gcode0-6-15] *
;     | /                                                                      
; 262 |       g_pit_cod= mult(g_code,  g_pitch);      /* Q[exp_gcode0-3+14-15]
;     | */                                                                     
; 264 |       L_tmp = Mpy_32_16(coeff[0], coeff_lsf[0], g2_pitch);             
; 265 |       L_tmp = L_add(L_tmp, Mpy_32_16(coeff[1], coeff_lsf[1], g_pitch) )
;     | ;                                                                      
; 266 |       L_tmp = L_add(L_tmp, Mpy_32_16(coeff[2], coeff_lsf[2], g2_code) )
;     | ;                                                                      
; 267 |       L_tmp = L_add(L_tmp, Mpy_32_16(coeff[3], coeff_lsf[3], g_code) );
; 268 |       L_tmp = L_add(L_tmp, Mpy_32_16(coeff[4], coeff_lsf[4], g_pit_cod)
;     |  );                                                                    
; 270 |       L_temp = L_sub(L_tmp, L_dist_min);                               
; 272 |       if( L_temp < 0L ){                                               
; 273 |          L_dist_min = L_tmp;                                           
; 274 |          index1 = add(cand1,i);                                        
; 275 |          index2 = add(cand2,j);                                        
; 282 | else{                                                                  
;----------------------------------------------------------------------
        SSBX      SXM
        NOP
        LD        *SP(25),A
        SUB       #1,A,A                ; |249| 
        BC        L25,AEQ               ; |249| 
        ; branch occurs ; |249| 
;**  	-----------------------    #pragma MUST_ITERATE(4, 4, 4)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$164 = index2*2;
;**  	-----------------------    C$6 = &gbk1;
;**  	-----------------------    U$176 = &C$6[2*index1];
;**  	-----------------------    K$175 = C$6;
;**  	-----------------------    K$168 = &gbk2;
;** 283	-----------------------    i = 0;
        LD        *SP(38),A
        STM       #_gbk1,AR1
        LD        *SP(37),B
        STL       A,#1,*SP(35)
        LDM       AR1,A
        ADD       B,#1,A
        STLM      A,AR7
        LD        #_gbk2,A
        STL       A,*SP(40)
        MVKD      *(AR1),*SP(39)
	.line	242
;----------------------------------------------------------------------
; 283 | for(i=0; i<NCAN1; i++){                                                
;----------------------------------------------------------------------
        LD        #0,A
        STL       A,*SP(30)
L22:    
;**	-----------------------g25:
;**  	-----------------------    #pragma MUST_ITERATE(8, 8, 8)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$169 = &K$168[U$164];
;** 284	-----------------------    j = 0;
        LD        *SP(40),B
        LD        *SP(35),A
        ADD       *(BL),A
        STLM      A,AR6
        NOP
	.line	243
;----------------------------------------------------------------------
; 284 | for(j=0; j<NCAN2; j++){                                                
;----------------------------------------------------------------------
        STM       #0,AR1
L23:    
;**	-----------------------g27:
;** 285	-----------------------    g_pitch = _sadd(*U$176, *U$169);
;** 289	-----------------------    tmp = L_shr(_lsadd((long)U$176[1], (long)U$169[1]), 1);
;** 294	-----------------------    C$5 = _smpy(gcode0, tmp);
;** 294	-----------------------    g_pit_cod = _smpy(C$5, g_pitch);
;** 296	-----------------------    L_tmp = Mpy_32_16(coeff[0], coeff_lsf[0], _smpy(g_pitch, g_pitch));
;** 297	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[1], coeff_lsf[1], g_pitch));
;** 298	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[2], coeff_lsf[2], _smpy(C$5, C$5)));
;** 299	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[3], coeff_lsf[3], C$5));
;** 300	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[4], coeff_lsf[4], g_pit_cod));
;** 302	-----------------------    if ( (L_temp = L_sub(L_tmp, L_dist_min)) >= 0L ) goto g29;
	.line	244
;----------------------------------------------------------------------
; 285 | g_pitch = add( gbk1[cand1+i][0], gbk2[cand2+j][0] );     /* Q14 */     
; 286 | L_acc = L_deposit_l( gbk1[cand1+i][1] );                               
; 287 | L_accb = L_deposit_l( gbk2[cand2+j][1] );                /* Q13 */     
; 288 | L_tmp = L_add( L_acc,L_accb );                                         
;----------------------------------------------------------------------
        LD        *AR7,16,A             ; |285| 
        SSBX      OVM
        NOP
        ADD       *AR6,16,A,A           ; |285| 
        SFTA      A,-16,A               ; |285| 
        STL       A,*SP(25)
	.line	248
;----------------------------------------------------------------------
; 289 | tmp = extract_l( L_shr( L_tmp,1 ) );                     /* Q12 */     
; 291 | g_code   = mult( gcode0, tmp );         /*  Q[exp_gcode0+12-15] */     
; 292 | g2_pitch = mult(g_pitch, g_pitch);                       /* Q13 */     
; 293 | g2_code  = mult(g_code,  g_code);       /* Q[2*exp_gcode0-6-15] */     
;----------------------------------------------------------------------
        ST        #1,*SP(0)             ; |289| 
        RSBX      OVM
        LD        *AR6(1),B             ; |289| 
        LD        *AR7(1),A             ; |289| 
        RSBX      SXM
        SSBX      OVM
        RSBX      FRCT
        ADD       B,A                   ; |289| 
        RSBX      OVM
        NOP
        CALL      #_L_shr               ; |289| 
        ; call occurs [#_L_shr] ; |289| 
	.line	253
;----------------------------------------------------------------------
; 294 | g_pit_cod= mult(g_code,  g_pitch);      /* Q[exp_gcode0-3+14-15] */    
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        LD        *(AL),16,A            ; |294| 
        SSBX      FRCT
        SSBX      OVM
        NOP
        MPYA      *SP(6)                ; |294| 
        RSBX      OVM
        SFTA      B,-16,A               ; |294| 
        STL       A,*SP(41)
        LD        *SP(25),A
        LD        *(AL),16,A            ; |294| 
        SSBX      OVM
        LD        *SP(41),T
        NOP
        MPYA      A                     ; |294| 
        SFTA      A,-16,A               ; |294| 
        STL       A,*SP(34)
	.line	255
;----------------------------------------------------------------------
; 296 | L_tmp = Mpy_32_16(coeff[0], coeff_lsf[0], g2_pitch);                   
;----------------------------------------------------------------------
        LD        *SP(13),A
        STL       A,*SP(0)
        LD        *SP(25),A
        RSBX      OVM
        LD        *(AL),16,A            ; |296| 
        SSBX      OVM
        LD        *SP(25),T
        NOP
        MPYA      A                     ; |296| 
        STH       A,*SP(1)              ; |296| 
        RSBX      FRCT
        RSBX      OVM
        LD        *SP(8),A
        CALL      #_Mpy_32_16           ; |296| 
        ; call occurs [#_Mpy_32_16] ; |296| 
        DST       A,*SP(28)             ; |296| 
	.line	256
;----------------------------------------------------------------------
; 297 | L_tmp = L_add(L_tmp, Mpy_32_16(coeff[1], coeff_lsf[1], g_pitch) );     
;----------------------------------------------------------------------
        LD        *SP(14),A
        STL       A,*SP(0)
        LD        *SP(25),A
        STL       A,*SP(1)
        RSBX      FRCT
        RSBX      OVM
        LD        *SP(9),A
        CALL      #_Mpy_32_16           ; |297| 
        ; call occurs [#_Mpy_32_16] ; |297| 
        SSBX      SXM
        SSBX      OVM
        DLD       *SP(28),B
        RSBX      SXM
        NOP
        ADD       A,B                   ; |297| 
        DST       B,*SP(28)             ; |297| 
	.line	257
;----------------------------------------------------------------------
; 298 | L_tmp = L_add(L_tmp, Mpy_32_16(coeff[2], coeff_lsf[2], g2_code) );     
;----------------------------------------------------------------------
        LD        *SP(15),A
        RSBX      OVM
        STL       A,*SP(0)
        SSBX      SXM
        LD        *SP(41),A
        LD        *(AL),16,A            ; |298| 
        SSBX      FRCT
        SSBX      OVM
        LD        *SP(41),T
        NOP
        MPYA      A                     ; |298| 
        RSBX      OVM
        STH       A,*SP(1)              ; |298| 
        RSBX      FRCT
        LD        *SP(10),A
        CALL      #_Mpy_32_16           ; |298| 
        ; call occurs [#_Mpy_32_16] ; |298| 
        SSBX      SXM
        NOP
        DLD       *SP(28),B
        RSBX      SXM
        SSBX      OVM
        NOP
        ADD       A,B                   ; |298| 
        DST       B,*SP(28)             ; |298| 
	.line	258
;----------------------------------------------------------------------
; 299 | L_tmp = L_add(L_tmp, Mpy_32_16(coeff[3], coeff_lsf[3], g_code) );      
;----------------------------------------------------------------------
        LD        *SP(16),A
        STL       A,*SP(0)
        LD        *SP(41),A
        STL       A,*SP(1)
        RSBX      OVM
        RSBX      FRCT
        LD        *SP(11),A
        CALL      #_Mpy_32_16           ; |299| 
        ; call occurs [#_Mpy_32_16] ; |299| 
        SSBX      SXM
        NOP
        DLD       *SP(28),B
        RSBX      SXM
        SSBX      OVM
        NOP
        ADD       A,B                   ; |299| 
        DST       B,*SP(28)             ; |299| 
	.line	259
;----------------------------------------------------------------------
; 300 | L_tmp = L_add(L_tmp, Mpy_32_16(coeff[4], coeff_lsf[4], g_pit_cod) );   
;----------------------------------------------------------------------
        LD        *SP(17),A
        STL       A,*SP(0)
        LD        *SP(34),A
        RSBX      OVM
        STL       A,*SP(1)
        RSBX      FRCT
        LD        *SP(12),A
        CALL      #_Mpy_32_16           ; |300| 
        ; call occurs [#_Mpy_32_16] ; |300| 
        SSBX      SXM
        NOP
        DLD       *SP(28),B
        RSBX      SXM
        SSBX      OVM
        NOP
        ADD       A,B                   ; |300| 
        DST       B,*SP(28)             ; |300| 
	.line	261
;----------------------------------------------------------------------
; 302 | L_temp = L_sub(L_tmp, L_dist_min);                                     
; 304 | if( L_temp < 0L ){                                                     
;----------------------------------------------------------------------
        RSBX      OVM
        NOP
        DLD       *SP(32),A
        RSBX      FRCT
        DST       A,*SP(0)              ; |302| 
        CALLD     #_L_sub               ; |302| 
        NOP
        LD        B,A                   ; |302| 
        ; call occurs [#_L_sub] ; |302| 
        RSBX      OVM
        SSBX      SXM
        SFTA      A,8                   ; |302| 
        SFTA      A,-8                  ; |302| 
        BC        L24,AGEQ              ; |302| 
        ; branch occurs ; |302| 
;** 305	-----------------------    L_dist_min = L_tmp;
;** 306	-----------------------    index1 = _sadd(cand1, i);
;** 307	-----------------------    index2 = _sadd(cand2, j);
	.line	264
;----------------------------------------------------------------------
; 305 | L_dist_min = L_tmp;                                                    
;----------------------------------------------------------------------
        DLD       *SP(28),A
        DST       A,*SP(32)             ; |305| 
	.line	265
;----------------------------------------------------------------------
; 306 | index1 = add(cand1,i);                                                 
;----------------------------------------------------------------------
        LD        *SP(30),B
        LD        *SP(4),16,A           ; |306| 
        SSBX      OVM
        ADD       *(BL),16,A,A          ; |306| 
        SFTA      A,-16,A               ; |306| 
        STL       A,*SP(37)
	.line	266
;----------------------------------------------------------------------
; 307 | index2 = add(cand2,j);                                                 
;----------------------------------------------------------------------
        RSBX      OVM
        NOP
        LD        *SP(5),16,A           ; |307| 
        SSBX      OVM
        ADD       *(AR1),16,A,A         ; |307| 
        SFTA      A,-16,A               ; |307| 
        STL       A,*SP(38)
L24:    
;**	-----------------------g29:
;** 310	-----------------------    U$169 += 2;
;** 310	-----------------------    if ( (++j) < 8 ) goto g27;
	.line	269
        MAR       *AR1+
        RSBX      OVM
        LD        *(AR1),A              ; |310| 
        SUB       #8,A,A                ; |310| 
        BCD       L23,ALT               ; |310| 
        MAR       *+AR6(#2)
        ; branch occurs ; |310| 
;** 311	-----------------------    U$176 += 2;
;** 311	-----------------------    if ( (++i) < 4 ) goto g25;
	.line	270
        LD        *SP(30),A
        ADD       #1,A
        STL       A,*SP(30)
        LD        *(AL),A               ; |311| 
        SUB       #4,A,A                ; |311| 
        BCD       L22,ALT               ; |311| 
        MAR       *+AR7(#2)
        ; branch occurs ; |311| 
;** 311	-----------------------    goto g40;
        B         L29                   ; |311| 
        ; branch occurs ; |311| 
L25:    
;**	-----------------------g31:
;**  	-----------------------    #pragma MUST_ITERATE(4, 4, 4)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$164 = cand2*2;
;**  	-----------------------    C$4 = &gbk1;
;**  	-----------------------    U$176 = &C$4[2*cand1];
;**  	-----------------------    K$175 = C$4;
;**  	-----------------------    K$168 = &gbk2;
;** 250	-----------------------    i = 0;
        LD        *SP(5),A
        STL       A,#1,*SP(35)
        LD        #_gbk1,A
        ADD       *SP(4),#1,A,B
        STL       A,*SP(39)
        LD        #_gbk2,A
        STL       A,*SP(40)
        STLM      B,AR7
	.line	209
        LD        #0,A
        STL       A,*SP(30)
L26:    
;**	-----------------------g33:
;**  	-----------------------    #pragma MUST_ITERATE(8, 8, 8)
;**  	-----------------------    #pragma LOOP_FLAGS(5120u)
;**  	-----------------------    U$169 = &K$168[U$164];
;** 251	-----------------------    j = 0;
        LD        *SP(40),B
        LD        *SP(35),A
        ADD       *(BL),A
        STLM      A,AR1
        NOP
	.line	210
        STM       #0,AR6
L27:    
;**	-----------------------g35:
;** 252	-----------------------    if ( (g_pitch = _sadd(*U$176, *U$169)) >= 16383 ) goto g38;
	.line	211
        LD        *AR7,16,A             ; |252| 
        SSBX      OVM
        NOP
        ADD       *AR1,16,A,A           ; |252| 
        RSBX      OVM
        SFTA      A,-16,A               ; |252| 
        STL       A,*SP(25)
        LD        *(AL),A               ; |252| 
        SUB       #16383,A,A            ; |252| 
        BC        L28,AGEQ              ; |252| 
        ; branch occurs ; |252| 
;** 257	-----------------------    tmp = L_shr(_lsadd((long)U$176[1], (long)U$169[1]), 1);
;** 262	-----------------------    C$3 = _smpy(gcode0, tmp);
;** 262	-----------------------    g_pit_cod = _smpy(C$3, g_pitch);
;** 264	-----------------------    L_tmp = Mpy_32_16(coeff[0], coeff_lsf[0], _smpy(g_pitch, g_pitch));
;** 265	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[1], coeff_lsf[1], g_pitch));
;** 266	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[2], coeff_lsf[2], _smpy(C$3, C$3)));
;** 267	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[3], coeff_lsf[3], C$3));
;** 268	-----------------------    L_tmp = _lsadd(L_tmp, Mpy_32_16(coeff[4], coeff_lsf[4], g_pit_cod));
;** 270	-----------------------    if ( (L_temp = L_sub(L_tmp, L_dist_min)) >= 0L ) goto g38;
	.line	216
        ST        #1,*SP(0)             ; |257| 
        LD        *AR1(1),B             ; |257| 
        LD        *AR7(1),A             ; |257| 
        SSBX      OVM
        RSBX      SXM
        RSBX      FRCT
        ADD       B,A                   ; |257| 
        RSBX      OVM
        NOP
        CALL      #_L_shr               ; |257| 
        ; call occurs [#_L_shr] ; |257| 
	.line	221
        SSBX      SXM
        RSBX      OVM
        SSBX      FRCT
        LD        *(AL),16,A            ; |262| 
        SSBX      OVM
        NOP
        MPYA      *SP(6)                ; |262| 
        SFTA      B,-16,A               ; |262| 
        STL       A,*SP(41)
        RSBX      OVM
        LD        *SP(25),A
        LD        *(AL),16,A            ; |262| 
        SSBX      OVM
        LD        *SP(41),T
        NOP
        MPYA      A                     ; |262| 
        SFTA      A,-16,A               ; |262| 
        STL       A,*SP(34)
	.line	223
        LD        *SP(13),A
        STL       A,*SP(0)
        LD        *SP(25),A
        RSBX      OVM
        LD        *(AL),16,A            ; |264| 
        LD        *SP(25),T
        SSBX      OVM
        NOP
        MPYA      A                     ; |264| 
        STH       A,*SP(1)              ; |264| 
        RSBX      FRCT
        RSBX      OVM
        LD        *SP(8),A
        CALL      #_Mpy_32_16           ; |264| 
        ; call occurs [#_Mpy_32_16] ; |264| 
        DST       A,*SP(28)             ; |264| 
	.line	224
        LD        *SP(14),A
        STL       A,*SP(0)
        LD        *SP(25),A
        STL       A,*SP(1)
        RSBX      FRCT
        RSBX      OVM
        LD        *SP(9),A
        CALL      #_Mpy_32_16           ; |265| 
        ; call occurs [#_Mpy_32_16] ; |265| 
        SSBX      SXM
        SSBX      OVM
        DLD       *SP(28),B
        RSBX      SXM
        NOP
        ADD       A,B                   ; |265| 
        DST       B,*SP(28)             ; |265| 
	.line	225
        SSBX      SXM
        SSBX      FRCT
        LD        *SP(15),A
        RSBX      OVM
        STL       A,*SP(0)
        LD        *SP(41),A
        LD        *(AL),16,A            ; |266| 
        LD        *SP(41),T
        SSBX      OVM
        NOP
        MPYA      A                     ; |266| 
        RSBX      FRCT
        STH       A,*SP(1)              ; |266| 
        RSBX      OVM
        LD        *SP(10),A
        CALL      #_Mpy_32_16           ; |266| 
        ; call occurs [#_Mpy_32_16] ; |266| 
        SSBX      SXM
        NOP
        DLD       *SP(28),B
        RSBX      SXM
        SSBX      OVM
        NOP
        ADD       A,B                   ; |266| 
        DST       B,*SP(28)             ; |266| 
	.line	226
        LD        *SP(16),A
        STL       A,*SP(0)
        LD        *SP(41),A
        RSBX      OVM
        RSBX      FRCT
        STL       A,*SP(1)
        LD        *SP(11),A
        CALL      #_Mpy_32_16           ; |267| 
        ; call occurs [#_Mpy_32_16] ; |267| 
        SSBX      SXM
        NOP
        DLD       *SP(28),B
        SSBX      OVM
        RSBX      SXM
        NOP
        ADD       A,B                   ; |267| 
        DST       B,*SP(28)             ; |267| 
	.line	227
        LD        *SP(17),A
        STL       A,*SP(0)
        LD        *SP(34),A
        STL       A,*SP(1)
        RSBX      FRCT
        RSBX      OVM
        LD        *SP(12),A
        CALL      #_Mpy_32_16           ; |268| 
        ; call occurs [#_Mpy_32_16] ; |268| 
        SSBX      SXM
        SSBX      OVM
        DLD       *SP(28),B
        RSBX      SXM
        NOP
        ADD       A,B                   ; |268| 
        DST       B,*SP(28)             ; |268| 
	.line	229
        RSBX      OVM
        NOP
        DLD       *SP(32),A
        RSBX      FRCT
        DST       A,*SP(0)              ; |270| 
        CALLD     #_L_sub               ; |270| 
        NOP
        LD        B,A                   ; |270| 
        ; call occurs [#_L_sub] ; |270| 
        RSBX      OVM
        SSBX      SXM
        SFTA      A,8                   ; |270| 
        SFTA      A,-8                  ; |270| 
        BC        L28,AGEQ              ; |270| 
        ; branch occurs ; |270| 
;** 273	-----------------------    L_dist_min = L_tmp;
;** 274	-----------------------    index1 = _sadd(cand1, i);
;** 275	-----------------------    index2 = _sadd(cand2, j);
	.line	232
        DLD       *SP(28),A
        DST       A,*SP(32)             ; |273| 
	.line	233
        LD        *SP(30),B
        LD        *SP(4),16,A           ; |274| 
        SSBX      OVM
        ADD       *(BL),16,A,A          ; |274| 
        SFTA      A,-16,A               ; |274| 
        STL       A,*SP(37)
	.line	234
        RSBX      OVM
        NOP
        LD        *SP(5),16,A           ; |275| 
        SSBX      OVM
        ADD       *(AR6),16,A,A         ; |275| 
        SFTA      A,-16,A               ; |275| 
        STL       A,*SP(38)
L28:    
;**	-----------------------g38:
;** 278	-----------------------    U$169 += 2;
;** 278	-----------------------    if ( (++j) < 8 ) goto g35;
	.line	237
        MAR       *AR6+
        RSBX      OVM
        LD        *(AR6),A              ; |278| 
        SUB       #8,A,A                ; |278| 
        BCD       L27,ALT               ; |278| 
        MAR       *+AR1(#2)
        ; branch occurs ; |278| 
;** 279	-----------------------    U$176 += 2;
;** 279	-----------------------    if ( (++i) < 4 ) goto g33;
	.line	238
        LD        *SP(30),A
        ADD       #1,A
        STL       A,*SP(30)
        LD        *(AL),A               ; |279| 
        SUB       #4,A,A                ; |279| 
        BCD       L26,ALT               ; |279| 
        MAR       *+AR7(#2)
        ; branch occurs ; |279| 
L29:    
;**	-----------------------g40:
;** 318	-----------------------    C$2 = &K$168[2*index2];
;** 318	-----------------------    C$1 = &K$175[2*index1];
;** 318	-----------------------    *gain_pit = _sadd(*C$1, *C$2);
;** 325	-----------------------    L_gbk12 = _lsadd((long)C$1[1], (long)C$2[1]);
;** 326	-----------------------    tmp = L_shr(L_gbk12, 1);
;** 329	-----------------------    L_acc = L_shl(_lsmpy(tmp, gcode0), _sadd(_sneg(exp_gcode0), 4));
;** 330	-----------------------    *gain_cod = L_acc>>16;
;** 335	-----------------------    Gain_update(K$12, L_gbk12);
;** 337	-----------------------    return _sadd(map1[index1]<<4, map2[index2]);
	.line	277
;----------------------------------------------------------------------
; 318 | *gain_pit = add( gbk1[index1][0], gbk2[index2][0] );      /* Q14 */    
; 323 | L_acc = L_deposit_l( gbk1[index1][1] );                                
; 324 | L_accb = L_deposit_l( gbk2[index2][1] );                               
;----------------------------------------------------------------------
        LD        *SP(38),B
        LD        *SP(40),A
        ADD       B,#1,A                ; |318| 
        STLM      A,AR2
        LD        *SP(37),B
        LD        *SP(39),A
        ADD       B,#1,A                ; |318| 
        STLM      A,AR1
        NOP
        NOP
        LD        *AR1,16,A             ; |318| 
        SSBX      OVM
        MVDK      *SP(27),*(AR3)
        ADD       *AR2,16,A,A           ; |318| 
        STH       A,*AR3                ; |318| 
	.line	284
;----------------------------------------------------------------------
; 325 | L_gbk12 = L_add( L_acc, L_accb );                          /* Q13 */   
;----------------------------------------------------------------------
        RSBX      OVM
        LD        *AR2(1),B             ; |325| 
        LD        *AR1(1),A             ; |325| 
        RSBX      SXM
        SSBX      OVM
        NOP
        ADD       B,A                   ; |325| 
        DST       A,*SP(28)             ; |325| 
	.line	285
;----------------------------------------------------------------------
; 326 | tmp = extract_l( L_shr( L_gbk12,1 ) );                     /* Q12 */   
; 327 | L_acc = L_mult(tmp, gcode0);                /* Q[exp_gcode0+12+1] */   
;----------------------------------------------------------------------
        RSBX      FRCT
        RSBX      OVM
        ST        #1,*SP(0)             ; |326| 
        CALL      #_L_shr               ; |326| 
        ; call occurs [#_L_shr] ; |326| 
	.line	288
;----------------------------------------------------------------------
; 329 | L_acc = L_shl(L_acc, add( negate(exp_gcode0),(-12-1+1+16) ));          
;----------------------------------------------------------------------
        SSBX      SXM
        RSBX      OVM
        NOP
        LD        *SP(7),16,B           ; |329| 
        SSBX      OVM
        NOP
        NEG       B,B                   ; |329| 
        ADD       #4,16,B,B             ; |329| 
        STH       B,*SP(0)              ; |329| 
        LD        *SP(6),T
        SSBX      FRCT
        MPY       *(AL),A               ; |329| 
        RSBX      FRCT
        RSBX      OVM
        NOP
        CALL      #_L_shl               ; |329| 
        ; call occurs [#_L_shl] ; |329| 
	.line	289
;----------------------------------------------------------------------
; 330 | *gain_cod = extract_h( L_acc );                             /* Q1 */   
;----------------------------------------------------------------------
        SFTL      A,#-16,A              ; |330| 
        MVDK      *SP(26),*(AR1)
        STL       A,*AR1                ; |330| 
	.line	294
;----------------------------------------------------------------------
; 335 | Gain_update( past_qua_en, L_gbk12 );                                   
;----------------------------------------------------------------------
        RSBX      OVM
        NOP
        DLD       *SP(28),A
        RSBX      FRCT
        DST       A,*SP(0)              ; |335| 
        LD        *SP(36),A
        CALL      #_Gain_update         ; |335| 
        ; call occurs [#_Gain_update] ; |335| 
	.line	296
;----------------------------------------------------------------------
; 337 | return( add( map1[index1]*(Word16)NCODE2, map2[index2] ) );            
;----------------------------------------------------------------------
        RSBX      OVM
        MVDK      *SP(37),*(AR1)
        LD        *AR1(_map1),#4,A      ; |337| 
        SSBX      SXM
        LD        *(AL),16,A            ; |337| 
        SSBX      OVM
        MVDK      *SP(38),*(AR1)
        ADD       *AR1(_map2),16,A,A    ; |337| 
        SFTA      A,-16,A               ; |337| 
	.line	298
        ANDM      #-833,*(ST1)          ; |337| 
        ANDM      #-4,*(PMST)           ; |337| 
        FRAME     #42                   ; |337| 
        POPM      AR7                   ; |337| 
        POPM      AR6                   ; |337| 
        POPM      AR1                   ; |337| 
        RET       ; |337| 
        ; return occurs ; |337| 
	.endfunc	339,000018400h,45


;***************************************************************
;* UNDEFINED EXTERNAL REFERENCES                               *
;***************************************************************
	.global	_L_sub
	.global	_L_shl
	.global	_L_shr
	.global	_L_Extract
	.global	_Mpy_32_16
	.global	_Gain_predict
	.global	_Gain_update
	.global	_divs
	.global	_crshft
	.global	_clshft
	.global	_gbk1
	.global	_gbk2
	.global	_map1
	.global	_map2
	.global	_coef
	.global	_L_coef
	.global	_thr1
	.global	_thr2

;***************************************************************
;* TYPE INFORMATION                                            *
;***************************************************************
	.sym	_Word16, 0, 3, 13, 16
	.sym	_Word16, 0, 3, 13, 16
	.sym	_Word32, 0, 5, 13, 32
