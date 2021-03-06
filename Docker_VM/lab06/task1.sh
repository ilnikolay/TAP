#!/usr/bin/env bash
#set -x

# Create networks
for i in {1..2}; do
  docker network create -d bridge net$i
done

# Create containers
for j in {1..3}; do
  docker run -dit --name alpine$j  alpine 
done

ip_alpine1=`docker inspect alpine1 -f "{{.NetworkSettings.IPAddress}}"`
ip_alpine2=`docker inspect alpine2 -f "{{.NetworkSettings.IPAddress}}"`
ip_alpine3=`docker inspect alpine3 -f "{{.NetworkSettings.IPAddress}}"`

# Add containers to different networks
docker network connect net1 alpine1
docker network connect net1 alpine2
docker network connect net2 alpine2
docker network connect net2 alpine3


# Performing pings
echo "Ping from alpine1 to alpine2"
docker exec alpine1 ping -c2 $ip_alpine2
echo "Ping from alpine1 to alpine3"
docker exec alpine1 ping -c2 $ip_alpine3
echo "Ping from alpine2 to alpine3"
docker exec alpine2 ping -c2 $ip_alpine3
