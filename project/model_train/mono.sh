#!/bin/bash

#puts all in the file
#find ../../features/cmp -name "*.cmp" > train.scp
PATH="$PATH:/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/bin"

# Create list of phonemes
#awk '{print $3}' /home/maimei/Documents/STUDIES/9.lukukaus
#i/08_Speech_Recognition/Project/Code/project/files/labels/*/monophone/*lab | sort -u > monophones0

#new version of proto where zero means and unit variances above have been replaced by the global speech means and variances
#HCompV -C config -f 0.01 -m -S train.scp -M hmm0 proto




#FILE TO CREATE HMMDEFS



#--------------------------------------------------------------------------
#training


#flat start monophones in hmm0 are re estimated with HERRESt
#-t is the treshold

lab_path=/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/labels/train/monophone

#first iteration
#	HERest -C config -L $lab_path -t 250.0 150.0 1000.0 \
#-S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 -g hmm1/hmmdefs.dur monophones0
	
#following iterations #DONT KNOW IF YOU CAN DO THIS WITH THE $i!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
n=5
#for i in $(seq 2 $n)
#do
#	mkdir hmm$i
#	HERest -C config -L $lab_path -t 250.0 150.0 1000.0 \
#-S train.scp -H hmm"$(($i-1))"/macros -H hmm"$(($i-1))"/hmmdefs -M hmm$i \
#-N hmm"$(($i-1))"/hmmdefs.dur -u mvwtdmv -R hmm$i monophones0 monophones0
#done

test_path=/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/labels/test/monophone
#Testing:
#Generate vocoder parameters for a label
#HMGenS -T 1 -C config -C generation.conf -H hmm5/macros -H hmm5/hmmdefs \
#-N hmm5/hmmdefs.dur -M . monophones0 monophones0 $test_path/arctic_b0500.lab

#Synthesize speech with params
excite -p 80 < test/arctic_b0500.f0 | mlsadf -p 80 test/arctic_b0500.mcep > test/data.syn.2
x2x -o +fs test/data.syn.2 > test/data.syn.2.short
play -e signed-integer -b 16 -t raw -r 16000 test/data.syn.2.short 
