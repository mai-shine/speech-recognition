#!/bin/bash

#Generate tree.hed

echo "RO 0
LS triphone/stats" > tree.dur.hed

cat /home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/files/misc_files/questions-unilex.hed >> tree.dur.hed

echo "TB 0 dur_s2_ {*.state[2].stream[1]}
TB 0 dur_s3_ {*.state[2].stream[2]}
TB 0 dur_s4_ {*.state[2].stream[3]}
TB 0 dur_s5_ {*.state[2].stream[4]}
TB 0 dur_s6_ {*.state[2].stream[5]}

AU triphone/triphones1
CO triphone/tiedlist.dur
ST triphone/trees.dur" >> tree.dur.hed
