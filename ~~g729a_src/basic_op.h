/*___________________________________________________________________________
 |                                                                           |
 |   Constants and Globals                                                   |
 |___________________________________________________________________________|
*/

#define MAX_32 (Word32)0x7fffffffL
#define MIN_32 (Word32)0x80000000L

#define MAX_16 (Word16)0x7fff
#define MIN_16 (Word16)0x8000

/*___________________________________________________________________________
 |                                                                           |
 |   Operators prototypes                                                    |
 |___________________________________________________________________________|
*/
#define 	add  		_sadd
#define 	L_add 		_lsadd
#define 	L_mac		_smac
#define 	L_abs		_labss
#define 	norm_l		_lnorm
#define 	norm_s		_norm
#define 	sub			_ssub
#define 	mult		_smpy
#define 	L_mult		_lsmpy
#define 	negate		_sneg
#define 	round		_rnd
#define 	L_msu		_smas
#define 	L_add_c		_addc
#define 	L_sub_c		_subc
#define 	abs_s		_abss
#define 	L_negate	_lsneg
#define 	mult_r 		_smpyr
//#define 	shr(a,b)       (crshft((a),(b)))
//#define 	shl(a,b)       (clshft((a),(b)))
#define 	shr_r(a,b)     (crshft_r((a),(b)))
#define 	L_shr_r(a,b)   (L_crshft_r((a),(b)))
#define 	L_deposit_h(a) ((long)a<<16)        
#define 	L_deposit_l(a) (a)
#define 	extract_h(a)   ((unsigned)((a)>>16))  
#define 	extract_l(a)   ((int)a) 
#define 	div_s(a,b)     (divs(a,b))

Word16  Verifi_Overflow(Word16 init, Word16  signal[], Word16 scal_sig[] ,Word16 lp1,Word16 lp2,Word16 lp3,Word32 *s);
  
Word32 L_sub(Word32 L_var1, Word32 L_var2);
Word32 L_shl(Word32 L_var1, Word16 var2); 
Word32 L_shr(Word32 L_var1, Word16 var2); 
Word16 shl(Word16 L_var1, Word16 L_var2);
Word16 shr(Word16 L_var1, Word16 L_var2);
