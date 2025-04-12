#!/bin/bash
# Installer UDP-Custom by Kang Hory
# recode https://github.com/Haris131/UDP-Custom.git
# Usage: ./install-udp.sh "80,443"

cd
rm -rf /root/udp
mkdir -p /root/udp

echo "Set timezone to GMT+7 (Asia/Jakarta)..."
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

echo "Installing UDP-Custom binary..."
wget -q "https://github.com/kanghory/UDP-Custom/raw/main/udp-custom-linux-amd64" -O /root/udp/udp-custom
chmod +x /root/udp/udp-custom

echo "Downloading default config..."
wget -q "https://raw.githubusercontent.com/kanghory/UDP-Custom/main/config.json" -O /root/udp/config.json
chmod 644 /root/udp/config.json

echo "Removing old service if exists..."
systemctl stop udp-custom &>/dev/null
systemctl disable udp-custom &>/dev/null
rm -f /etc/systemd/system/udp-custom.service

echo "Creating systemd service..."
if [ -z "$1" ]; then
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom by ePro Dev. Team

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
else
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom by ePro Dev. Team

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server -exclude $1
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
fi

echo "Reloading systemd daemon..."
systemctl daemon-reexec
systemctl daemon-reload

echo "Starting and enabling udp-custom service..."
systemctl start udp-custom
systemctl enable udp-custom

echo "Installation complete, jika udp belum konek silahkan reboot vps kalian"
echo ""
read -p "Reboot now? [y/n]: " yn
if [[ "$yn" =~ ^[Yy]$ ]]; then
    reboot
else
    echo ""
    echo "Instalasi selesai. Silakan reboot manual lewat menu reboot di menu awal vps jika udp custom belum konek."
    exit 0
fi


