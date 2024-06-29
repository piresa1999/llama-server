FROM python:3.12 as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Download a llamafile from HuggingFace
RUN wget https://huggingface.co/jartine/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/TinyLlama-1.1B-Chat-v1.0.Q5_K_M.llamafile

# Make the file executable. On Windows, instead just rename the file to end in ".exe".
RUN chmod +x TinyLlama-1.1B-Chat-v1.0.Q5_K_M.llamafile


FROM base AS poetry

# Install Poetry
RUN pip install --upgrade pip && pip install poetry

# Copy only requirements to cache them in docker layer
COPY poetry.lock pyproject.toml ./

# Project initialization
# RUN poetry config virtualenvs.create false 
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Start the model server. Listens at http://localhost:8080 by default.
# RUN ./TinyLlama-1.1B-Chat-v1.0.Q5_K_M.llamafile --server --nobrowser