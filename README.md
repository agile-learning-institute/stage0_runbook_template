# stage0_runbook_template

This is a GitHub Template Repo that you have used to create your own Custom, Deployable Runbook. Complete the following steps to customize it for your team:

## Template Setup Instructions

1. **Create a new repo using this template and clone it** (you're off to a great start!)
2. **Configure the Makefile** to provide the ghcr image name in `make container`
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
# Run the tool in Dev mode (mounts ./runbooks)
make dev

# Package runbooks into custom container
make container

# Open the WebUI 
make open

# Validate a runbook (assumes API is running in dev mode)
RUNBOOK=./runbooks/test-a-book.md ENV="[]" make validate

# Execute a runbook (assumes API is running)
RUNBOOK=./runbooks/test-a-book.md ENV="[]" make execute
```

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
