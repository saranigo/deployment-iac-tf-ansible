locals {
       env_tag = {
            Environment = "${terraform.workspace}"
}
            Jenkins_tags = "${merge(var.Jenkins_tags, local.env_tag)}"
 }

resource "aws_instance" "Jenkins" {
  count = "${var.Jenkins_ec2_count}"
  ami           = "${var.jenkins_web_amis[var.region]}"
  instance_type = "${var.Jenkins_instance_type}"
  subnet_id = "${local.pub_sub_ids[count.index]}"
  tags = "${local.Jenkins_tags}"
  
}
