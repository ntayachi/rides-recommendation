from flask import Flask, render_template, request, redirect, url_for
import requests
import config
import json

app = Flask(__name__)


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        sunday_date = request.form["sunday_date"]
        return redirect(url_for("destination", date=sunday_date))
    return render_template("index.html")


@app.route("/destination/<date>")
def destination(date):
    dest = calculateDestination(date)
    return render_template("destination.html", destination=dest)


def calculateDestination(sunday_date):
    api_url = (
        f"{config.API_BASE_URL}/forecast.json?key={config.API_KEY}&q=TUN&days=3&hour=6"
    )
    api_response = requests.get(api_url).content
    weather = json.loads(api_response)
    days_forecast = weather["forecast"]["forecastday"]
    target_day_weather = [day for day in days_forecast if day["date"] == sunday_date][0]
    weather_conditions = {
        "City": weather["location"]["name"],
        "Wind Direction": target_day_weather["hour"][0]["wind_dir"],
        "Wind Speed": target_day_weather["hour"][0]["wind_kph"],
        "Temperature": target_day_weather["hour"][0]["temp_c"],
    }
    destination = []
    with open("destinations.json", "r") as inputFile:
        destinations = json.load(inputFile)
    for dest in destinations:
        if dest["wind"] in target_day_weather["hour"][0]["wind_dir"]:
            destination += dest["city"]
    result = {**weather_conditions, **{"Destinations": destination}}
    return result


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
