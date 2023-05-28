output "public_ip" {
  value = length(aws_spot_instance_request.this) > 0 ? aws_spot_instance_request.this[*].public_ip : aws_instance.this[*].public_ip
}
output "private_ip" {
  value = length(aws_spot_instance_request.this) > 0 ? aws_spot_instance_request.this[*].private_ip : aws_instance.this[*].private_ip
}
