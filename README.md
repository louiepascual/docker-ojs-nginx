# Docker OJS using nginx

This repository contains the Dockerfile to build the container image that runs Open Journal System (OJS) using php-fpm.

You'll need to run nginx webserver that will pass the processing of PHP files to php-fpm. See `docker-compose.yaml` to see how you can implement it.


## Build the OJS php-fpm image

```bash
docker build -t ojs-nginx:latest .
```

## Spinning up the application
1. Copy `config.TEMPLATE.inc.php` as `config.inc.php`.
2. Create and run docker containers using docker-compose:

```bash
docker-compose up -d
```
