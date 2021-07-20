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
====================================================================\n\
= Kafka and Cassandra tools are found in the tools directory       =\n\
= However the tools can be called form initial login location      =\n\
= As they have been added to container path,you can call           =\n\
= kafka-tools or cqlsh in cassandra.  To list available            =\n\
= kafka & cassandra tools simply run 'listkafka or 'listcassandra' =\n\
=                                                                  =\n\
= Other Cloud tools inc aws-okta, saml2aws tfenv, helm,            =\n\
= helmsman, kubectl and vault.                                     =\n\
===================================================================\n"\


    > /etc/motd

RUN \
       apt-get -qq update && \
       apt-get install -y ack awscli curl dnsutils git htop inetutils-ping mtr netcat nmap  openjdk-8-jre-headless python python3 python3-pip ruby-full sed tcpdump util-linux wget && rm -rf /var/lib/apt/lists/* && apt-get clean && \
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
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/tools/kafka/kafka_2.12-2.5.1/bin:/tools/cassandra/apache-cassandra-3.11.10/bin:${PATH}"

USER root

RUN \
        brew update && brew install aws-okta helm helmsman saml2aws kubectl tfenv 

RUN \
        brew tap hashicorp/tap
RUN \
        brew install hashicorp/tap/vault
RUN \
        echo 'alias listkafka="ls /tools/kafka/kafka_2.12-2.5.1/bin/"' >> ~/.bashrc && \
        echo 'alias listcassandra="ls /tools/cassandra/apache-cassandra-3.11.10/bin"' >> ~/.bashrc
