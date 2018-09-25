resource "random_string" "kubeadm_token" {
  length = 32
  special = true
}
