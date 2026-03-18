FROM fedora:43
LABEL maintainer="borsatto at mail dot com"

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo 'root:megabash123!' | chpasswd

RUN dnf update -y && \
    dnf copr enable -y alternateved/eza && \
    dnf install -y \
        ncurses wget curl libicu gnupg2 openssh-clients unzip git \
        iputils bind-utils busybox mtr nmap-ncat iperf3 \
        jq yq fzf eza ansible \
        htop btop \
        https://github.com/PowerShell/PowerShell/releases/download/v7.5.5/powershell-7.5.5-1.rh.x86_64.rpm && \
    dnf clean all && \
    pwsh -Command "Install-Module -Name VMware.PowerCLI, Az, AWS.Tools.Installer, GoogleCloud, OCI.PSModules -Force -Scope CurrentUser" && \
    pwsh -Command "Install-AWSToolsModule AWS.Tools.CloudFormation, AWS.Tools.CloudWatch, AWS.Tools.DynamoDBv2, AWS.Tools.EC2, AWS.Tools.IdentityManagement, AWS.Tools.Lambda, AWS.Tools.RDS, AWS.Tools.S3, AWS.Tools.SecretsManager, AWS.Tools.SQS, AWS.Tools.Common -Force" && \
    wget -qO- https://starship.rs/install.sh | sh -s -- -y && \
    mkdir -p /root/.config/powershell/ /usr/local/share/fonts && \
    wget -q --progress=dot:mega https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip && \
    unzip Hack.zip -d /usr/local/share/fonts && \
    rm Hack.zip

COPY starship.toml /root/.config/
COPY Microsoft.PowerShell_profile.ps1 /root/.config/powershell/
COPY tokyo-night.toml /root/.config/powershell/
COPY .bashrc /root/
