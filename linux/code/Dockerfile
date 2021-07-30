FROM ubuntu:18.04

RUN apt-get update && apt-get install -y sudo iputils-ping curl iproute2 net-tools bridge-utils tcpdump iptables
WORKDIR /home/shell
COPY ./shell .

ENTRYPOINT ["sh"]
CMD ["agr1"]