FROM python:3.8-alpine

WORKDIR /app
ADD src /app
RUN pip install -r requirements.txt

EXPOSE 5000
CMD ["python", "/app/app.py"]