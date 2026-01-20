FROM python:3.10-slim

WORKDIR /c2
COPY c2.py .

RUN apt-get update \
	&& apt-get install -y --no-install-recommends tcpdump \
	&& rm -rf /var/lib/apt/lists/* \
	&& pip install --no-cache-dir flask

EXPOSE 9000
CMD ["python3", "c2.py"]
