#!/bin/bash

# get the world name from command line

world_name=${1:-world}

# log file location
log_file=/home/patroklo_root/server_log.log


# checks the server status and returns a 1 for online a 0 for offline
check_status()
{
	# we call the service that checks if the server is online
	# then we check through a regex that gets the first word after
	# the server name, if it is not "running" then it's not active
	# and will return a 0 in that case
	return_call=$(mc_call "status $world_name")
	server_state=`expr match "$return_call" '.*'$world_name': \(\w\+\)'`

	if [[ $server_state == "running"* ]];
	then
	  echo 1
	else
	  echo 0
	fi
}

# sends to the minecraft server the order of storing in disk all data that it's only in memory
backup_server()
{
	echo $(mc_call "send $world_name save-all")
}

# sends to the minecraft server the order of starting the server
start_server()
{
	mc_call "start $world_name"
}

# base method of making all the minecraft server callings
mc_call()
{
    echo `/home/patroklo_root/minecraft_server/mscs/mscs $1`
}

# adds a new entry in the log file
new_log()
{
	NOW=$(date +"%d-%m-%Y %H:%M:%S")
	echo "$NOW - $1" >> $log_file
}

# 1 - check that the server is still running
is_running=$(check_status)

if [[ $is_running == 1 ]];
then
	new_log "Server is online!"
	# 2 - if server is running we store the memory data in disk
	backup_server
	new_log "Server data stored"
else
	# 3 - if server is down, we start it again
	new_log "Server is offline!"
	start_server

        PIDS=`pidof java`
        for p in $PIDS; do
           chrt -f -p 10 $p
        done
	new_log "Server started"
fi
exit 0
