# Criador Automatizado de E-mail cPanel

[EN](README.md)

![Licença](https://img.shields.io/github/license/sr00t3d/cpanel-create-mail) ![Script Shell](https://img.shields.io/badge/language-Bash-green.svg) ![Compatibilidade](https://img.shields.io/badge/compatible-cpanel-blue)

<img width="700" src="cpanel-create-mail-cover.webp" />

Um script Bash projetado para administradores de sistemas automatizarem a criação de contas de e-mail em servidores cPanel/WHM via linha de comando. Ele utiliza o `UAPI` e `WHMAPI1` do cPanel para operações seguras e padronizadas.

## Recursos

* **Geração Automática de Senha:** Usa OpenSSL para gerar senhas aleatórias fortes de 16 caracteres.
* **Verificações Pré-Execução:**
    * Valida a sintaxe do formato de e-mail.
    * Verifica se o domínio existe em `/etc/trueuserdomains`.
    * Confere se a conta cPanel está atualmente **suspensa** antes de tentar a criação.
    * Verifica se o endereço de e-mail já existe para evitar sobrescritas.
* **Nativo do cPanel:** Utiliza scripts padrão do cPanel (`/scripts/whoowns`) e APIs (`uapi`).

## Pré-requisitos

* **Sistema Operacional:** CentOS/AlmaLinux/CloudLinux com cPanel & WHM instalados.
* **Usuário:** Deve ser executado como `root` (para acessar a API do WHM e alternar usuários para UAPI).
* **Dependências:** `openssl` (geralmente pré-instalado).

## Como usar

### Modo hospedado

1. **Baixe o arquivo no servidor:**

```bash
curl -O https://raw.githubusercontent.com/sr00t3d/cpanel-create-mail/refs/heads/main/cp-create-email.sh
```

2. **Dê permissão de execução:**

```bash
chmod +x cp-create-email.sh
```

3. **Execute o script:**

```bash
./cp-create-email.sh email@dominio.com
```

### Modo direto

```bash
bash <(curl -fsSL 'https://raw.githubusercontent.com/sr00t3d/cpanel-create-mail/refs/heads/main/cp-create-email.sh') mail@dominio.com
```

## Exemplo de Saída

```bash
./cp-create-email.sh mail@domain.com

Success! The email account has been created.
--------------------------------------------------
Email:    tmail@domain.com
Password: mEWlB7wIlQ8sacHGKg8zpg==
--------------------------------------------------
```

## Como Funciona

- **Validação de Entrada**: Garante que o argumento foi fornecido e parece ser um e-mail.
- **Consulta de Usuário**: Identifica o proprietário do cPanel do domínio usando `/scripts/whoowns`.
- **Verificação de Segurança**: Consulta `whmapi1 accountsummary` para garantir que a conta de hospedagem está ativa (não suspensa).
- **Criação**: Executa `uapi --user=USERNAME Email add_pop` para criar a caixa de correio com cota ilimitada (`quota=0`).

## Solução de Problemas

- **Domínio não registrado no servidor**: Certifique-se de que o domínio está listado no cPanel e não é apenas um apontamento DNS.
- **Conta está suspensa**: O script bloqueará a criação em contas suspensas para evitar abuso. Reative a conta via WHM primeiro.

## Aviso Legal

> [!WARNING]
> Este software é fornecido "tal como está". Certifique-se sempre de ter permissão explícita antes de executar. O autor não se responsabiliza por qualquer uso indevido, consequências legais ou impacto nos dados causados ​​por esta ferramenta.

## Detailed Tutorial

Para um guia completo, passo a passo, confira meu artigo completo:

👉 [**Criação Rápida de Conta de E-mail no cPanel**](https://perciocastelo.com.br/blog/fast-create-cpanel-mail-account.html)

## Licença

Este projeto está licenciado sob a **GNU General Public License v3.0**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.