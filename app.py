from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        sunday_date = request.form['sunday_date']
        dest = calculateDestination(sunday_date)
        return redirect(url_for('destination', destination=dest))
    return render_template('index.html')

@app.route('/destination/<string:destination>')
def destination(destination):
    return render_template('destination.html', destination=destination)

def calculateDestination(sunday_date):
    return 'Tunis'

if __name__ == '__main__':
    app.run(debug=True)