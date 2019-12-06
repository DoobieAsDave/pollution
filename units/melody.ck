BPM tempo;

// Master channel
Gain master;

// Operator chain
SinOsc voice1 => master;
TriOsc voice2 => master;
master => ADSR adsr => Delay delay => dac;

// Delay chain
delay => delay;

// Reverberation chain
delay => Delay rev1 => dac;
delay => Delay rev2 => dac;
delay => Delay rev3 => dac;
rev1 => rev1;
rev2 => rev2;
rev3 => rev3;

//

(1.0 / 6.0) => master.gain;

(50 :: ms, 100 :: ms, 1.0, 90 :: ms) => adsr.set;

.3 => delay.gain;
tempo.note => delay.max;
tempo.note / 3 => delay.delay;

.015 => rev1.gain => rev2.gain => rev3.gain;
tempo.note => rev1.max => rev2.max => rev3.max;
tempo.quarterNote * Math.random2f(.7, .15) => rev1.delay;
tempo.quarterNote * Math.random2f(.7, .15) => rev2.delay;
tempo.quarterNote * Math.random2f(.7, .15) => rev3.delay;

//

float decayTime;
float reverbGain;

function void modDecayTime(ADSR adsr, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) / 2 => float steps;

    min => decayTime;

    while(true) {
        step +=> decayTime;
        decayTime :: ms => adsr.decayTime;

        if (decayTime >= max) {
            amount * -1 => step;
        }
        else if (decayTime <= min) {
            amount => step;
        }

        //<<<decayTime>>>;

        modTime / steps => now;        
    }
}
function void modReverbGain(Delay rev1, Delay rev2, Delay rev3, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) * 2 => float steps;

    min => reverbGain;

    while(true) {
        step +=> reverbGain;
        reverbGain => rev1.gain => rev2.gain => rev3.gain;

        if (reverbGain >= max) {
            amount * -1 => step;
        }
        else if (reverbGain <= min) {
            amount => step;
        }        

        modTime / steps => now;
    }
}

spork ~ modDecayTime(adsr, tempo.note / 3, 40.0, 100.0, 1);
spork ~ modReverbGain(rev1, rev2, rev3, tempo.note * 2, .01, .4, .001);

//

61 => int key;
[key, key + 3, key + 5, key + 7, key + 10] @=> int notes[];

while(true) {
    setADSR();

    notes[Math.random2(0, notes.cap() - 1)] => int note;    
    note => Std.mtof => voice1.freq;
    note + 7 => Std.mtof => voice2.freq;

    1 => adsr.keyOn;        
    tempo.sixteenthNote - adsr.releaseTime() => now;
        
    1 => adsr.keyOff;
    adsr.releaseTime() => now;
}

function void setADSR() {
    Math.random2(0, 50) :: ms => adsr.attackTime;
    Math.random2(0, 100) :: ms => adsr.releaseTime;
    Math.random2f(.6, 1) => adsr.sustainLevel;
}
