# Rides Recommendation

This project is to recommend Sunday ride destinations for cyclists based on the wind.

**NOTE**

You should enter the following date format in the 'Sunday date' input field: YYYY-MM-DD.

## Steps to run locally

### Create virtual environment

```
python3 -m venv venv
```

### Activate the virtual environment

```
source venv/bin/activate
```

### Install dependencies

```
pip install -r requirements.txt
```

### Create config.py file

```
vi config.py

API_BASE_URL = 'http://api.weatherapi.com/v1'
API_KEY = '********************'
```

### Start the app on web development server

```
python app.py
```

## Steps to run in Docker

### Build the Docker image

```
docker build -f docker/Dockerfile -t rides-rec:latest .
```

Make sure that the image was built

```
docker image ls
```

### Run the app in a Docker container

```
docker run -d -p 5000:5000 --name rides-rec-v1 rides-rec:latest
```

Go to http://localhost:5000 to access the application.

#### To stop and remove the container

```
docker container stop rides-rec-v1

docker container rm rides-rec-v1
```

## Steps to run in Kubernetes

We will deploy the application in a local Kubernetes cluster using minikube.

### minikube steps

#### Install minikube

Follow these steps to install [minikube](https://minikube.sigs.k8s.io/docs/start/)

#### Start minikube

```
minikube start
```

#### Configure the environment to use minikube’s Docker daemon

```
eval $(minikube docker-env)
```

#### Enable the Nginx ingress controller

```
minikube addons enable ingress
```

To verify that the Nginx ingress controller is running

```
kubectl get pods -n ingress-nginx
```

You should see something like this:

```
$ kubectl get pods -n ingress-nginx
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-qntq5        0/1     Completed   0          6d23h
ingress-nginx-admission-patch-5q5r9         0/1     Completed   0          6d23h
ingress-nginx-controller-59b45fb494-jxdv4   1/1     Running     2          6d23h
```

### Build the Docker image

```
docker build -f docker/Dockerfile -t rides-rec:latest .
```

### Create Kubernetes resources

The `kubernetes` folder contains YAML files to create deployment for the python application and other resources for the EFK logging stack (Elasticsearch, Fluentd and Kibana).

The resources will be deployed in two different namespaces: `cycling` and `logging`. This is the command:

```
kubectl apply -f kubernetes/
```

Make sure there are pods running the application.

```
kubectl get pods -n cycling
```

Verify that the service was created and is available.

```
kubectl get svc -n cycling -l app=rides-rec
```

### Get the URL of the service

```
minikube service rides-rec-svc -n cycling --url
```

Example:

```
$ minikube service rides-rec-svc -n cycling --url
http://192.168.49.2:30971
```

Go to `http://${IP}:${PORT}` to access the application.

Where `${IP}` and `${PORT}` are respectively the IP and port from the previous command output.

If you want to test the application using one command:

```
curl $(minikube service rides-rec-svc -n cycling --url)
```

### Access the Kibana UI

To access the Kibana UI you need first to forward its pod port number *5601* using this command:

```
kubectl port-forward ${KIBANA_POD_NAME} -n logging 5601:5601
```

Example:

```
$ kubectl port-forward -n logging kibana-dpl-5fd44bf458-w24fm 5601:5601
Forwarding from 127.0.0.1:5601 -> 5601
Forwarding from [::1]:5601 -> 5601
```

If you're lazy ( like me ), use this single command to fetch the *Kibana* pod name and forward the port at the same time:

```
kubectl port-forward $(kubectl get pods -n logging -l app=kibana -o json | jq -r '.items[].metadata.name') -n logging 5601:5601
```

The Kibana UI is now running on **http://localhost:5601**.

### Create an Index Pattern

1. Click Management from the left menu ( [link](http://localhost:5601/app/kibana#/management) )

2. Click on **Index Patterns** under Kibana from the left menu

3. Click on **Create index pattern**

4. Enter `logstash-*` as the **Index pattern** and click on **Next step**

5. Select `@timestamp` as the **Time Filter field name** and click on **Create index pattern**

### View the kubernetes logs

1. Go to the Discover menu from the left ( [link](http://localhost:5601/app/kibana#/discover) )

2. On the **KQL** search bar, enter the following query to view the python application logs:

```
kubernetes.labels.app : "rides-rec"
```

### Delete the resources

Once you are done with the application, you can delete the resources using the following command:

```
kubectl delete -f kubernetes/
```