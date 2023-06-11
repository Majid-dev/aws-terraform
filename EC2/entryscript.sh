#!/bin/bash
apt upgrade -y
apt install -y apache2
systemctl statrt apache2
systemctl enable apache2
echo "<h1> Hello World from $(hostname -f)</h1>" > /var/www/html/index.html