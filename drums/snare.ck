BPM tempo;

SndBuf snare => Dyno dynamics => Pan2 stereo => dac;

//

me.dir(-1) + "audio/snare.wav" => snare.read;
snare.samples() => snare.pos;
1.1 => snare.rate;
.4 => snare.gain;

dynamics.compress();

-.15 => stereo.pan;

//

[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0] @=> int sequence[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {            
            0 => snare.pos;
        }

        tempo.note / sequence.cap() => now;
    }
}