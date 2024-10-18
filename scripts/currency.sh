#!/bin/bash
sudo apt update
sudo apt install python3-pip -y
sudo apt install wget unzip
sudo pip install Flask
sudo pip install mysql-connector
sudo apt install -y mysql-server

git clone https://github.com/amansin0504/tfm-demo-app-agents2.0-gcp.git
mkdir -p app/templates
cp tfm-demo-app-agents2.0-gcp/source/currency.py app/app.py
cp tfm-demo-app-agents2.0-gcp/source/templates/currency.json app/templates/
cd app
flask run  --host=0.0.0.0 -p 8996&


# Login to MySQL as root and create a dummy database and table
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';
FLUSH PRIVILEGES;
CREATE DATABASE dummy_db;
USE dummy_db;
CREATE TABLE credit_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    customer_name VARCHAR(100),
    card_number VARCHAR(16),
    expiry_date DATE,
    cvv VARCHAR(3)
);
INSERT INTO credit_cards (user_id, customer_name, card_number, expiry_date, cvv) VALUES
(10001, 'John Doe', '1111222233334444', '2023-12-31', '123'),
(10002, 'Jane Smith', '5555666677778888', '2024-06-30', '456'),
(10003, 'Alice Johnson', '9999000011112222', '2025-09-15', '789'),
(10004, 'Bob Brown', '3333444455556666', '2022-11-20', '101'),
(10005, 'Charlie Davis', '7777888899990000', '2023-01-10', '202');
EOF

echo "MySQL installation and dummy database setup complete."

# Install agent
wget -O csw-linux-installer.sh "${downloadurl}"
chmod 755 csw-linux-installer.sh 
sudo ./csw-linux-installer.sh