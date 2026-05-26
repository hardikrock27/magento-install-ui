#!/bin/bash

# Magento Installer UI
# Graphical Magento installer using whiptail

# ==========================================
# Helper Functions
# ==========================================

check_cancel() {
    if [ $? -ne 0 ]; then
        clear
        echo "Installation cancelled by user."
        exit 1
    fi
}

show_error() {
    whiptail --title "Error" --msgbox "$1" 10 60
    exit 1
}

# ==========================================
# Welcome
# ==========================================

whiptail --title "Magento Installation Wizard" \
--msgbox "Welcome to the Magento Installation Wizard.\n\nThis script will guide you through Magento installation using a graphical interface." \
12 70

# ==========================================
# Installation Folder
# ==========================================

FOLDER_NAME=$(whiptail \
--title "Installation Directory" \
--inputbox "Enter Magento folder name:" \
10 60 \
"magento" \
3>&1 1>&2 2>&3)

check_cancel

CURRENT_DIR=$(pwd)
CHECK_FOLDER_EXIST="$CURRENT_DIR/$FOLDER_NAME"

if [ -d "$CHECK_FOLDER_EXIST" ]; then
    show_error "Folder '$FOLDER_NAME' already exists.\nPlease choose another folder name."
fi

# ==========================================
# Magento Version Selection
# ==========================================

MAGENTO_VERSION=$(whiptail \
--title "Magento Version" \
--menu "Choose Magento Version" \
20 70 12 \
"2.4.9" "Magento 2.4.9" \
"2.4.8" "Magento 2.4.8" \
"2.4.7-p5" "Magento 2.4.7 Latest Patch" \
"2.4.7-p4" "Magento 2.4.7 Previous Patch" \
"2.4.6-p8" "Magento 2.4.6 Latest Patch" \
"2.4.6-p7" "Magento 2.4.6 Older Patch" \
"Custom" "Enter manually" \
3>&1 1>&2 2>&3)

check_cancel

# ==========================================
# Custom Magento Version
# ==========================================

if [ "$MAGENTO_VERSION" = "Custom" ]; then

    MAGENTO_VERSION=$(whiptail \
    --title "Custom Magento Version" \
    --inputbox "Enter Magento Version (Example: 2.4.9)" \
    10 60 \
    "2.4.9" \
    3>&1 1>&2 2>&3)

    check_cancel

    if [ -z "$MAGENTO_VERSION" ]; then
        show_error "Magento version cannot be empty."
    fi
fi

# ==========================================
# Database Configuration
# ==========================================

DB_HOST="localhost"

DB_USER=$(whiptail \
--title "Database Configuration" \
--inputbox "Enter Database Username:" \
10 60 \
"root" \
3>&1 1>&2 2>&3)

check_cancel

DB_PASS=$(whiptail \
--title "Database Configuration" \
--passwordbox "Enter Database Password:" \
10 60 \
3>&1 1>&2 2>&3)

check_cancel

DB_NAME=$(whiptail \
--title "Database Configuration" \
--inputbox "Enter Database Name:" \
10 60 \
"magento" \
3>&1 1>&2 2>&3)

check_cancel

# ==========================================
# Table Prefix
# ==========================================

TABLE_PREFIX=""

if (whiptail --title "Table Prefix" \
--yesno "Do you want to add a database table prefix?" \
10 60); then

    TABLE_PREFIX=$(whiptail \
    --title "Table Prefix" \
    --inputbox "Enter Table Prefix:" \
    10 60 \
    3>&1 1>&2 2>&3)

    check_cancel
fi

# ==========================================
# Admin Configuration
# ==========================================

ADMIN_FIRSTNAME=$(whiptail \
--title "Admin Configuration" \
--inputbox "Enter Admin First Name:" \
10 60 \
"Admin" \
3>&1 1>&2 2>&3)

check_cancel

ADMIN_LASTNAME=$(whiptail \
--title "Admin Configuration" \
--inputbox "Enter Admin Last Name:" \
10 60 \
"User" \
3>&1 1>&2 2>&3)

check_cancel

ADMIN_EMAIL=$(whiptail \
--title "Admin Configuration" \
--inputbox "Enter Admin Email:" \
10 60 \
"admin@example.com" \
3>&1 1>&2 2>&3)

check_cancel

