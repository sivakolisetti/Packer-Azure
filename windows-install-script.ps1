echo "ping test"
ping google.com
#Requires -RunAsAdministrator

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

echo "checking choco"
choco



echo "==========Installing Package Kubectl=========="
choco install kubernetes-cli -y

echo "==========Installing Package Curl=========="
choco install curl -y

echo "==========Installing Package Azure CLI=========="
choco install azure-cli -y 

echo "==========Installing Package Wget=========="
choco install wget -y

echo "==========Installing Package Helm=========="
choco install kubernetes-helm -y

echo "==========Installing Package Git=========="
choco install git -y

echo "==========Installing Package Jq=========="
choco install jq -y 

echo "==========Installing Package NetCat=========="
choco install netcat -y

echo "==========Installing Package Docker Engine 20.10.16=========="
choco install choco install docker-engine -y

echo "==========Installing Package Docker-compose 1.29.2=========="
choco install docker-compose -y

echo "==========Installing Package Docker CLI 20.10.16=========="
choco install docker-cli -y
