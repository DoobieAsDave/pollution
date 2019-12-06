BPM tempo;

Gain master;
SinOsc voice1 => master;
SinOsc voice2 => master;
master => ADSR adsr => Dyno dynamic => dac;

35 => int key;

//

1.5 => voice1.gain;
.5 => voice2.gain;

(1.0 / 5.0) => master.gain;

(5 :: ms, 25 :: ms, .95, 250 :: ms) => adsr.set;

dynamic.compress();
.8 => dynamic.thresh;

//

while(true) {
    for (0 => int step; step < 8; step++) {
        1 => adsr.keyOn;
        key => Std.mtof => voice1.freq;
        voice1.freq() / 2 => voice2.freq;

        tempo.quarterNote - adsr.releaseTime() => now;
        
        1 => adsr.keyOff;
        adsr.releaseTime() => now;
    }
}