BPM tempo;

SndBuf hihat => dac;

//

me.dir(-1) + "audio/hihat.wav" => hihat.read;
hihat.samples() => hihat.pos;
.25 => hihat.gain;

//

[1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0] @=> int sequence[];

while(true) {    
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {
            setHihatPosition(5) => hihat.pos;
        }

        tempo.note / sequence.cap() => now;
    }
}
function int setHihatPosition(int percent) {
    return Math.random2(0, hihat.samples() * (percent / 100.0) => Std.ftoi);
}