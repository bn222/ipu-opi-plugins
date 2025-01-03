# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024 Intel Corporation
FROM registry.ci.openshift.org/ocp/builder:rhel-9-golang-1.22-openshift-4.18 AS builder
ARG TARGETOS
ARG TARGETARCH

COPY . /usr/src/ipu-opi-plugin
WORKDIR /usr/src/ipu-opi-plugin
RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} go build -a -o bin/ipuplugin ipuplugin/main.go

FROM registry.ci.openshift.org/ocp/4.19:base-rhel9
ENV PYTHONUNBUFFERED=1
ENV P4_NAME=fxp-net_linux-networking
RUN dnf install -y NetworkManager openvswitch3.4 iproute python3 python3-pip openssh-clients
RUN python3 -m pip install --no-cache-dir /opt/p4/p4-cp-nws/bin/p4runtime-2023.11.0-py3-none-any.whl grpcio'=='1.59.3 protobuf'=='4.25.0 netaddr'=='0.9.0
#By setting workdir, the directory is created automatically
WORKDIR /opt/p4/p4-cp-nws/bin/

COPY fxp-net_linux-networking/fxp-net_linux-networking.pkg /
COPY bin/p4rt-ctl /opt/p4/p4-cp-nws/bin/
#TODO: Update to newer package, according to release.
COPY bin/p4runtime-2023.11.0-py3-none-any.whl /opt/p4/p4-cp-nws/bin/

COPY --from=builder /usr/src/ipu-opi-plugin/bin/ipuplugin /usr/bin/
WORKDIR /
LABEL io.k8s.display-name="IPU OPI Plugin"
