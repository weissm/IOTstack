# IOTstack
docker stack for getting started on IOT on the Raspberry PI

This Docker stack consists of:
  * nodered
  * Grafana
  * influxDB
  * postgres
  * portainer
  * adminer
  
# Tested platform
Raspberry Pi 3B running Raspbian (Stretch)
  
# Youtube reference
this repo was inspired by Andreas Spiess's video on using these tools https://www.youtube.com/watch?v=JdV4x925au0 . This is an alternative approach to the setup. Be sure to watch the video for the instructions. Just note that the network addresses are different, see note below

## Download the project

```
git clone https://github.com/gcgarner/IOTstack.git
```

For those not familar with git or not CLI savy, the clone command downloads the repository and creates a folder with the repository name.

To enter the direcory run:
```
cd IOTstack
```
Personally I like to create a specific folder in my home directory for git repos so they are grouped together in `~/git`

## Before you start
Installing docker
```
curl -sSL https://get.docker.com | sh
```

to install docker-compose
```
sudo apt update && sudo apt install -y docker-compose
```

Note: when I installed docker-compose it is not the latest version it did not support version 3.
I devided to leave the yml file on version 2 for backwards compatibility.

# Running Docker commands
From this point on make sure you are executing the commands from inside the repo folder. If you need to at any point start or stop navigate back to the repo folder first

## Folder permissions
The containers are set to store persistent data in folder. Grafana runs with a different userid than the standard pi user. This workaround changes the permission of the folder so that data can be stored locally, run the `folderfix.sh`

```
sudo chmod +x ./folderfix.sh
sudo ./folderfix.sh
```
you only need to run this once.

## Starting and Stopping containers
to start the stack navigate to the folder containing the docker-compose.yml file

run the following
`docker-compose up -d`

to stop
`docker-compose down`

I've added two scripts for startin and stopping if you forget the commands
`./start.sh` starts the containers
`./stop.sh` stops the containers

side note: Docker deletes the containers with the docker-compose down command. However because the compose file specifies volumes the data is stored in persistent folders on the host system. This is good because it allows you to update the image and retain your data

## Updating the images
If a new version of a container it is simple to update it.
use the  `docker-compose down` command to stop the stack

pull the latest version from docker hub with one of the following commands

```
docker pull grafana/grafana:latest
docker pull influxdb:latest
docker pull nodered/node-red:latest
```

## Current issue with Grafana
As of the date of this publish the team at Grafana are working on an issue in the 6.4.X version for the ARM image. The compose file hard codes to version 6.3.6, when the issue is resolved the ":latest" tag can be used again in stead of ":6.3.6"

## Networking
The compose instruction creates a internal network for the containers to communicate in.
It also creates a "DNS" the name being the container name.
When you need to specify the address of your influxdb it will not be 127.0.0.1:8086 ! It will be INFLUXDB:8086
Similarly inside the containers the containers talk by name. However if you need to interact with it (from outside) you do if via your pi's ip e.g. 192.168.0.n:3000 (or 127.0.0.1:3000 if you are using the pi itself)

An easy way to find out your ip is by typing `ifconfig` in the terminal and look next to eth0 or wlan0 for your ip

## Portainer
Portainer is a great application for managing Docker. In your web browser navigate to `#yourip:9000`. You will be asked to choose a password. In the next window select 'Local' and connect, it shouldn't ask you this again. From here you can play around, click local, and take a look around. This can help you find unused images/containers. On the Containers section there are 'Quick actions' to view logs and other stats. Note: This can all be done from the CLI but portainer just makes it much much easier

## Postgres
I added a SQL server, for those that need it see password section for login details

## Adminer
This is a nice tool for managing databases. Web interface on port 8080

## Passwords
### Grafana
Grafana's default credentials are username "admin" passord "admin" it will ask you to choose a new password on boot

### influxdb
there is a file called influx.env in the folder influxdb inside it is the username and password. The default I set is "nodered" for both it is HIGHLY recommended that you change that

### Mosiquitto (MQTT)
reference https://www.youtube.com/watch?v=1msiFQT_flo
By default the MQTT container has no password. You can leave it that way if you like but its always a good idea to secure your services.

Step 1
To add the password run `./terminal_mosquitto.sh`, i put some helper text in the script. Basically you use the `mosquitto_passwd -c /etc/mosquitto/passwd MYUSER` command, replacing MYUSER with your username. it will then ask you to type your password and confirm it. exiting with `exit`. 

Step 2
edit the file called ./mosquitto/mosquitto.conf and remove the comment in front of password_file. Stop and Start and you should be good to go. Type those credentials into Nodered etc


## Node-red GPIO



