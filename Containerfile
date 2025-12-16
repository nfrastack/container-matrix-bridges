# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}
LABEL \
        org.opencontainers.image.title="Matrix Bridges" \
        org.opencontainers.image.description="Containerized bridges to interconnect services via Matrix" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/matrix-bridges" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-matrix-bridges/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-matrix-bridges.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
      DISCORD_VERSION="v0.7.5" \
      HOOKSHOT_VERSION="5.2.1" \
      IMESSAGE_VERSION="7a7312c59b0dd56c54f14ebfd047fcb7c32b6ea6" \
      META_VERSION="v0.2512.0" \
      SIGNAL_VERSION="v0.2512.0" \
      SLACK_VERSION="v25.10" \
      TELEGRAM_VERSION="v0.15.1" \
      WHATSAPP_VERSION="v0.2512.0" \
      DISCORD_REPO_URL="https://github.com/mautrix/discord" \
      HOOKSHOT_REPO_URL="https://github.com/matrix-org/matrix-hookshot" \
      IMESSAGE_REPO_URL="https://github.com/mautrix/imessage" \
      META_REPO_URL="https://github.com/mautrix/meta" \
      SIGNAL_REPO_URL="https://github.com/mautrix/signal" \
      SLACK_REPO_URL="https://github.com/mautrix/slack" \
      TELEGRAM_REPO_URL="https://github.com/mautrix/telegram" \
      WHATSAPP_REPO_URL="https://github.com/mautrix/whatsapp"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    FFMPEG_BINARY=/usr/bin/ffmpeg \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    IMAGE_NAME="nfrastack/matrix-bridges" \
    IMAGE_REPO_URL="https://github.com/nfrastack/conmtainer-matrix-bridges/"

