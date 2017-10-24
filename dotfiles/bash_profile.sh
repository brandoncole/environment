#!/usr/bin/env bash

# Aliases
alias a=aws
alias g=gcloud
alias k=kubectl

# Environment
export GOPATH=~/Workspace/go
mkdir -p $GOPATH
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Bash Settings
HISTFILESIZE=10000
HISTCONTROL=ignoreboth

# -----------------------------------------------------------------------------
# General Utilities
# -----------------------------------------------------------------------------
function update() {
    (cd ~/environment/ && ./bootstrap-macOS.sh update)
}

# -----------------------------------------------------------------------------
# AWS Utilities
# -----------------------------------------------------------------------------

# Switches to a profile configured via aws configure --profile profileid
# e.g. aws_profile profileid
function aws_profile() {

    # Why there's 2...
    # https://aws.amazon.com/blogs/security/a-new-and-standardized-way-to-manage-credentials-in-the-aws-sdks/
    # http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
    local profile=$1
    export AWS_PROFILE="$profile"
    export AWS_DEFAULT_PROFILE="$profile"
}

# Performs 2FA for CLI
# e.g. aws_login 1234567890 username 123456
function aws_login() {

    local account=$1
    local user=$2
    local token=$3

    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    local credentials="`aws sts get-session-token --serial-number arn:aws:iam::$account:mfa/$user --token-code $token`"

    export AWS_ACCESS_KEY_ID="`echo $credentials | jq -r .Credentials.AccessKeyId`"
    export AWS_SECRET_ACCESS_KEY="`echo $credentials | jq -r .Credentials.SecretAccessKey`"
    export AWS_SESSION_TOKEN="`echo $credentials | jq -r .Credentials.SessionToken`"
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

# e.g. aws_volumes --region us-west-2
function aws_volumes() {
    aws ec2 describe-volumes $@ --query 'Volumes[*][VolumeId, AvailabilityZone, VolumeType, Size, Iops, State, (Tags[?Key==`Name`].Value)[0]]' --output text | column -t -c 4 | sort
}

# -----------------------------------------------------------------------------
# Docker Utilities
# -----------------------------------------------------------------------------

# e.g. docker_cleanup
function docker_cleanup() {
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
    docker images -q --filter "dangling=true" | xargs docker rmi
}

# Purges all versions of an image by name
# e.g. docker_purge registry.com/imagename
function docker_delete_image() {

    local image=$1
    docker images | grep $image | awk {'print $3'} | xargs docker rmi

}

# -----------------------------------------------------------------------------
# LastPass Automation
# -----------------------------------------------------------------------------
function load_pass() {

    local item=$1
    local username=""

    if  ! lpass status --quiet; then
        echo "Enter LastPass Username: "
        read username
        lpass login $username || exit 1
    fi

    echo Loading $item from LastPass...
    local content=$(lpass show --notes "$item")
    if [[ ! "$content" == "" ]]; then
        eval "$content"
    fi

}