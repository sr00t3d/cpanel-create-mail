# cPanel Automated Email Creator

Readme: [BR](README-ptbr.md)

![License](https://img.shields.io/github/license/sr00t3d/cpanel-create-mail)
![Shell Script](https://img.shields.io/badge/language-Bash-green.svg)
![Compatibility](https://img.shields.io/badge/compatible-cpanel-blue)

<img width="700" src="cpanel-create-mail-cover.webp" />

A Bash script designed for system administrators to automate the creation of email accounts on cPanel/WHM servers via the command line. It utilizes the cPanel `UAPI` and `WHMAPI1` for secure and standardized operations.

## 🚀 Features

* **Automated Password Generation:** Uses OpenSSL to generate strong, 16-character random passwords.
* **Pre-flight Checks:**
    * Validates email format syntax.
    * Checks if the domain exists in `/etc/trueuserdomains`.
    * Verifies if the cPanel account is currently **suspended** before attempting creation.
    * Checks if the email address already exists to prevent overwrites.
* **cPanel Native:** Uses standard cPanel scripts (`/scripts/whoowns`) and APIs (`uapi`).

## 📋 Prerequisites

* **Operating System:** CentOS/AlmaLinux/CloudLinux with cPanel & WHM installed.
* **User:** Must be executed as `root` (to access WHM API and switch users for UAPI).
* **Dependencies:** `openssl` (usually pre-installed).

## 💻 How to Use

### Hosted Mode

1. **Download the file to the server:**

```bash
curl -O https://raw.githubusercontent.com/sr00t3d/cpanel-create-mail/refs/heads/main/cpanel-create-email.sh

```

2. **Give execution permission:**

```bash
chmod +x cpanel-create-email.sh

```

3. **Execute the script:**

```bash
./cpanel-create-email.sh email@domain.com

```

### Direct Mode

```bash
bash <(curl -fsSL 'https://raw.githubusercontent.com/sr00t3d/cpanel-create-mail/refs/heads/main/cpanel-create-email.sh') mail@dominio.com
```

## Example Output

```bash
./cpanel-create-email.sh mail@domain.com

Success! The email account has been created.

--------------------------------------------------
Email: tmail@domain.com
Password: mEWlB7wIlQ8sacHGKg8zpg==
--------------------------------------------------
```

🛠️ How it Works

- **Input Validation**: Ensures argument is provided and looks like an email.
- **User Lookup**: Identifies the cPanel owner of the domain using `/scripts/whoowns`.
- **Safety Check**: Queries `whmapi1 accountsummary` to ensure the hosting account is active (not suspended).
- **Creation**: Executes `uapi --user=USERNAME Email add_pop` to create the mailbox with unlimited quota (`quota=0`).

## ⚠️ Troubleshooting

- **Domain not registered on server**: Ensure the domain is listed in cPanel and not just a DNS pointer.
- **Account is suspended**: The script will block creation on suspended accounts to prevent abuse. Unsuspend the account via WHM first.

## ⚠️ Legal Notice

> [!WARNING]
> This software is provided "as is". Always ensure you have explicit permission before running. The author is not responsible for any misuse, legal consequences, or data impact caused by this tool.

## 📚 Detailed Tutorial

For a complete, step-by-step guide, check out my full article:

👉 [**Fast Create cPanel Mail Account**](https://perciocastelo.com.br/blog/fast-create-cpanel-mail-account.html)

## License 📄

This project is licensed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for details.
