#!/bin/sh
# call this script with a command to run inside
# tmux
#
# Create script.sh to be run inside tmux
# this script will log it's output to script.log
# write it's exit vaue in the file called done
# and after that do one more echo. The echo is
# needed to the reading process can wait for
# input and check for the exitence of a generated
# done file
#
# @TODO use tmp files for the scripts
#
echo "#!/bin/sh
stty raw
dir=`pwd`
$@  2>&1  > \${dir}/script.log
echo \$?  > \${dir}/done
echo >>  \${dir}/script.log
" > script.sh

chmod +x script.sh


#do some cleanup
rm -rf done
unset TMUX
rm -rf script.log


#start a non attached tmux session that
#runs the script
tmux new-session -d -x 120 -y 60 ./script.sh

#wait for the file to be there
while [ ! -f script.log ]
do
	sleep .2
done

#now read the output of the program
#until the "done" file is created
tail -f script.log | while read line
do
	if [ -f done ] 
	then
		#@TODO only kill the $current tail by getting the tail attached to the current
		#ppid
		ps h --ppid $$ | grep tail | awk '{print $1}' | xargs --no-run-if-empty kill
		echo $line
		exit
	fi
	echo $line
done
ret=`cat done`
rm -rf script.log done
echo "exit value $ret"
exit $ret
