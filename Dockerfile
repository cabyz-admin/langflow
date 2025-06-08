# Dockerfile for LangFlow v1.x+
FROM python:3.10-slim

# Set environment
ENV LANGFLOW_PORT=7860 \
    LANGFLOW_ENV=production \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Install OS deps
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - --preview
ENV PATH="/root/.local/bin:$PATH"

# Copy project files
COPY . /app

# Install Python deps with Poetry
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi --only main

# Expose LangFlow port
EXPOSE 7860

CMD ["poetry", "run", "langflow", "run", "--host", "0.0.0.0", "--port", "7860"]
