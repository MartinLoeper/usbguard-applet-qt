FROM mcr.microsoft.com/devcontainers/cpp:1-debian-12

ARG REINSTALL_CMAKE_VERSION_FROM_SOURCE="3.22.2"

# Optionally install the cmake for vcpkg
COPY ./reinstall-cmake.sh /tmp/

RUN if [ "${REINSTALL_CMAKE_VERSION_FROM_SOURCE}" != "none" ]; then \
        chmod +x /tmp/reinstall-cmake.sh && /tmp/reinstall-cmake.sh ${REINSTALL_CMAKE_VERSION_FROM_SOURCE}; \
    fi \
    && rm -f /tmp/reinstall-cmake.sh

# [Optional] Uncomment this section to install additional packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

#RUN mkdir /nix \
#    && chmod ugo+wrx /nix \
#    && curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

ARG NIX_VERSION=2.15.1
RUN wget https://nixos.org/releases/nix/nix-${NIX_VERSION}/nix-${NIX_VERSION}-$(uname -m)-linux.tar.xz \
  && tar xf nix-${NIX_VERSION}-$(uname -m)-linux.tar.xz \
  && addgroup --gid 30000 nixbld \
  && for i in $(seq 1 30); do adduser --system nixbld$i && usermod -a -G nixbld nixbld$i ; done \
  && mkdir -m 0755 /etc/nix \
  && echo "sandbox = false" > /etc/nix/nix.conf \
  && echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf \
  && mkdir -m 0755 /nix && USER=root sh nix-${NIX_VERSION}-$(uname -m)-linux/install \
  && ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/ \
  && rm -r /nix-${NIX_VERSION}-$(uname -m)-linux* \
  && rm -rf /var/cache/apk/* \
  && /nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-old \
  && /nix/var/nix/profiles/default/bin/nix-store --optimise \
  && /nix/var/nix/profiles/default/bin/nix-store --verify --check-contents \
  && chown 1000:1000 -R /nix/

ONBUILD ENV \
    ENV=/etc/profile \
    USER=root \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENV \
    ENV=/etc/profile \
    USER=root \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    NIX_PATH=/nix/var/nix/profiles/per-user/root/channels