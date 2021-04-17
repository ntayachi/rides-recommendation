from flask import Flask, render_template, request, redirect, url_for
import requests
import config
import json

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        sunday_date = request.form['sunday_date']
        return redirect(url_for('destination', date=sunday_date))
    return render_template('index.html')

@app.route('/destination/<date>')
def destination(date):
    dest = calculateDestination(date)
    return render_template('destination.html', destination=dest)

def calculateDestination(sunday_date):
    api_url = f'{config.API_BASE_URL}/current.json?key={config.API_KEY}&q=TUN'
    weather = requests.get(api_url).content
    weather_json = json.loads(weather)
    result = {
        'City': weather_json['location']['name'],
        'Wind Direction': weather_json['current']['wind_dir'],
        'Wind Speed': weather_json['current']['wind_kph'],
        'Temperature': weather_json['current']['temp_c']
    }
    return result

if __name__ == '__main__':
    app.run(debug=True)