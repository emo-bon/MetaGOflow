# InterProScan with the version 3 Prosite binaries required for AMD EPYC cluster
# Cymon J. Cox (9/11/23)

# Get the core part of IPS
# -------------------------
FROM busybox AS base

LABEL Maintainer="MGnify team <https://www.ebi.ac.uk/support/metagenomics>, Haris Zafeiropoulos <haris.zafeiropoulos@kuleuven.be>"
LABEL Version="metaGOflow version"

ARG IPR=5
ENV IPR $IPR
ARG IPRSCAN=5.64-96.0 
ENV IPRSCAN $IPRSCAN

FROM base AS buildcore
RUN mkdir -p /opt/interproscan
WORKDIR /opt

RUN wget -q -O /opt/interproscan-core-$IPRSCAN.tar.gz ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/interproscan-core-$IPRSCAN.tar.gz && \
    wget -q -O /opt/interproscan-core-$IPRSCAN.tar.gz.md5 ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/interproscan-core-$IPRSCAN.tar.gz.md5 && \
    md5sum -c interproscan-core-$IPRSCAN.tar.gz.md5 && \
    tar -pxvf interproscan-core-$IPRSCAN.tar.gz -C /opt/interproscan --strip-components=1 && \
    rm -f interproscan-core-$IPRSCAN.tar.gz interproscan-core-$IPRSCAN.tar.gz
RUN sed -i 's/https:\/\/www\.ebi\.ac\.uk\/interpro\/match-lookup//' /opt/interproscan/interproscan.properties && \
    sed -i '20i binary.prosite.pfsearchv3.path=${bin.directory}/prosite/pfsearchV3\n' /opt/interproscan/interproscan.properties && \
    sed -i '20i binary.prosite.pfscanv3.path=${bin.directory}/prosite/pfscanV3' /opt/interproscan/interproscan.properties && \
    sed -i '20i # See https://interproscan-docs.readthedocs.io/en/latest/KnownIssues.html#prosite-pfsearchv3-errors' /opt/interproscan/interproscan.properties

# Get the bin part of IPS
# -------------------------
FROM base AS buildbin
RUN mkdir -p /opt/interproscan
WORKDIR /opt

RUN wget -q -O /opt/interproscan-mgbin-$IPRSCAN.tar.gz ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/interproscan-mgbin-$IPRSCAN.tar.gz && \
    wget -q -O /opt/interproscan-mgbin-$IPRSCAN.tar.gz.md5 ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/$IPR/$IPRSCAN/alt/interproscan-mgbin-$IPRSCAN.tar.gz.md5 && \
    md5sum -c interproscan-mgbin-$IPRSCAN.tar.gz.md5 && \
    tar -pxvzf interproscan-mgbin-$IPRSCAN.tar.gz -C /opt/interproscan --strip-components=1 && \
    rm -f interproscan-mgbin-$IPRSCAN.tar.gz interproscan-mgbin-$IPRSCAN.tar.gz.md5
    
# The default Prosite binaries are Ubuntu (ie the same as our container)
#RUN rm /opt/interproscan/bin/prosite/pfscanV3 && \
    #ln -s centos7.9/pfscanV3 /opt/interproscan/bin/prosite/pfscanV3 && \
    #rm /opt/interproscan/bin/prosite/pfsearchV3 && \
    #ln -s centos7.9/pfsearchV3 /opt/interproscan/bin/prosite/pfsearchV3

# biocontainers/biocontainers:latest is 5 yrs old and is based on
# Ubuntu 16.04. To get v 1.2.0 ubuntu:20.04 you need to pull it thusly:
FROM biocontainers/biocontainers:v1.2.0_cv2

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -f --reinstall -y python3 && \
    apt-get install openjdk-11-jdk -y --force-yes && \
    #This version of pcre2 is need by the Prosite binaries
    apt-get install libpcre2-8-0 -y && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=buildcore /opt/interproscan /opt/interproscan
COPY --from=buildbin /opt/interproscan/bin /opt/interproscan/bin

ENV PATH="/opt/interproscan/:/opt/interproscan/bin:${PATH}"
# Sets language to UTF8 : this works in pretty much all cases
ENV LANG pt_BR.UTF-8

# Setup JAVA_HOME and other environment variables, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
ENV PATH $PATH:$JAVA_HOME/bin
ENV CLASSPATH $JAVA_HOME/lib/tools.jar
ENV MANPATH $JAVA_HOME/man

WORKDIR /opt/interproscan

CMD ["/bin/bash", "/opt/interproscan/interproscan.sh"]
#ENTRYPOINT ["/bin/bash"]
#singularity pull --force --name cymon_interproscan-5.64-96.0:0.5.sif docker://cymon/interproscan-5.64-96.0-cluster:0.5
