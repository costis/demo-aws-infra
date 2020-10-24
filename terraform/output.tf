output bastion_ip {
  value = aws_eip.bastion.public_ip
}

output web_a_ip {
  value = aws_instance.web_a.private_ip
}

output web_b_ip {
  value = aws_instance.web_b.private_ip
}

output alb_dns {
  value = aws_lb.alb.dns_name
}

output rds_ip {
  value = aws_db_instance.default.address
}

# the ansible inventory file
resource "local_file" ansible-inventory {
  content = templatefile("ansible_inventory.tmpl",
    {
      bastion-ip = aws_eip.bastion.public_ip,
      web_a-ip   = aws_instance.web_a.private_ip,
      web_b-ip   = aws_instance.web_b.private_ip
    }
  )
  filename = "../ansible/inventory"
}

# jump host 
resource "local_file" jump-host {
  content = templatefile("ansible_jumphost.tmpl",
    {
      jump_host         = aws_eip.bastion.public_ip,
      db_ip             = aws_db_instance.default.address,
      db_admin_username = var.db_username,
      db_admin_password = var.db_password

    }
  )
  filename = "../ansible/vars/jumphost.yml"
}

