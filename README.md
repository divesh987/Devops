# Devops
## Development Environment Setup
* Download and install Virtual Box from <https://www.virtualbox.org/wiki/Downloads>
* Download and install Vagrant from <https://www.vagrantup.com/downloads.html> for your operating system.
* Open the Terminal, you can use cmd + space and search "terminal"
*  Go to your working directory, run the command ```cd (directory path)```
* Run the command ```vagrant init ubuntu/xenial64```
* Run the command ```vagrant up``` to set up your virtual machine.
* Run the command ```vagrant ssh``` to login to your  virtual machine. 
* Run the command ```sudo apt-get update -y``` to make sure package sources are up to date.
* Run the command ```sudo apt-get install nginx -y``` to install nginx web server.
* Your development environment is now ready !
* Go to the url: <http://development.local/> to test your server

