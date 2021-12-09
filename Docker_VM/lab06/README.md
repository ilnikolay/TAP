## 1. Script from task 1:
```bash
#!/usr/bin/env bash

# Create networks
for i in {1..2}; do
  docker network create -d bridge net$i
done

# Create containers
for j in {1..3}; do
  docker run -dit --name alpine$j alpine 
done

# Add containers to different networks
docker network connect net1 alpine1
docker network connect net1 alpine2
docker network connect net2 alpine2
docker network connect net2 alpine3

# Performing pings
echo "Ping from alpine1 to alpine2"
docker exec alpine1 ping -c2 alpine2
echo "Ping from alpine1 to alpine3"
docker exec alpine1 ping -c2 alpine3
echo "Ping from alpine2 to alpine3"
docker exec alpine2 ping -c2 alpine3
```

### Results for task1:
```
Creating both networks:

970274e86eefed0cc40d58be6a13a08cf2091bad4c023fcd3b2fb4ab60018797
09392e24182e2f58a325c3e4fe6961432fc4835813323808aaee9ad1b670ee1c

Running the containers

caecb7797228e8e8d8f3f2e166d9fcf02e393822c15a760b87f11e57f8c9efb2
0ca432a5202a126d8817c58f5717c78099777db9cb0f7455a839dcab13d8aab6
3e27e9a80b5672b6a6365652143ca49cb9e0ff8640cc165ca64d118b003641b5


Ping from alpine1 to alpine2
PING alpine2 (172.19.0.3): 56 data bytes
64 bytes from 172.19.0.3: seq=0 ttl=64 time=0.151 ms
64 bytes from 172.19.0.3: seq=1 ttl=64 time=0.156 ms

--- alpine2 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.151/0.153/0.156 ms
Ping from alpine1 to alpine3
ping: bad address 'alpine3'
Ping from alpine2 to alpine3
PING alpine3 (172.20.0.3): 56 data bytes
64 bytes from 172.20.0.3: seq=0 ttl=64 time=0.155 ms
64 bytes from 172.20.0.3: seq=1 ttl=64 time=0.147 ms

--- alpine3 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.147/0.151/0.155 ms
```
## 2. All files for task2 are in the folder task2
