#!/bin/bash
sudo apt-get update
sudo apt install -y python3-dev python3-pip python3-virtualenv sqlite3
sudo -H pip3 install -r requirements.txt