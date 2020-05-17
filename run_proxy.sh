#!/bin/bash

PID_END=99
PPROXY_PORT=8100
TOR_PORT=9100
TOR_CONTROL=20000
BASE_IP=192.168.77.3
INSTANCE=$1
ACTION=$2
UPDATE="update"

case $ACTION in
"-start")
    echo "Start"
    for i in $(seq 1 ${INSTANCE});
      do
    	c_port=$((TOR_CONTROL+i))
	s_port=$((TOR_PORT+i))
	p_port=$((PPROXY_PORT+i))
    echo "tor --RunAsDaemon 1 --CookieAuthentication 0 --HashedControlPassword "" --ControlPort $c_port --SocksPort $s_port --DataDirectory /root/tor/data_tor/tor$i"
    tor --RunAsDaemon 1 --CookieAuthentication 0 --HashedControlPassword "" --ControlPort $c_port --SocksPort $s_port --DataDirectory /root/tor/data_tor/tor$i
    echo "pproxy -l http+socks4+socks5://$BASE_IP:$p_port/#user1:111 -r socks5://127.0.0.1:$s_port --daemon"
    pproxy -l http+socks4+socks5://$BASE_IP:$p_port/#user1:111 -r socks5://127.0.0.1:$s_port --daemon
      done
;;
"-stop")
    echo "Stop"
;;
esac
