FROM python:3.12-alpine

WORKDIR /app
ADD app /app
ADD destinations.json /app
RUN pip install -r requirements.txt

EXPOSE 5000
CMD ["python", "/app/app.py"]
