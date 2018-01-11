#!/bin/sh

rm -f /etc/redis/sentinel.conf

tee /etc/redis/sentinel.conf <<EOF
port 26379

dir /tmp
bind 0.0.0.0
sentinel monitor docker-cluster $SENTINEL_MASTER_HOST $SENTINEL_QUORUM
sentinel down-after-milliseconds docker-cluster $SENTINEL_DOWN_AFTER
sentinel parallel-syncs docker-cluster 1
sentinel failover-timeout docker-cluster $SENTINEL_FAILOVER
logfile "/etc/redis/redis-sentinel.log"
EOF


if [ -n "$SLAVEOF" ]; then
	redis_cmd="nohup redis-server --bind 0.0.0.0 --port $PORT --slaveof $SLAVEOF --logfile /etc/redis/redis-server.log > /dev/null 2>&1 &"
else
	redis_cmd="nohup redis-server --bind 0.0.0.0 --port $PORT --logfile /etc/redis/redis-server.log > /dev/null 2>&1 &"
fi

if [ -n "$SENTINEL_MASTER_HOST" ]; then
	echo $redis_cmd$'\n nohup redis-server /etc/redis/sentinel.conf --sentinel  > /dev/null 2>&1 &' > /etc/redis/start_redis
else
	echo "$redis_cmd" > /etc/redis/start_redis 

fi

chmod +x /etc/redis/start_redis

exec "$@"