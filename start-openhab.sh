docker run --name openhab \
--net=host \
--tty \
-v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro \
-v /home/pi/shared/IOTstack/volumes/openhab/addons:/openhab/addons:rw \
-v /home/pi/shared/myscripts/openhab/conf:/openhab/conf:rw \
-v /home/pi/shared/IOTstack/volumes/openhab/userdata:/openhab/userdata:rw \
-d \
-e OPENHAB_HTTP_PORT=4050 \
-e OPENHAB_HTTPS_PORT=4051 \
-e USER_ID=1000 \
-e GROUP_ID=115 \
-e "EXTRA_JAVA_OPTS=-Duser.timezone=Europe/Berlin" \
--restart=always \
openhab/openhab:latest

