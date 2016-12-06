
#puts all in the file
find ../../features/cmp -name "*.cmp" > train.scp
PATH="$PATH:/home/maimei/Documents/STUDIES/9.lukukausi/08_Speech_Recognition/Project/Code/project/bin"

#new version of proto where zero means and unit variances above have been replaced by the global speech means and variances
HCompV -C config -f 0.01 -m -S train.scp -M hmm0 proto

#Creating proto file for each phoneme
#path=
#for f in $path
#do
#	fn=$(basename ${f%.raw})
	
#done

#flat start monophones in hmm0 are re estimated with HERRESt
#-t is the treshold

#first iteration
#data.delta HERest -C config -I phones0.mlf -t 250.0 150.0 1000.0 \
#    -S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 -g hmm1/hmmdefs.dur monophones0
	
#following iterations #DONT KNOW IF YOU CAN DO THIS WITH THE $i!!!!!!!!!
#n=5
#for i in {2..$n}
#do
#data.delta HERest -C config -I phones0.mlf -t 250.0 150.0 1000.0 \
 #   -S train.scp -N $sourcedir/hmmdefs.dur -u mvwtdmv -R $targetdir\
#	-H hmm$(i-1)/macros -H hmm$(i-1)/hmmdefs -M hmm$i -g hmm$i/hmmdefs.dur monophones0 monophones0
#done

#Testing:
#HMGenS -T 1  -C config -C generation.conf -H hmm5/macros -H hmm5/hmmdefs \
#-N hmm5/hmmdefs.dur -M . monophones0 monophones0 \
#/work/courses/T/S/89/5150/general/synthesis/labels/test/monophone/arctic_b0500.lab
