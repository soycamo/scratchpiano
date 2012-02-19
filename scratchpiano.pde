/* -------Arduino Proto-Synth 08/07/07
  --------Collin Cunningham - Narbotic.net
  --------with portions of code from "Freqout" by Paul Badger and "MIDI drum kit" by Tod E. Kurt

  This is my stab at a monophonic synthesizer for the Arduino and my first stab at coding anything really. 
  It reads input on Analog0 for a stepped pitch transposition. Each note switch(digipins 1-10 & 13) connects to 
  ground in order to register. Higher notes get priority.  Pin 11 is speaker output.  
  I used a little RC Low Pass Filter to smooth out the sound:
  
  PIN11->------\/\/\---o----\/\/\----o-------> OUTPUT
               1K      |    1K       |
                       |             |
                   .1uF_cap      .1uF_cap
                       |             |
                      GND           GND
                      
            (no clue how to draw caps in ascii)
                      
  Features I'd like to add 
  - Another octave (maybe add a transpose switch on each of the next octave, then they can share pins with the first)
  - Last note hit priority
  - Portamento (note-slide)
  - Real sine wave out (no external LPF anymore please) 
  - Polyphony (I had it working badly, need better math)
  - any real keyboard feature in existance(or not) attack, decay, waveform, vibrato, etc.
  
Contact me at narbotic.net with any suggestions/help - and if you improve any of the code please send it on over.

*/

#include <math.h>

#define speakerOut 3
#define switchAPin 2   //(this should be for key2
#define key1 4   //key 1
// VCC is Key 2. Don't press. NOPRESS. NO. stop it.
#define key3 5   //key 3
#define key4 6   //key 4
#define key5 7   //key 5
#define key6 8   //key 6
#define key7 9   //key 7
#define key8 10  //key 8
#define key9 11  //key 9
#define key10 12  //key 10
#define key11 13  //key 11
#define key12 14  //key 12
#define key13 15  //key 13
#define key14 16  //key 14
#define key15 17  //key15
#define key16 18  //key16
#define key17 19  //key17

float pitchval = 1;
float val = 0;

float freq;

float noteval;
//note values
float C     = 261.626;
float CS    = 277.183;
float D     = 293.665;
float DS    = 311.127;
float E     = 329.628;
float F     = 349.228;
float FS    = 369.994;
float G     = 391.995;
float GS    = 415.305;
float AA2   = 440;
float AA2S  = 466.164;
float B2    = 493.883; 
float C2    = 523.251;
float C2S   = 554.364;
float D2    = 587.33;
float D2S   = 622.254;
float E2    = 659.255;
float F2    = 698.456;
float F2S   = 700;
float G2    = 700;
float G2S   = 700;
float AA3   = 880; 

// just checking...
float t = 1;

void setup() {
  pinMode(key1, INPUT);
  pinMode(key3, INPUT);
  pinMode(key4, INPUT);
  pinMode(key5, INPUT);
  pinMode(key6, INPUT);
  pinMode(key7, INPUT);
  pinMode(key8, INPUT);
  pinMode(key9, INPUT);
  pinMode(key10, INPUT);
  pinMode(key11, INPUT);
  pinMode(key12, INPUT);
  pinMode(key13, INPUT);
  pinMode(key14, INPUT);
  pinMode(key15, INPUT);
  pinMode(key16, INPUT);
  pinMode(key17, INPUT);

  pinMode(speakerOut, OUTPUT);
  
  // comment out these lines for a surprise!:
  digitalWrite(key1, HIGH);  // turn on internal pullup
  digitalWrite(key3, HIGH);  // turn on internal pullup
  digitalWrite(key4, HIGH);  // turn on internal pullup
  digitalWrite(key5, HIGH);  // turn on internal pullup
  digitalWrite(key6, HIGH);  // turn on internal pullup
  digitalWrite(key7, HIGH);  // turn on internal pullup
  digitalWrite(key8, HIGH);  // turn on internal pullup
  digitalWrite(key9, HIGH);  // turn on internal pullup
  digitalWrite(key10, HIGH);  // turn on internal pullup
  digitalWrite(key11, HIGH);  // turn on internal pullup
  digitalWrite(key12, HIGH);  // turn on internal pullup
  digitalWrite(key13, HIGH);  // turn on internal pullup
  digitalWrite(key14, HIGH);  // turn on internal pullup
  digitalWrite(key15, HIGH);  // turn on internal pullup
  digitalWrite(key16, HIGH);  // turn on internal pullup
  digitalWrite(key17, HIGH);  // turn on internal pullup
}

// Pins are read in reverse to give higher key priority

void loop() {

  if( digitalRead(key17) == LOW ) 
  {
    noteval = E2;
    freqout(noteval, t);
  }

  else if( digitalRead(key16) == LOW ) 
  {
    noteval = D2S;
    freqout(noteval, t);
  }

  else if( digitalRead(key15) == LOW ) 
  {
    noteval = D2;
    freqout(noteval, t);
  }

  else if( digitalRead(key14) == LOW ) 
  {
    noteval = C2S;
    freqout(noteval, t);
  }

  else if( digitalRead(key13) == LOW ) 
  {
    noteval = C2;
    freqout(noteval, t);
  }

  else if( digitalRead(key12) == LOW ) 
  {
    noteval = B2;
    freqout(noteval, t);
  }

  else if( digitalRead(key11) == LOW ) 
  {
    noteval = AA2S;
    freqout(noteval, t);
  }

  else if( digitalRead(key10) == LOW ) 
  {
    noteval = AA2;
    freqout(noteval, t);
  }

  else if( digitalRead(key9) == LOW ) 
  {
    noteval = GS;
    freqout(noteval, t);
  }

  else if( digitalRead(key8) == LOW ) 
  {
    noteval = G;
    freqout(noteval, t);
  }

  else if( digitalRead(key7) == LOW ) 
  {
    noteval = FS;
    freqout(noteval, t);
  }

  else if( digitalRead(key6) == LOW ) 
  {
    noteval = F;
    freqout(noteval, t);
  }

  else if( digitalRead(key5) == LOW ) 
  {
    noteval = E;
    freqout(noteval, t);
  }

  else if( digitalRead(key4) == LOW ) 
  {
    noteval = DS;
    freqout(noteval, t);
  }

  else if( digitalRead(key3) == LOW ) 
  {
    noteval = D;
    freqout(noteval, t);
  }
  
/*  else if( digitalRead(key2) == LOW ) 
  {
    noteval = CS;
    freqout(noteval, t);
  }
*/

  else if( digitalRead(key1) == LOW ) 
  {
    noteval = C;
    freqout(noteval, t);
  }

  else 
  {
    digitalWrite(speakerOut, LOW);
  }
}

//freqout code by Paul Badger (and hacked a bit by me)
void freqout(float freq, float t) 
{ 
    int hperiod;     //calculate 1/2 period in us 
    long cycles, i; 
    hperiod = (500000 / ((freq - 7) * pitchval));             // subtract 7 us to make up for digitalWrite overhead - determined empirically 
    // calculate cycles 
    cycles = (long) ((freq * t) / 1000);    // calculate cycles 

    for (i=0; i<= cycles; i++){              // play note for t ms  
       digitalWrite(speakerOut, HIGH);  
       delayMicroseconds(hperiod); 
       digitalWrite(speakerOut, LOW);  
       delayMicroseconds(hperiod - 1);     // - 1 to make up for fractional microsecond in digitaWrite overhead 
    } 
}

void playNote(int pin)
{
   switch(pin){
     
   }    
}
