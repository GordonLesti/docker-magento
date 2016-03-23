# docker-magento1

This is my prevered development environment for open source Magento extensions. Not the
recommended way, but all in one [Docker](https://www.docker.com/) container. This image is build on
[Debian Jessie](https://www.debian.org/) and contains the following software or packages.

* [wget](http://www.gnu.org/software/wget/)
* [curl](https://curl.haxx.se/)
* [git](https://git-scm.com/)
* [sudo](https://www.sudo.ws/)
* [apache2](http://httpd.apache.org/)
* [mysql-server](http://www.mysql.com/)
* [php5](http://php.net/)
 + cli
 + mysql
 + mcrypt
 + curl
 + gd
* [n98-magerun](https://github.com/netz98/n98-magerun)
* [Magento 1.9](https://magento.com/)
* [modman](https://github.com/colinmollenhour/modman)

## Docker

### Build

You can build the image with the following command. This can take a long time. Please replace `<image>` with something
meaningful like `mage1` for example.
```
$ docker build -t <image> .
```

### Run

You can run the container with the following command. Please replace `<module_dir_host>`, `<module_dir_container>`,
`<port>`, `<container>` with something meaningful like `~/Projects/Lesti_Fpc`, `/Lesti_Fpc`, `8080` and `fpc` for
example.
```
$ docker run -d -p -v <module_dir_host>:<module_dir_container> <port>:80 --name <container> <image>
```
Please visit the Magento frontend under `http://127.0.0.1:<port>` and backend under `http://127.0.0.1:<port>/admin`. The
credentials are `admin` and `password123`.

### Exec

You can jump into the running container with the following command.
```
$ docker exec -ti <container> bash
```
The magento installation is under the directory `/opt/magento`. You can install a Magento extension that is shared in
the directory `/Lesti_Fpc` for example by the following command.
```
$ cd /opt/magento
$ ./modman link /Lesti_Fpc
```

### Stop

You can stop the container with the following command.
```
$ docker stop <container>
```

### Start

You can start the container again with the following command.
```
$ docker start <container>
```
