#!/bin/bash
# Log output for debugging
exec > >(tee /var/log/userdata.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=== Starting EC2 initialization with Apache2 ==="

# Update and upgrade system packages
sudo apt update -y
sudo apt upgrade -y

# Install Apache2 web server
sudo apt install -y apache2

# Enable and start Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

# Create a custom index page
cat <<EOF | sudo tee /var/www/html/index.html
<html>
  <head>
    <title>KAREEM TERRAFORM EC2 INSTANCE!</title>
  </head>
  <body style="font-family: Arial; background: #f8f9fa; text-align: center;">
    <h1 style="color: #007bff;">KAREEM TERRAFORM EC2 INSTANCE!</h1>
    <p>Apache Web Server successfully installed and running.</p>
    <p>Hostname: $(hostname)</p>
    <p>Deployed on: $(date)</p>
  </body>
</html>
EOF

# Allow HTTP through UFW (if firewall is active)
if command -v ufw >/dev/null 2>&1; then
  sudo ufw allow 'Apache Full'
  sudo ufw --force enable
fi

echo "=== Apache installation and setup complete ==="
