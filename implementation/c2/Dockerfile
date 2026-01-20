FROM python:3.10-slim

WORKDIR /c2
COPY c2.py .

RUN pip install flask

EXPOSE 9000
CMD ["python3", "c2.py"]
