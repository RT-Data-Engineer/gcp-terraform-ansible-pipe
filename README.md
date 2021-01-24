# How to launch the project
Open cloud shell (top right corner) and execute this commands. If you want to relaunch the installation again to create another one project, **restarting the gcloud console is strongly recommended**. To perform a restart, select three dots on gcloud console settigns and pick the **Restart** option.

```bash
sudo -s
cd ~
rm -rf $HOME/bootstrap/
git clone https://github.com/RT-Data-Engineer/gcp-terraform-ansible-pipe.git $HOME/bootstrap
sudo bash $HOME/bootstrap/install.sh
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
copy remote_user from /opt/bootstrap/ansible.cfg<br>
copy key file /opt/bootstrap/ssh-key<br>
```bash
ssh -i <ssh-key> <remote_user>@<vm-public_ip>
```
# How ansible pipeline works
Script generates following files from created VMs and generated keys:<br>
```bash
/opt/bootstrap/ansible/ansible.cfg 
/opt/bootstrap/hosts 
/opt/bootstrap/ssh-key
```
Where 'ansible.cfg' file has ssh username, 'hosts' has public IP associations of created VMs and 'ssh-key' is a private key used to ssh into those VMs.<br>
<br>
Copy them into your local machine, go into the folder where ansible.cfg reside and launch with this command:<br>
```bash
ansible-playbook -i /opt/bootstrap/hosts /opt/bootstrap/ansible/postgres-kafka-nifi.yaml --private-key /opt/bootstrap/ssh-key
```
