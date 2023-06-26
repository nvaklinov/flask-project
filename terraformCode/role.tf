resource "aws_iam_role" "rolej" {
  name               = "eks-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::884249961762:root"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "profilrole" {
  name = "rolejprofile"
  role = aws_iam_role.rolej.name
}