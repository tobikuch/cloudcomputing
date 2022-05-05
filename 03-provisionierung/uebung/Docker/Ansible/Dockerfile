FROM ubuntu:21.10

RUN "apt-get update && apt-get install -y openssh-server
mkdir /var/run/sshd
echo 'root:verysecretpassword' | chpasswd
sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
echo "export VISIBLE=now" >> /etc/prof"