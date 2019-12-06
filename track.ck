.75 => float gainMax;
0 => float gainMin;
.01 => float gainStep;

gainMax / gainStep => float gainStepAmount;

//

gainMin => dac.gain;

BPM tempo;
tempo.setBPM(121.5);

//

int kickId, bassId, hihatId, snareId, clapId, tomId, padId, recordId;

Machine.add(me.dir() + "record.ck") => recordId;

spork ~ modulateGain(1, tempo.note);

Machine.add(me.dir() + "drums/kick.ck") => kickId;
Machine.add(me.dir() + "units/808.ck") => bassId;
Machine.add(me.dir() + "drums/hihat.ck") => hihatId;
Machine.add(me.dir() + "units/pad.ck") => padId;

//tempo.note * 4 => now;
Machine.add(me.dir() + "drums/snare.ck") => snareId;

//tempo.note * 4 => now;
Machine.add(me.dir() + "drums/clap.ck") => clapId;

//tempo.note * 8 => now;
Machine.add(me.dir() + "drums/tom.ck") => tomId;

tempo.note * 32 => now;

spork ~ modulateGain(0, tempo.note);

tempo.note * 2 => now;
Machine.remove(kickId);
Machine.remove(bassId);
Machine.remove(hihatId);
Machine.remove(snareId);
Machine.remove(clapId);
Machine.remove(padId);
Machine.remove(recordId);
Machine.status();

//

function void modulateGain(int mode, dur duration) {
    // Rise gain
    if (mode) {
        while(dac.gain() <= gainMax) {
            dac.gain() + gainStep => dac.gain;   
            duration / gainStepAmount => now;            
        }
    }
    // Lower gain
    else {
        while(dac.gain() >= gainMin) {
            dac.gain() - gainStep => dac.gain;
            duration / gainStepAmount => now;             
        }
    }
}