#!/bin/bash

set -ex

IMAGE_NAME="ancc/base"
VERSION=1.0.0

docker build -t $IMAGE_NAME:$VERSION .
mkdir output
echo $IMAGE_NAME:$VERSION > output/image