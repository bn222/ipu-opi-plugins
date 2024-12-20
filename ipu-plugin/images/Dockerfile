# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024 Intel Corporation
FROM golang:1.22.5-alpine@sha256:0d3653dd6f35159ec6e3d10263a42372f6f194c3dea0b35235d72aabde86486e AS builder
RUN apk add --no-cache git
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache --virtual build-dependencies build-base
COPY . /usr/src/ipu-opi-plugin
WORKDIR /usr/src/ipu-opi-plugin
RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} go build -a -o bin/ipuplugin ipuplugin/main.go

# FROM registry.access.redhat.com/ubi9/ubi
FROM registry.ci.openshift.org/ocp/4.19:base-rhel9
ARG P4_NAME
ENV P4_NAME=$P4_NAME

COPY --from=builder /usr/src/ipu-opi-plugin/bin/ipuplugin /usr/bin/
COPY ${P4_NAME}/${P4_NAME}.pkg /
RUN mkdir -p /opt/p4/p4-cp-nws/bin/
COPY bin/p4rt-ctl /opt/p4/p4-cp-nws/bin/
#TODO: Update to newer package, according to release.
COPY bin/p4runtime-2023.11.0-py3-none-any.whl /opt/p4/p4-cp-nws/bin/

WORKDIR /
LABEL io.k8s.display-name="IPU OPI Plugin"
ENV PYTHONUNBUFFERED=1
RUN dnf install -y NetworkManager openvswitch3.4 iproute python3 python3-pip openssh-clients
RUN python3 -m pip install --no-cache-dir /opt/p4/p4-cp-nws/bin/p4runtime-2023.11.0-py3-none-any.whl grpcio'=='1.59.3 protobuf'=='4.25.0 netaddr'=='0.9.0
