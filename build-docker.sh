#!/bin/bash

version=$1

# First we build the images
sudo docker build . -t  feldrise/adopteunmatou-app 

# The we add tag for version
sudo docker image tag feldrise/adopteunmatou-app:latest feldrise/adopteunmatou-app:$version

# Finally we push to Docker hub
sudo docker push feldrise/adopteunmatou-app:latest
sudo docker push feldrise/adopteunmatou-app:$version