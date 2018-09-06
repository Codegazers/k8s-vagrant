
## We are Using Minikube for a Quick Demo

### We deploy complete NGINX Plus Ingress Controller with a full deployment file
~~~
https://raw.githubusercontent.com/Codegazers/k8s-vagrant/master/demo/nginx-plus-ingress_full-deployment.yml | kubectl apply -f -
~~~

### We have created 'nginx-ingress' namespace so we will wait until all Kong components are ready.
~~~
kubectl get all --namespace nginx-ingress
~~~
### We deploy now two deployments with their services (red-app and blue-app with red-svc and blue-svc) 
~~~
curl https://raw.githubusercontent.com/Codegazers/k8s-vagrant/master/examples/colors/colors.yml | kubectl create -f -
~~~

### We review the deployments
~~~
kubectl get all --namespace default
~~~

### For quick access we prepare some envirnment variables
~~~


export INGRESS_IP=$(minikube   service -n nginx-ingress nginx-ingress --url --format "{{ .IP }}" | head -1)

export INGRESS_HTTP_PORT=$(minikube   service -n nginx-ingress nginx-ingress --url --format "{{ .Port }}" | head -1)

export INGRESS_HTTPS_PORT=$(minikube   service -n nginx-ingress nginx-ingress --url --format "{{ .Port }}" | tail -1)

~~~

### Now we deploy colors-ingress ingress resource for accesing both applications
~~~
curl https://raw.githubusercontent.com/Codegazers/k8s-vagrant/master/examples/colors/colors-ingress.yml | kubectl create -f -
~~~

### We just set up host routing
~~~
kubectl get ingress colors-ingress -o yaml
~~~

### And now we can access our applications setting host headers
~~~
http ${INGRESS_IP}:${INGRESS_HTTP_PORT}/text Host:red.example.com

http ${INGRESS_IP}:${INGRESS_HTTP_PORT}/text Host:blue.example.com
~~~

### We review backends because red-app has 3 replicas
~~~
ab -n 10000 -v 2 -k  -H "host: red.example.com" ${INGRESS_IP}:${INGRESS_HTTP_PORT}/text
~~~

### We will deploy now ingress resource with active health checks

kubectl delete ingress colors-ingress

curl https://raw.githubusercontent.com/Codegazers/k8s-vagrant/master/examples/colors/colors-ingress.yml | kubectl apply -f -


~~~

