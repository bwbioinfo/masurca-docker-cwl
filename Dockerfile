FROM rockylinux/rockylinux:8

RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf clean all

RUN dnf install -y wget
RUN dnf install -y gcc-c++ 
RUN dnf install -y gcc
RUN dnf install -y make 
RUN dnf install -y zlib-devel 

RUN dnf clean all

WORKDIR /opt/

RUN wget https://github.com/alekseyzimin/masurca/releases/download/v4.1.0/MaSuRCA-4.1.0.tar.gz
RUN tar -xvf MaSuRCA-4.1.0.tar.gz

WORKDIR /opt/MaSuRCA-4.1.0
RUN ./install.sh

ENTRYPOINT ["masurca"]
