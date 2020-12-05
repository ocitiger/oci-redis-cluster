#!/bin/bash

INIT_COUNT=${count}
INIT_DNS="${name}0.${name}.${name}.oraclevcn.com"
NODE_DNS=$(hostname -f)
MASTER_PRIVATE_IP=$(host "$INIT_DNS" | awk '{ print $4 }')
PRIVATE_IP=$(host "$NODE_DNS" | awk '{ print $4 }')

REDIS_PORT=6379
REDIS_CONFIG_FILE=/etc/redis.conf
SENTINEL_PORT=26379
SENTINEL_CONFIG_FILE=/etc/sentinel.conf


# Setup firewall rules
firewall-offline-cmd  --zone=public --add-port=6379/tcp
firewall-offline-cmd  --zone=public --add-port=16379/tcp
firewall-offline-cmd  --zone=public --add-port=26379/tcp
systemctl restart firewalld

yum install epel-release -y ; yum update -y ;yum install redis  -y ; systemctl start redis ; systemctl enable redis; yum install redis-trib  -y;

sed -i "s/^bind 127.0.0.1/bind $PRIVATE_IP/g" $REDIS_CONFIG_FILE
sed -i "s/^# cluster-enabled yes/cluster-enabled yes/g" $REDIS_CONFIG_FILE
# cluster-enabled yes
systemctl restart redis

sleep 120
#only execute on the first node
if [[ $INIT_DNS == $NODE_DNS ]]; then
  #try to ping each redis node,make sure they are all live
  tryCount=10
  tryI=0
  while [ $tryI -lt $tryCount ]; do
    echo "trying for the  $tryI loop " >> /tmp/M.log
    P_NODE_IP_PORT="" 
    let tryI++
    #try get the internal ip address of redis node.
    P_RESDIS_RES_PING_FLAG="PONG"
    for (( c=0; c<$INIT_COUNT; c++ ))
    do
      P_NODE_DNS="${name}$c.${name}.${name}.oraclevcn.com"
      P_NODE_IP=$(host "$P_NODE_DNS" | awk '{ print $4 }')
      P_RESDIS_RES_PING=$(redis-cli -h $P_NODE_IP ping)
      if [ "$P_RESDIS_RES_PING" == "PONG" ]; then
        echo "$P_NODE_DNS $P_NODE_IP $P_RESDIS_RES_PING" >> /tmp/M.log
        P_NODE_IP_PORT=$P_NODE_IP_PORT$P_NODE_IP":"$REDIS_PORT" "
      else
        P_RESDIS_RES_PING_FLAG=$P_RESDIS_RES_PING
        echo "$P_NODE_DNS $P_NODE_IP $P_RESDIS_RES_PING" >> /tmp/M.log
        echo "Break for 10s then be ready for the next loop" >> /tmp/M.log
      fi
    done
    if [ "$P_RESDIS_RES_PING" == "PONG" ]; then
      echo "Ready at the $tryI loop"
      echo "all the redis nodes are live..." >> /tmp/M.log
      echo "echo yes | sudo redis-trib create --replicas 1  $P_NODE_IP_PORT" >> /tmp/M.log
      echo yes | sudo redis-trib create --replicas 1  $P_NODE_IP_PORT
      #exit the while loop
      break
    else
      echo "Not Ready  at the $tryI loop,Break 10s for the next loop"  >> /tmp/M.log
      sleep 10
    fi
    #systemctl restart redis
  done
#do nothing on the other nodes
else
  echo "..." >>/tmp/S.log
fi
