#!/bin/sh
#
# Create a new session without attaching to it
# -d
# 


#create  script.sh
echo "#!/bin/sh
rm -rf done
$@ 2>&1 > script.log
echo \$? > done" > script.sh

chmod +x script.sh

rm -rf done
unset TMUX
tmux new-session -d -x 120 -y 60 ./script.sh
while [ ! -f done ]
do
	sleep 1
done
cat script.log
exit `cat done`

