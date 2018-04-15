#!/bin/bash

command=`grep url _data/navigation.yml | awk -F ": " '{print $2}'`

for line in $command
do
	file=${line::-4}"md"

	if [[ ! -f $file ]]
	then
		echo "creating" $file
		install -D /dev/null $file
		echo -e "---\nlayout: article\n---\n" > $file
	fi
done
