#!/bin/bash

find files/wav/ -name "*.wav" > features/scp/arctic_slt.wav.scp
PATH="$PATH:/home/maimei/Lataukset/project/bin"

# Create simple windows:
echo "-0.5 0 0.5" | x2x +af > features/delta.win.float
echo "1.0 -2.0 1.0" | x2x +af > features/accel.win.float

# Some ancient tradition dictates that features are in a directory called cmp. I have no idea what it means!
mkdir -p features/cmp

vocoderdim=25; # Number of vocoder parameters, the more the merrier, maybe?
vocoderorder=$(( vocoderdim - 1 ))

cat features/scp/arctic_slt.wav.scp | while read line; do 
    
    echo $line
    cp $line features/data.wav

    # Audio conversion can be nasty! Sox scales the audio when saving as floating poins, SPTK does not like that.
    # Saving with sox as signed-integer raw and using x2x to switch formats is a way around this:

    sox features/data.wav -t raw -r 16000 -e signed-integer -b 16 features/data.2bitInteger 
    x2x +sf features/data.2bitInteger > features/data.float

    # Extract pitch here with values that suit the speaker and save to data.pitch.raw.float
    # Add your code here: 
    pitch -a 1 -s 16 -p 80 -L 80 -H 250 features/data.float> features/data.pitch.raw.float
   
    # Handle the magic number:
    cat features/data.pitch.raw.float | x2x +fa | awk '{if ($1>0) {print log($1)} else {print "-1.0E10"}}' | x2x +af > features/data.pitch

    # Make delta pitch features, save into ascii format:
    delta -l 1  -d features/delta.win.float -d features/accel.win.float -M -1e+10 features/data.pitch | x2x +fa3 | awk '{ if ($1 == -1e+10) {print $1"\t"$1"\t"$1} else { if ($2 == "5e+09" || $2 == "-5e+09") { print $1"\t"$3"\t"$3} else {print $0 } } }' > features/data.pitch.delta.ascii


    # Extract the features with your chosen vocoder, save to float:daa
    # Add your code here:
    frame -l 400 -p 80 < features/data.float| window -l 400 -L 1024 | mcep -m $vocoderdim -l 1024 -a 0.36 > features/data.mcep.float

    # Check this by synthesising from the features (example for lsp features):
                     excite -p 80 < features/data.pitch.raw.float | mlsadf -p 80 features/data.mcep.float > features/data.syn.2
                     x2x -o +fs features/data.syn.2 > features/data.syn.2.short
                     play -e signed-integer -b 16 -t raw -r 16000 features/data.syn.2.short 

    # make delta features, save into ascii format:
    delta -l $vocoderdim -d  features/delta.win.float -d features/accel.win.float features/data.mcep.float | x2x +fa$(( vocoderdim * 3 )) > features/data.mcep.delta.ascii 

    # Combine features frame by frame, easiest done in ascii columns with "paste" command:
    paste features/data.mcep.delta.ascii features/data.pitch.delta.ascii | x2x +af > features/data.delta

    # Check this with x2x +fa$(( ( vocoderdim + 1 ) * 3 )) data.delta | less -S

    # The HTK file format header is 12 bytes long and contains the following data
    # nSamples   - number of samples in file (4-byte integer)
    # sampPeriod - sample period in 100ns units (4-byte integer)
    # sampSize   - number of bytes per sample (2-byte integer)
    # parmKind   - a code indicating the sample kind (2-byte integer)

    #nSamples=`wc -l data.pitch.delta.ascii | awk '{print $1}'`
    #sampsPeriod=$(( 5 * 10000 ))

    sampSize=$(( 4 * ( $vocoderdim + 1) * 3  ))
    parmKind="9"

    Hhead -p 5.0 -s $sampSize -k $parmKind features/data.delta > features/cmp/`basename $line wav`cmp

done
