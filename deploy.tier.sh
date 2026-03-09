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

echo "Deployment Complete!"
