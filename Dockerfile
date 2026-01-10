# Stage0 Runbook Template Dockerfile
# This Dockerfile packages your runtime dependencies 
# and runbooks into a custom container image. 
#
# Base image includes: Python 3.12, Flask API, Gunicorn, Prometheus metrics

FROM ghcr.io/agile-learning-institute/stage0_runbook_api:latest

##################################
# OPTIONAL: Install AWS CLI v2
# Uncomment this section if your runbooks need AWS CLI
##################################
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         curl \
#         unzip && \
#     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
#     unzip awscliv2.zip && \
#     ./aws/install && \
#     rm -rf awscliv2.zip aws && \
#     rm -rf /var/lib/apt/lists/* && \
#     aws --version

##################################
# OPTIONAL: Install GitHub CLI
# Uncomment this section if your runbooks need GitHub CLI
##################################
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         curl \
#         ca-certificates && \
#     curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
#         dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
#     chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
#     echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
#         tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends gh && \
#     rm -rf /var/lib/apt/lists/* && \
#     gh --version

##################################
# OPTIONAL: Install Docker CLI
# Uncomment this section if your runbooks need Docker CLI
# Note: You'll also need to mount /var/run/docker.sock in docker-compose.yaml
##################################
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         ca-certificates \
#         curl \
#         gnupg && \
#     install -m 0755 -d /etc/apt/keyrings && \
#     curl -fsSL https://download.docker.com/linux/debian/gpg | \
#         gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
#     chmod a+r /etc/apt/keyrings/docker.gpg && \
#     echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#         tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends docker-ce-cli && \
#     rm -rf /var/lib/apt/lists/* && \
#     docker --version

##################################
# OPTIONAL: Install Terraform
# Uncomment this section if your runbooks need Terraform
##################################
# ENV TERRAFORM_VERSION=1.6.0
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         curl \
#         unzip && \
#     curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
#     unzip terraform.zip && \
#     mv terraform /usr/local/bin/ && \
#     rm terraform.zip && \
#     rm -rf /var/lib/apt/lists/* && \
#     terraform version

##################################
# OPTIONAL: Install Additional Tools
# Add your custom tool installations here
# Example: kubectl, helm, gcloud, etc.
##################################
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#         your-package-here && \
#     rm -rf /var/lib/apt/lists/*

##################################
# REQUIRED: Package Your Runbooks
# This section copies your runbooks into the container
# Adjust the destination path if needed
##################################
# Create directory for runbooks (matches production working directory)
RUN mkdir -p /opt/stage0/runner/runbooks

# Copy runbooks folder into the container
# Assumes runbooks are in ./runbooks/ relative to build context
COPY ./runbooks/ /opt/stage0/runner/runbooks/

# Set working directory (matches docker-compose.yaml configuration)
WORKDIR /opt/stage0/runner

##################################
# OPTIONAL: Verify Installation
# Uncomment to verify tools are installed correctly
##################################
# RUN python3 --version && \
#     pipenv --version && \
#     ls -la /opt/stage0/runner/runbooks/
