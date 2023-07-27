# Create IAM role
resource "aws_iam_role" "role" {
  name               = "ec2-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": "examplerole"
   }
 ]
}
EOF
}

# Use IAM policy from data source
data "aws_iam_policy" "admin_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "admin-role-policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.admin_access.arn
}

# Create instance profile using role
resource "aws_iam_instance_profile" "profile" {
  name = "ec2-iam-profile"
  role = aws_iam_role.role.name
}