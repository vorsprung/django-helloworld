#!/bin/bash
sudo apt-get update
sudo apt install -y python3-dev python3-pip python3-virtualenv sqlite3
cat << EOSIF > requirements.txt
# requirements.txt file
Django==2.2.3
EOSIF
pip3 install --user -r requirements.txt
