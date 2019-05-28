# k8s_Install-Ansible

# This code will build a node to the point it is ready for kubeadm init, which initilizes a K8s cluster.
* This command will prepare the cluster to be deployed using Flannel as the network backend.
    - kubeadm init --pod-network-cidr=10.244.0.0/16
* After the cluster initilizes, follow the the directions on the screen to setup your workstation to interact
with the cluster.
* When
  - `kubectl config view`
* and
  - `kubectl get nodes`
*  both work, you are ready to install the flannel network drivers with the following command.
  - ```kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml```
* `kubectl get pods --all-namespaces` should produce an output showing everything running, including flannel

*```NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
kube-system   coredns-fb8b8dccf-ddrdf                       1/1     Running   0          70m
kube-system   coredns-fb8b8dccf-j8snv                       1/1     Running   0          70m
kube-system   etcd-gre-k8s-0.novalocal                      1/1     Running   0          69m
kube-system   kube-apiserver-gre-k8s-0.novalocal            1/1     Running   0          69m
kube-system   kube-controller-manager-gre-k8s-0.novalocal   1/1     Running   0          69m
kube-system   kube-flannel-ds-amd64-d98bx                   1/1     Running   0          69m
kube-system   kube-flannel-ds-amd64-df2j8                   1/1     Running   0          67m
kube-system   kube-flannel-ds-amd64-jblln                   1/1     Running   0          66m
kube-system   kube-flannel-ds-amd64-p52cq                   1/1     Running   0          65m
kube-system   kube-proxy-25z9k                              1/1     Running   0          70m
kube-system   kube-proxy-2klqx                              1/1     Running   0          66m
kube-system   kube-proxy-kwrvf                              1/1     Running   0          65m
kube-system   kube-proxy-zqvmr                              1/1     Running   0          67m
kube-system   kube-scheduler-gre-k8s-0.novalocal            1/1     Running   0          69m```*


* at this point you have built a functional cluster, and you are ready to add worker nodes to the environment.

```kubeadm token create --print-join-command``` - Will create a connection command to run on worker nodes.

# The cluster is ready for users to deploy applications now.



# Note
This will need to be in the .ssh directory of the awx/ansible host to prevent host key checking.
[root@gre-chef-lab-awx1 .ssh]# cat config 
# for all hosts
Host *
    StrictHostKeyChecking no
