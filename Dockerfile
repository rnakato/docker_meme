FROM rnakato/ubuntu:20.04
LABEL maintainer="Ryuichiro Nakato <rnakato@iqb.u-tokyo.ac.jp>"

WORKDIR /opt

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    imagemagick \
    libexpat1-dev \
    libxml2-dev \
    python \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/list

# MEME
# MEME uses Python2 (specified by "--with-python=/usr/bin/python")
RUN wget --progress=dot:giga https://meme-suite.org/meme/meme-software/5.4.1/meme-5.4.1.tar.gz \
https://meme-suite.org/meme/meme-software/5.4.1/meme-5.4.1.tar.gz \
    && tar zxvf meme-5.4.1.tar.gz \
    && cd meme-5.4.1 \
    && ./configure --prefix=/opt/meme --with-url=http://meme-suite.org \
    --enable-build-libxml2 \
    --enable-build-libxslt \
    --with-python=/usr/bin/python \
    && make \
    && make install
#    && make test \

RUN mkdir db \
    && cd db \
    && wget --progress=dot:giga https://meme-suite.org/meme/meme-software/Databases/motifs/motif_databases.12.22.tgz \
    && tar zxvf motif_databases.12.22.tgz \
    && wget --progress=dot:giga http://meme-suite.org/meme-software/Databases/gomo/gomo_databases.3.2.tgz \
    && tar zxvf gomo_databases.3.2.tgz \
    && wget --progress=dot:giga http://meme-suite.org/meme-software/Databases/tgene/tgene_databases.1.0.tgz \
    && tar zxvf tgene_databases.1.0.tgz

COPY policy.xml /etc/ImageMagick-6/policy.xml

ENV PATH ${PATH}:/opt/meme/bin:/opt/meme/libexec/meme-5.4.1

CMD ["/bin/bash"]
