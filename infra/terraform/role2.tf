resource "aws_iam_role" "role2" {
  name               = "eks-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "AWS": "arn:aws:iam::058302395964:root"
     },
     "Effect": "Allow" 
   }
 ]
}
EOF
}

#data "aws_iam_policy" "admin_access" {
#  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#}

#resource "aws_iam_role_policy_attachment" "admin-role-policy-attach" {
#  role       = aws_iam_role.role2.name
#  policy_arn = data.aws_iam_policy.admin_access.arn
#}

resource "aws_iam_instance_profile" "profile2" {
  name = "${local.name}-profile2"
  role = aws_iam_role.role2.name
}
