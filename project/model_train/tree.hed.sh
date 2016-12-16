#!/bin/bash

#Generate tree.hed

echo "RO 0
LS triphone/stats" > tree.hed

cat /home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/misc_files/questions-unilex.hed >> tree.hed

echo "TB 0 lsf_s2_ {*.state[2].stream[1]}
TB 0 lsf_s3_ {*.state[3].stream[1]}
TB 0 lsf_s4_ {*.state[4].stream[1]}
TB 0 lsf_s5_ {*.state[5].stream[1]}
TB 0 lsf_s6_ {*.state[6].stream[1]}

TB 0 lf0_s2_ {*.state[2].stream[2-4]}
TB 0 lf0_s3_ {*.state[3].stream[2-4]}
TB 0 lf0_s4_ {*.state[4].stream[2-4]}
TB 0 lf0_s5_ {*.state[5].stream[2-4]}
TB 0 lf0_s6_ {*.state[6].stream[2-4]}

AU triphone/triphones1
CO triphone/tiedlist
ST triphone/trees" >> tree.hed
