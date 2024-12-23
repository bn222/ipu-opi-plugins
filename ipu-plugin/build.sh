#!/usr/bin/env bash
cd /root/ipu-opi-plugins/ipu-plugin/

cp -r ../e2e/artefacts/fxp-net_linux-networking .
mkdir -p ./bin && cp -r ../e2e/artefacts/bin/* ./bin/

buildah manifest rm intel-vsp-manifest || true
buildah manifest create intel-vsp-manifest
buildah build --authfile /root/config.json --manifest intel-vsp-manifest --platform linux/amd64,linux/arm64 -f Dockerfile -t intel-ipuplugin:latest
