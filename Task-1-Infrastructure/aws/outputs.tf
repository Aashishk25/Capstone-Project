output "aws_app_ip" {
  value = aws_instance.app.public_ip
}

output "aws_tools_ip" {
  value = aws_instance.tools.public_ip
}
