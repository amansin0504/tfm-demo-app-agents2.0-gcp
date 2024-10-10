#!/bin/bash
sudo apt update
sudo apt install python3-pip -y
sudo apt install wget
sudo pip install Flask

git clone https://github.com/amansin0504/tfm-demo-app-agents2.0-gcp.git
mkdir -p app/templates
cp tfm-demo-app-agents2.0-gcp/source/currency.py app/app.py
cp tfm-demo-app-agents2.0-gcp/source/templates/currency.json app/templates/
cd app
flask run  --host=0.0.0.0 -p 8996&
