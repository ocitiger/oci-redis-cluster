output "Redis-IP" {
  value = data.oci_core_vnic.redis_vnic.public_ip_address
}
