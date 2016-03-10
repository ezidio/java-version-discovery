#!/bin/bash

# Find jars and wars
for jarFile in `find . -iname '*.war' -o -iname '*.jar'` ; do 

	echo "$jarFile"
	
	# read file content
	for zipFile in `unzip -l $jarFile`; do
	
		# Trim spaces
		zipFileName="${zipFile%"${zipFile##*[![:space:]]}"}"
		
		if [[ "$zipFileName" =~ .*class$ ]];
		then
			content=`unzip -c $jarFile $zipFileName`
			
			# Calc offset to skip the file and jar name
			jarFileSize=${#jarFile}
			zipFileNameSize=${#zipFileName}
			offset=$(($jarFileSize + $zipFileNameSize + 28))
			
			# Extract hex file content 
			hexContent=`echo ${content:$offset} | xxd -p`
			
			# Find file header and extract version
			type="none"
			if [[ $hexContent =~ (cafebabe[0]?[2-3][0-9a-f]) ]]; then
				type=${BASH_REMATCH[1]:(-2)}
			fi
			
			# Echo the version
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
					echo "!!! Unindentified java version !!! "
					echo "File hex content:"
					echo hexContent
			esac
			
			break
		fi
	done
done
