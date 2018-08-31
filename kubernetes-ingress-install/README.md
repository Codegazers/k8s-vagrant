
### Deploy Ingress Controller 
~~~
$ kubectl apply -f common/ns-and-sa.yaml
$ kubectl apply -f common/default-server-secret.yaml
$ kubectl apply -f common/nginx-config.yaml
$ kubectl apply -f rbac/rbac.yaml
$ kubectl apply -f deployment/nginx-plus-ingress.yaml
$ kubectl create -f service/nodeport.yaml
~~~

~~~
$ kubectl get pods --namespace=nginx-ingress
~~~

### Enable port forwarding to local port

~~~
$ kubectl port-forward nginx-ingress-6f98b7df6-4nk5f 8080:8080 --namespace=nginx-ingress
~~~

### We can review Ingress Controller configuration

~~~
$ kubectl --namespace=nginx-ingress exec -it nginx-ingress-6f98b7df6-4nk5f -- ls -l /etc/nginx/nginx.d
~~~

### Dashboard:
From local node (Labs Host) forward locally host port 8080 to lab host with port forwarding to access Dashboard:

~~~
ssh -L 127.0.0.1:8080:127.0.0.1:8080 vagrant@10.10.10.11
~~~

curl -vvvv 0.0.0.0:31325/text -H "Host: red.example.com"
curl -vvvv 0.0.0.0:31325/text -H "Host: blue.example.com"
