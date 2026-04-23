**Automated System Setup**

This repo contains an installation script to quickly set up development environment on a fresh Linux machine.

**Usage**

`./install.sh` -> Runs all scripts

`./install.sh <script-name>` -> Runs a specific script

`./install.sh -y` -> Skips prompt

`./install.sh -h` -> Shows help menu

---

**What it does**
- Detects your Linux distro and selects the right package manager
- Installs required packages
- Sets up config, plugin manager, etc. 

---

**Add a new script**
- Create a bash script: **setup/my-tool.sh**
- Use the internal `install` function to fetch packages and write your installation or configuration logic
- Run with `./install.sh my-tool`

---

**Add environment variables**
- Create **.env** file in the root directory
- Define your variables using the format: `KEY=value`
- Access them in any script using `$KEY`

---

**Note**: This project is personal and includes custom configurations. Use at your own risk.
