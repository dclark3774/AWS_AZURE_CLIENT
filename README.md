# AWS_AZURE_CLIENT
This repository was created to allow the AXC F 2152 connection to AWS or Azure. 

For this repository, ensure that the AXC F 2152 has an internet connection.

Below explains the additional files needed for the code to function properly.
-----------------------------------------------------------------------------
AWS:
-----------------------------------------------------------------------------
A folder with the AWS certificates on the AXC F 2152 in the root directory. 
The folder name MUST be named AWSCerts. It is case sensitive. 

There must be at least 3 files within this folder. 
1: <filename>.pem file 
2: <security certname>-certificate.pem 
3: <security certname>-private.pem.key

Azure:
------------------------------------------------------------------------------
No additional files needed.

After all necessary files have been added to the root directory of the controller, bash nodescript.sh.

