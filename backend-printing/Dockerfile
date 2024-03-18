# Use an official Python runtime as the base image
FROM mcr.microsoft.com/azure-functions/python:4-python3.10

RUN apt-get update \
    && apt-get install -y iputils-ping \
    && apt-get clean
# Set the working directory in the container
COPY . /home/site/wwwroot

# Install Python dependencies
RUN cd /home/site/wwwroot && pip install --no-cache-dir -r requirements.txt

# RUN python -m compileall /app/helper
