#!/bin/bash
tag='7.4'

#for tag in 7.2 7.3 7.4; do
    docker build -t mageviper/magento-unit-tests:$tag -f Dockerfile:$tag . --no-cache
#    docker push mageviper/magento-unit-tests:$tag
#done
