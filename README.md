# Minecraft Status Server Script

Must be used alongside [minecraft server script](https://github.com/sandain/MinecraftServerControlScript).

## Installation

* Change the log file name into a proper one for your installation.
* Make a cronjob calling the server_check_script.sh file.
> For example, to make a 1 minute cronjob calling
> ```
> crontab -e
> ```
> And then adding this code to the file
> ```
> * * * * * /home/minecraft/derp/server_check_script.sh > /dev/null
> ```

* Profit!

## Ways of calling the file

* With server name

```
./server_check_script.sh server_name
```

* Without server name (by default will use "world" as server name)

```
./server_check_script.sh
```

## How it works:

* Checks if the server passed via parameter is up.
* If server is up, then stores all RAM data that it's not still saved in disk.
* If server is down, it starts it.
