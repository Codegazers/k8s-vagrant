### DEMO:


#### 1. Deploy Kong
~~~
$ demo/kong-ingress$ kubectl apply -f kong-ingress-all-in-one-postgres.yaml
namespace/kong created
customresourcedefinition.apiextensions.k8s.io/kongplugins.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongconsumers.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongcredentials.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongingresses.configuration.konghq.com created
service/postgres created
deployment.extensions/postgres created
serviceaccount/kong-serviceaccount created
clusterrole.rbac.authorization.k8s.io/kong-ingress-clusterrole created
role.rbac.authorization.k8s.io/kong-ingress-role created
rolebinding.rbac.authorization.k8s.io/kong-ingress-role-nisa-binding created
clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-clusterrole-nisa-binding created
service/kong-ingress-controller created
deployment.extensions/kong-ingress-controller created
service/kong-proxy created
deployment.extensions/kong created
~~~


##### __Red Demo__

~~~
$ echo "
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: red-ingress
spec:
  rules:
  - host: red.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: red-svc
          servicePort: 80
" | kubectl create -f -


$ kubectl patch ingress red-ingress \
  -p '{"metadata":{"annotations":{"rate-limiting.plugin.konghq.com":"add-ratelimiting-to-route\n"}}}'



$ kubectl get ingress red-ingress -o yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    rate-limiting.plugin.konghq.com: |
      add-ratelimiting-to-route
  creationTimestamp: 2018-09-05T17:38:58Z
  generation: 1
  name: red-ingress
  namespace: default
  resourceVersion: "7651"
  selfLink: /apis/extensions/v1beta1/namespaces/default/ingresses/red-ingress
  uid: 91e95985-b132-11e8-8ee0-080027f4233a
spec:
  rules:
  - host: red.example.com
    http:
      paths:
      - backend:
          serviceName: red-svc
          servicePort: 80
        path: /
status:
  loadBalancer:
    ingress:
    - ip: 10.0.2.15

$ kubectl get ingress red-ingress -o yaml

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    rate-limiting.plugin.konghq.com: |
      add-ratelimiting-to-route
  creationTimestamp: 2018-09-05T17:38:58Z
  generation: 1
  name: red-ingress
  namespace: default
  resourceVersion: "7651"
  selfLink: /apis/extensions/v1beta1/namespaces/default/ingresses/red-ingress
  uid: 91e95985-b132-11e8-8ee0-080027f4233a
spec:
  rules:
  - host: red.example.com
    http:
      paths:
      - backend:
          serviceName: red-svc
          servicePort: 80
        path: /
status:
  loadBalancer:
    ingress:
    - ip: 10.0.2.15





$ curl -vvv ${PROXY_IP}:${HTTP_PORT}/text -H "Host: red.example.com"
*   Trying 192.168.99.100...
* Connected to 192.168.99.100 (192.168.99.100) port 31949 (#0)
> GET /text HTTP/1.1
> Host: red.example.com
> User-Agent: curl/7.47.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< Content-Type: text/plain; charset=UTF-8
< Transfer-Encoding: chunked
< Connection: keep-alive
< X-RateLimit-Limit-hour: 100
< X-RateLimit-Remaining-hour: 99
< X-RateLimit-Limit-second: 10
< X-RateLimit-Remaining-second: 9
< Date: Wed, 05 Sep 2018 17:41:14 GMT
< X-Kong-Upstream-Latency: 3
< X-Kong-Proxy-Latency: 9
< Via: kong/0.13.1
< 
APP_VERSION: 1.0
COLOR: red
CONTAINER_NAME: red-app-5d4f94678c-8f4h6
CONTAINER_IP: 172.17.0.12
~~~

---

#### __COLORS__

~~~
$ echo "
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: colors-ingress
spec:
  rules:
  - host: red.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: red-svc
          servicePort: 80
  - host: blue.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: blue-svc
          servicePort: 80
" | kubectl create -f -

$ kubectl patch ingress colors-ingress   -p '{"metadata":{"annotations":{"rate-limiting.plugin.konghq.com":"add-ratelimiting-to-route\n"}}}'

$ curl -vvv ${PROXY_IP}:${HTTP_PORT}/text -H "Host: red.example.com"
  
$ curl -vvv ${PROXY_IP}:${HTTP_PORT}/text -H "Host: blue.example.com"

$ curl -vvv ${PROXY_IP}:${HTTP_PORT}/text -H "Host: red.example.com"


$ kubectl logs -n kong kong-ingress-controller-69fdbc99f5-llcb9

$ kubectl logs -n kong kong-ingress-controller-69fdbc99f5-llcb9 ingress-controller

$ kubectl logs -n kong --selector="app=ingress-kong" -c ingress-controller

$ http ${KONG_ADMIN_IP}:${KONG_ADMIN_PORT}/upstreams/default.red-svc.3000/targets

$ http ${KONG_ADMIN_IP}:${KONG_ADMIN_PORT}/upstreams/default.http-svc.80/targets

$ http ${KONG_ADMIN_IP}:${KONG_ADMIN_PORT}/upstreams/default.http-svc.80/


$ http ${KONG_ADMIN_IP}:${KONG_ADMIN_PORT}/plugins

$ kubectl delete ingress

$ kubectl delete ingress --all
