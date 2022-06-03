# SLEwithDocker
A SLE15 SP3 based container that includes a fixed address capacity, SSH access, and Docker.

Requirements:
- Docker (tests were done on 20.10/openSUSE 15.3).
- A subscription for SLE, since upgrade and package installation are done at build.
- Privileged mode for running containers.

To build a container with 8 GiB memory:
  docker build -m 8G -t slewdocker .

Create a network for containers' use:
docker network create -d bridge --subnet=192.168.250.0/24 --ip-range=192.168.250.0/24 clusterlab

Run the container:
docker run --privileged -d --restart=unless-stopped --ip=192.168.250.23 --hostname=myregistry.domain --name=myregistry -p 2322:22 -v /sys/fs/cgroup:/sys/fs/cgroup --cap-add SYS_ADMIN slewdocker
