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

parentIDOU=""
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
printf "\n Printing the Parent ID, the new OU Name et le profile \n"
echo $parentIDOU , $newOUName, $newProfile

# Get the parent ID (root)

printf "\n Getting the ID of the Root Organization\n"

parentIDOU=$(aws organizations list-roots --query 'Roots[0].[Id]' --output text)

printf "\n Printing the Parent ID, the new OU Name et le profile de nouveau \n"

echo $parentIDOU , $newOUName, $newProfile

printf "\n Getting the ID of the Root Organization\n"

# Creating the new organization unit
printf "\n Creating the new organization\n"
RES=$(aws organizations create-organizational-unit --parent-id $parentIDOU --name $newOUName \
--query 'OrganizationalUnit.[Id]' --output text)

printf "\n Printing the ID of the new organization unit \n"
echo $RES

# Creating a policy a service control policy for my new organization unit
printf "\n Creating a SCP for my new organization unit\n"
PES=$(aws organizations create-policy --content file://mutex-ou-er-policy.json \
--name AllowedServices --type SERVICE_CONTROL_POLICY \
--description "Allowed Services Epargne Retraite" \
--query 'Policy.PolicySummary.[Id]' --output text)

# Attaching the policy that we have just created to the OU we ceated earlier
printf "\n Attaching the policy that we have just created to the OU we ceated earlier \n"
TES=$(aws organizations attach-policy --policy-id $PES --target-id $RES)