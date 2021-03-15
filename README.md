# How to launch the project - inital setup
Open cloud shell (top right corner) and execute this commands. If you want to relaunch the installation again to create another one project, **restarting the gcloud console is strongly recommended**. To perform a restart, select three dots on gcloud console settigns and pick the **Restart** option.

Manually run this command **rm -rf $HOME/bootstrap/** if you having conflicts with previous installs.

```bash
cd ~

git clone https://github.com/RT-Data-Engineer/gcp-terraform-ansible-pipe.git $HOME/bootstrap

bash $HOME/bootstrap/install.sh
```

# How to launch step 2 - dataproc cluster

Manually run this command **rm -rf $HOME/step2/** if you having conflicts with previous installs.

```bash
cd ~

git clone https://github.com/RT-Data-Engineer/gcp-terraform-ansible-pipe.git $HOME/step2

bash $HOME/step2/install_step2.sh
```

# How to launch step 3 - greenplum

Manually run this command **rm -rf $HOME/step3/** if you having conflicts with previous installs.

```bash
cd ~

git clone https://github.com/RT-Data-Engineer/gcp-terraform-ansible-pipe.git $HOME/step3

bash $HOME/step3/install_step3.sh
```

# How to delete the project(s)
To do it manually: <br>
1. Refresh the page<br>
2. Search for "Manage resources" in gcloud search bar<br>
3. Select the project  you want to delete and confirm<br>
<br>
To remove ALL (!) projects and resources, run this script line:<br>

```bash
gcloud projects list | cut -f2 | awk '{print $1}' | tail -n+2 | xargs -n1 gcloud projects delete --quiet
```
# How to ssh manually 
copy remote_user from $HOME/bootstrap/ansible.cfg<br>
copy key file $HOME/bootstrap/ssh-key<br>
```bash
ssh -i <ssh-key> <remote_user>@<vm-public_ip>
```
# How ansible pipeline works
Script generates following files from created VMs and generated keys:<br>
```bash
$HOME/bootstrap/ansible/ansible.cfg 
$HOME/bootstrap/hosts 
$HOME/bootstrap/ssh-key
```
Where 'ansible.cfg' file has ssh username, 'hosts' has public IP associations of created VMs and 'ssh-key' is a private key used to ssh into those VMs.<br>
<br>
Copy them into your local machine, go into the folder where ansible.cfg reside and launch with this command:<br>
```bash
ansible-playbook -i $HOME/bootstrap/hosts $HOME/bootstrap/ansible/postgres-kafka-nifi.yaml --private-key $HOME/bootstrap/ssh-key
```
