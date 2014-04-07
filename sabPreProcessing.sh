#!/bin/bash

#########################################################################################################################################################################
# Pre-Processing Script for Sabnzbd                                                                                                                                  ####
# Usage: ./sabPreProcessing.sh 'Dexter.S07E06.FRENCH.720p.HDTV.x264-JMT Testmessage, not part of releasename / securepassword' '3' 'standard' '' '-100' '9711567550' ####
#########################################################################################################################################################################

# Get actual script folder without any symbolic links
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )";

# Check for default config file
if [ ! -f "$DIR"'/default.config.sh' ]; then
    echo "Fatal error: No default config file found!";
    exit 1;
fi;

# Create config file when non-existant
if [ ! -f "$DIR"'/config.sh' ]; then
    cp "$DIR"'/default.config.sh' "$DIR"'/config.sh';
fi;

# Load config files
source "$DIR"'/default.config.sh';
source "$DIR"'/config.sh'; # Override default config with user variables

# Log function
function log() {
  if $DO_LOG; then
    echo "$(date +'%y-%m-%d %T')"": ""$1" >> "$LOGFILE";
  fi;
}

# Check for logfile
if [ ! -f "$LOGFILE" ]; then
    LOGFILE="$DIR"'/preprocessing.log';
    log "Logfile not found. Using default path.";
fi

log "Starting Pre-Processing...";

# Print all arguments to log
log " Arguments: ""$*";

