#!/bin/bash
sudo apt upgrade -y
sudo apt install -y apache2
sudo systemctl statrt apache2
sudo systemctl enable apache2
echo "<h1> Hello World from $(hostname -f)</h1>" > /var/www/html/index.html