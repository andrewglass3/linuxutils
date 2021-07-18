FROM ubuntu:focal
LABEL name Andrew Glass <andrew.glass@outlook.com>

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' \
    >> /etc/bash.bashrc \
    ; echo "\
==============================================================\n\
= Trading Cloud Engineering Troubleshooting Tools Container  =\n\
==============================================================\n\
\n\
This container has the usual linux suspects for debugging ie netcat, dig, nmap, mtr, nslookup, awk, ack etc.\n\
Built to avoid mac os tooling changes that may catch us unaware i.e nslookup usage differences\n\
\n\
(c) Andrew Glass 2021  (c) \n\
\n\
==============================================================\n\
= Kafka and Cassandra tools are found in the tools directory =\n\
==============================================================\n"\


    > /etc/motd

RUN \
       apt-get -qq update && \
       apt-get install -y ack awscli curl dnsutils git htop inetutils-ping mtr netcat nmap  python python3 python3-pip sed tcpdump util-linux wget && rm -rf /var/lib/apt/lists/* && apt-get clean && \
       mkdir -p /tools/kafka && \
       cd /tools/kafka/ && \
       wget https://archive.apache.org/dist/kafka/2.5.1/kafka_2.12-2.5.1.tgz && \
       tar xvzf kafka_2.12-2.5.1.tgz && \
       rm kafka_2.12-2.5.1.tgz && \
       mkdir -p /tools/cassandra && \
       cd /tools/cassandra && \
       wget https://www.mirrorservice.org/sites/ftp.apache.org/cassandra/3.11.10/apache-cassandra-3.11.10-bin.tar.gz && \
       tar -xf apache-cassandra-3.11.10-bin.tar.gz && \
       rm apache-cassandra-3.11.10-bin.tar.gz