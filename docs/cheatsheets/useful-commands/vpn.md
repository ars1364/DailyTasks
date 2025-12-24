# Useful commands: VPN

```text
#uncheck use default gateway(VPN connection peroperties)
strong swan
###### l2tp client
https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients.md#linux
VPN_SERVER_IP='x.x.x.x'
VPN_IPSEC_PSK='00000'
VPN_USER='username'
VPN_PASSWORD='password'
mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control
ipsec restart
service xl2tpd restart
ipsec up myvpn
echo "c myvpn" > /var/run/xl2tpd/l2tp-control
```