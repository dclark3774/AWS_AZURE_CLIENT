# AWS_AZURE_CLIENT
This repository was created to allow the AXC F 2152 connection to AWS or Azure. 

For this repository, ensure that the AXC F 2152 has an internet connection.

Download the nodescript.sh script to your PC, and using WINSCP copy the file to the /opt/plcnext/ folder of the PLCNext.

Below explains the additional files needed for the code to function properly.
============================================================================
AWS:
-----------------------------------------------------------------------------
A folder with the AWS certificates on the AXC F 2152 in the opt/plcnext directory. 
The folder name MUST be named AWSCerts. It is case sensitive. 

There must be at least 3 files within this folder. 
1: <filename>.pem file 
2: <security certname>-certificate.pem 
3: <security certname>-private.pem.key

Azure:
------------------------------------------------------------------------------
No additional files needed.

Download:
==============================================================================
After all necessary files have been added to the root directory of the controller, wget the Linux repository folder in the root directory.

Then bash nodescript.sh (./nodescript.sh), and follow the commands in the command line. 

After script completion:
==============================================================================
Download the PLCnext Engineer library from my PLCnext_AWS_AZURE repository, and import into a PLCnext Engineer project.

Read the help file attached to the library for additional guidance. 
