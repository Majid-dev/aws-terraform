#!/bin/bash
sudo apt upgrade -y
sudo apt install -y apache2
sudo systemctl statrt apache2
sudo systemctl enable apache2