FROM rnakato/ubuntu:20.04
MAINTAINER Ryuichiro Nakato <rnakato@iqb.u-tokyo.ac.jp>

WORKDIR /opt

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt update \
    && apt install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    imagemagick \
    libexpat1-dev \
    libxml2-dev \
    python \
    zlib1g-dev \
    && apt clean \
    && rm -rf /var/lib/apt/list

# CPAN
RUN bash \
    && git clone https://github.com/tokuhirom/plenv.git /opt/.plenv \
    && git clone https://github.com/tokuhirom/Perl-Build.git /opt/.plenv/plugins/perl-build/ \
    && echo 'export PLENV_ROOT=/opt/.plenv'    >> ~/.bashrc \
    && echo 'export PATH=$PLENV_ROOT/bin:$PLENV_ROOT/shims:$PATH' >> ~/.bashrc \
    && echo 'eval "$(plenv init -)"' >> ~/.bashrc

    ENV PLENV_ROOT /opt/.plenv
    ENV PATH ${PLENV_ROOT}/bin:$PLENV_ROOT/shims:${PATH}
    RUN plenv install 5.30.0 \
    && plenv global 5.30.0 \
    && plenv list-modules \
    && plenv install-cpanm \
    && cpanm Math::CDF Excel::Writer::XLSX XSLoader HTML::TreeBuilder \
    Path::Class Array::Utils Pod::Usage List::Util Log::Log4perl \
    JSON File::Which XML::Parser::Expat XML::Simple List::Util\
    HTML::Template XML::Compile XML::Compile::SOAP11 XML::Compile::WSDL11 \
    Config::General Params::Validate List::MoreUtils
#    Math::VecStat Regexp::Common Set::IntSpan Readonly Text::Format SVG Math::Bezier Math::Round

# MEME
# MEME uses Python2 (specified by "--with-python=/usr/bin/python")
RUN wget http://meme-suite.org/meme-software/5.1.1/meme-5.1.1.tar.gz \
    && tar zxvf meme-5.1.1.tar.gz \
    && cd meme-5.1.1 \
    && ./configure --prefix=/opt/meme --with-url=http://meme-suite.org \
    --enable-build-libxml2 \
    --enable-build-libxslt \
    --with-python=/usr/bin/python \
    && make \
    && make install
#    && make test \


RUN mkdir db \
    && cd db \
    && wget http://meme-suite.org/meme-software/Databases/motifs/motif_databases.12.19.tgz \
    && tar zxvf motif_databases.12.19.tgz \
    && wget http://meme-suite.org/meme-software/Databases/gomo/gomo_databases.3.2.tgz \
    && tar zxvf gomo_databases.3.2.tgz \
    && wget http://meme-suite.org/meme-software/Databases/tgene/tgene_databases.1.0.tgz \
    && tar zxvf tgene_databases.1.0.tgz

ENV PATH ${PATH}:/opt/meme/bin:/opt/meme/libexec/meme-5.1.1

CMD ["/bin/bash"]
