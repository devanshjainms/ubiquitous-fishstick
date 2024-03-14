# Use an official Python runtime as the base image
FROM python:3.10-slim

RUN apt-get update \
    && apt-get install -y iputils-ping \
    && apt-get clean
# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the working directory
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Python program to the working directory
COPY /helper /app/helper

RUN python -m compileall /app/helper
