#!/bin/bash

# docker run -d -p 8080:80 --name vanillary --rm -v "uploads:/var/www/html/uploads" -v "conf:/var/www/html/conf" severeoverfl0w/vanilla

docker run -d -p 8080:80 --name vanillary -v "uploads:/var/www/html/uploads" -v "conf:/var/www/html/conf" suculent/vanilla-forums

