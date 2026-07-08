# megabash

`megabash` is a collection of specialised Docker environments designed as powerful development workbenches. It provides pre-configured, high-performance containers tailored for DevOps, cloud engineering, and infrastructure management tasks.

The primary goal is to provide "ready-to-go" environments that include essential CLI tools (Terraform, Kubernetes, Helm, Ansible), shell enhancements (Starship, eza) and cloud CLI tools (AWS, Azure, Google Cloud, OCI).

## 🚀 Environments

### 1. megabash (Fedora-based)
A robust, Fedora-powered container designed for heavy-duty DevOps work. It comes pre-loaded with a massive suite of cloud and infrastructure tools.

**Key Features:**
- **Base OS:** `fedora:43`
- **Core CLI Tools:** 
  - Infrastructure as Code: `terraform`, `helm`, `kubectl`, `ansible`.
  - Networking & System: `nmap`, `iperf3`, `mtr`, `bind-utils`, `socat`, `dig`.
  - Cloud SDKs (PowerShell): `Az` (Azure), `AWS.Tools`, `GoogleCloud`, `OCI.PSModules`, `VMware.PowerCLI`.
  - Modern Utilities: `eza`, `fzf`, `jq`, `yq`, `htop`, `btop`, `starship`.
- **Shell Experience:** 
  - Highly customized `bash` and `powershell` profiles.
  - `starship` prompt with a sleek "Tokyo Night" theme.
  - Integrated Nerd Fonts (Hack) for beautiful terminal iconography.

**Docker Build Configuration:**
The setup includes specialised logic for managing repositories (Hashicorp, Kubernetes) and installing PowerShell modules during the build process.

---

## 🛠️ Setup & Usage

To build the `megabash` environment, navigate to the directory containing the `Dockerfile` and run:

```bash
docker build -t megabash .
```

To run the container interactively:

```bash
docker run -it --rm megabash /bin/bash
```

## 🎨 Customization
The environment is highly customizable. The container utilize:
- **Starship Prompts:** Shared configurations for a consistent, beautiful shell experience.
- **Tokyo Night Theme:** A dark, high-contrast theme used for both Starship and PowerShell profiles.
- **Nerd Fonts:** Integrated font support to ensure all icons render correctly in the terminal.

## 📝 License
This project is provided as-is for development and workbench purposes.
