sudo apt-get update
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y && sudo apt-get install packer -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
apt-get install docker.io git helm -y
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y && sudo apt-get install terraform -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
./aws/install -i /usr/local/aws-cli -b /usr/local/bin

pass=$(perl -e 'print crypt($ARGV[0], "password")' summit)
useradd -m -s /bin/bash -p $pass summit
echo 'summit  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#   PasswordAuthentication yes/   PasswordAuthentication yes/g' /etc/ssh/ssh_config
echo 'summit  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
service ssh reload

#This script will deploy k8s on AWS instance

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo apt-get update
sudo apt-get install docker.io -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo hostnamectl set-hostname "master"
sudo apt-get install -y kubelet=1.20.5-00 kubeadm=1.20.5-00 kubectl=1.20.5-00
sudo apt-mark hold kubelet kubeadm kubectl
sudo echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo kubeadm init --node-name master --pod-network-cidr=10.0.1.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


curl https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O
kubectl apply -f kube-flannel.yml
kubectl taint nodes master node-role.kubernetes.io/master-
