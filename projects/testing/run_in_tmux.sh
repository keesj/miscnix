#!/bin/sh
#
# Create a new session without attaching to it
# -d
# 


#create  script.sh
echo "#!/bin/sh
rm -rf done
$@
echo \$? > done" > script.sh

chmod +x script.sh

rm -rf done
tmux new-session -d -x 80 -y 25 ./script.sh
while [ ! -f done ]
do
	sleep 1
done
exit `cat done`

