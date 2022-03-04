#################################################################################
# HacktiveDirectory.ps1 v.1                                                     #
#                                                                               #
#  This script is intended to quickly install and configure ADDS and create an  #
#                         Intentionally vulnerable domain                       #
#                     WRITTEN BY: Darryl G. Baker, CISSP, CEH                   #
#                                                                               #
#################################################################################


#Turn off Windows Defender
Set-MpPreference -DisableRealtimeMonitoring $true

#Downloads Python2.7,Pycrypto, and impacket framework
try{
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/2.7.15/python-2.7.15.msi" -OutFile python.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I python.msi ALLUSERS=1 ADDLOCAL=ALL Include_pip=1 /qn'
    Invoke-WebRequest -Uri "https://github.com/dfirdeferred/pycrypto2.6.1/raw/main/pycrypto-2.6.1.win32-py2.7.msi" -OutFile pycrypto.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I pycrypto.msi ALLUSERS=1 ADDLOCAL=ALL /qn'
    setx PATH "%PATH%;C:\Python27\Scripts"
    setx PATH "%PATH%;C:\Python27"
    start-process C:\Python27\Scripts\pip.exe -ArgumentList 'install pyasn1'
    Start-Sleep -seconds 5
    start-process C:\Python27\Scripts\pip.exe -ArgumentList 'install pyasn1-modules'
    Start-Sleep -seconds 5
    start-process C:\Python27\Scripts\pip.exe -ArgumentList 'install impacket'
}
catch
{
    Write-Host "Impacket failed to install"
}



#Download Git Repositories from FrameworkURLs.csv
function Download-GitHub
{ 
    $Location = "c:\temp"
     Get-Content .\FrameWorkURLs.csv | %{

          $url = $_
          $Name = $url.Split('/')[4]

         # Force to create a zip file 
         $ZipFile = "$location\$Name.zip"
         New-Item $ZipFile -ItemType File -Force
 
         # download the zip 
        Write-Host 'Starting downloading the GitHub Repository'
        Invoke-RestMethod -Uri $url -OutFile $ZipFile
        Write-Host 'Download finished'
 
        #Extract Zip File
        Write-Host 'Starting unzipping the GitHub Repository locally'
        Expand-Archive -Path $ZipFile -DestinationPath $location -Force
        Write-Host 'Unzip finished'
     
        # remove the zip file
        Remove-Item -Path $ZipFile -Force
        }
    
    #Download Hashcat
    $hzipFile = "$location\hashcat.7z"
 
    # download the zip 
    Write-Host 'Downloading Hashcat'
    Invoke-RestMethod -Uri 'https://hashcat.net/files/hashcat-6.2.5.7z' -OutFile $hzipFile
    Write-Host 'Download finished'
 
}
     

try
    {
        Download-GitHub
    }
catch
    {
        echo "One or more github repositories did not download properly."
    }


#Joins computer to the ad.vulndomain.corp based on user's choice
function domain-join{
$join= Read-Host "Would you like the script to add this computer to ad.vulndomain.corp? Y/n"
if($join -eq 'Y' -or $join -eq 'y'){
    
    Add-Computer -DomainName ad.vulndomain.corp -Credential AD\dcadmin -restart -force
    }
elseif($join -eq 'N' -or $join -eq 'n'){
    exit
    }
else
    {
    domain-join
    }
}

domain-join
