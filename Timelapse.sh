#!/bin/bash

SERVER_DIR="/mnt/Backups/dormTimeLapse" #Path to the NAS where the files will be moved.
LOCAL_DIR="/var/www/photodump.reshall.rose-hulman.edu/uploads"

FILE_DATE=$(date +'%Y-%m-%d')    # Ex. 2022.01.23
HUMAN_DATE=$(date +'%B %d, %Y')  # Ex. January 23, 2022

# TIMELAPSE_DATE=$(date --date="1 day ago" +'%m-%d-%Y')
TIMELAPSE_DATE=$(date +'%m-%d-%Y')

# WEBHOOK_URL="https://discord.com/api/webhooks/792932713174663181/dsgVjFAPly0v_8nkJ7B6Fp7XzsaPnHhTyDsIlBhcavE5x7TZW4Mu9ZM3VGBZqPlREgjH"
SECONDS=0

# PAYLOAD=" { \"content\": \"Started the time lapse for $(date --date="1 day ago" +'%B %d, %Y').\" }"
# curl -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$WEBHOOK_URL"

# DATE=$(date --date="1 day ago" +'%B %d, %Y')

# Debug Date
DATE=$(date +'%B %d, %Y')

ffmpeg -framerate 60 -pattern_type glob -i "$SERVER_DIR/$FILE_DATE/*.jpg" -s:v 1600x1200 -c:v libx264 -crf 25 -pix_fmt yuv420p "$SERVER_DIR/$FILE_DATE/Dorm Timelapse $TIMELAPSE_DATE.mp4"



# Discord Notification
if (( $SECONDS > 3600 )); then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
    PAYLOAD=" { \"content\": \"The CCTV footage finished the time lapse in $hours hour(s), $minutes minute(s) and $seconds second(s). The size after the time lapse is **$PRE_SIZE**.\" }"

elif (( $SECONDS > 60 )); then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
    PAYLOAD=" { \"content\": \"The CCTV footage finished the time lapse in $minutes minute(s) and $seconds second(s). The size after the time lapse is **$PRE_SIZE**.\" }"
else
    echo "Completed in $SECONDS seconds"
    PAYLOAD=" { \"content\": \"The CCTV footage finished the time lapse in $SECONDS seconds. The size after the time lapse is **$PRE_SIZE**.\" }"
fi

# curl -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$WEBHOOK_URL"
