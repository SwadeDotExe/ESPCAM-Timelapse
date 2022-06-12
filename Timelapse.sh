#!/bin/bash

SERVER_DIR="/mnt/Backups/dormTimeLapse" #Path to the NAS where the files will be moved.
LOCAL_DIR="/var/www/html/uploads"

FILE_DATE=$(date --date="1 day ago" +'%Y-%m-%d')    # Ex. 2022.01.23
HUMAN_DATE=$(date --date="1 day ago" +'%B %d, %Y')  # Ex. January 23, 2022

TIMELAPSE_DATE=$(date --date="1 day ago" +'%m-%d-%Y')

SECONDS=0

DATE=$(date --date="1 day ago" +'%B %d, %Y')

# Debug Date
#DATE=$(date +'%B %d, %Y')

# Creates the timelapse
ffmpeg -framerate 60 -pattern_type glob -i "$SERVER_DIR/$FILE_DATE/*.jpg" -s:v 1600x1200 -c:v libx264 -crf 25 -pix_fmt yuv420p "$SERVER_DIR/$FILE_DATE/Dorm Timelapse $TIMELAPSE_DATE.mp4"

# Uploads timelapse to YouTube
youtube-upload --client-secrets=/mnt/SSD/Scripts/DormTimeLapse/secret.json --title="Dorm Timelapse $TIMELAPSE_DATE" --description="Timelapse from Indianapolis on $HUMAN_DATE." --playlist="Dorm Timelapses" "$SERVER_DIR/$FILE_DATE/Dorm Timelapse $TIMELAPSE_DATE.mp4" --privacy unlisted

# Change directory to picture location
cd "$SERVER_DIR/$FILE_DATE"

# Zip all pictures into Pictures.zip
sudo zip -R Pictures '*.jpg'

# Delete all the JPGs
sudo find . -name "*.jpg" -type f -delete

# Shell Notification
if (( $SECONDS > 3600 )); then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
elif (( $SECONDS > 60 )); then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
else
    echo "Completed in $SECONDS seconds"
fi
