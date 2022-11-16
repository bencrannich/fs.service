FROM debian:stable-slim AS base

WORKDIR /root

ENV LC_ALL C
ENV TZ=UTC
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::Install-Recommends "0"; \n\
APT::Install-Suggests "0"; \n\
APT::Get::Assume-Yes "true"; \n\
' > /etc/apt/apt.conf.d/noninteractive
ONBUILD RUN apt-get update

## File Service container for rsync clients

FROM base AS rsync

RUN apt-get install -y openssh-server rsync
RUN rm -vf /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub

CMD ["/usr/sbin/sshd", "-D", "-e"]

## File Service container for CIFS clients

FROM base AS cifs

RUN apt-get install -y samba

EXPOSE 137/udp
EXPOSE 138/udp
EXPOSE 139
EXPOSE 445

CMD ["/usr/sbin/smbd", "-FS", "--no-process-group"]
