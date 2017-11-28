#!/bin/bash

echo -n "[i] removing current MoTD content: "
echo "" | sudo tee /etc/motd
echo "done"

if [ -f "/etc/ssh/sshd_config" ]; then
	echo -n "[i] configuring sshd: "
    sudo sed -i 's/^PrintMotd .*//g' /etc/ssh/sshd_config
    sudo sed -i 's/^PrintLastLog .*//g' /etc/ssh/sshd_config
    echo "PrintMotd no" | sudo tee -a /etc/ssh/sshd_config
    echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config
	echo "done"

	echo -n "[i] restarting sshd service: "
    sudo service ssh restart
	echo "done"
fi

if [ -f "/etc/init.d/motd" ]; then
    sudo sed -i '/uname/ s/^/#/' /etc/init.d/motd
    sudo rm -f /run/motd.dynamic
fi

if [ ! -f "/etc/motd.dynamic" ]; then
	echo -n "[i] installing new MoTD: "
    sudo cp ./motd.sh /etc/motd.dynamic
    sudo chmod +x /etc/motd.dynamic
    echo "source /etc/motd.dynamic" | sudo tee -a ~/.profile
	echo "done"
fi

echo "[raspberrypi-motd] - successfully installed!"