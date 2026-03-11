#!/bin/bash
# Azure Multi-Tier Architecture Deployment Script
# Author: Adesewa

# Create Resource Group
az group create --name AdesewamultitierRG --location southafricanorth

# Create VNet
az network vnet create --resource-group AdesewamultitierRG --name AdesewamultitierVNet --address-prefix 10.0.0.0/16

# Create Subnets
az network vnet subnet create --resource-group AdesewamultitierRG --vnet-name AdesewamultitierVNet --name WebSubnet --address-prefix 10.0.1.0/24
az network vnet subnet create --resource-group AdesewamultitierRG --vnet-name AdesewamultitierVNet --name AppSubnet --address-prefix 10.0.2.0/24
az network vnet subnet create --resource-group AdesewamultitierRG --vnet-name AdesewamultitierVNet --name DBSubnet --address-prefix 10.0.3.0/24

# Create NSGs
az network nsg create --resource-group AdesewamultitierRG --name WebNSG
az network nsg create --resource-group AdesewamultitierRG --name AppNSG
az network nsg create --resource-group AdesewamultitierRG --name DBNSG

# Create NSG Rules
az network nsg rule create --resource-group AdesewamultitierRG --nsg-name AppNSG --name AllowFromWeb --priority 100 --source-address-prefixes 10.0.1.0/24 --source-port-ranges 0-65535 --destination-address-prefixes 10.0.2.0/24 --destination-port-ranges 80 443 --access Allow --protocol Tcp --direction Inbound
az network nsg rule create --resource-group AdesewamultitierRG --nsg-name DBNSG --name AllowFromApp --priority 100 --source-address-prefixes 10.0.2.0/24 --source-port-ranges 0-65535 --destination-address-prefixes 10.0.3.0/24 --destination-port-ranges 3306 --access Allow --protocol Tcp --direction Inbound

# Attach NSGs to Subnets
az network vnet subnet update --resource-group AdesewamultitierRG --vnet-name AdesewamultitierVNet --name WebSubnet --network-security-group WebNSG
az network vnet subnet update --resource-group AdesewamultitierRG --vnet-name AdesewamultitierVNet --name AppSubnet --network-security-group AppNSG
az network vnet subnet update --resource-group AdesewamultitierRG --vnet-name AdesewamultitierVNet --name DBSubnet --network-security-group DBNSG

# Create VMs
az vm create --resource-group AdesewamultitierRG --name WebVM --image Ubuntu2204 --vnet-name AdesewamultitierVNet --subnet WebSubnet --admin-username azureuser --generate-ssh-keys
az vm create --resource-group AdesewamultitierRG --name AppVM --image Ubuntu2204 --vnet-name AdesewamultitierVNet --subnet AppSubnet --admin-username azureuser --generate-ssh-keys --public-ip-address ""
az vm create --resource-group AdesewamultitierRG --name DBVM --image Ubuntu2204 --vnet-name AdesewamultitierVNet --subnet DBSubnet --admin-username azureuser --generate-ssh-keys --public-ip-address ""

echo "Deployment Complete!"![IMG_3641](https://github.com/user-attachments/assets/bba8aa55-27a6-42cb-996d-c9cf4deae062)
![IMG_3640](https://github.com/user-attachments/assets/cf24f230-d26c-4b02-96d1-6c2ef47ef0d0)
![IMG_3642](https://github.com/user-attachments/assets/2139dee8-491a-4bcb-acf4-0d91ee5833f9)
![IMG_3643](https://github.com/user-attachments/assets/e2632f64-1556-4604-80ae-0b3f2b68e91d)
![IMG_3644](https://github.com/user-attachments/assets/c53f31a9-5942-4a70-9de2-f21901c8a129)
![IMG_3646](https://github.com/user-attachments/assets/9341c4ce-af38-4a66-bd60-4a61dcd0cb50)
![IMG_3645](https://github.com/user-attachments/assets/9ca355e6-4ffe-49c4-b65e-ddba04a134f2)
![IMG_3639](https://github.com/user-attachments/assets/d0687336-e9d8-4112-84c1-cab40bf93ba0)
![IMG_3638](https://github.com/user-attachments/assets/aaa66590-a9cd-41c6-9e5a-363480087439)
![IMG_3639](https://github.com/user-attachments/assets/1fc40c38-5375-4332-9366-a64af98c5db4)
