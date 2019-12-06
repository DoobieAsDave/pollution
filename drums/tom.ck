BPM tempo;

SndBuf tom => Pan2 stereo => dac;

//

me.dir(-1) + "audio/tom.wav" => tom.read;
tom.samples() => tom.pos;
.5 => tom.rate;
.75 => tom.gain;

-.2 => stereo.pan;

//

while(true) {
    for (0 => int beat; beat < 4; beat++) {
        if (beat != 3) {
            tempo.quarterNote => now;
            0 => tom.pos;
            (tempo.note * 4) - tempo.quarterNote => now;            
        }
        else {
            tempo.quarterNote => now;
            0 => tom.pos;
            tempo.quarterNote => now;
            
            repeat(2) {
                0 => tom.pos;
                tempo.quarterNote => now;
            }

            tempo.note * 3 => now;            
        }
    }

    /* // 1st bar
    tempo.quarterNote => now;
    0 => tom.pos;
    tempo.quarterNote * 3 => now;
        
    // 2 & 3rd bar
    tempo.note * 2 => now;

    // 4th bar
    tempo.quarterNote * 3 => now;
    0 => tom.pos;
    tempo.quarterNote => now; */
}