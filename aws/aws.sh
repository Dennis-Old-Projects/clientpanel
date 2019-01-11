#Create the VPC
awsresponse=$(aws ec2 create-vpc \
--cidr-block=173.255.221.238/24 \
--output json)

#Extract the VPC id from the response
vpcId=$(echo -e $awsresponse \
| jq '.Vpc.VpcId' \
 | tr -d '"')
echo "Created VPC with id" $vpcId

#Name the VPC
echo "Naming the VPC"
aws ec2 create-tags \
 --resources $vpcId \
 --tags Key=Name,Value=scriptedVp