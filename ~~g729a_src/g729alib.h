/********************************************************/
/*		Filename : g729alib.h                             */
/*    Description: define g729alib entry                */     
/********************************************************/



extern void G729aCoder_Init();
void G729aCoder(Word16 SpeechBuf[],Word16 serial[]);
void G729aDecoder_Init();
void G729aDecoder(Word16 serial[], Word16 speech[]);
