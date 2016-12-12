#!/bin/bash

PATH="$PATH:/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/bin"

# Create list of triphones
#awk '{print $3}' /home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/#labels/*/triphone/*lab | sort -u > triphone/triphones1

#HLEd -n triphones1 -l ’*’ -i wintri.mlf mktri.led aligned.mlf



# Cloning
# use monophones0 (skip step 7, where monohpones1 is created)
# run for acoustic model
#mkdir triphone/hmm6
#HHEd -B -H monophone/hmm5/hmmdefs -M triphone/hmm6 mktri.hed monophone/monophones0

# run for duration mode
#HHEd -B -H monophone/hmm5/hmmdefs.dur -M triphone/hmm6 mktri.hed monophone/monophones0



# Re-estimation for 2 iters
lab_path=/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/labels/train/triphone

HERest -B -C config -L $lab_path -t 250.0 150.0 1000.0 -s stats \
-S train.scp -H monophone/hmm5/hmmdefs -M triphone/hmm6 \
-N monophone/hmm5/hmmdefs.dur -u mvwtdmv -R triphone/hmm6 triphone/triphones1 triphone/triphones1

HERest -B -C config -L $lab_path -t 250.0 150.0 1000.0 -s stats \
-S train.scp -H triphone/hmm6/hmmdefs -M triphone/hmm7 \
-N triphone/hmm6/hmmdefs.dur -u mvwtdmv -R triphone/hmm7 triphone/triphones1 triphone/triphones1

