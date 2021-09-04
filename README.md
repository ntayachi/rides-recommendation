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
docker run -d -p 5000:5000 --name rides-recomm-v1 rides-recomm
```

Go to http://localhost:5000 to test the application.

#### To stop and remove the container

```
docker container stop rides-recomm-v1

docker container rm rides-recomm-v1
```