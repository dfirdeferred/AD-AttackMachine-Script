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
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/2.7/python-2.7.amd64.msi" -OutFile python.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I python-2.7.amd64.msi ALLUSERS=1 ADDLOCAL=ALL /qn'
    Invoke-WebRequest -Uri "http://www.voidspace.org.uk/python/pycrypto-2.6.1/pycrypto-2.6.1.win32-py2.7.msi" -OutFile pycrypto.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I pycrypto.msi ALLUSERS=1 ADDLOCAL=ALL /qn'
    setx PATH "%PATH%;C:\Python27\Scripts"
    setx PATH "%PATH%;C:\Python27"
    pip install pyasn1
    pip install pyasn1-modules
    pip install impacket
}
catch
{
    Write-Host "Impacket failed to install"
}



#Download Git Repositories from FrameworkURLs.csv
function Download-GitHub
{ 
    $Location = "c:\temp"
     Import-Csv .\FrameWorkURLs.csv | &{

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
    $hzipFile = "$location\$hashcat.zip"
    New-Item $hzipFile -ItemType File -Force
 
    # download the zip 
    Write-Host 'Downloading Hashcat'
    Invoke-RestMethod -Uri 'https://hashcat.net/files/hashcat-6.2.5.7z' -OutFile $hzipFile
    Write-Host 'Download finished'
 
    #Extract Zip File
    Write-Host 'Starting unzipping the GitHub Repository locally'
    Expand-Archive -Path $hzipFile -DestinationPath $location -Force
    Write-Host 'Unzip finished'
     
    #remove the zip file
    Remove-Item -Path $hzipFile -Force
}
     
    # remove the zip file
    Remove-Item -Path $ZipFile -Force
}

try
    {
        Download-GitHub
    }
catch
    {
        echo "One or more github repositories did not download properly."
    }


#Joins computer to the ad.vulndomain.corp
add-computer –domainname ad.vulndomain.corp -Credential AD\dcadmin -restart –force