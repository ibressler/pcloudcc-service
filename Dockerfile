# A Dockerfile to build and package pCloudCC from source
#
#   podman build . -t pcloudcc --build-arg TZ=Europe/Berlin
#
# Run the container interactively:
#
#   podman run --rm -it --cap-add SYS_ADMIN --device /dev/fuse -v ~/.config/pcloudcc:/root/.pcloud pcloudcc bash
#

FROM ubuntu:24.04 as builder
ARG TZ
# Set the environment variable for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive
# Set the timezone by given argument
ENV TZ=${TZ}

COPY . /build
WORKDIR /build
RUN sh install-build-deps.sh && \
    sh build.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ls -la /build

FROM ubuntu:24.04
ARG TZ
ENV DEBIAN_FRONTEND=noninteractive
# install runtime dependencies for pcloud and cleanup development packages later
RUN apt-get update && \
    apt-get install -y tzdata fuse libboost-program-options-dev libreadline8t64 sqlite3 && \
    apt-get purge -y $(dpkg -l | awk '/-dev[\s:]/{split($2,a,":"); print a[1]}') && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo "user_allow_other" >> /etc/fuse.conf

COPY --from=builder /build/src/pcloudcc /usr/local/bin

ENV USERNAME=
ENV DB=/root/.pcloud/data.db

CMD pcloudcc -s -u $USERNAME -m /pCloudDrive
