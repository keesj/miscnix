#!/bin/sh
#
# Create a new session without attaching to it
# -d
# 
# Create a child process with a pid
# let that child start tmux
#


#create  script.sh
echo "#!/bin/sh
(
$@  2>&1 
pid=\$?
echo \$pid > done
) >> script.log
#
# ensure tail -f does handle
# the loop one more time.
#
echo >> script.log
" > script.sh

chmod +x script.sh

rm -rf done
unset TMUX
rm -rf script.log

tmux new-session -d -x 120 -y 60 ./script.sh

#wait for the file to be there
while [ ! -f script.log ]
do
	sleep .2
done

tail -f script.log | while read line
do
	if [ -f done ] 
	then
		killall tail
		exit
	fi
	echo $line
done
exit `cat done`
