# Magento Installation Wizard (Whiptail UI)

A simple interactive Bash installer for Magento using `whiptail`.

This script provides a graphical terminal-based interface to install Magento quickly with:

- Magento version selection
- Custom Magento versions
- Database configuration
- Admin user setup
- Store URL setup
- Optional table prefix
- Automatic Magento installation
- Automatic database creation
- Disable Magento 2FA
- Post-install Magento commands

---

# Supported Magento Versions

- 2.4.9
- 2.4.8
- 2.4.7-p5
- 2.4.7-p4
- 2.4.6-p8
- Custom versions supported

---

# Requirements

Before running the installer, make sure your server has:

- PHP
- Composer
- MySQL
- Elasticsearch/OpenSearch
- Apache or Nginx
- Git
- whiptail

---

# Install Dependencies

## Ubuntu/Debian

```bash
sudo apt update
sudo apt install whiptail -y
```

---

# Download Script

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/magento-install-ui.git
```

```bash
cd magento-install-ui
```

---

# Make Script Executable

```bash
chmod +x install_magento_ui.sh
```

---

# Run Installer

```bash
./install_magento_ui.sh
```

---

# Features

## Interactive TUI Installer

Uses `whiptail` for a clean terminal UI.

## Custom Magento Versions

You can install any Magento version manually.

Example:

```text
2.4.9
2.4.7-p5
2.4.8
```

## Automatic Database Creation

The script automatically creates the database if it does not exist.

## Disable Magento 2FA

Automatically disables:

- Magento_TwoFactorAuth
- Magento_AdminAdobeImsTwoFactorAuth

---

# Example Installation Flow

1. Choose Magento version
2. Enter database details
3. Configure admin user
4. Enter base URL
5. Install Magento automatically

---

# Notes

- Make sure Composer authentication is configured for Magento repository access.
- Elasticsearch/OpenSearch must be running.
- PHP version must match Magento requirements.

---

# Composer Authentication

Configure Magento Composer authentication:

```bash
composer config --global http-basic.repo.magento.com PUBLIC_KEY PRIVATE_KEY
```

Get keys from:

https://marketplace.magento.com/

---

# License

MIT License

---

# Contributing

Pull requests are welcome.
Feel free to improve the installer.

---

# Author

Created for the Magento community.
