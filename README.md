# stage0_runbook_template

This is a GitHub Template Repo that you have used to create your own Custom, Deployable Runbook. Complete the following steps to customize it for your team:

## Template Setup Instructions

1. **Create a new repo using this template and clone it** (you're off to a great start!)
2. **Configure the Makefile** - Update `CONTAINER_IMAGE` with your GHCR image name (see [Customizing the Makefile](#customizing-the-makefile) below)
3. **Configure the Dockerfile** to install any CLI utilities your scripts may need (GitHub CLI, AWS CLI, etc.)
4. **Configure the docker-compose.yaml** to use the ghcr image you build
5. **Configure the GitHub Action docker-push workflow** to push your ghcr package
   - You will need to set up the ghcr package for this to work.

---

# Welcome
This is <your org>'s DevOps runbook. Runbook automation is done using the [Stage0 Runbook system](https://github.com/agile-learning-institute/stage0_runbooks). Write a warm welcome to the team's runbooks repo, include standards or patterns for managing secrets or running scripts. This is where you write, test, and package runbooks for the team.

## Quick Start (Users Guide)

```sh
# Run the system with packaged runbooks.
make deploy

# Shut down the containers when you're done
make down
```

## Quick Start (Script Author Guide)

```sh
# Start API server with local runbooks mounted (run in one terminal)
make api

# In another terminal, validate a runbook
make validate RUNBOOK=./runbooks/test-a-book.md

# Execute a runbook with environment variables
make execute RUNBOOK=./runbooks/test-a-book.md DATA='{"env_vars":{"VAR1":"value1","VAR2":"value2"}}'

# Open the WebUI 
make open

# Package runbooks into custom container
make container
```

---

# Customizing the Makefile

The Makefile provides simple commands for testing runbooks using `curl` (no Python CLI required). Customize it for your organization:

## Required Customizations

1. **Update the container image name** (line ~12):
   ```makefile
   CONTAINER_IMAGE ?= ghcr.io/YOUR_ORG/YOUR_RUNBOOKS_IMAGE:latest
   ```
   Replace `YOUR_ORG` and `YOUR_RUNBOOKS_IMAGE` with your GitHub organization and image name.

2. **Update docker-compose.prod.yaml references** if you've customized your production compose file.

## Optional Customizations

- **Change API URL**: If you're running the API on a different host/port, update `API_URL`
- **Add custom commands**: Add team-specific make targets for common workflows
- **Customize token roles**: Modify the `get-token` target to request different roles

## How It Works

The Makefile uses `curl` to interact with the API:
- `make api` - Starts docker-compose with your local runbooks mounted
- `make validate` - Gets a dev token, then calls the validate API endpoint (uses `DATA` parameter, defaults to `{"env_vars":{}}`)
- `make execute` - Gets a dev token, then calls the execute API endpoint (uses `DATA` parameter, defaults to `{"env_vars":{}}`)
- `make container` - Builds your custom container with runbooks
- `make deploy` - Deploys using your packaged container

All commands work without requiring Python or the CLI tool - just `make`, `curl`, and `jq` (for JSON formatting).

**Note**: The `DATA` parameter accepts JSON in the form `{"env_vars":{...}}`. If not provided, it defaults to `{"env_vars":{}}` (empty environment variables).

---

# Customizing your Dockerfile

The base `stage0_runbook_api` image includes:
- Python 3.12 and pipenv
- zsh (required for runbook scripts)
- The runbook runner utility
- Flask API server with Gunicorn
- Prometheus metrics endpoint

For runbooks that need additional tools (like Docker CLI, GitHub CLI, AWS CLI, etc.), you can extend the base image. This is especially useful when you want to package approved tools with your runbook execution environment.

## Using the Extended Image

An extended image is available that includes Docker CLI and GitHub CLI:

```yaml
services:
  api:
    image: ghcr.io/agile-learning-institute/stage0_runbook_api:extended
    # ... rest of configuration
```

This image is useful for runbooks that need to:
- Build and push Docker images
- Interact with GitHub repositories
- Use Docker-in-Docker capabilities

**Note**: When using Docker CLI, you'll need to mount the Docker socket:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

## Creating Custom Extended Images

You can create your own extended Dockerfile based on your specific needs. Sample Dockerfiles are provided in the `samples/` directory:

- **[Dockerfile.basic](samples/Dockerfile.basic)** - Basic runbook packaging with no additional tools
- **[Dockerfile.aws](samples/Dockerfile.aws)** - Extends base image with AWS CLI v2
- **[Dockerfile.terraform](samples/Dockerfile.terraform)** - Extends base image with Terraform
- **[Dockerfile.extended](samples/Dockerfile.extended)** - Extends the extended image (Docker + GitHub CLI) with additional tools

Copy and customize one of these samples, or use them as a reference for creating your own Dockerfile.

## Packaging Runbooks

You can package a collection of verified runbooks directly into a container image. This is useful for:
- Creating approved runbook collections
- Distributing runbooks without external volume mounts
- Ensuring runbook version consistency
- Creating immutable runbook execution environments

### Basic Runbook Packaging

See [samples/Dockerfile.basic](samples/Dockerfile.basic) for a simple example that packages runbooks without additional tools.

### Packaging with Tools

The sample Dockerfiles in `samples/` demonstrate how to combine tool extensions with runbook packaging:
- [Dockerfile.aws](samples/Dockerfile.aws) - AWS CLI + runbooks
- [Dockerfile.terraform](samples/Dockerfile.terraform) - Terraform + runbooks
- [Dockerfile.extended](samples/Dockerfile.extended) - Docker CLI, GitHub CLI, AWS CLI, Terraform + runbooks

All sample Dockerfiles include runbook packaging, so you get your tools and runbooks in one immutable image.

---

# Customizing your docker-compose

The `docker-compose.yaml` file configures how your runbook system runs. Sample configurations are provided in the `samples/` directory:

- **[docker-compose.dev.yaml](samples/docker-compose.dev.yaml)** - Development setup with volume-mounted runbooks
- **[docker-compose.packaged.yaml](samples/docker-compose.packaged.yaml)** - Using packaged runbooks (no volume mounts)
- **[docker-compose.extended.yaml](samples/docker-compose.extended.yaml)** - Extended image with Docker socket access
- **[docker-compose.prod.yaml](samples/docker-compose.prod.yaml)** - Production configuration

Copy and customize one of these samples for your needs.

**Important Production Notes**:
- Set `ENABLE_LOGIN=false` to disable development login
- Use a strong, randomly generated `JWT_SECRET`
- Configure `JWT_ISSUER` and `JWT_AUDIENCE` to match your identity provider
- Use read-only volume mounts when possible
- Set appropriate resource limits
- Expose ports only to localhost and use a reverse proxy for TLS termination

For more detailed production deployment guidance, see the [SRE Documentation](https://github.com/agile-learning-institute/stage0_runbooks/blob/main/SRE.md).

---

## Additional Resources

- [Stage0 Runbooks SRE Documentation](https://github.com/agile-learning-institute/stage0_runbooks/blob/main/SRE.md)
- [API Repository](https://github.com/agile-learning-institute/stage0_runbook_api)
- [SPA Repository](https://github.com/agile-learning-institute/stage0_runbook_spa)
- [Runbook Format Specification](https://github.com/agile-learning-institute/stage0_runbook_api/blob/main/RUNBOOK.md)
