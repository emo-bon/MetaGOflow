# Get the core part of IPS
# -------------------------
FROM busybox AS buildcore

LABEL Maintainer="MGnify team <https://www.ebi.ac.uk/support/metagenomics>, Haris Zafeiropoulos <haris.zafeiropoulos@kuleuven.be>"
LABEL Version="metaGOflow version"

ARG IPR=5
ENV IPR $IPR
ARG IPRSCAN=5.57-90.0
ENV IPRSCAN $IPRSCAN

RUN mkdir -p /opt

RUN wget -q -O /opt/interproscan-core-$IPRSCAN.tar.gz ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/interpro
scan-core-$IPRSCAN.tar.gz
RUN wget -q -O /opt/interproscan-core-$IPRSCAN.tar.gz.md5 ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/inte
rproscan-core-$IPRSCAN.tar.gz.md5

WORKDIR /opt

RUN md5sum -c interproscan-core-$IPRSCAN.tar.gz.md5

RUN mkdir -p /opt/interproscan

RUN tar -pxzf interproscan-core-$IPRSCAN.tar.gz \
    -C /opt/interproscan --strip-components=1 && \
    rm -f interproscan-core-$IPRSCAN.tar.gz interproscan-core-$IPRSCAN.tar.gz.md5

# Get the bin part of IPS
# -------------------------
FROM busybox AS buildbin

ARG IPR=5
ENV IPR $IPR
ARG IPRSCAN=5.57-90.0
ENV IPRSCAN $IPRSCAN

RUN mkdir -p /opt

RUN wget -q -O /opt/interproscan-mgbin-$IPRSCAN.tar.gz ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/interpr
oscan-mgbin-$IPRSCAN.tar.gz
RUN wget -q -O /opt/interproscan-mgbin-$IPRSCAN.tar.gz.md5 ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/int
erproscan-mgbin-$IPRSCAN.tar.gz.md5

WORKDIR /opt

RUN md5sum -c interproscan-mgbin-$IPRSCAN.tar.gz.md5

RUN mkdir -p /opt/interproscan

RUN tar -pxvzf interproscan-mgbin-$IPRSCAN.tar.gz \
    -C /opt/interproscan --strip-components=1 && \
    rm -f interproscan-mgbin-$IPRSCAN.tar.gz interproscan-mgbin-$IPRSCAN.tar.gz.md5

# Build the image joining the 2 previous part of IPS
# --------------------------------------------------
FROM biocontainers/biocontainers:latest

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -f --reinstall -y python3 && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=buildcore /opt/interproscan /opt/interproscan
COPY --from=buildbin /opt/interproscan/bin /opt/interproscan/bin

ENV PATH="/opt/interproscan/:/opt/interproscan/bin:${PATH}"

RUN sed -i 's/http:\/\/www\.ebi\.ac\.uk\/interpro\/match-lookup//' /opt/interproscan/interproscan.properties

RUN apt-get install -y java-11

# Install the python script required for "add-apt-repository"
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        libgl1-mesa-dev \
        python-software-properties \
        software-properties-common \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Sets language to UTF8 : this works in pretty much all cases
ENV LANG pt_BR.UTF-8

# Install Java 11
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get install openjdk-11-jdk -y --force-yes

# Setup JAVA_HOME and other environment variables, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
ENV PATH $PATH:$JAVA_HOME/bin
ENV CLASSPATH $JAVA_HOME/lib/tools.jar
ENV MANPATH $JAVA_HOME/man

RUN echo "localhost" > /etc/hostname && echo "127.0.0.1\tlocalhost" > /etc/hosts 

WORKDIR /opt/interproscan

RUN rm -r data/

RUN apt-get install -y libpcre3-dev

CMD ["/bin/bash", "/opt/interproscan/interproscan.sh"]
