BPM tempo;

Gain master;
SawOsc voice1 => master;
SawOsc voice2 => master;
SawOsc voice3 => master;
SawOsc voice4 => master;
SawOsc voice5 => master;
master => ADSR adsr => Pan2 stereo => dac;

master => Delay d1 => dac.left;
master => Delay d2 => dac.right;
master => Delay d3 => dac;
d1 => d1;
d2 => d2;
d3 => d3;

//

(1.0 / 30.0) => master.gain;

(tempo.note * 1.3, 250 :: ms, 1.0, tempo.note * 2) => adsr.set;

tempo.note => d1.max => d2.max => d3.max;
tempo.eighthNote => d1.delay;
tempo.note / Math.random2(1, 3) => d3.delay;
.3 => d1.gain;
Math.random2f(.05, .2) => d2.gain;
.5 => d3.gain;

//

47 => int key;
[key, key - 4] @=> int sequence[];
[0, 1] @=> int harmonics[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (Math.random2(0, 1)) 47 => key;
        else 47 + 12 => key;
        
        Math.random2f(-1, 1) => stereo.pan;
        
        tempo.eighthNote * Math.random2f(.5, 1.5) => d2.delay;

        sequence[step] => Std.mtof => voice1.freq;
        if (harmonics[step]) sequence[step] + 4 => Std.mtof => voice2.freq;
        else sequence[step] + 3 => Std.mtof => voice2.freq;
        sequence[step] + 7 => Std.mtof => voice3.freq;
        if (harmonics[step]) sequence[step] + 11 => Std.mtof => voice4.freq;
        else sequence[step] + 10 => Std.mtof => voice4.freq;
        sequence[step] - 12 => Std.mtof => voice5.freq;

        1 => adsr.keyOn;
        (tempo.note * 3) - adsr.releaseTime() => now;
        1 => adsr.keyOff;
        adsr.releaseTime() => now;

        // one bar pause
        tempo.note => now;
    }
}