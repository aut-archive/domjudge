# domjudge
Fully Dockerized DOMJudge Setup

**THIS REPO IS NOT MAINTAINED ANYMORE, PLEASE OPEN A ISSUE IF YOU WANT TO CONTINUE**

## Setup

First Clone repo and build with latest version

```bash
./build
```

Use this `docker-compose` configuration:

```yml
version: '2'

services:

    # Jury UI Service
    domserver: 
        image: daavar/domserver
        links:
           - mysql
        environment:
           - VIRTUAL_HOST=
           - MYSQL_HOST=mysql
           - MYSQL_DATABASE=
           - MYSQL_USER=
           - MYSQL_PASSWORD=
        ports:
         - "8080:80"
        network_mode: bridge
        restart: always

    # Judgehosts service
    judgehost: 
        image: daavar/judgehost
        links:
           - domserver
        ipc: host
        privileged: true
        volumes:
           - "/dev:/dev"
        environment:
           - API_URL=http://domserver/api/
           - API_USER=judgehost
           - API_PASSWORD=
        network_mode: bridge
        restart: always
```

## Setup DB

```bash
docker-compose run --rm domserver dj-setup-database -r install
```
