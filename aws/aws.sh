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
awsresponse=$(aws ec2 modify-vpc-attribute \
 --vpc-id $vpcId \
 --enable-dns-support "{ \"Value\": true}")
 echo $awsresponse
#Add DNS HostNames
echo "Enabling DNS Hostnames"
awsresponse=$(aws ec2 modify-vpc-attribute \
 --vpc-id $vpcId \
 --enable-dns-hostnames "{ \"Value\": true}")
 echo $awsresponse

#Create Internet Gateway
echo "Creating Internet Gateway"
internetGatewayResponse=$(aws ec2 create-internet-gateway --output json)
internetGatewayId=$(echo -e $internetGatewayResponse | jq '.InternetGateway.InternetGatewayId' | tr -d '"')
#Name the Internet Gateway
echo "Naming the Internet Gateway"
aws ec2 create-tags \
 --resources $internetGatewayId \
 --tags Key=Name,Value="$gatewayName"
#Attach gateway to VPC
echo "Attach gateway to VPC"
awsresponse=$(aws ec2 attach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId)
echo $awsresponse

#Create a subnet for the the VPC
echo "Create a subnet for the the VPC"
subnetResponse=$(aws ec2 create-subnet --cidr-block $subNetCidrBlock --vpc-id $vpcId --output json)
subnetId=$(echo -e $subnetResponse | jq '.Subnet.SubnetId' | tr -d '"' )
echo "Created Subnet " $subnetId
#Name the subnet
echo "Naming the subnet"
awsresponse=$(aws ec2 create-tags --resources $subnetId --tags Key=Name,Value="$subnetName" )
echo $awsresponse
#Enable public ip on subnet
echo "Enable public ip on subnet"
awsresponse=$(aws ec2 modify-subnet-attribute --subnet-id $subnetId --map-public-ip-on-launch)

#Create security group for vpc
echo "Create security group for vpc"
securityGroupResponse=$(aws ec2 create-security-group --group-name $securityGroupName \
  --description "Private: $securityGroupName" \
  --vpc-id $vpcId --output json)
securityGroupId=$(echo -e $securityGroupResponse | jq '.GroupId' | tr -d '"')
echo "Created Security Group " $securityGroupId
#Name the security group
awsresponse=$(aws ec2 create-tags --resources $securityGroupId --tags Key=Name,Value="$securityGroupName")
echo $awsresponse
#enable port 22
awsresponse=$(aws ec2 authorize-security-group-ingress \
  --group-id $securityGroupId \
  --protocol tcp --port 22 \
  --cidr $port22CidrBlock )
echo $awsresponse

