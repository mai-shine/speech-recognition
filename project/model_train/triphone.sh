#!/bin/bash

#find ../features/cmp -name "*.cmp" > train.scp
PATH="$PATH:/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/bin"

# Create list of triphones
#awk '{print $3}' /home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/labels/*/triphone/#*lab | sort -u | sed -r '/^$/d' > triphone/triphones1

# Cloning
# use monophones0 (skip step 7, where monohpones1 is created)
# run for acoustic model
#mkdir triphone/hmm6
#HHEd -H monophone/hmm5/macros -H monophone/hmm5/hmmdefs -M triphone/hmm6 mktri.hed monophone/monophones0

# run for duration mode
#HHEd -H monophone/hmm5/hmmdefs.dur -M triphone/hmm6 mktri.hed monophone/monophones0


# Re-estimation for 2 iters
lab_path=/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/labels/train/triphone
#mkdir triphone/hmm7

#HERest -C config -L $lab_path -t 250.0 150.0 1000.0 \
#-S train.scp -H triphone/hmm6/macros -H triphone/hmm6/hmmdefs -M triphone/hmm7 \
#-N triphone/hmm6/hmmdefs.dur -u mvwtdmv -R triphone/hmm7 triphone/triphones1 triphone/triphones1

#mkdir triphone/hmm8
#HERest -C config -L $lab_path -t 250.0 150.0 1000.0 -s triphone/stats \
#-S train.scp -H triphone/hmm7/macros -H triphone/hmm7/hmmdefs -M triphone/hmm8 \
#-N triphone/hmm7/hmmdefs.dur -u mvwtdmv -R triphone/hmm8 triphone/triphones1 triphone/triphones1

# Create tree.hed file 
# use RO 0 and TB 0
#./tree.hed.sh

# Tied-state triphones
# run for acoustic model
#mkdir triphone/hmm9

#HHEd -T 1 -H triphone/hmm8/macros -H triphone/hmm8/hmmdefs -a 1.0 -i -p -s -M triphone/hmm9 \
#tree.hed triphone/triphones1 | tee triphone/log_hmmdefs

#HHEd -H triphone/hmm8/macros -H triphone/hmm8/hmmdefs -i -p -s -m -a 1.0 -M triphone/hmm9 \
#tree.hed triphone/triphones1 > triphone/log_hmmdefs

# Create tree.dur.hed
#awk '{print NR "\t" $1 "\t1\t1"}' triphone/triphones1 > triphone/stats.dur
#./tree.dur.hed.sh

# run for duration model
#HHEd -T 1 -H triphone/hmm8/hmmdefs.dur -a 1.0 -i -p -s -M triphone/hmm9 \
#tree.dur.hed triphone/triphones1 | tee triphone/log_hmmdefs.dur

#HHEd -H triphone/hmm8/hmmdefs.dur -i -p -s -m -a 1.0 -M triphone/hmm9 \
#tree.dur.hed triphone/triphones1 > triphone/log_hmmdefs.dur

# Final re-estimation 
#mkdir triphone/hmm10

HERest -C config -L $lab_path -t 250.0 150.0 1000.0 \
-S train.scp -H triphone/hmm9/macros -H triphone/hmm9/hmmdefs -M triphone/hmm10 \
-N triphone/hmm9/hmmdefs.dur -u mvwtdmv -R triphone/hmm10 triphone/tiedlist triphone/tiedlist.dur

#mkdir triphone/hmm11
#HERest -C config -L $lab_path -t 250.0 150.0 1000.0 \ #-s triphone/stats.dur \
#-S train.scp -H triphone/hmm10/macros -H triphone/hmm10/hmmdefs -M triphone/hmm11 \
#-N triphone/hmm10/hmmdefs.dur -u mvwtdmv -R triphone/hmm11 triphone/tiedlist triphone/tiedlist.dur
