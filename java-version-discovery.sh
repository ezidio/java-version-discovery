#!/bin/bash

for jarFile in `find . -iname '*.war' -o -iname '*.jar'` ; do 

	echo "$jarFile"
	for zipFile in `unzip -l $jarFile`; do
		zipFileName="${zipFile%"${zipFile##*[![:space:]]}"}"
		if [[ "$zipFileName" =~ .*class$ ]];
		then
			content=`unzip -c $jarFile $zipFileName`
			jarFileSize=${#jarFile}
			zipFileNameSize=${#zipFileName}
			offset=$(($jarFileSize + $zipFileNameSize + 13 + 9 + 6))
			hexContent=`echo ${content:$offset} | xxd -p`
			
			type="none"
			if [[ $hexContent =~ (cafebabe[0]?[2-3][0-9a-f]) ]]; then
				type=${BASH_REMATCH[1]:(-2)}
			fi
			
			case $type in
				"34")
					echo "Java SE 8"
					;;
				"33")
					echo "Java SE 7"
					;;
				"32")
					echo "Java SE 6.0"
					;;
				"31")
					echo "Java SE 5.0"
					;;
				"30")
					echo "JDK 1.4"
					;;
				"2f")
					echo "JDK 1.3"
					;;
				"2e")
					echo "JDK 1.2"
					;;
				"2d")
					echo "JDK 1.1"
					;;
				*)
					echo "!!! Não identificado... "
					echo hexContent
			esac
			
			break
		fi
	done
done



