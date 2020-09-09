#!/bin/sh

if [ x"$URL" = x"localhost" ];then
  echo Invalid URL
  exit -1
fi

# Download and install newappray
mkdir /tmp/newapp
curl -L -H "Cache-Control: no-cache" -o /tmp/newapp/newapp.zip $URL
unzip /tmp/newapp/newapp.zip -d /tmp/newapp
install -m 755 /tmp/newapp/v2ray /usr/local/bin/newappray
install -m 755 /tmp/newapp/v2ctl /usr/local/bin/newappctl

# Remove temporary directory
rm -rf /tmp/newapp

# newappray new configuration
install -d /usr/local/etc/newapp
cat << EOF > /usr/local/etc/newapp/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 0
                    }
                ],
                "disableInsecureEncryption": true
            },
            "tag": "in-0",
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/v2"
                }
            }
        }
    ],
    "outbounds": [
        {
            "tag": "direct",
            "protocol": "freedom"
        }
    ]
}
EOF

# Run newappray
/usr/local/bin/newappray -config /usr/local/etc/newapp/config.json
