# Example

In this example we deploy the NGINX or NGINX Plus Ingress controller, a simple web application and then configure load balancing for that application using the Ingress resource.

## Running the Example

## 1. Deploy the Ingress Controller

1. Follow the installation instructions to deploy the Ingress controller with Helm on [helm-chart directory] (../../helm-chart).
	
  1. Create 'tiller' account to deploy helm ingress package
~~~	
	$ kubectl create -f tiller-account.yml
~~~	
  2. Initiate Helm configuration
~~~
	$ helm init --service-account tiller
~~~
  3. Install ingress helm package
~~~
	$ helm install --name codegazers .
~~~
2. Save the public IP address and HTTP port of the Ingress controller into a shell variable:
~~~
    $ export IC_IP=XXX.YYY.ZZZ.III
    $ export IC_HTTP_PORT=KKKK
~~~ 

## 2. Deploy the Colors Application

Create the blue and red colors deployments and services:
~~~
$ kubectl create -f colors.yml
~~~

## 3. Configure Load Balancing

1. Create an Ingress resource:
~~~
    $ kubectl create -f colors-ingress.yml
~~~

## 4. Test the Application

1. To access the application, curl the blue and red services using -H option.
    
    1. To get blue application:
    ~~~
    $ curl --resolve blue.example.com:$IC_HTTP_PORT:$IC_IP http://blue.example.com:$IC_HTTP_PORT
    ~~~
    or
    ~~~
    $ curl -H 'Host: blue.example.com' http://$IC_IP:$IC_HTTP_PORT
    ~~~
    2. To get red application:
    ~~~
    $ curl --resolve red.example.com:$IC_HTTP_PORT:$IC_IP http://red.example.com:$IC_HTTP_PORT
    ~~~
    or
    ~~~
    $ curl -H 'Host: blue.example.com' http://$IC_IP:$IC_HTTP_PORT
    ~~~
