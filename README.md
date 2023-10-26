# graylog_installer
```
apt -y update && apt -y upgrade && apt -y install git
git clone https://github.com/wallacemariadeandrade/graylog_installer.git
cd graylog_installer
chmod +x debian11_installer.sh
./debian11_installer.sh


To set "1234" as new admin's password: 

./debian11_installer.sh 1234
```

Some CPUs do not support AVX instructions, so MongoDB service won't work.
If that happens and you're using Proxmox, please go to through your VM Hardware > Processors and change 'Type' field value to 'Host'.

If this does not solve the problem, use the debian11_oldinstaller.sh script.

```
apt -y update && apt -y upgrade && apt -y install git
git clone https://github.com/wallacemariadeandrade/graylog_installer.git
cd graylog_installer
chmod +x debian11_oldinstaller.sh
./debian11_oldinstaller.sh


To set "1234" as new admin's password: 

./debian11_oldinstaller.sh 1234
```
