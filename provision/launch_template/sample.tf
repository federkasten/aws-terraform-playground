variable "name" {}

resource "aws_launch_template" "main" {
  name = var.name

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 10
      volume_type = "gp2"
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdcz"

    ebs {
      volume_size = 100
      volume_type = "gp2"
    }
  }

  monitoring {
    enabled = true
  }

  user_data = filebase64("${path.module}/userdata.txt")
}

output "launch_template_id" {
  value = aws_launch_template.main.id
}
