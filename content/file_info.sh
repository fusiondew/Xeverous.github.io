#!/bin/bash

FILES=`find . -type f`
declare -A HASHMAP

FILECOUNT=0
while read FILE
do
	CONTENT=$(<$FILE)
	FILECOUNT=$(($FILECOUNT+1))
	if [ ${HASHMAP["$CONTENT"]+_} ]
	then
		HASHMAP["$CONTENT"]=$((${HASHMAP["$CONTENT"]}+1))
	else
		HASHMAP["$CONTENT"]=1
	fi
done <<< "$FILES"

COUNT=0
ARRAY=()
for KEY in "${!HASHMAP[@]}"
do
	VALUE=${HASHMAP["$KEY"]}
	ARRAY[$COUNT]="${#KEY} => $VALUE"
	COUNT=$(($COUNT+1))
	#echo "${#KEY} => ${HASHMAP["$KEY"]}"
done

SORTED=()
readarray -t SORTED < <(printf '%s\n' "${ARRAY[@]}" | sort -n -k3,3 -k1,1)

echo "file length => file copies"
printf '%s\n' "${SORTED[@]}"
echo "total files: $FILECOUNT"
echo "different files: ${#HASHMAP[@]}"

