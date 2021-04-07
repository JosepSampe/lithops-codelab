# Lithops CodeLab

Lithops CodeLab is a containerized development environment that integrates VS Code (code-server) and JupyterLab in the same docker container.

## Configuration
For running the Lithops CodeLab container, you need to configure some environment variables before running the container.

```
CODELAB_PASSWORD=lithops
CODELAB_S3_ACCESS_KEY_ID=<>
CODELAB_S3_SECRET_ACCESS_KEY=<>
CODELAB_S3_ENDPOINT=<>
CODELAB_S3_BUCKET=<>

LITHOPS_CONFIG_FILE=/home/jovyan/workspace/.lithops_config
```

Currently, the CODELAB_PASSWORD variable must be specified in plain text.

## Initialization
Once configured, you can start the container with:

```
docker run --name lithops-codelab -d --rm -p 8770:8080 --env-file=config.env jsampe/lithops-codelab
```

Note that Lithops CodeLab entry point is listening at port 8080, so you have to map an external node port to this port.

For debugging purposes, start the container with:

```
docker run -it --rm -p 8770:8080 --env-file=config.env jsampe/lithops-codelab /bin/bash
```

For terminating the container, you can execute:

```
docker rm -f lithops-codelab
```
