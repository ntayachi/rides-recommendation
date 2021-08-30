# Rides Recommendation

This project is to recommend Sunday ride destinations for cyclists based on the wind.

## Steps

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

**NOTE**

You should enter the following date format in the 'Sunday date' input field: YYYY-MM-DD.