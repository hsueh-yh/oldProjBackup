/****************************************************************************
 Entry.c
 
 Define G729ALIB ENTRY ROUTINE

*****************************************************************************/
#include <stdio.h>
#include <stdlib.h>

#include "typedef.h"
#include "basic_op.h"
#include "ld8a.h"
/*****************************************************************************/
/* Global Variables                                                          */
/*****************************************************************************/

//static volatile Word16 bad_lsf;
Word16 bad_lsf;

void G729aCoder_Init()
{
    Init_Pre_Process();
    Init_Coder_ld8a();	
}
void G729aCoder(Word16 SpeechBuf[],Word16 serial[])
{     
    extern Word16 *new_speech;       /* Pointer to new speech data           */
    Word16 prm[PRM_SIZE];            /* Analysis parameters.               */
    Word16 i;

    for(i=0;i<L_FRAME;i++)
    	new_speech[i]=SpeechBuf[i];
    	
    Set_zero(prm, PRM_SIZE);
    	
    Pre_Process(new_speech, L_FRAME);
    Coder_ld8a(prm);
    prm2bits_ld8k( prm, serial);
}
void G729aDecoder_Init()
{
	extern Word16 *synth;
	  
    bad_lsf = 0;          /* Initialize bad LSF indicator */
    
    Init_Decod_ld8a();
    Init_Post_Filter();
    Init_Post_Process();
}
void G729aDecoder(Word16 serial[], Word16 speech[])
{
	extern  Word16  *synth; /* Synthesis                   */
	Word16  parm[PRM_SIZE+1];             /* Synthesis parameters        */
	Word16  Az_dec[MP1*2];                /* Decoded Az for post-filter  */
	Word16  T2[2];                        /* Pitch lag for 2 subframes   */
	Word16  i;
	  		
    bits2prm_ld8k( &serial[2], &parm[1]);
    
    parm[0] = 0;          
    for (i=2; i < SERIAL_SIZE; i++)
      if (serial[i] == 0 ) parm[0] = 1; 
    
    parm[4] = Check_Parity_Pitch(parm[3], parm[4]);
    Decod_ld8a(parm, synth, Az_dec, T2);  
    Post_Filter(synth, Az_dec, T2);       

    Post_Process(synth, L_FRAME);   
    
    for(i=0;i<L_FRAME;i++)
    	speech[i]=synth[i];
}
/**************************************
DaiZhichun add this fun 2005.8.20
for the prev L_Comp can't work correctly
**************************************/

Word32 L_Comp(Word16 hi, Word16 lo)
{
  Word32 L_32;

  L_32 = L_deposit_h(hi);
  return( L_mac(L_32, lo, 1));          /* = hi<<16 + lo<<1 */
}

