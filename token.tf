resource "random_string" "kubeadm_token1" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "kubeadm_token2" {
  length  = 16
  special = false
  upper   = false
}
