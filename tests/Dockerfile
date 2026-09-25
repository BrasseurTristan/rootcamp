# Debian 13 avec systemd, pour tester les labs comme dans une vraie VM.
#   docker build -t rootcamp-test -f tests/Dockerfile .
#   docker run -d --name rootcamp --privileged --cgroupns=host \
#     -v /sys/fs/cgroup:/sys/fs/cgroup:rw -v /dev:/dev rootcamp-test
#   docker exec rootcamp bash /opt/rootcamp/tests/run-labs.sh
FROM debian:trixie
ENV container=docker
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends systemd systemd-sysv dbus
COPY . /opt/rootcamp-src
RUN RC_SOURCE=/opt/rootcamp-src bash /opt/rootcamp-src/install.sh
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
