SERVER_DIR="/mnt/Backups/dormTimeLapse" #Path to the NAS where the files will be moved.
LOCAL_DIR="/var/www/photodump.reshall.rose-hulman.edu/uploads"

FILE_DATE=$(date +'%Y-%m-%d')    # Ex. 2022.01.23
HUMAN_DATE=$(date +'%B %d, %Y')  # Ex. January 23, 2022

cp -p "$LOCAL_DIR/"* "$SERVER_DIR/"
rm -r "$LOCAL_DIR/"*

cd "$SERVER_DIR/"

for IMAGE in *.jpg; do
  MOD_DATE=$(stat -c %y $IMAGE | cut -d ' ' -f 1)
  MOD_TIME=$(stat -c %y $IMAGE | cut -d ' ' -f 2 | cut -d '.' -f 1)

  sudo convert ./$IMAGE -gravity SouthEast -pointsize 48 -fill white -annotate +30+30  "$HUMAN_DATE $MOD_TIME" ./$IMAGE

  mkdir -p "$SERVER_DIR/$MOD_DATE"
  cp -p ./$IMAGE ./$MOD_DATE/
  rm ./$IMAGE

done
