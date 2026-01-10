# Stage0 Runbook Template

This is a GitHub Template Repository for creating your own runbook collection using the [Stage0 Runbook System](https://github.com/agile-learning-institute/stage0_runbooks).

## Quick Start

1. **Use this template** to create your own repository
2. **[Configure your Dockerfile](Dockerfile)** - Uncomment sections for tools your runbooks need (AWS CLI, GitHub CLI, Docker, Terraform, etc.)
3. **[Configure your docker-compose.yaml](docker-compose.yaml)** - update the container image tag ``ghcr.io/YOUR_ORG/YOUR_RUNBOOKS_IMAGE:latest`` to match your deployment.
4. **Update the [Makefile](Makefile)** - Set `CONTAINER_IMAGE` value from ``ghcr.io/YOUR_ORG/YOUR_RUNBOOKS_IMAGE:latest`` to your image name (line 12)
5. **Configure CI** Update the provided GitHub Actions [docker-push.yml](./.github/workflows/docker-push.yml) workflow to replace ``ghcr.io/your-org/your-repo-name:latest`` with your image name, and configure the package for deployment.  
5. **Make your Container**: Create your runbooks, and use the commands below to validate, test, and package your runbook for deployment.

## Runbook Author Guide
Welcome team member, this is where we document our operational processes, i.e. This is where the [./runbooks](./runbooks/) are. Runbooks are just markdown files. To make your runbooks executable with the Runbook Automation tools follow [these guidelines](https://github.com/agile-learning-institute/stage0_runbook_api/blob/main/RUNBOOK.md). 

## Runbook Developer Commands
```sh
## Build you custom runbook container
make container  

## Run your runbook in Dev mode (Mounts ./runbooks)
make dev

## Run you runbook in Deploy mode (Packaged Runbooks)
make deploy     

## Open the web UI in your browser
make open   

## Tail the API log files
make tail

## Shut down containers. 
make down
```

## Development

How to build a Runbook 

```sh
## Build and start your custom container
make container && make dev

## Edit your runbook as a markdown file in ./runbooks. 
## ./runbooks/Runbook.md is a empty template
## ./runbooks/SimpleRunbook.md is a simple example.

## Use the WebUI to test your script
make open  

## Or do it from the cli
make validate ./runbooks/MyNewRunbook.md
# or
make execute ./runbooks/MyNewRunbook.md /
   DATA='{"env_vars":{"VAR1":"value1"}}'
```

## Additional Resources

- [Stage0 Runbooks Documentation](https://github.com/agile-learning-institute/stage0_runbooks)
- [Runbook Format Specification](https://github.com/agile-learning-institute/stage0_runbook_api/blob/main/RUNBOOK.md)
