BPM tempo;

SndBuf openhat => Pan2 stereo => dac;

//

me.dir(-1) + "audio/openhat.wav" => openhat.read;
openhat.samples() => openhat.pos;
.25 => openhat.gain;

//

[0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 2, 0, 3] @=> int sequence[];

while(true) {
    for (0 => int beat; beat < 2; beat++) {
        for (0 => int step; step < sequence.cap(); step++) {
            if (sequence[step]) {
                if (sequence[step] == 1) 0 => openhat.pos;
                else {
                    if (sequence[step] == 2) {
                        if (beat == 1) 0 => openhat.pos;
                    }
                    else {
                        if (beat == 1 && Math.random2(0, 1)) 0 => openhat.pos;
                    }
                }
            }

            tempo.note / sequence.cap() => now;
        }
    }
}