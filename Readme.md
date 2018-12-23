## Vagrant Kubernetes Quick Environment (No High Availability)

>NOTE:
For This to work without using vagrant ssh (using Kubeconfig export environment), be sure to create a virtualbox host-only interface in same segment as K8s nodes defined in config.yml).
>For example (in my configuration):
>~~~
>35: vboxnet1: <BROADCAST,MULTICAST,UP,>LOWER_UP> mtu 1500 qdisc fq_codel state >UP group default qlen 1000
>    link/ether 0a:00:27:00:00:01 brd ff:ff:ff:ff:ff:ff
>    inet 10.10.10.10/24 brd 10.10.10.255 scope global vboxnet1
>       valid_lft forever preferred_lft forever
>    inet6 fe80::800:27ff:fe00:1/64 scope link 
>       valid_lft forever preferred_lft forever
>~~~
>This allows me define in Vagrantfile:
>~~~
>      config.vm.network "private_network",
>      ip: node['mgmt_ip'],:netmask => "255.255.255.0",
>      virtualbox__intnet: false,
>      hostonlyadapter: ["vboxnet1"]
>~~~
> Where 'mgmt_ip' will be configured in config.yml 


### Usage
1. Download Repo

2. Execute make create
~~~
$ make recreate
make[1]: Entering directory '/home/zero/Labs/k8s-vagrant'
==> k8s-3: Forcing shutdown of VM...
==> k8s-3: Destroying VM and associated drives...
==> k8s-2: Forcing shutdown of VM...
==> k8s-2: Destroying VM and associated drives...
==> k8s-1: Forcing shutdown of VM...
==> k8s-1: Destroying VM and associated drives...
make[1]: Leaving directory '/home/zero/Labs/k8s-vagrant'
make[1]: Entering directory '/home/zero/Labs/k8s-vagrant'
Bringing machine 'k8s-1' up with 'virtualbox' provider...
Bringing machine 'k8s-2' up with 'virtualbox' provider...
Bringing machine 'k8s-3' up with 'virtualbox' provider...
==> k8s-1: Cloning VM...
==> k8s-1: Matching MAC address for NAT networking...
==> k8s-1: Checking if box 'frjaraur/xenial64' is up to date...
==> k8s-1: Setting the name of the VM: k8s-1
==> k8s-1: Clearing any previously set network interfaces...
==> k8s-1: Preparing network interfaces based on configuration...
    k8s-1: Adapter 1: nat
    k8s-1: Adapter 2: hostonly

...
...
... Few minutes later ...
...
...

k8s-3: [tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
    k8s-3: [patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "k8s-3" as an annotation
    k8s-3:
    k8s-3: This node has joined the cluster:
    k8s-3: * Certificate signing request was sent to master and a response
    k8s-3:   was received.
    k8s-3: * The Kubelet was informed of the new secure connection details.
    k8s-3:
    k8s-3: Run 'kubectl get nodes' on the master to see this node join the cluster.
make[1]: Leaving directory '/home/zero/Labs/k8s-vagrant'
~~~

3. Execute make export 
~~~
$ make export
export KUBECONFIG=_Wherever_you_are_/tmp_deploying_stage/kubeconfig
~~~
4. Export KUBECONFIG varable and enjoy...
~~~
$ export KUBECONFIG=/home/frjaraur/Labs/k8s-vagrant/tmp_deploying_stage/kubeconfig

$ kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
k8s-1     Ready     master    23m       v1.11.2
k8s-2     Ready     <none>    19m       v1.11.2
k8s-3     Ready     <none>    15m       v1.11.2
~~~


