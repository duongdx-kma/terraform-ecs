#!/bin/bash

# volume setup
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
# wait for the device to be attached
DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
DEVICEEXISTS=''
while [[ -z $DEVICEEXISTS ]]; do
echo "checking $DEVICENAME"
DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
if [[ $DEVICEEXISTS != "1" ]]; then
sleep 15
fi
done
pvcreate ${DEVICE}
vgcreate data ${DEVICE}
lvcreate --name volume1 -l 100%FREE data
mkfs.ext4 /dev/data/volume1
fi
mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins

# install default-jre (needed for ubuntu 18.04)
apt-get update
apt-get install -y default-jre wget

# install jenkins and docker
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install -y jenkins unzip docker.io

# enable docker and add perms
usermod -G docker jenkins
systemctl enable docker
service docker start
service jenkins restart

# install awscli
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install
aws --version

# install terraform
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# clean up
apt-get clean
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip