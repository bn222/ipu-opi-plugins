#/usr/local/lib/python3.9/site-packages/ SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024 Intel Corporation
FROM registry.ci.openshift.org/ocp/builder:rhel-9-golang-1.22-openshift-4.18 AS builder
ARG TARGETOS
ARG TARGETARCH

COPY . /usr/src/ipu-opi-plugin
WORKDIR /usr/src/ipu-opi-plugin
RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} go build -a -o bin/ipuplugin ipuplugin/main.go

FROM registry.ci.openshift.org/ocp/4.18:base-rhel9
ARG P4_NAME
ENV P4_NAME $P4_NAME

COPY --from=builder /usr/src/ipu-opi-plugin/bin/ipuplugin /usr/bin/
COPY ${P4_NAME}/${P4_NAME}.pkg /
RUN mkdir -p /opt/p4/p4-cp-nws/bin/
COPY bin/p4rt-ctl /opt/p4/p4-cp-nws/bin/
#TODO: Update to newer package, according to release.
COPY bin/p4runtime-2023.11.0-py3-none-any.whl /opt/p4/p4-cp-nws/bin/
RUN dnf install -y python3-pip openssh NetworkManager openvswitch iproute
RUN python3 -m pip install --no-cache-dir /opt/p4/p4-cp-nws/bin/p4runtime-2023.11.0-py3-none-any.whl

WORKDIR /
LABEL io.k8s.display-name="IPU OPI Plugin"
ENV PYTHONUNBUFFERED=1
