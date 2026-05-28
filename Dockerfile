FROM ros:humble

# Install git, colcon, and the REQUIRED rosbridge-server
RUN apt-get update && apt-get install -y \
    git \
    python3-colcon-common-extensions \
    ros-humble-rosbridge-server \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-image-transport-plugins \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --user \
    'git+https://github.com/Chandrahas-kasoju/python-st3215.git'


WORKDIR /root/ros2_ws/src

RUN pip3 install pi5neo





WORKDIR /root/ros2_ws



RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> /root/.bashrc
RUN mkdir -p /etc/turtlebot4
COPY setup.bash /etc/turtlebot4/setup.bash
COPY cyclonedds_pc.xml /etc/turtlebot4/cyclonedds_pc.xml
RUN echo "source /etc/turtlebot4/setup.bash" >> /root/.bashrc

CMD ["bash"]
