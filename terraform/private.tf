#Create Private Key Pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Create AWS Key (supply just public key you just created)
resource "aws_key_pair" "ssh" {
  key_name   = var.project
  public_key = tls_private_key.ssh.public_key_openssh
}

#Write the private key in users .ssh dir
resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/${var.project}.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.ssh.private_key_pem
}