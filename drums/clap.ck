BPM tempo;

SndBuf clap => HPF filter => Pan2 stereo => dac;

//

me.dir(-1) + "audio/clap.wav" => clap.read;
clap.samples() => clap.pos;
.4 => clap.gain;

100 => Std.mtof => filter.freq;

//

float filterFreq;
function void modFilterFreq(HPF filter, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) / 2 => float steps;

    min => filterFreq;

    while(true) {
        step +=> filterFreq;
        filterFreq => filter.freq;

        if (filterFreq >= max) {
            amount * -1 => step;
        }
        else if (filterFreq <= min) {
            amount => step;
        }

        modTime / steps => now;
    }
}

spork ~ modFilterFreq(filter, (tempo.note * 4) / 3, 80 => Std.mtof, 100 => Std.mtof, .001);

//

[0, 0, 0, 0, 0, 0, 1, 0] @=> int sequence[];

while(true) {
    for (0 => int beat; beat < 4; beat++) {
        for (0 => int step; step < sequence.cap(); step++) {            
            if (sequence[step]) {
                Math.random2f(-.4, .4) => stereo.pan;

                if (beat != 3) {
                    0 => clap.pos;
                }
                else {
                    repeat(2) {
                        0 => clap.pos;
                        (tempo.note / sequence.cap()) / 2 => now;
                    }

                    continue;
                }
            }

            tempo.note / sequence.cap() => now;
        }  
    }
}