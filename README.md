# ADAttackMachineScript
Script to pull down github repos and other useful frameworks for AD atacks
RUN AS ADMINSTRATOR or the script will fail.
Copy files to the same folder. Open Powershell as admin and CD to the folder. Run the .ps1. 
The script will install python2.7.15, pycrypto, and the impacket framework. The script then pulls down various useful repos such as mimikatz, atomicred, and hashcat.
Finally the script will ask if you want it to join the .ad.vulndomain (the domain that is created by the create-vuln-adds repo).

You can add any path to a .zip file in the frameworkurls.csv and the script will download them and add them to C:\temp
