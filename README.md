# 🛠️ CLI Hub Toolkit

A cross-platform, modular collection of command-line tools, automation routines, and environment setup scripts for personal system provisioning and day-to-day tasks.

This repository serves as a centralized toolkit to simplify the setup, configuration, and automation of developer and analyst environments across Linux and Windows. It is designed to be **portable**, **scalable**, and **self-documented**.

---

## 📌 Purpose & Philosophy

- **One repository** to clone on a new machine and hit the ground running
- Clear distinction between **init**, **setup**, **daily tasks**, **automation jobs**, and **system maintenance**
- Full support for both **Bash** (`.sh`) and **PowerShell** (`.ps1`) environments
- Dispatcher pattern (`init`, `setup`, `task`, `job`, etc.) enables intuitive CLI access
- Scripts are **self-contained**, **documented**, and **platform-aware**

---

## 📁 Folder Structure & Categories

| Folder   | Dispatcher | Purpose                                                               |
| -------- | ---------- | --------------------------------------------------------------------- |
| `init/`  | `init`     | First-time system identity setup (Git identity, SSH keys, etc.)       |
| `setup/` | `setup`    | One-time installs and configuration (e.g., Starship, Neovim)          |
| `tasks/` | `task`     | CLI-executed utilities for daily/manual workflows                     |
| `jobs/`  | `job`      | Scheduled or condition-based automation jobs (e.g., sync vault)       |
| `ops/`   | `ops`      | System operations: cleanup, monitoring, uptime checks                 |
| `dev/`   | `dev`      | Development utilities: doc generation, code formatting, test runners  |
| `meta/`  | `meta`     | Scripts to maintain the CLI hub itself (validators, help index, etc.) |

Each category has a matching dispatcher script in the `bin/` directory (e.g., `task`, `task.ps1`) to simplify usage and discovery.

---

## 🧠 Why `.sh` and `.ps1` Scripts?

This toolkit is designed to work seamlessly across:

- **Linux/macOS** via Bash/Zsh
- **Windows** via PowerShell

Each dispatcher selects the correct implementation automatically:

- Bash shells call `.sh` scripts (e.g., `setup/starship`)
- PowerShell calls `.ps1` scripts (e.g., `setup/starship.ps1`)

Script pairs share the same name, differing only by extension. This enables consistent CLI commands regardless of OS.

---

## 🚀 How to Use

### 1. **Clone the repository to a consistent location**

Regardless of operating system, clone the repository to:

```sh
git clone https://github.com/youruser/toolkit.cli-hub.git "$HOME/.local/bin"
```

### 2. **Add dispatchers to your PATH**

Manually add the `~/.local/bin/bin` subdirectory to your PATH so dispatcher commands are available globally:

For Bash (Linux/macOS):

```sh
export PATH="$HOME/.local/bin/bin:$PATH"
```

For PowerShell (Windows):

```powershell
$env:PATH += ";$HOME\.local\bin\bin"
```

### 3. **Initialize environment variables**

Run the upcoming `init-env` script (to be implemented) to set any required base environment variables:

```sh
init init-env
```

This step ensures paths like `XDG_CONFIG_HOME`, `STARSHIP_CONFIG`, and others are set consistently.

### 4. **Use dispatcher commands**

```sh
init git-user               # Setup git identity
setup starship              # Install Starship prompt
task clear-cache            # Run cache cleaner script
job sync-vault              # Background sync for notes vault
```

### 5. **Discover available scripts**

Each dispatcher supports `--help` or `list`:

```sh
setup list
job --help
```

---

## 🧩 Design Patterns

- **Dispatcher pattern**: Top-level CLI tools delegate to scripts in matching folders
- **Metadata header (`#:`)**: Scripts optionally include a `#:` comment to describe purpose (shown in `list` commands)
- **Hybrid wrappers**: `jobs/` often wrap `tasks/` for scheduling (e.g., `task/sync.sh` + `job/sync-wrapper.sh`)

---

## 📦 Example Scripts

- `init/git-user.sh` — sets global git name/email
- `setup/starship.ps1` — installs Starship and applies user config
- `task/clear-cache.sh` — clears logs and temp files on demand
- `job/sync-vault.ps1` — keeps note vault repo synced every few minutes
- `ops/monitor-disk-usage.sh` — warns if any disk usage exceeds threshold
- `dev/generate-readme.sh` — builds README from templated metadata
- `meta/validate-dispatchers.sh` — checks dispatcher/folder alignment

---

## 🔒 Assumptions

- User has no root/admin access (scripts install and run at user level)
- Scripts are designed to be run **standalone** and require minimal dependencies
- Config paths (like `$XDG_CONFIG_HOME`) are respected and exported if needed

---

## 🧰 Maintenance & Contribution

Scripts should:

- Include a shebang line and platform-specific syntax
- Follow naming conventions: lowercase with dashes
- Include a `#:` header for help visibility
- Remain self-contained (no global state)

Dispatchers are responsible for:

- Routing to the correct script
- Listing and describing available commands
- Ensuring only matching script extensions are called

---

## 📄 License

MIT or similar permissive license. You are free to clone, modify, and reuse.

---

## 🧭 Roadmap

- Add usage logging (optional)
- Add Windows Scheduled Task generators
- Add interactive setup modes (choose what to install)
- Add dispatcher for `ops`, `dev`, and `meta` (once they grow)

---

> Designed for professionals who value clarity, maintainability, and frictionless onboarding across platforms.
