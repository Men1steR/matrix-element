# Matrix Synapse Auto-Deployment

## Description

This project is designed for the automatic deployment of a full-featured Matrix server based on the Synapse component. The solution automatically installs and configures:

- **Synapse (Matrix server)** — the core messaging server responsible for user registration, message history storage, event routing, and federation with other servers.
- **Element Web** — a web-based Matrix client that provides a modern interface for communication, available in the browser immediately after deployment.
- **PostgreSQL** — an external database fully configured and optimized for use with Synapse, ensuring stability, scalability, and reliable data storage.

The project enables fully automated setup of the entire infrastructure, minimizing manual intervention. Once deployed, the user receives a ready-to-use Matrix cluster accessible via a web interface and supporting federation.

## Requirements

To run this project, you need:

- Docker  
- Docker Compose (version 2 or higher)

If Docker and Docker Compose are not installed yet, run:

```bash
curl -fsSL https://get.docker.com | sh

## Install

To deploy the project, follow these steps:

1. Navigate to the /opt directory:

    ```bash
    cd /opt
    ```

2. Clone the project repository:

    ```bash
    git clone https://github.com/Men1steR/matrix-element.git
    ```

3. Enter the project folder:

    ```bash
    cd matrix-element
    ```

4. Create the .env file based on the template:

    ```bash
    cat .env.template > .env
    ```

5. Edit the .env file to match your setup (domains, database settings).

6. Start the installation:

    ```bash
    sudo bash ./install.sh
    ```

After successful installation, the project will be automatically deployed and will be available over **HTTPS** on **port 443**.
