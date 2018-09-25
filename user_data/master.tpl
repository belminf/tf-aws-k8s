
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
  - kubeadm init --token="${kubeadm_token}" --pod-network-cidr="10.244.0.0/16"
  - mkdir -p /home/ubuntu/.kube
  - cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
  - chown ubuntu:ubuntu /home/ubuntu/.kube/config
  - sudo -u ubuntu kubectl get nodes
  - sudo -u ubuntu kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
  - sudo -u ubuntu kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/canal.yaml

output:
    init: "/var/log/cloud-init.log"
    config: "/var/log/cloud-config.log"
    final:
        - "/var/log/cloud-final.out"
        - "/var/log/cloud-final.err"

final_message: "The system is finally up, after $UPTIME seconds"
