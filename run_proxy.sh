#!/bin/bash

PID_END=99
PPROXY_PORT=8100
TOR_PORT=9100
TOR_CONTROL=20000
BASE_IP=192.168.77.3
INSTANCE=$2
ACTION=$1
UPDATE="update"

case $ACTION in
"-start")
    echo "Start"
    root_dir=/var/tmp/tor/
    if ! [ -d $root_dir ]; then
	    mkdir $root_dir
	    chown toranon:toranon $root_dir
    fi
    for i in $(seq 1 ${INSTANCE});
      do
    	c_port=$((TOR_CONTROL+i))
	s_port=$((TOR_PORT+i))
	p_port=$((PPROXY_PORT+i))
      
        tor_cmd="tor --RunAsDaemon 1 --CookieAuthentication 0 --HashedControlPassword \"\" --ControlPort $c_port --SocksPort $s_port --DataDirectory  $root_dir/tor$i --User toranon"
        echo $tor_cmd
        eval $tor_cmd
        echo "pproxy -l http+socks4+socks5://$BASE_IP:$p_port/#user1:111 -r socks5://127.0.0.1:$s_port --daemon"
        pproxy -l http+socks4+socks5://$BASE_IP:$p_port/#user1:111 -r socks5://127.0.0.1:$s_port --daemon
      done
;;
"-stop")
    echo "Stop"
    killall tor
    killall pproxy
;;
"--help"|"-h"|*)
    echo "Usage: run_proxy.sh [-start,-stop,-help] [instance]"
esac
