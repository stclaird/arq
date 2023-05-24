#!/bin/bash
hostnamectl set-hostname web-server
swapoff -a
apt-get -y update
apt-get install -y python3-pip
pip install fastapi
pip install uvicorn
pip install jinja2

apt-get -y git
apt install -y nginx
service nginx start

PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

cat <<EOF > /etc/nginx/sites-enabled/dynamic-string.conf
server {
        listen 80;    
        server_name dynamic-string.davidstclair.co.uk       
        location / {        
                proxy_pass http://127.0.0.1:8000;    
        }
}

EOF

mkdir /projects
cd /projects
git clone https://github.com/stclaird/arq

cd /projects/arq/arg

(crontab -l 2>/dev/null || echo ""; echo "*/5 * * * * /projects/arq/start_uvicorn.bash") | crontab -


service nginx restart