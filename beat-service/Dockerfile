FROM python:3.9
WORKDIR /app
RUN apt-get update && apt-get install -y libxml2-dev libxslt1-dev zlib1g-dev
RUN pip install --upgrade pip

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

CMD ["python", "main.py"]