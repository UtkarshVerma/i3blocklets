#!/bin/bash
#----------------------------------------------------------------------------------------------------
# Requires playerctl - https://github.com/acrisci/playerctl
#----------------------------------------------------------------------------------------------------
#Exit the script if no music players running
[[ "$(playerctl status 2>&1)" = "No players found" ]] && exit 33;

# Define cursor icons
playIcon="";
pauseIcon=" ⏸️";
stopIcon=" ⏹️";

#User provided args for playerctl
ARGUMENTS="$INSTANCE";

#Mouse actions for the block
case $BLOCK_BUTTON in
	1) playerctl $ARGUMENTS previous ;;
	2) playerctl $ARGUMENTS play-pause ;;
	3) playerctl $ARGUMENTS next ;;
	4) playerctl $ARGUMENTS position 5+ ;;
	5) playerctl $ARGUMENTS position 5- ;;
esac

#Define song info variables
playerStatus=$(playerctl $ARGUMENTS status);
songArtist="$(playerctl $ARGUMENTS metadata artist)";
songArtist="${songArtist:-(Unknown Artist)}";
songTitle=$(playerctl $ARGUMENTS metadata title);
songInfo="$songArtist - $songTitle";
songDuration="";
elapsedTime=$(playerctl metadata --format "{{ duration(position) }}");
songLength=$(playerctl metadata --format "{{ duration(mpris:length) }}");

#`playerctl position` doesn't work for "Spotify"
if [[ $(playerctl -l) != "spotify" ]]; then
	songDuration=" ($elapsedTime/$songLength)";
fi

#Display output
if [[ "${playerStatus^}" = "Paused" ]]; then
	echo "$songInfo$songDuration$pauseIcon";
elif [[ "${playerStatus^}" = "Playing" ]]; then
	echo "$songInfo$songDuration$playIcon";
elif [[ "${playerStatus^}" = "Stopped" ]]; then
	echo "Stopped$stopIcon";
fi
