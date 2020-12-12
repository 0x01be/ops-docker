FROM 0x01be/ops:build as build

FROM 0x01be/base

RUN apk add --no-cache --virtual ops-runtime-dependencies \
    tcl \
    tk

COPY --from=build /opt/ops/ /opt/ops/

