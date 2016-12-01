#!/usr/bin/env bash

# Aliases
alias a=aws
alias g=gcloud
alias k=kubectl
alias dir="ls -la"

# Environment
export GOPATH=~/Workspace/go
mkdir -p $GOPATH
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Bash Settings
HISTFILESIZE=10000

# Functions
function update() {
    (cd ~/environment/ && ./bootstrap-macOS.sh update)
}

function aws_instances() {
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].[(Tags[?Key==`Name`].Value)[0], Placement.AvailabilityZone, InstanceId, PrivateIpAddress]' --output text | column -t | sort -k 1,2
}

function aws_subnets() {
    aws ec2 describe-subnets --query 'Subnets[*][(Tags[?Key==`Name`].Value)[0], AvailabilityZone, CidrBlock, VpcId, SubnetId]' --output text | column -t | sort -k 1,2
}

function aws_vpcs() {
    aws ec2 describe-vpcs --query='Vpcs[*][(Tags[?Key==`Name`].Value)[0],VpcId, CidrBlock]' --output text | column -t | sort
}

function aws_peering() {
    aws ec2 describe-vpc-peering-connections --query='VpcPeeringConnections[*][VpcPeeringConnectionId, AccepterVpcInfo.OwnerId, AccepterVpcInfo.VpcId, AccepterVpcInfo.CidrBlock, RequesterVpcInfo.OwnerId, RequesterVpcInfo.VpcId, RequesterVpcInfo.CidrBlock]' --output text | column -t | sort
}

function aws_security_groups() {
    aws ec2 describe-security-groups --query 'SecurityGroups[*][GroupName, GroupId, VpcId]' --output text | column -t | sort
}

function aws_route_tables() {
    aws ec2 describe-route-tables --query 'RouteTables[*][(Tags[?Key==`Name`].Value)[0], RouteTableId, VpcId, (Routes[?VpcPeeringConnectionId][VpcPeeringConnectionId, DestinationCidrBlock][])[1]]'  --output text | column -t | sort
}