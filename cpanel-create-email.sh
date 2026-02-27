#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                                                                           ║
# ║   cPanel Create Mail v2.0.0                                               ║
# ║                                                                           ║
# ╠═══════════════════════════════════════════════════════════════════════════╣
# ║   Autor:   Percio Castelo                                                 ║
# ║   Contato: percio@evolya.com.br | contato@perciocastelo.com.br            ║
# ║   Web:     https://perciocastelo.com.br                                   ║
# ║                                                                           ║
# ║   Função:  Create a new cPanel account using whmapi1.                     ║
# ║                                                                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

if [[ -z "$1" ]]; then
    echo "[!] Usage: ./cpanel-create-email.sh user@domain.com"
    exit 1
fi

EMAIL=$1

# ------------------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------------------

function check_openssl(){ 
    if ! command -v openssl >/dev/null 2>&1; then
        echo "[!] Error: OpenSSL is required but not installed."
        exit 1
    fi
}

function validate_email_format(){
    if [[ -z "${EMAIL}" ]]; then
        echo "[!] Error: Email cannot be empty."
        exit 1
    fi

    # Regex validation
    if [[ ! ${EMAIL} =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "[!] Error: Invalid email format: ${EMAIL}"
        exit 1
    fi
}

function verify_password_gen(){
    if [[ -z "${SENHA}" ]]; then
        echo "[!] Error: Failed to generate a password."
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# Execution Logic
# ------------------------------------------------------------------------------

# Generate random password (16 chars)
SENHA=$(openssl rand -base64 16)

# Run validations
check_openssl
validate_email_format
verify_password_gen

# Extract domain from email
DOMINIO=${EMAIL#*@}

if [[ -z "${DOMINIO}" ]]; then
    echo "[!] Error: Could not extract domain from email."
    exit 1
fi

# Check if domain resolves (Local check)
if ! getent hosts "${DOMINIO}" >/dev/null; then
    echo "[!] Warning: Domain ${DOMINIO} does not resolve locally."
fi

# Check if domain exists in cPanel user file
if ! awk -F: -v d="$DOMINIO" 'BEGIN{IGNORECASE=1} tolower($1)==tolower(d){found=1} END{exit !found}' /etc/trueuserdomains; then
    echo "[!] Error: Domain ${DOMINIO} is NOT registered on this server."
    exit 1
fi

# Get the cPanel username for the domain
USUARIO=$(/scripts/whoowns "${DOMINIO}")
if [[ -z "${USUARIO}" ]]; then
    echo "[!] Error: Could not determine the cPanel user for this domain."
    exit 1
fi

# Check if the account is suspended
IS_SUSPENDED=$(whmapi1 accountsummary user="${USUARIO}" 2>/dev/null \
  | awk -F': ' '/^[[:space:]]*suspended:/{print $2+0; exit}')

if [ -z "$IS_SUSPENDED" ]; then
  echo "[!] Error: Could not retrieve account status for ${USUARIO} (API error)."
  exit 2
elif [ "$IS_SUSPENDED" -eq 1 ]; then
  echo "[!] Error: The account ${USUARIO} is SUSPENDED. Cannot create email."
  exit 1
fi

# Check if email already exists
if uapi --user="${USUARIO}" Email list_pops domain="${DOMINIO}" | grep -qF "${EMAIL}"; then
    echo "[!] Error: The email account ${EMAIL} already exists on the server."
    exit 1
fi

# Create the email account via UAPI
RESPONSE=$(uapi --user="${USUARIO}" Email add_pop email="${EMAIL}" domain="${DOMINIO}" password="${SENHA}" quota=0 --output=json)

# Parse status from JSON response
status=$(echo "$RESPONSE" | grep -oP '"status":\s*\K\d+')

if [[ -z "$status" || "$status" -ne 1 ]]; then
    echo "[!] Error creating email account. Server response:"
    echo "${RESPONSE}"
    exit 1
fi

# Success Output
echo -e "Success! The email account has been created."
echo -e "--------------------------------------------------"
echo -e "Email:    ${EMAIL}"
echo -e "Password: ${SENHA}"
echo -e "--------------------------------------------------"