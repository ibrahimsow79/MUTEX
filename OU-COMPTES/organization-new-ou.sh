#!/bin/bash

# Description : this scripts create an OU organization unit and attach a SCPP (Service Control Policy)
# Version : v1.0
# 2 parameters should be provided : the parent OU ID and the name of the OU to be creeated 
# - please check whether an organizaton has been created with ALL FEATURE ENABLED (Mutex context)
# Author : Mutex Ibrahim Sow	


function usage
{
    echo "usage: organization_new_ou.sh [-h] --parent_id PARENT_ID
                                      --new_ou_name NEW_OU_NAME
                                      --cl_profile_name CLI_PROFILE_NAME
                                      [--region AWS_REGION]"
}

parentIdOU=""
newOUName=""
newProfile=""
roleName="OrganizationAccountAccessRole"
region="eu-west-3"

while [ "$1" != "" ]; do
    case $1 in
        -n | --parent_id)   shift
                                parentIDOU=$1
                                ;;
        -e | --new_ou_name )  shift
                                newOUName=$1
                                ;;
        -p | --cl_profile_name ) shift
                                newProfile=$1
                                ;;
        -r | --region )        shift
                                region=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
    esac
    shift
done

if [ "$parentIDOU" = "" ] || [ "$newOUName" = "" ] || [ "$newProfile" = "" ]
then
  usage
  exit
fi
echo $parentIDOU , $newOUName, $newProfile
