FROM python:latest
WORKDIR /usr/src/app
COPY ..
CMD ["python3", "app.py"]

