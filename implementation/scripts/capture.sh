#!/bin/bash

docker exec victim tcpdump -i eth0 -w /tmp/capture.pcap
docker cp victim:/tmp/capture.pcap ~/botnet-lab/capture.pcap
cp ~/botnet-lab/capture.pcap /mnt/c/Users/FOI/Documents/SIS/SIS-TIM22-TCP-Shells-And-Botnets/results/capture.pcap