ADMIN_USER=$(whiptail \
--title "Admin Configuration" \
--inputbox "Enter Admin Username:" \
10 60 \
"admin" \
3>&1 1>&2 2>&3)

check_cancel

ADMIN_PASSWORD=$(whiptail \
--title "Admin Configuration" \
--passwordbox "Enter Admin Password:" \
10 60 \
3>&1 1>&2 2>&3)

check_cancel

# ==========================================
# Store Configuration
# ==========================================

BASE_URL=$(whiptail \
--title "Store Configuration" \
--inputbox "Enter Store Base URL:" \
10 70 \
"http://127.0.0.1/$FOLDER_NAME/" \
3>&1 1>&2 2>&3)

check_cancel

ADMIN_URI=$(whiptail \
--title "Store Configuration" \
--inputbox "Enter Admin URI:" \
10 60 \
"admin" \
3>&1 1>&2 2>&3)

check_cancel

# ==========================================
# Confirmation
# ==========================================

if (whiptail \
--title "Confirm Installation" \
--yesno "Ready to install Magento $MAGENTO_VERSION ?\n\nFolder: $FOLDER_NAME\nDatabase: $DB_NAME\nBase URL: $BASE_URL" \
15 70); then

    clear

    echo "======================================"
    echo "Starting Magento Installation"
    echo "======================================"

    # ==========================================
    # Download Magento
    # ==========================================

    echo "Downloading Magento $MAGENTO_VERSION ..."

    composer create-project \
    --repository=https://repo.magento.com/ \
    magento/project-community-edition:$MAGENTO_VERSION \
    $FOLDER_NAME

    if [ $? -ne 0 ]; then
        show_error "Magento download failed.\nCheck Composer credentials or Magento version."
    fi

    # ==========================================
    # Create Database
    # ==========================================

    echo "Creating Database..."

    mysql -u "$DB_USER" -p"$DB_PASS" \
    -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

    # ==========================================
    # Magento Installation
    # ==========================================

    cd "$FOLDER_NAME" || exit

    echo "Running Magento setup:install ..."

    INSTALL_CMD="php bin/magento setup:install \
    --base-url=\"$BASE_URL\" \
    --db-host=\"$DB_HOST\" \
    --db-name=\"$DB_NAME\" \
    --db-user=\"$DB_USER\" \
    --db-password=\"$DB_PASS\" \
    --admin-firstname=\"$ADMIN_FIRSTNAME\" \
    --admin-lastname=\"$ADMIN_LASTNAME\" \
    --admin-email=\"$ADMIN_EMAIL\" \
    --admin-user=\"$ADMIN_USER\" \
    --admin-password=\"$ADMIN_PASSWORD\" \
    --language=\"en_US\" \
    --currency=\"USD\" \
    --timezone=\"America/Chicago\" \
    --use-rewrites=\"1\" \
    --backend-frontname=\"$ADMIN_URI\" \
    --search-engine=\"elasticsearch7\" \
    --elasticsearch-host=\"localhost\""

    # ==========================================
    # Optional Table Prefix
    # ==========================================

    if [ -n "$TABLE_PREFIX" ]; then
        INSTALL_CMD="$INSTALL_CMD --db-prefix=\"$TABLE_PREFIX\""
    fi

    eval "$INSTALL_CMD"

    if [ $? -ne 0 ]; then
        show_error "Magento installation failed."
    fi

    # ==========================================
    # Disable Magento 2FA
    # ==========================================

    BASE_VERSION=$(echo "$MAGENTO_VERSION" | cut -d'-' -f1)
    CLEAN_VERSION=$(echo "$BASE_VERSION" | tr -d '.')

    if [ "$CLEAN_VERSION" -ge "246" ]; then
        bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth
    fi

    bin/magento module:disable Magento_TwoFactorAuth

    # ==========================================
    # Final Magento Commands
    # ==========================================

    bin/magento setup:upgrade
    bin/magento indexer:reindex
    bin/magento cache:flush
    bin/magento cache:clean

    # ==========================================
    # Success Message
    # ==========================================

    whiptail --title "Installation Complete" \
    --msgbox "Magento installation completed successfully!\n\nFrontend:\n$BASE_URL\n\nAdmin:\n$BASE_URL$ADMIN_URI" \
    15 70

else
    clear
    echo "Installation cancelled."
fi