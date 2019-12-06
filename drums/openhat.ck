BPM tempo;

SndBuf openhat => Pan2 stereo => dac;

//

me.dir(-1) + "audio/openhat.wav" => openhat.read;
openhat.samples() => openhat.pos;
.25 => openhat.gain;

//

while(true) {    
    for (0 => int step; step < 8; step++) {
        Math.random2f(-.3, .3) => stereo.pan;
        
        if (step != 7) {
            .8 => openhat.rate;
            0 => openhat.pos;
            tempo.quarterNote => now;
        }
        else {
            if (Math.random2(0, 1)) {
                repeat(2) {
                    Math.random2f(.775, .825) => openhat.rate;
                    0 => openhat.pos;
                    tempo.quarterNote / 2 => now;
                }
            }
            else {
                0 => openhat.pos;
                tempo.quarterNote => now;
            }
        }
    }
}