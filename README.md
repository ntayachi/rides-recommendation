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
docker build -f docker/Dockerfile -t rides-recomm:latest .
```

Make sure that the image was built

```
docker image ls
```

### Run the app in a Docker container

```
docker run -d -p 5000:5000 --name rides-recomm-v1 rides-recomm:latest
```

Go to http://localhost:5000 to access the application.

#### To stop and remove the container

```
docker container stop rides-recomm-v1

docker container rm rides-recomm-v1
```

## Steps to run in Kubernetes

We will deploy the application in a local Kubernetes cluster using minikube.

### minikube steps

#### Install minikube

Follow these steps to install minikube: [https://minikube.sigs.k8s.io/docs/start/]

#### Start minikube

```
minikube start
```

#### Configure the environment to use minikube’s Docker daemon

```
eval $(minikube docker-env)
```

### Build the Docker image

```
docker build -f docker/Dockerfile -t rides-recomm:latest .
```

### Create Kubernetes deployment

```
kubectl apply -f kubernetes/deployment.yml
```

Make sure there are pods running the application.

```
kubectl get pods
```

### Expose the LoadBalancer

As of now, we created a service of type **LoadBalancer** which has no external IP assgined.

#### Display the Service

```
kubectl get svc -l app=rides-recomm
```

You should see something similar to this:

```
$ kubectl get svc -l app=rides-recomm
NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
rides-recomm-service   LoadBalancer   10.102.182.68   <pending>     5000:31432/TCP   3d21h
```

Notice that the **EXTERNAL-IP** field is in **pending** state.

#### Run tunnel in another terminal

To assign an IP to the service, execute the following command in a separate terminal.

```
minikube tunnel
```

If you display the service again you will see that an IP was assigned to it.

```
$ kubectl get svc -l app=rides-recomm
NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
rides-recomm-service   LoadBalancer   10.102.182.68   10.102.182.68   5000:31432/TCP   3d21h
```

Go to `http://${EXTERNAL-IP}:5000` to access the application.

#### Delete the deployment

Once you are done with the application, you can delete the resources using the following command:

```
kubectl delete -f kubernetes/deployment.yml
```