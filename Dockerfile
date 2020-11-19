FROM 0x01be/ops:build as build

FROM alpine

RUN apk add --no-cache --virtual ops-runtime-dependencies \
    tcl \
    tk

COPY --from=build /opt/ops/ /opt/ops/

