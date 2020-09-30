# hypersign-docker

## Components

* [Core](https://github.com/hypersign-protocol/core)
* [Explorer](https://github.com/hypersign-protocol/explorer)
* [Studio](https://github.com/hypersign-protocol/studio)
    * Client
    * Server

## Architecture

![img](architecture.png)


## Pre-requisite

- You need [Google recaptcha](https://www.google.com/recaptcha/about/) site key and secret key. 
- You need mail server configuration. You can use your [google account](https://support.google.com/mail/answer/7126229?hl=en) for that. 

## Run containers

```bash
./restart.sh
```

## Stop containers

```bash
./stop.sh
```

## Environment Vars

Please make sure you set env var in the docker-compose file.

### core

- `PORT`: <Enter port. i.e. 5000>
- `JWT_SECRET`:<Enter your JWT secret key>
- `RECAPTCHA_SECRET`: Recaptcha secret 

### studio-server

- `PORT`: <Enter port. i.e. 9000>
- `JWT_SECRET`: <Enter your JWT secret key>

Below configurations are required to set email client. 

- `MAIL_HOST`: <Enter email server host i.e. smtp.gmail.com> 
- `MAIL_PORT`: <Enter email server port i.e. 465>
- `MAIL_USERNAME`: <Enter admin email id i.e. test@gmail.com>
- `MAIL_PASSWORD`: <Enter admin email password i.e. testPassW0rd1@>
- `MAIL_NAME`: <Enter admin name i.e Hypersign Admin> 

### studio-client

- `PORT`: <Enter port. i.e. 9001>
- `VUE_APP_TITLE`: <Enter app name. i.e Hypersign studio>
- `VUE_APP_VERSION`: <Enter app version i.e. v1.0>
- `VUE_APP_STUDIO_SERVER_BASE_URL`: <Enter studio-server base url. i.e http://localhost:9000/>
- `VUE_APP_NODE_SERVER_BASE_URL`: <Enter blockchain node (core) base url. i.e. http://localhost:5000/>
- `VUE_APP_EXPLORER_BASE_URL`: <Enter explorer ui base url. i.e. http://localhost:5001/>

### explorer

- `PORT`: <Enter port. i.e. 5001>
- `VUE_APP_TITLE`: <Enter app name. i.e Identity Explorer>
- `VUE_APP_VERSION`: <Enter app version i.e. v1.0>
- `VUE_APP_STUDIO_BASE_URL`: <Enter studio-client base url. i.e http://localhost:9001/>
- `VUE_APP_NODE_SERVER_BASE_URL`: <Enter blockchain node (core) base url. i.e. http://localhost:5000/>
- `VUE_APP_RECAPTCHA_SITE_KEY`: <Enter recaptchs site key>

## Container size

```bash
docker stats
```

