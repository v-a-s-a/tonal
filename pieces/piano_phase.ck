
//Wurley voc => JCRev r => dac;
//220.0 => voc.freq;
//0.95 => voc.gain;
//.8 => r.gain;
//.1 => r.mix;

//StifKarp m => NRev r => dac;
//.75 => r.gain;
//.02 => r.mix;

//Rhodey voc => JCRev r => Echo a => Echo b => Echo c => dac;
//220.0 => voc.freq;
//0.8 => voc.gain;
//.8 => r.gain;
//.2 => r.mix;
//1000::ms => a.max => b.max => c.max;
//750::ms => a.delay => b.delay => c.delay;
//.50 => a.mix => b.mix => c.mix;

BlowBotl voice1 => JCRev r => Delay d => dac.left;
BlowBotl voice2 => r => d => dac.right;
0.1 => voice1.noiseGain;
0.1 => voice2.noiseGain;
0.01 => voice1.rate;
0.01 => voice1.rate;
0.2 => d.gain;

80 => int tempo; // Maelzel Metronome units (quarters per minute)

[64, 66, 71, 73, 74, 66, 64, 73, 71, 66, 74, 73] @=> int score[];

0 => int player1_note;
0 => int player2_note;

0 => int finish_piece;

fun void player1(int tempo) {
    0 => int bar;
    
    240000::ms / ( 1 * tempo )  => dur whole;
    whole / 16 => dur sixteenth;

    while(true) {
        
        for (0 => int i; i < score.cap(); i++) {
            Std.mtof(score[i]) => voice1.freq;
            1 => voice1.noteOn;
            sixteenth => now;
            
            i => player1_note;
            if ((bar > 20) && (player1_note == player2_note)) {
                1 => finish_piece;
            }
        }
        
        bar++;

        if (bar == 2) {
            sixteenth * 0.99 => sixteenth;
        } else if ((bar > 26) && (finish_piece == 1)) {
            0 => voice1.gain;
            0 => voice2.gain;
            break;
        }

    }
}

fun void player2(int tempo) {
    0 => int bar;
    240000::ms / ( 1 * tempo )  => dur whole;
    whole / 16 => dur sixteenth;
    
    while(true) {
        for (0 => int i; i < score.cap(); i++) {
            Std.mtof(score[i]) => voice2.freq;
            1 => voice2.noteOn;
            sixteenth => now;
            i => player2_note;
        }

        bar++;

        if ((bar > 26) && (finish_piece == 1) ) {
            break;
        }

    }    
    
}

spork ~ player1(tempo);
spork ~ player2(tempo);

while(true) {
    5::second => now;
}


