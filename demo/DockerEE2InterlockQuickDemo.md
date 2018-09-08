
## We are Using Docker EE2 UCP Interlock

###
# We download our bundle

~~~
docker run --rm --name ucptools  -v $(pwd):/OUTDIR hopla/ucptools \
-i <MY_LOCAL_USERID>:<MY_LOCAL_GROUPID> -u <UCP_USERNAME> -p <UCP_PASSWORD> -n <UCP_URL_WITH_PORT>
~~~

# Then we load ucp environment
~~~
cd bundle-admin

source env.sh
~~~

# And deploy our 2 services stack directly on our ucp cluster (logged as <UCP_USERNAME>)
~~~
curl https://raw.githubusercontent.com/Codegazers/k8s-vagrant/master/demo/colors-interlock.yml | docker stack deploy colors -c -
~~~

# We add some variables for quick access
~~~
export INTERLOCK_IP=ucp.hoplasoftware.com

export INTERLOCK_HTTP_PORT=10080
~~~

# We can access our proxied services through interlock proxy
~~~
http ${INTERLOCK_IP}:${INTERLOCK_HTTP_PORT}/text Host:blue.example.com

http ${INTERLOCK_IP}:${INTERLOCK_HTTP_PORT}/text Host:red.example.com
~~~