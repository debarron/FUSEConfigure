# FUSEConfigure
This repository helps you configure the <a href="https://github.com/libfuse/libfuse">libfuse</a> project
in a cluster of computers hosted in <a href="https://cloudlab.us/">CloudLab</a>.
Before you use it, make sure to have a <a href="http://docs.cloudlab.us/users.html#%28part._ssh-access%29">private SSH key registered to your CloudLab account</a>.

## The script
It needs three input params, in the following order:
* MACHINES\_LIST, A text file with a list of all nodes where you want to install and configure libfuse
* USER\_NAME, Your CloudLab's user name
* PRIVATE\_KEY, Your CloubLab's SSH private key

Run the script as:
`./fuse-configure.sh MACHINE\_LIST USER\_NAME PRIVATE\_KEY`


