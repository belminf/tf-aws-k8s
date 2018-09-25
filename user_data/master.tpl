
packages:
  - docker.io
  - apt-transport-https
  - curl

package_upgrade: true

runcmd:
  - curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  - echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  - apt-get update
  - apt-get install -y kubelet kubeadm kubectl
  - apt-mark hold kubelet kubeadm kubectl
  - systemctl daemon-reload
  - systemctl enable docker kubelet
  - systemctl start docker
  - kubeadm init --token=${kubeadm_token}
  - kubectl apply -f https://git.io/weave-kube

output:
    init: "/var/log/cloud-init.log"
    config: "/var/log/cloud-config.log"
    final:
        - "/var/log/cloud-final.out"
        - "/var/log/cloud-final.err"

final_message: "The system is finally up, after $UPTIME seconds"
