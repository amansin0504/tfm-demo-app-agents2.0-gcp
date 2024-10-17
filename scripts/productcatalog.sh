#!/bin/bash
sudo apt update
sudo apt install python3-pip -y
sudo apt install wget unzip
sudo pip install Flask

git clone https://github.com/amansin0504/tfm-demo-app-agents2.0-gcp.git
mkdir -p app/templates
cp tfm-demo-app-agents2.0-gcp/source/productcatalog.py app/app.py
cp tfm-demo-app-agents2.0-gcp/source/templates/productcatalog.json app/templates/
cd app
flask run  --host=0.0.0.0 -p 8994&

wget -O csw-linux-installer.sh "${downloadurl}"
chmod 755 csw-linux-installer.sh 
sudo ./csw-linux-installer.sh