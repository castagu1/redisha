FROM centos:latest

RUN yum -y install make
RUN yum -y install centos-release-scl
RUN yum -y install gcc gcc-c++

RUN mkdir /usr/local/bin/redis
COPY redis-4.0.6.tar.gz /usr/local/bin/redis
RUN tar -xvf /usr/local/bin/redis/redis-4.0.6.tar.gz -C /usr/local/bin/redis/
RUN cd /usr/local/bin/redis/redis-4.0.6/deps && make hiredis jemalloc linenoise lua
RUN cd /usr/local/bin/redis/redis-4.0.6 && make install

COPY createSentinelConfigFile.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/createSentinelConfigFile.sh
COPY start_redis /usr/local/bin/
RUN mkdir -p /etc/redis
ENTRYPOINT createSentinelConfigFile.sh && start_redis && /bin/bash
