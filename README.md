# Domjudge in Docker
Dockerized [DOMjudge](https://github.com/DOMjudge/domjudge)

## CGroups
The judgedaemon needs to run a recent Linux kernel (at least 3.2.0). The following steps configure cgroups on Ubuntu.
Edit `/etc/default/grub` and change the default commandline to:

```ini
GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1"
```

## Images
Pull images from dockerHub

```bash
docker pull domjudge/domserver
docker pull domjudge/judgehot
```

Or build youself:

```bash
git clone https://github.com/daavar/domjudge.git
cd domjudge
./build
```

## Usage
Install a Mysql or Mariadb server on your host and create dedicated empty database for use.  
Make sure `docker-compose` in installed our get latest from [Here](https://github.com/docker/compose/releases)

`docker-compose.yml`: (Edit fields inside braces with appretiate values)

```yml
version: '2'

services:

    # Web Service
    domserver: 
        image: daavar/domserver
        environment:
           - MYSQL_HOST=[mysql_host_ip]
           - MYSQL_DATABASE=[database]
           - MYSQL_USER=[username for mysql]
           - MYSQL_PASSWORD=[password for mysql]
        ports:
         - "8080:80"
        network_mode: bridge
        restart: always

    # Judgehosts Service
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
           - API_PASSWORD=[ChangeMe]
        privileged: true
        network_mode: bridge
        restart: always
```

### Finalize setup
```bash
# cd to where docker-compose.yml is located

# Setup CGROUPS
docker-compose run --rm domserver create_cgroups

# Setup Initial Database
docker-compose run --rm domserver dj-setup-database -r install
# [Enter MYSQL ROOT password]

```

### Startup
```bash
docker-compose up -d
```

### How to scale judgehosts
```bash
# cd to where docker-compose.yml is located

docker-compose scale judge-host=[N]
```
