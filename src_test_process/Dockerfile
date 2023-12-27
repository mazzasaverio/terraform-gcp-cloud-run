# Use an official Python runtime as a parent image
FROM python:3.10-slim as builder

# Set the working directory in the container
WORKDIR /app

# Install system dependencies for OpenCV and other required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1-mesa-dev libglib2.0-0

# Copy only the requirements file, to improve build caching
COPY requirements.txt .

# Install required Python packages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Second stage to create a smaller image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy installed python packages from builder stage
COPY --from=builder /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the current directory contents into the container at /app
COPY . /app

# Optionally copy certificates if present
COPY ./certs /app/certs

# Run the web service on container startup
CMD exec uvicorn main:app --host 0.0.0.0 --port ${PORT:-8080}
