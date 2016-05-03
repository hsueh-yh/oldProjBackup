/*
   ITU-T G.729A Speech Coder    ANSI-C Source Code
   Version 1.1    Last modified: September 1996

   Copyright (c) 1996,
   AT&T, France Telecom, NTT, Universite de Sherbrooke
   All rights reserved.
*/

/*-------------------------------------------------------------------*
 * Function  Qua_lsp:                                                *
 *           ~~~~~~~~                                                *
 *-------------------------------------------------------------------*/
#include "typedef.h"
#include "basic_op.h"

#include "ld8a.h"
#include "tab_ld8a.h"

void Qua_lsp(
  Word16 lsp[],       /* (i) Q15 : Unquantized LSP            */
  Word16 lsp_q[],     /* (o) Q15 : Quantized LSP              */
  Word16 ana[]        /* (o)     : indexes                    */
)
{
  Word16 lsf[M], lsf_q[M];  /* domain 0.0<= lsf <PI in Q13 */

  /* Convert LSPs to LSFs */
  Lsp_lsf2(lsp, lsf, M);

  Lsp_qua_cs(lsf, lsf_q, ana );

  /* Convert LSFs to LSPs */
  Lsf_lsp2(lsf_q, lsp_q, M);

  return;
}

/* static memory */

static Word16 freq_prev[MA_NP][M];    /* Q13:previous LSP vector       */
static Word16 freq_prev_reset[M] = {  /* Q13:previous LSP vector(init) */
  2339, 4679, 7018, 9358, 11698, 14037, 16377, 18717, 21056, 23396
};     /* PI*(float)(j+1)/(float)(M+1) */


void Lsp_encw_reset(void)
{
  Word16 i;

  for(i=0; i<MA_NP; i++)
    Copy( &freq_prev_reset[0], &freq_prev[i][0], M );
}


void Lsp_qua_cs(
  Word16 flsp_in[M],    /* (i) Q13 : Original LSP parameters    */
  Word16 lspq_out[M],   /* (o) Q13 : Quantized LSP parameters   */
  Word16 *code          /* (o)     : codes of the selected LSP  */
)
{
  Word16 wegt[M];       /* Q11->normalized : weighting coefficients */

  Get_wegt( flsp_in, wegt );

  Relspwed( flsp_in, wegt, lspq_out, lspcb1, lspcb2, fg,
    freq_prev, fg_sum, fg_sum_inv, code);
}

void Relspwed(
  Word16 lsp[],                 /* (i) Q13 : unquantized LSP parameters */
  Word16 wegt[],                /* (i) norm: weighting coefficients     */
  Word16 lspq[],                /* (o) Q13 : quantized LSP parameters   */
  Word16 lspcb1[][M],           /* (i) Q13 : first stage LSP codebook   */
  Word16 lspcb2[][M],           /* (i) Q13 : Second stage LSP codebook  */
  Word16 fg[MODE][MA_NP][M],    /* (i) Q15 : MA prediction coefficients */
  Word16 freq_prev[MA_NP][M],   /* (i) Q13 : previous LSP vector        */
  Word16 fg_sum[MODE][M],       /* (i) Q15 : present MA prediction coef.*/
  Word16 fg_sum_inv[MODE][M],   /* (i) Q12 : inverse coef.              */
  Word16 code_ana[]             /* (o)     : codes of the selected LSP  */
)
{
  Word16 mode, j;
  Word16 index, mode_index;
  Word16 cand[MODE], cand_cur;
  Word16 tindex1[MODE], tindex2[MODE];
  Word32 L_tdist[MODE];         /* Q26 */
  Word16 rbuf[M];               /* Q13 */
  Word16 buf[M];                /* Q13 */

  for(mode = 0; mode<MODE; mode++) {
    Lsp_prev_extract(lsp, rbuf, fg[mode], freq_prev, fg_sum_inv[mode]);

    Lsp_pre_select(rbuf, lspcb1, &cand_cur );
    cand[mode] = cand_cur;

    Lsp_select_1(rbuf, lspcb1[cand_cur], wegt, lspcb2, &index);

    tindex1[mode] = index;

    for( j = 0 ; j < NC ; j++ )
      buf[j] = add( lspcb1[cand_cur][j], lspcb2[index][j] );

    Lsp_expand_1(buf, GAP1);

    Lsp_select_2(rbuf, lspcb1[cand_cur], wegt, lspcb2, &index);

    tindex2[mode] = index;

    for( j = NC ; j < M ; j++ )
      buf[j] = add( lspcb1[cand_cur][j], lspcb2[index][j] );

    Lsp_expand_2(buf, GAP1);

    Lsp_expand_1_2(buf, GAP2);

    Lsp_get_tdist(wegt, buf, &L_tdist[mode], rbuf, fg_sum[mode]);
  }

  Lsp_last_select(L_tdist, &mode_index);

  code_ana[0] = shl( mode_index,NC0_B ) | cand[mode_index];
  code_ana[1] = shl( tindex1[mode_index],NC1_B ) | tindex2[mode_index];

  Lsp_get_quant(lspcb1, lspcb2, cand[mode_index],
      tindex1[mode_index], tindex2[mode_index],
      fg[mode_index], freq_prev, lspq, fg_sum[mode_index]) ;

  return;
}

