# this script reproduce steps of deploying this project
# into a mikrotik router running on routeros [7.24.4^]

# enable containers support
# [requires 'container' pkg installed on routeros]
/system/device-mode/update container=yes

# create virtual ethernet
/interface/veth/add name=veth1 address=172.17.0.2/24 gateway=172.17.0.1

# create birdge for containers
/interface/bridge/add name=containers

# define address for bridge
/ip/address/add address=172.17.0.1/24 interface=containers

# link interface:veth1 <> bridge:containers
/interface/bridge/port/add bridge=containers interface=veth1

# add firewall rule to forward ports from container on global router address
# [ if you modified port or address in server's 'config.json',
#   fill dst-* with your values ]
/ip/firewall/nat/add \
    chain=dstnat \
    action=dst-nat \
    to-addresses=172.17.0.2 \
    to-ports=1984 \
    protocol=tcp \
    dst-address=192.168.88.1 \
    dst-port=1984

# create cluster directory mount entry
/container/mounts/add name=cluster src=usb1/.cluster dst=.cluster

# add container with following rules
# [change 'usb1' with your disk name]
/container/add \
  file=usb1/de-gui.tar \
  interface=veth1 \
  root-dir=usb1/containers/de-gui \
  mountlists=cluster \
  name=de-gui \
  start-on-boot=yes \ 
  logging=yes \
  dns=1.1.1.1,8.8.8.8

# run the container
/container/start de-gui

# (additionally) check if 'de-gui' container is running ['R' letter on the left]
/container/print