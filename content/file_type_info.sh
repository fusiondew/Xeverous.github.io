#!/bin/bash

FILES=`find . -type f`
declare -A HASHMAP

FILECOUNT=0
NOEXT=0
while read FILE
do
	FILENAME=$(basename -- "$FILE")
	EXTENSION=$([[ "$FILENAME" = *.* ]] && echo ".${FILENAME##*.}" || echo '')
	if [ -z $EXTENSION ]
	then
		NOEXT=$(($NOEXT+1))
	elif [ ${HASHMAP["$EXTENSION"]+_} ]
	then
		HASHMAP["$EXTENSION"]=$((${HASHMAP["$EXTENSION"]}+1))
	else
		HASHMAP["$EXTENSION"]=1
	fi
	FILECOUNT=$(($FILECOUNT+1))
done <<< "$FILES"

COUNT=0
ARRAY=()
for KEY in "${!HASHMAP[@]}"
do
	VALUE=${HASHMAP["$KEY"]}
	ARRAY[$COUNT]="$KEY => $VALUE"
	COUNT=$(($COUNT+1))
done

SORTED=()
readarray -t SORTED < <(printf '%s\n' "${ARRAY[@]}" | sort -n -k3,3 -k1,1)

echo "extension => files"
printf '%s\n' "${SORTED[@]}"
echo "total files: $FILECOUNT"
echo "different extentions: ${#HASHMAP[@]}"
echo "files without extension: $NOEXT"
SIZE=$(du -hs . | cut -f1)
echo "total directory size: ${SIZE}B"
TEXTLINES="( find . -type f -print0 | xargs -0 cat ) | wc -l"
TEXTLINES=$(eval "$TEXTLINES")
echo "total text lines: $TEXTLINES"

