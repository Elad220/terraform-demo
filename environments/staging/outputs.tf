output "compute_instance_id" {
  value = module.compute.instance_id
}

output "compute_public_ip" {
  value = module.compute.public_ip
}

output "vpc_id" {
  value = var.enable_vpc ? module.vpc[0].vpc_id : null
}
