# Episode-Renamer
A convenient script that gives meaningful names to episodes from your TV series collection.

# Usage
1.  Paste this script in the same location as your episode files.

2.  Obtain the episode titles (an easy way would be to get a screenshot of the Wikipedia page and passing it through OCR) and save them in a plain text file.

3.  Run the script with the following arguments:
  * -p (--prefix)

    The prefix that you want for every file. For example, if you are renaming episodes from the third season of the series, the prefix could be 'S03'
  * -v (--video):

    The file extension of the video files e.g. mkv, mp4, etc.
  * -s (--subtitle):

    The file extension of the subtitle files e.g. srt, sub, etc.
  * -t (--title):

    The name of the text file with the episode titles

(**-t** is mandatory, whereas at least one should be passed from **-v** and **-s**)

# Sample Usage
```
$ ll
ep1.mkv
ep1.srt
ep2.mkv
ep2.srt
ep3.mkv
ep3.srt
episode_renamer.sh
titles.txt

$ cat titles.txt
First Episode
Second Episode
Third Episode

$ bash episode_renamer.sh -v mkv -s srt -p S01 -t titles.txt
Renaming 3 episodes...
Done!

$ ll
episode_renamer.sh
S01E01 - First Episode.mkv
S01E01 - First Episode.srt
S01E02 - Second Episode.mkv
S01E02 - Second Episode.srt
S01E03 - Third Episode.mkv
S01E03 - Third Episode.srt
titles.txt
```