RUN echo "" && \
    MATRIXBRIDGES_BUILD_DEPS_ALPINE=" \
                                        build-base \
                                        git \
                                    " && \
    MATRIXBRIDGES_RUN_DEPS_ALPINE="  \
                                        postgresql-client \
                                        sqlite \
                                  "  && \
    DISCORD_BUILD_DEPS_ALPINE=" \
                                olm-dev \
                              " && \
    DISCORD_RUN_DEPS_ALPINE="  \
                                olm \
                                ffmpeg \
                            " && \
    HOOKSHOT_BUILD_DEPS_ALPINE=" \
                                    cargo \
                                    nodejs \
                                    openssl-dev \
                                    rust \
                                    yarn \
                               " && \
    HOOKSHOT_RUN_DEPS_ALPINE="  \
                                nodejs \
                                yarn \
                             "  && \
    IMESSAGE_BUILD_DEPS_ALPINE="    \
                                    olm-dev \
                               " && \
    IMESSAGE_RUN_DEPS_ALPINE="  \
                                olm \
                                ffmpeg \
                             " && \
    META_BUILD_DEPS_ALPINE=" \
                               olm-dev \
                            " && \
    META_RUN_DEPS_ALPINE="  \
                            olm \
                            ffmpeg \
                         "  && \
    SIGNAL_BUILD_DEPS_ALPINE=" \
                                cargo \
                                clang-dev \
                                cmake \
                                g++ \
                                git \
                                make \
                                musl-dev \
                                olm-dev \
                                protoc \
                                rust \
                                zlib-dev \
                             " && \
    SIGNAL_RUN_DEPS_ALPINE="  \
                                olm \
                                ffmpeg \
                              " && \
    SLACK_BUILD_DEPS_ALPINE=" \
                                olm-dev \
                            " && \
    SLACK_RUN_DEPS_ALPINE=" \
                            olm \
                            ffmpeg \
                          " && \
    TELEGRAM_BUILD_DEPS_ALPINE=" \
                                    libffi-dev  \
                                    py3-pip \
                                    py3-setuptools \
                                    py3-setuptools-rust \
                                    py3-wheel \
                                    py3-pillow \
                                    python3-dev \
                               " \
                               && \
    TELEGRAM_RUN_DEPS_ALPINE="  \
                                ffmpeg \
                                py3-aiohttp \
                                py3-cffi \
                                py3-commonmark \
                                py3-decorator \
                                py3-future \
                                py3-idna \
                                py3-magic \
                                py3-mako \
                                py3-numpy \
                                py3-olm \
                                py3-phonenumbers \
                                py3-pillow \
                                py3-pyaes \
                                py3-pycryptodome \
                                py3-pysocks \
                                py3-qrcode \
                                py3-requests \
                                py3-rsa \
                                py3-ruamel.yaml \
                                py3-tqdm \
                                py3-unpaddedbase64 \
                             " && \
    WHATSAPP_BUILD_DEPS_ALPINE=" \
                                    olm-dev \
                                " && \
    WHATSAPP_RUN_DEPS_ALPINE="  \
                                olm \
                                ffmpeg \
                             " && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user matrix 8008 matrix 8008 /home/matrix && \
    mkdir -p /home/matrix && \
    chown matrix:matrix /home/matrix && \
    chown 700 /home/matrix && \
    mkdir -p /container/data/matrix-bridges && \
    \
    package update && \
    package upgrade && \
    package install \
                    MATRIXBRIDGES_BUILD_DEPS \
                    MATRIXBRIDGES_RUN_DEPS \
                    && \
    package build go && \
    package build yq && \
    #
    #package install \
    #                DISCORD_BUILD_DEPS \
    #                DISCORD_RUN_DEPS \
    #                && \
    #cd /usr/src && \
    #clone_git_repo "${DISCORD_REPO_URL}" "${DISCORD_VERSION}" && \
    #go build -o /usr/local/bin/mautrix-discord && \
    #mkdir -p /container/data/matrix-bridges/discord && \
    #/usr/local/bin/mautrix-discord -c /container/data/matrix-bridges/discord/config.yaml.example -e && \
    #container_build_log add "Mautrix Discord" "${DISCORD_VERSION}" "${DISCORD_REPO_URL}" && \
    #\
    #
    #package install \
    #                HOOKSHOT_BUILD_DEPS \
    #                HOOKSHOT_RUN_DEPS \
    #                && \
    #cd /usr/src && \
    #clone_git_repo "${HOOKSHOT_REPO_URL}" "${HOOKSHOT_VERSION}" /usr/src/hookshot && \
    #yarn \
    #    --ignore-scripts \
    #    --pure-lockfile \
    #    --network-timeout 600000 \
    #    && \
    #node node_modules/esbuild/install.js && \
    #yarn build && \
    #mkdir -p /opt/hookshot && \
    #cp -R package.json /opt/hookshot && \
    #cp -R yarn.lock /opt/hookshot && \
    #cp -R lib /opt/hookshot && \
    #cp -R public /opt/hookshot && \
    #container_build_log add "Matrix Hookshot" "${HOOKSHOT_VERSION}" "${HOOKSHOT_REPO_URL}" && \
    #\
    #
    #package install \
    #                META_BUILD_DEPS \
    #                META_RUN_DEPS \
    #                && \
    #cd /usr/src && \
    #clone_git_repo "${META_REPO_URL}" "${META_VERSION}" /usr/src/meta && \
    #export MAUTRIX_VERSION=$(cat go.mod | grep 'maunium.net/go/mautrix ' | awk '{ print $2 }') && \
    #export GO_LDFLAGS="-s -w -X main.Tag=$(git describe --exact-match --tags 2>/dev/null) -X main.Commit=$(git rev-parse HEAD) -X 'main.BuildTime=`date '+%b %_d %Y, %H:%M:%S'`' -X 'maunium.net/go/mautrix.GoModVersion=$MAUTRIX_VERSION'" && \
    #go build -o /usr/local/bin/mautrix-meta -ldflags "$GO_LDFLAGS" ./cmd/mautrix-meta "$@" && \
    #mkdir -p /container/data/matrix-bridges/meta && \
    #container_build_log add "Mautrix Meta" "${META_VERSION}" "${META_REPO_URL}" && \
    #
    #package install \
    #                IMESASGE_BUILD_DEPS \
    #                IMESASGE_RUN_DEPS \
    #                && \
    #cd /usr/src && \
    #clone_git_repo "${IMESSAGE_REPO_URL}" "${IMESSAGE_VERSION}" /usr/src/imessage && \
    #go build -o /usr/local/bin/mautrix-imessage && \
    #mkdir -p /container/data/matrix-bridges/imessage && \
    #/usr/local/bin/mautrix-imessage -c /container/data/matrix-bridges/imessage/config.yaml.example -e && \
    #container_build_log add "Mautrix IMessage" "${IMESSAGE_VERSION}" "${IMESSAGE_REPO_URL}" && \
    #\
    package install \
                    SIGNAL_BUILD_DEPS \
                    SIGNAL_RUN_DEPS \
                    && \
    cd /usr/src && \
    clone_git_repo "${SIGNAL_REPO_URL}" "${SIGNAL_VERSION}" /usr/src/signal && \
    cd pkg/libsignalgo/libsignal && \
    RUSTFLAGS="-Ctarget-feature=-crt-static" \
    RUSTC_WRAPPER="" \
    cargo build \
        -p libsignal-ffi \
        --profile=release \
        && \
    cd /usr/src/signal && \
    MAUTRIX_VERSION=$(cat go.mod | grep 'maunium.net/go/mautrix ' | awk '{ print $2 }') && \
    GO_LDFLAGS="-X main.Tag=$(git describe --exact-match --tags 2>/dev/null) -X main.Commit=$(git rev-parse HEAD) -X 'main.BuildTime=`date -Iseconds`' -X 'maunium.net/go/mautrix.GoModVersion=$MAUTRIX_VERSION'" && \
    LIBRARY_PATH=/usr/src/signal/pkg/libsignalgo/libsignal/target/release \
    go build -o /usr/local/bin/mautrix-signal ./cmd/mautrix-signal && \
    mkdir -p /container/data/matrix-bridges/signal && \
    /usr/local/bin/mautrix-signal -c /container/data/matrix-bridges/signal/config.yaml.example -e && \
    container_build_log add "Mautrix Signal" "${SIGNAL_VERSION}" "${SIGNAL_REPO_URL}" && \
    #
    #package install \
    #                SLACK_BUILD_DEPS \
    #                SLACK_RUN_DEPS \
    #                && \
    #cd /usr/src && \
    #clone_git_repo "${SLACK_REPO_URL}" "${SLACK_VERSION}" /usr/src/slack && \
    #MAUTRIX_VERSION=$(cat go.mod | grep 'maunium.net/go/mautrix ' | awk '{ print $2 }' | head -n1) && \
    #GO_LDFLAGS="-s -w -X main.Tag=$(git describe --exact-match --tags 2>/dev/null) -X main.Commit=$(git rev-parse HEAD) -X 'main.BuildTime=`date -Iseconds`' -X 'maunium.net/go/mautrix.GoModVersion=$MAUTRIX_VERSION'" && \
    #go build -ldflags="$GO_LDFLAGS" -o /usr/local/bin/mautrix-slack ./cmd/mautrix-slack "$@" && \
    #mkdir -p /container/data/matrix-bridges/slack && \
    #/usr/local/bin/mautrix-slack -c /container/data/matrix-bridges/slack/config.yaml.example -e && \
    #container_build_log add "Mautrix Slack" "${SLACK_VERSION}" "${SLACK_REPO_URL}" && \
    #
    #package install \
    #                TELEGRAM_BUILD_DEPS \
    #                TELEGRAM_RUN_DEPS \
    #                && \
    #clone_git_repo "${TELEGRAM_REPO_URL}" "${TELEGRAM_VERSION}" /usr/src/telegram && \
    #pip3 install \
    #            --break-system-packages \
    #            --upgrade \
    #            --no-cache-dir \
    #            -r requirements.txt \
    #            -r optional-requirements.txt \
    #            .[all] \
    #            && \
    #mkdir -p /container/data/matrix-bridges/telegram && \
    #cp -R mautrix_telegram/example-config.yaml /container/data/matrix-bridges/telegram/example.config.yaml && \
    #container_build_log add "Mautrix Telegram" "${TELEGRAM_VERSION}" "${TELEGRAM_REPO_URL}" && \
    #\
    #
    package install \
                    WHATSAPP_BUILD_DEPS \
                    WHATSAPP_RUN_DEPS \
                    && \
    cd /usr/src && \
    clone_git_repo "${WHATSAPP_REPO_URL}" "${WHATSAPP_VERSION}" /usr/src/whatsapp && \
    MAUTRIX_VERSION=$(cat go.mod | grep 'maunium.net/go/mautrix ' | awk '{ print $2 }') && \
    GO_LDFLAGS="-s -w -X main.Tag=$(git describe --exact-match --tags 2>/dev/null) -X main.Commit=$(git rev-parse HEAD) -X 'main.BuildTime=`date -Iseconds`' -X 'maunium.net/go/mautrix.GoModVersion=$MAUTRIX_VERSION'" && \
    go build -ldflags="$GO_LDFLAGS" -o /usr/local/bin/mautrix-whatsapp ./cmd/mautrix-whatsapp && \
    mkdir -p /container/data/matrix-bridges/whatsapp && \
    /usr/local/bin/mautrix-whatsapp -c /container/data/matrix-bridges/whatsapp/config.yaml.example -e && \
    container_build_log add "Mautrix WhatsApp" "${WHATSAPP_VERSION}" "${WHATSAPP_REPO_URL}" && \
    chown matrix:matrix /container/data/matrix-bridges/ && \
    package remove  \
                    MATRIXBRIDGES_BUILD_DEPS \
                    #DISCORD_BUILD_DEPS \
                    #HOOKSHOT_BUILD_DEPS \
                    #IMESSAGE_BUILD_DEPS \
                    #META_BUILD_DEPS \
                    SIGNAL_BUILD_DEPS \
                    #SLACK_BUILD_DEPS \
                    #TELEGRAM_BUILD_DEPS \
                    WHATSAPP_BUILD_DEPS \
                    && \
    package cleanup && \
    rm -rf \
                /root/.cache \
                /root/.cargo \
                /root/.config \
                /root/.gitconfig \
                /root/.gradle \
                /root/go \
                /tmp/* \
                /usr/example-config.yaml \
                /usr/src/*

COPY rootfs /