# Check if all arguments got assigned (actually 11, but we use only 6)
if (($# < 6)); then
  log " Not enough arguments (""$#""/6)";
  echo "Not enough arguments (""$#""/6)!";
  exit 1;
fi;

# Arguments
NAME="$1";             # Name of the NZB (no path, no ".nzb")
PP_FLAGS="$2";         # Post Processing (PP) flags: 0 = Download, 1 = +Repair, 2 = +Unpack, 3 = +Delete
CATEGORY="$3";         # Category
SCRIPT="$4";           # Script (no path / basename)
PRIORITY="$5";         # Priority (-100, -1, 0 or 1 meaning Default, Low, Normal, High)
SIZE="$6";             # Size of the download (in bytes)
#GROUP_LIST="$7";      # Group list (separated by spaces)
#SHOW_NAME="$8";       # Show name
#SEASON="$9";          # Season (1..99)
#EPISODE="${10}";      # Episode (1..99)
#EPISODE_NAME="${11}"; # Episode name

# Accept by default
ACCEPT=1;

# Handle name exceptions
STRING_EXCEPTION=false;
for EXCEPTION in "${EXCEPTIONS[@]}"
do
  if ! [ -z "$(echo "$NAME" | grep -io "$EXCEPTION")" ]; then STRING_EXCEPTION=true; fi;
done;

if [ "$STRING_EXCEPTION" == "false" ]; then

  # Get password if there is one (" / pw", other pw-options get parsed before)
  PASSWORD=$(echo "$NAME" | grep -o ' \/ \(.*\)$');
  PASSWORD=${PASSWORD/ \/ /};

  # Sometimes PWs MAY appear as "_PW_pass", rare
  if [ -z "$PASSWORD" ]; then
    PASSWORD=$(echo "$NAME" | grep -oiE '_PW_(.*)$');
    PASSWORD=${PASSWORD/PW_/};
  fi;

  # Append password to PASSWORD_FILE when not already in there
  if $ADD_TO_PASSWORD_FILE; then
    if [ ! -f "$PASSWORD_FILE" ]; then
      PASSWORD_FILE="$DIR"'/passwordlist';
      log "Password file not found. Using default path.";
    fi

    if ! [ -z "$PASSWORD" ]; then
      if [ -z "$(grep -Eo "^${PASSWORD}\$" "$PASSWORD_FILE")" ]; then
      echo "$PASSWORD" >> "$PASSWORD_FILE";
      fi;
    fi;
  fi;

  # Get a clean name by removing the password and some exceptions from CLEAN_ARRAY (config)
  CLEAN_NAME="${NAME/PASSWORD/}";
  for CLEANER in "${CLEAN_ARRAY[@]}"
  do
    CLEAN_NAME="$(echo "$CLEAN_NAME" | sed -e 's/'"$CLEANER"'/g')";
  done;

  # Check if its a tv show (f.e. contains S01E01 or category is SERIES_CATEGORY)
  if ! [ -z "$(echo "$CLEAN_NAME" | grep -io 'S[0-9]\{1,3\}E[0-9E-]\{1,3\}')" ]; then IS_TV_SHOW=true; else IS_TV_SHOW=false; fi;
  if ! [ -z "$(echo "$CLEAN_NAME" | grep -io '[ ._]S[0-9-]\{1,3\}[ ._]')" ]; then IS_TV_SHOW=true; fi;
  if [ "$CATEGORY" == "$SERIES_CATEGORY" ]; then IS_TV_SHOW=true; fi;

  # If its a tv show, set category to SERIES_CATEGORY. If size is below SERIES_MIN_SIZE pause the nzb,
  # otherwise set priority to SERIES_PRIORITY. Additionally, set the pp-script.
  if $IS_TV_SHOW; then
    log " NZB is a tv show.";
    CATEGORY="$SERIES_CATEGORY";
    if (( SIZE < ((SERIES_MIN_SIZE * 1024 * 1024)) )); then PRIORITY='-2'; else PRIORITY="$SERIES_PRIORITY"; fi;
    SCRIPT="$SERIES_SCRIPT";
  fi;


  if ! [ "$CATEGORY" == "$SERIES_CATEGORY" ]; then
    # Check if its a movie (f.e. contains imdb id or category is SERIES_CATEGORY)
    # If movie, do tv show procedure for movies and set imdb to a CouchPotato value when found.
    IMDB_ID=$(echo "$CLEAN_NAME" | grep -Eio 'tt[0-9]+');
    if ! [ -z "$IMDB_ID" ]; then
      IS_MOVIE=true;
      if $INCLUDE_IMDB_ID; then IMDB_ID=".cp(""$IMDB_ID"")"; else IMDB_ID=""; fi;
    else IS_MOVIE=false;
    fi;
    if [ "$CATEGORY" == "$MOVIES_CATEGORY" ]; then IS_MOVIE=true; fi;
    if $IS_MOVIE; then
      log " NZB is a movie.";
      CATEGORY="$MOVIES_CATEGORY";
      if (( SIZE < ((MOVIES_MIN_SIZE * 1024 * 1024)) )); then PRIORITY='-2'; else PRIORITY="$MOVIES_PRIORITY"; fi;
      SCRIPT="$MOVIES_SCRIPT";
    fi;
  fi;


  if ! [ "$CATEGORY" == "$SERIES_CATEGORY" ]; then
    if ! [ "$CATEGORY" == "$MOVIES_CATEGORY" ]; then
      # If GAMES_GROUPS name is found do tv show procedure for games
      for GAMES_GROUP in "${GAMES_GROUPS[@]}"
      do
        if (( ${#GAMES_GROUP} > 2 )); then
        	if ! [ -z "$(echo "$CLEAN_NAME" | grep -io \"[-| ]"$GAMES_GROUP"\")" ]; then
            	log "  NZB is a game.";
  	        CATEGORY="$GAMES_CATEGORY";
  	        PRIORITY="$GAMES_PRIORITY";
  	        SCRIPT="$GAMES_SCRIPT";
        	fi;
        fi;
      done;
    fi;
  fi;


  # Set priority to high when size is under HIGH_PRIORITY_SIZE.
  if (( SIZE < ((HIGH_PRIORITY_SIZE * 1024 * 1024)) ));
    then PRIORITY='1';
    log " Size below ''$HIGH_PRIORITY_SIZE''mb, assigning high priority.";
  fi;

  # Get the releasename if there is one
  RELEASENAME_REGEX="[_a-zA-Z.0-9-]\{""$MIN_RELEASENAME_SIZE"",\}-[a-zA-Z0-9]\{2,\}";
  RELEASENAME=$(echo "$CLEAN_NAME" | grep -o ""$RELEASENAME_REGEX"" | head -1);
  if [ -z "$RELEASENAME" ]; then
    # Replace spaces with . and try again
    RELEASENAME=$(echo "${CLEAN_NAME// /.}" | grep -o ""$RELEASENAME_REGEX"" | head -1);
    if [ -z "$RELEASENAME" ]; then
      # Try another method to catch the releasename (Catches "Dexter FRENCH test 720p HDTV x264 JMT" f.e.
      readarray -t VAR <<< "$(echo "$CLEAN_NAME" | grep -Eo '( [a-zA-Z0-9]{2,15})')";
      if ! [ -z "$VAR" ]; then
        VAR=${VAR[((${#VAR[@]} - 1))]};
        VAR=${VAR/ /};
        VAR=${CLEAN_NAME/ $VAR/-$VAR};
        RELEASENAME=$(echo "${VAR// /.}" | grep -o ""$RELEASENAME_REGEX"" | head -1);
      fi;
    fi;
  fi;

  # Mix RELEASENAME, IMDB_ID and PASSWORD to final nzb name. If no RELEASENAME found, use original name.
  if ! [ -z "$RELEASENAME" ]; then
    if ! [ -z "$PASSWORD" ]; then
      NZBNAME="$RELEASENAME""$IMDB_ID"" / ""$PASSWORD";
    else
      NZBNAME="$RELEASENAME""$IMDB_ID";
    fi;
    log " New name: \"""$NZBNAME""\".";
  else
    NZBNAME="$NAME";
    log " No releasename found, using original name.";
  fi;

else
  log " String exception found - stopped pre processing, using original name.";
  NZBNAME="$NAME";
fi;

# Each parameter (except 1) can be an empty line, meaning the original value.
echo "$ACCEPT";   # 0=Refuse, 1=Accept
echo "$NZBNAME";  # Name of the NZB (no path, no ".nzb")
echo "$PP_FLAGS"  # Post Processing (PP) flags: 0 = Download, 1 = +Repair, 2 = +Unpack, 3 = +Delete
echo "$CATEGORY"; # Category
echo "$SCRIPT"    # Script (basename)
echo "$PRIORITY"; # Priority (-100 -2, -1, 0 or 1, meaning Default, Paused, Low, Normal, High)
echo ''           # Group to be used (in case your provider doesn't carry all groups and there are multiple groups in the NZB)

# Any output after line 7 is ignored.

if [ "$ACCEPT" == 0 ]; then log " NZB ""$NZBNAME"" refused."; fi;

log "Done.";

exit 0; # If the script has an exit code other than 0, it's assumed the script failed and the NZB will be accepted. 0 is standard.

