FROM centos:7
MAINTAINER The CentOS Project <cloud-ops@centos.org>
LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40

RUN yum -y update && \
    yum -y upgrade && \
    yum -y install python && \
    yum -y install python-pip

COPY script.sh /root/script.sh

RUN chmod +x /root/script.sh

WORKDIR /root/
expose 2000

CMD ["sh", "-c"," ./script.sh"]
