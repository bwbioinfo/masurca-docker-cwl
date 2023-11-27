# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Update the package repository and install necessary dependencies
RUN apt-get update -y && \
    apt-get install -y wget \
    g++ \
    gcc \
    make \
    bzip2 \
    zlib1g-dev \
    libboost-all-dev \
    libbz2-dev && \
    # Clean up package manager caches and lists to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

WORKDIR /opt/
RUN wget https://github.com/alekseyzimin/masurca/releases/download/v4.1.0/MaSuRCA-4.1.0.tar.gz && \
    tar -xvf MaSuRCA-4.1.0.tar.gz && \
    rm MaSuRCA-4.1.0.tar.gz

# Set the working directory to the MaSuRCA directory
WORKDIR /opt/MaSuRCA-4.1.0

# Run the installation script for flye
RUN sed -i 's/ && cp -a \.\.\/Flye \$DEST//' install.sh
# Run the installation script
RUN ./install.sh

RUN apt-get update && \
    apt-get install -y cpanminus


# Remove unnecessary build packages to reduce image size
RUN apt-get remove -y wget \
    g++ \
    gcc \
    make \
    bzip2 \
    zlib1g-dev \
    libboost-all-dev \
    libbz2-dev && \
    apt-get autoremove -y && \
    # Clean up package manager caches and lists again
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# add the masurca bin to the path
ENV PATH="/opt/MaSuRCA-4.1.0/bin:${PATH}"

# Check the installation
RUN masurca -h

# Set Default Behavior
CMD ["masurca"]