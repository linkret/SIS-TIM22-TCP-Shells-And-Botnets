#!/bin/bash

docker exec victim tcpdump -n 'tcp[tcpflags] & tcp-syn != 0 and port 80'