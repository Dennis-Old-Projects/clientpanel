name="CLI VPC"
gatewayName="$name Gateway"
subnetName="$name Subnet"
securityGroupName="$name SecurityGroup"
routeTableName="$name RouteTable"
vpcCidrBlock="10.0.0.0/16"
subNetCidrBlock="10.0.1.0/24"
port22CidrBlock="0.0.0.0/0"
destinationCidrBlock="0.0.0.0/0"

#Create the VPC
awsresponse=$(aws ec2 create-vpc \
--cidr-block=$vpcCidrBlock \
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
 --tags Key=Name,Value="$name"

#Tool to calculated VPC and subnets CIDR
#http://www.davidc.net/sites/default/subnets/subnets.html?network=172.16.0.0&mask=18&division=7.31

#Add DNS support
echo "Enabling DNS support"
awsresponse = $(aws ec2 modify-vpc-attribute \
 --vpc-id $vpcId \
 --enable-dns-support "{ \"Value\": true}")
 echo $awsresponse

#Add DNS HostNames
echo "Enabling DNS Hostnames"
awsresponse = $(aws ec2 modify-vpc-attribute \
 --vpc-id $vpcId \
 --enable-dns-hostnames "{ \"Value\": true}")

 echo $awsresponse



