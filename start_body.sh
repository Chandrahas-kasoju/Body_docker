#!/bin/bash
# Container command: brings up all body ROS nodes.
# Runs on every container start, so `restart: unless-stopped` in
# docker-compose.yaml is all that is needed for autostart on boot.

# The robot's router boots slower than the Pi. If the nodes start before WiFi
# is up, CycloneDDS binds to docker0 and they stay invisible to the head.
# The container uses host networking, so the host's routes are visible here.
echo "[start_body] Waiting for network..."
for i in $(seq 1 150); do
    if awk '$2 == "00000000" { found = 1 } END { exit !found }' /proc/net/route; then
        echo "[start_body] Network is up."
        break
    fi
    sleep 2
done

source /etc/turtlebot4/setup.bash
cd /root/ros2_ws

if [ ! -f install/setup.bash ]; then
    echo "[start_body] No install/ found, building workspace..."
    colcon build || exit 1
fi
source install/setup.bash

exec ros2 launch body_bringup body_bringup.launch.py
