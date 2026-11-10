FROM fedora:44
LABEL maintainer="borsatto at mail dot com"

ARG TARGETARCH

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN printf "[kubernetes]\nname=Kubernetes\nbaseurl=https://pkgs.k8s.io/core:/stable:/v1.37/rpm/\nenabled=1\ngpgcheck=1\ngpgkey=https://pkgs.k8s.io/core:/stable:/v1.37/rpm/repodata/repomd.xml.key\n" > /etc/yum.repos.d/kubernetes.repo && \
    dnf install -y wget dnf-plugins-core && \
    wget -qO /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
    dnf copr enable -y alternateved/eza && \
    dnf update -y && \
    dnf install -y \
        ncurses curl libicu gnupg2 openssh-clients unzip git vim \
        iputils bind-utils busybox mtr nmap-ncat iperf3 skopeo \
        jq yq fzf eza ansible \
        htop btop \
        terraform \
        kubectl \
        helm \
        bat ripgrep age trivy && \
    if [ -z "$TARGETARCH" ]; then \
        ARCH=$(uname -m); \
        case "$ARCH" in \
            aarch64|arm64) TARGETARCH="arm64" ;; \
            *) TARGETARCH="amd64" ;; \
        esac; \
    fi && \
    case "$TARGETARCH" in \
        arm64) PWSH_ARCH="arm64"; LAZYGIT_ARCH="arm64" ;; \
        amd64|*) PWSH_ARCH="x64"; LAZYGIT_ARCH="x86_64" ;; \
    esac && \
    mkdir -p /opt/microsoft/powershell/7 && \
    curl -sSLo /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.6.9/powershell-7.6.9-linux-${PWSH_ARCH}.tar.gz && \
    tar -zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
    rm -f /tmp/powershell.tar.gz && \
    dnf clean all && \
    rm -rf /var/cache/dnf && \
    curl -sSLo /tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.66.3/lazygit_0.66.3_Linux_${LAZYGIT_ARCH}.tar.gz && tar -xzf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit && rm -f /tmp/lazygit.tar.gz && \
    curl -sSLo /usr/local/bin/kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && chmod +x /usr/local/bin/kubectx && \
    curl -sSLo /usr/local/bin/kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && chmod +x /usr/local/bin/kubens && \
    curl -sSLo /tmp/k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.51.0/k9s_Linux_${TARGETARCH}.tar.gz && tar -xzf /tmp/k9s.tar.gz -C /usr/local/bin k9s && rm -f /tmp/k9s.tar.gz && \
    curl -sSLo /tmp/stern.tar.gz https://github.com/stern/stern/releases/download/v1.35.0/stern_1.35.0_linux_${TARGETARCH}.tar.gz && tar -xzf /tmp/stern.tar.gz -C /usr/local/bin stern && rm -f /tmp/stern.tar.gz && \
    curl -sSLo /usr/local/bin/calicoctl https://github.com/projectcalico/calico/releases/download/v3.33.0/calicoctl-linux-${TARGETARCH} && chmod +x /usr/local/bin/calicoctl && \
    curl -sSLo /tmp/velero.tar.gz https://github.com/velero-io/velero/releases/download/v1.18.4/velero-v1.18.4-linux-${TARGETARCH}.tar.gz && tar -xzf /tmp/velero.tar.gz --strip-components=1 -C /usr/local/bin velero-v1.18.4-linux-${TARGETARCH}/velero && rm -f /tmp/velero.tar.gz && \
    curl -sSLo /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v3.6.1/argocd-linux-${TARGETARCH} && chmod +x /usr/local/bin/argocd && \
    curl -sSLo /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/download/v3.1.4/cosign-linux-${TARGETARCH} && chmod +x /usr/local/bin/cosign && \
    curl -sSLo /usr/local/bin/sops https://github.com/getsops/sops/releases/download/v3.13.3/sops-v3.13.3.linux.${TARGETARCH} && chmod +x /usr/local/bin/sops && \
    pwsh -NoLogo -NoProfile -Command 'Install-PSResource -Name AWS.Tools.Installer, VMware.PowerCLI, Az, GoogleCloud, OCI.PSModules -Scope CurrentUser -TrustRepository -AcceptLicense -Reinstall; Import-Module AWS.Tools.Installer; Install-AWSToolsModule AWS.Tools.CloudFormation, AWS.Tools.CloudWatch, AWS.Tools.DynamoDBv2, AWS.Tools.EKS, AWS.Tools.EC2, AWS.Tools.IdentityManagement, AWS.Tools.Lambda, AWS.Tools.RDS, AWS.Tools.S3, AWS.Tools.SecretsManager, AWS.Tools.SQS, AWS.Tools.Common -Force -CleanUp' && \
    find /root/.local/share/powershell/Modules -type d \( -name 'net45' -o -name 'net472' -o -name 'fullclr' \) -exec rm -rf {} + 2>/dev/null || true && \
    find /root/.local/share/powershell/Modules/GoogleCloud -name '*.dll' ! -name 'Google.*' -exec rm -f {} + 2>/dev/null || true && \
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
