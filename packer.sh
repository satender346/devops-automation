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

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
sudo systemctl start jenkins
