FROM fedora:42 
LABEL maintainer="borsatto at mail dot com"

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo 'root:megabash123!' | chpasswd

  
RUN dnf update -y \
    && dnf copr enable -y alternateved/eza \
    && dnf install -y ncurses \
       wget \
       curl \
       libicu \
       https://github.com/PowerShell/PowerShell/releases/download/v7.5.3/powershell-7.5.3-1.rh.x86_64.rpm \
       gpg \
       apt-transport-https \
       busybox \
       dnsutils \
       eza \
       fzf \
       unzip \
       ansible \
    && dnf clean all \
    && pwsh -Command Install-Module VMware.PowerCLI -Force \
    && pwsh -Command Install-Module -Name Az -Repository PSGallery -Force \
    && wget --progress=dot:mega https://starship.rs/install.sh \
    && chmod +x install.sh \
    && ./install.sh -y \
    && mkdir -p /root/.config/powershell/ \
    && rm install.sh \
    && wget --progress=dot:mega https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip \
    && unzip Hack.zip -d /usr/local/share/fonts \
    && rm Hack.zip

COPY starship.toml /root/.config/
COPY Microsoft.PowerShell_profile.ps1 /root/.config/powershell/
COPY tokyo-night.toml /root/.config/powershell/
COPY .bashrc /root/

