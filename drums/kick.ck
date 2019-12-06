BPM tempo;

SndBuf kick => Dyno dynamics => dac;

//

me.dir(-1) + "audio/kick.wav" => kick.read;
kick.samples() => kick.pos;
.5 => kick.rate;
.75 => kick.gain;

dynamics.limit();
.5 => dynamics.thresh;

//

[0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0] @=> int sequence[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {
            0 => kick.pos;
            
        }
        
        tempo.note / sequence.cap() => now;     
    }
}