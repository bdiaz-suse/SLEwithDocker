FROM registry.suse.com/suse/sle15:15.3
MAINTAINER Benjamin Diaz <benjamin.diaz@suse.com>
RUN zypper ref
RUN zypper in -y -t pattern base enhanced_base
RUN zypper in -y dmidecode SUSEConnect
RUN /usr/sbin/SUSEConnect --regcode MY-REGCODE012 --email "johndoe@mydomain.com"
RUN /usr/sbin/SUSEConnect -p sle-module-basesystem/15.3/x86_64
RUN /usr/sbin/SUSEConnect -p sle-module-server-applications/15.3/x86_64
RUN /usr/sbin/SUSEConnect -p sle-module-containers/15.3/x86_64
RUN /usr/sbin/SUSEConnect -p sle-module-legacy/15.3/x86_64
RUN zypper in -y -t pattern yast2_basis yast2_server
RUN zypper in -y irqbalance libpcap1 libsmi libsmi2 tcpdump binutils bzip2 less vim ed numactl sudo docker openvswitch bridge-utils ebtables bind-utils
RUN zypper up -y
RUN /usr/sbin/sshd-gen-keys-start
RUN echo 'root:SuSE1234' | chpasswd
RUN useradd -s /bin/bash -c "Geeko Chameleon" -m geeko -G docker
RUN echo 'geeko:Ch4mele0n' | chpasswd
CMD /usr/lib/systemd/systemd --system
ENV container docker
RUN ln -s /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target
RUN rm /usr/lib/systemd/system/multi-user.target.wants/getty.target
RUN rm /etc/systemd/system/multi-user.target.wants/remote-fs.target
RUN systemctl enable wicked
RUN systemctl enable sshd
RUN systemctl enable docker
RUN sed -i "s/^Defaults targetpw/#Defaults targetpw/;s/^ALL/#ALL/" /etc/sudoers
RUN echo -e "geeko\tALL=(ALL)\tALL" >> /etc/sudoers
RUN /usr/sbin/SUSEConnect -d -p sle-module-containers/15.3/x86_64
RUN /usr/sbin/SUSEConnect -d -p sle-module-server-applications/15.3/x86_64
RUN /usr/sbin/SUSEConnect -d -p sle-module-basesystem/15.3/x86_64
RUN echo 'GODEBUG="x509ignoreCN=0"' >> /etc/sysconfig/docker
EXPOSE 22 80 443
VOLUME ["/sys/fs/cgroup"]
VOLUME ["/var/lib/docker"]
ENTRYPOINT ["/usr/lib/systemd/systemd","--system"]
