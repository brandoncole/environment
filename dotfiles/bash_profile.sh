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

# -----------------------------------------------------------------------------
# General Utilities
# -----------------------------------------------------------------------------
function update() {
    (cd ~/environment/ && ./bootstrap-macOS.sh update)
}

# -----------------------------------------------------------------------------
# AWS Utilities
# -----------------------------------------------------------------------------

# Performs 2FA for CLI
# e.g. aws_login 1234567890 username 123456
function aws_login() {
    local account=$1
    local user=$2
    local token=$3
    aws sts get-session-token --serial-number arn:aws:iam::$account:mfa/$user --token-code $token
}

# Switches to a profile configured via aws configure --profile profileid
# e.g. aws_profile profileid
function aws_profile() {

    # Why there's 2...
    # https://aws.amazon.com/blogs/security/a-new-and-standardized-way-to-manage-credentials-in-the-aws-sdks/
    # http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

    local profile=$1
    export AWS_PROFILE=$profile
    export AWS_DEFAULT_PROFILE=$profile
}

# e.g. aws_instances --region us-west-2
function aws_instances() {
    aws ec2 describe-instances $@ --query 'Reservations[*].Instances[*].[(Tags[?Key==`Name`].Value)[0], Placement.AvailabilityZone, InstanceId, PrivateIpAddress]' --output text | column -t | sort -k 1,2
}

# e.g. aws_subnets --region us-west-2
function aws_subnets() {
    aws ec2 describe-subnets $@ --query 'Subnets[*][(Tags[?Key==`Name`].Value)[0], AvailabilityZone, CidrBlock, VpcId, SubnetId]' --output text | column -t | sort -k 1,2
}

# e.g. aws_vpcs --region us-west-2
function aws_vpcs() {
    aws ec2 describe-vpcs $@ --query='Vpcs[*][(Tags[?Key==`Name`].Value)[0],VpcId, CidrBlock]' --output text | column -t | sort
}

# e.g. aws_peering --region us-west-2
function aws_peering() {
    aws ec2 describe-vpc-peering-connections $@ --query='VpcPeeringConnections[*][VpcPeeringConnectionId, AccepterVpcInfo.OwnerId, AccepterVpcInfo.VpcId, AccepterVpcInfo.CidrBlock, RequesterVpcInfo.OwnerId, RequesterVpcInfo.VpcId, RequesterVpcInfo.CidrBlock]' --output text | column -t | sort
}

# e.g. aws_security_groups --region us-west-2
function aws_security_groups() {
    aws ec2 describe-security-groups $@ --query 'SecurityGroups[*][GroupName, GroupId, VpcId]' --output text | column -t | sort
}

# e.g. aws_route_tables --region us-west-2
function aws_route_tables() {
    aws ec2 describe-route-tables $@ --query 'RouteTables[*][(Tags[?Key==`Name`].Value)[0], RouteTableId, VpcId, (Routes[?VpcPeeringConnectionId][VpcPeeringConnectionId, DestinationCidrBlock][])[1]]'  --output text | column -t | sort
}