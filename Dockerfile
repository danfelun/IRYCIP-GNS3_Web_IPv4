FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        nginx \
        bash \
        iproute2 \
        iputils-ping \
        curl \
        wget \
        procps \
        net-tools \
        traceroute \
        dnsutils \
        netcat-openbsd \
        tcpdump \
        nano \
        vim-tiny \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
