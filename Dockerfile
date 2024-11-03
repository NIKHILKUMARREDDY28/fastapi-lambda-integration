FROM python:3.11.3-slim-bullseye

# Set the working directory in the container
WORKDIR /app
RUN echo "Working directory at the start of the build:" && pwd

# Copy the dependencies files to the working directory
COPY pyproject.toml poetry.lock* ./

# Install Poetry using pip
RUN pip install poetry

# Add Poetry to PATH
ENV PATH="/root/.local/bin:$PATH"

# Install dependencies using Poetry
RUN poetry install --no-root --no-interaction --no-ansi
RUN echo "Dependencies installed."

# Copy the rest of the application code
COPY . .

RUN echo "Application code copied."
RUN echo "Listing files:" && ls

EXPOSE 8000

# Specify the entry point to run the application
CMD ["poetry", "run", "python", "main.py"]
