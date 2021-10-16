#!/bin/bash

echo 'Server start script initialized...'



echo '[ServerNotifier] Cleaning port 9000...'
fuser -k 9000/tcp


# Starting the NotifierServer in a job
echo 'Starting the PlexNotifierServer...\nLogs will be available in '$PWD'/logServer.txt'
dart /app/NotifierServer/bin/plex_notifier.dart &> logServer.txt &

# Set the port
PORT=32485

# Kill anything that is already running on that port
echo '[WebApp] Cleaning port ' $PORT '...'
fuser -k 32485/tcp

# Change directories to the release folder
cd build/web/

# Start the HTTP server for webapp
echo '[WebApp] Starting webapp on port' $PORT '...'
python3 -m http.server $PORT

# Exit
echo '[WebApp] HTTP Server exited...'