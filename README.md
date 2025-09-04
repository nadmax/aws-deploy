# aws-deploy

This template creates AWS VPC and subnet resources, including both custom VPC/subnet and a subnet in the default VPC.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.12.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions to create VPC and subnet resources

## Resources Created

This template creates the following AWS resources:

1. **Custom VPC** (`aws_vpc.dev-vpc`)
   - Configurable CIDR block via variables
   - Custom naming via tags

2. **Custom Subnet** (`aws_subnet.dev-subnet-1`)
   - Created within the custom VPC
   - Deployed in `eu-west-3a` availability zone
   - Configurable CIDR block via variables

3. **Default VPC Subnet** (`aws_subnet.dev-subnet-2`)
   - Created within the existing default VPC
   - Uses hardcoded CIDR block `172.31.48.0/20`
   - Deployed in `eu-west-3a` availability zone

## Usage

### 1. Configure Variables

Edit `terraform.tfvars` file with your desired values:

```hcl
vpc_cidr_block = "10.0.0.0/16"
environment    = "development"

cidr_blocks = [
  {
    cidr_block = "10.0.0.0/16"
    name       = "dev-vpc"
  },
  {
    cidr_block = "10.0.1.0/24" 
    name       = "dev-subnet-1"
  }
]
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan the Deployment

```bash
terraform plan
```

### 4. Apply the Configuration

```bash
terraform apply
```

### 5. Destroy Resources (when needed)

```bash
terraform destroy
```

## Variables

| Variable | Type | Description | Default | Required |
|----------|------|-------------|---------|----------|
| `vpc_cidr_block` | string | CIDR block for the VPC | - | Yes |
| `environment` | string | Deployment environment | - | Yes |
| `cidr_blocks` | list(object) | List of CIDR blocks and names for VPC and subnets | - | Yes |
| `subnet_cidr_block` | string | Default subnet CIDR block | `10.0.10.0/24` | No |

### cidr_blocks Object Structure

The `cidr_blocks` variable expects a list of objects with the following structure:

```hcl
cidr_blocks = [
  {
    cidr_block = "string"  # CIDR block (e.g., "10.0.0.0/16")
    name       = "string"  # Resource name tag
  }
]
```

**Note**: The first object in the list is used for the VPC, and the second object is used for the first subnet.

## Outputs

| Output | Description |
|--------|-------------|
| `dev-vpc-id` | ID of the created VPC |
| `dev-subnet-id` | ID of the first subnet in the custom VPC |

## AWS Provider Configuration

The template uses:

- AWS Provider version: `6.11.0`
- No specific region configuration (uses default from AWS CLI/environment)

## Important Notes

1. **Region**: The subnets are hardcoded to deploy in `eu-west-3a`. Modify the `availability_zone` in `resources.tf` if you need a different AZ.

2. **Default VPC**: The template assumes a default VPC exists in your AWS account. If you've deleted the default VPC, the `aws_subnet.dev-subnet-2` resource will fail.

3. **CIDR Planning**: Ensure your CIDR blocks don't overlap and follow AWS VPC requirements:
   - VPC CIDR can be between /16 and /28
   - Subnet CIDR must be a subset of the VPC CIDR
   - Subnet CIDR can be between /16 and /28

## Example Usage

```bash
# Clone or download the template files
# Create terraform.tfvars file with your values
# Initialize and apply

terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Troubleshooting

- **Authentication Issues**: Ensure AWS credentials are configured via AWS CLI, environment variables, or IAM roles
- **Permission Errors**: Verify your AWS user/role has permissions for EC2 VPC operations
- **CIDR Conflicts**: Check that your CIDR blocks don't conflict with existing VPCs or subnets
- **Availability Zone**: If `eu-west-3a` is not available in your region, update the AZ in `resources.tf`
