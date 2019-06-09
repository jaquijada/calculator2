#!/bin/bash
#test $(curl 172.17.0.1:8765/sum?a=1\&b=2) -eq 3
CALCULATOR_PORT=$(docker-compose port calculator 8080 | cut -d: -f2)
test $(curl 172.17.0.1:$CALCULATOR_PORT/sum?a=1\&b=2) -eq 3
