FROM php:8.1-cli

# Install curl
RUN apt-get update && apt-get install -y curl

# Set working directory
WORKDIR /app

# Copy your PHP app into the container
COPY index.php .

# Optional: Default command
CMD ["php", "index.php"]
