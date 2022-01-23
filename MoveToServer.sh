
# Paths
SERVER_DIR="/mnt/Backups/dormTimeLapse"                         # Server Storage Location
LOCAL_DIR="/var/www/photodump.reshall.rose-hulman.edu/uploads"  # Web Server Dropbox

# Dates
FILE_DATE=$(date +'%Y.%m.%d')    # Ex. 2022.01.23
HUMAN_DATE=$(date +'%B %d, %Y')  # Ex. January 23, 2022

# Make directory if doesn't exist (only at midnight really)
mkdir -p "$SERVER_DIR/$HUMAN_DATE"

# Move pictures matching regex to correct date
mv "$LOCAL_DIR/$FILE_DATE"* "$SERVER_DIR/$HUMAN_DATE"
