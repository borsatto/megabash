FROM fedora:44
LABEL maintainer="borsatto at mail dot com"

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo 'root:megabash123!' | chpasswd && \
    printf "[kubernetes]\nname=Kubernetes\nbaseurl=https://pkgs.k8s.io/core:/stable:/v1.37/rpm/\nenabled=1\ngpgcheck=1\ngpgkey=https://pkgs.k8s.io/core:/stable:/v1.37/rpm/repodata/repomd.xml.key\n" > /etc/yum.repos.d/kubernetes.repo && \
    dnf install -y wget dnf-plugins-core && \
    wget -qO /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
    dnf copr enable -y alternateved/eza && \
    dnf update -y && \
    dnf install -y \
        ncurses curl libicu gnupg2 openssh-clients unzip git vim \
        iputils bind-utils busybox mtr nmap-ncat iperf3 \
        jq yq fzf eza ansible \
        htop btop \
        terraform \
        kubectl \
        helm \
        https://github.com/PowerShell/PowerShell/releases/download/v7.6.9/powershell-7.6.9-1.rh.x86_64.rpm && \
    dnf clean all && \
    rm -rf /var/cache/dnf && \
    pwsh -NoLogo -NoProfile -Command 'Install-PSResource -Name AWS.Tools.Installer, VMware.PowerCLI, Az, GoogleCloud, OCI.PSModules -Scope CurrentUser -TrustRepository -AcceptLicense -Reinstall; Import-Module AWS.Tools.Installer; Install-AWSToolsModule AWS.Tools.CloudFormation, AWS.Tools.CloudWatch, AWS.Tools.DynamoDBv2, AWS.Tools.EKS, AWS.Tools.EC2, AWS.Tools.IdentityManagement, AWS.Tools.Lambda, AWS.Tools.RDS, AWS.Tools.S3, AWS.Tools.SecretsManager, AWS.Tools.SQS, AWS.Tools.Common -Force -CleanUp' && \
    rm -rf ~/.local/share/NuGet ~/.nuget ~/.config/powershell/Telemetry && \
    wget -qO- https://starship.rs/install.sh | sh -s -- -y && \
    mkdir -p /root/.config/powershell/ /usr/share/fonts/hack && \
    wget -q --progress=dot:mega https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip && \
    unzip Hack.zip -d /usr/share/fonts/hack && \
    rm Hack.zip

COPY starship.toml /root/.config/
COPY Microsoft.PowerShell_profile.ps1 /root/.config/powershell/
COPY tokyo-night.toml /root/.config/powershell/
COPY .bashrc /root/
