FROM 0x01be/swig:4.0 as swig

FROM 0x01be/base as build

COPY --from=swig /opt/swig/ /opt/swig/

ENV SWIG_DIR=/opt/swig \
    SWIG_EXECUTABLE=/opt/swig/bin/swig \
    PATH=${PATH}:/opt/swig/bin \
    REVISION=master

RUN apk add --no-cache --virtual ops-build-dependencies \
    git \
    build-base \
    cmake \
    coreutils \
    bison \
    flex \
    tcsh \
    tcl-dev \
    tk-dev \
    boost-dev &&\
    apk add --no-cache --virtual ops-doc-dependencies \
    doxygen \
    graphviz &&\
    git clone --recursive --branch ${REVISION} https://github.com/scale-lab/OpenPhySyn.git /ops

WORKDIR /ops/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/ops \
    .. &&\
    sed -i.bak 's/PAGE_SIZE/PAGE_SIZE_OPENPHYSYN/g' /ops/external/OpenDB/src/db/dbAttrTable.h &&\
    sed -i.bak 's/PAGE_SIZE/PAGE_SIZE_OPENPHYSYN/g' /ops/external/OpenDB/src/db/dbPagedVector.h &&\
    ln -s /usr/lib/libtcl8.6.so /usr/lib/libtcl.so &&\
    make
RUN make install
 
