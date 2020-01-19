prefix=
video_format=
subtitle_format=
title_file=

# Parse command line arguments
while [[ $# -gt 0 ]]
do
	key="$1"
	case $key in
		-p|--prefix)
		        prefix="$2"
		        shift
		        shift
		;;
		-v|--video)
		        video_format="$2"
		        shift
		        shift
		;;
		-s|--subtitle)
		        subtitle_format="$2"
		        shift
		        shift
		;;
		-t|--title)
		        title_file="$2"
		        shift
		        shift
		;;
		*)
		        shift
		;;
	esac
done

# Exit if mandatory arguments are not passed
if [ -z "$video_format" ] && [ -z "$subtitle_format" ]
then
	printf "No video or subtitle format passed.\nExiting.\n"
	exit
fi
if [ -z "$title_file" ]
then
	printf "No title file passed.\nExiting.\n"
	exit
fi

# Inform about skipped arguments
if [ -z "$prefix" ]
then
    printf "Prefix not passed. Skipping...\n\n"
fi
if [ -z "$video_format" ]
then
    printf "Video files not passed. Skipping...\n\n"
fi
if [ -z "$subtitle_format" ]
then
    printf "Subtitle files not passed. Skipping...\n\n"
fi

# Read and verify that titles do not have invalid characters
IFS=$'\n' read -d '' -r -a titles < "$title_file"
for title in "${titles[@]}"
do
	if [[ $title =~ ['\\/:*?"<>|'] ]];
	then
		printf "Invalid character found in following title:\n$title\nExiting.\n"
		exit
	fi
done

# Read names of video files
if [ ! -z "$video_format" ]
then
	i=0
	while read line
	do
		episodes[ $i ]="$line"
		(( i++ ))
	done < <(ls -1v *."$video_format")
fi

# Read names of subtitle files
if [ ! -z "$subtitle_format" ]
then
	i=0
	while read line
	do
		subtitles[ $i ]="$line"
		(( i++ ))
	done < <(ls -1v *."$subtitle_format")
fi

# Check if number of titles matches with number of videos/subtitles/both
matchingFiles=true
if [ ! -z "$video_format" ]
then
	if [ ${#titles[@]} -ne ${#episodes[@]} ]
	then
    	matchingFiles=false
	fi
fi
if [ ! -z "$subtitle_format" ]
then
	if [ ${#titles[@]} -ne ${#subtitles[@]} ]
	then
	    matchingFiles=false
	fi
fi

if [ "$matchingFiles" = false ]
then
	# Exit if there is a mismatch in the number of titles and files
    printf "Mismatch in number of files. Exiting.\n"
    exit
else
	echo "Renaming ${#titles[@]} episodes..."
	for i in "${!titles[@]}"; do
	    episode_no=$((i+1))
		# Append '0' to start of episode number if it is less than 10
	    if [ "$i" -lt 9 ];
	    then
            episode_no="0$episode_no"
	    fi

		# Rename video file
	    if [ ! -z "$video_format" ]
	    then
            mv "${episodes[$i]}" "${prefix}E$episode_no - ${titles[$i]}.$video_format"
	    fi

		# Rename subtitle file
	    if [ ! -z "$subtitle_format" ]
	    then
            mv "${subtitles[$i]}" "${prefix}E$episode_no - ${titles[$i]}.$subtitle_format"
        fi
    done
fi
printf "Done!\n"
