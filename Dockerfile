# Use python as base image
FROM pytorch/pytorch  as base


# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # Set work directory
WORKDIR /app

# # Install Python 3.12 and other system dependencies
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#     software-properties-common \
#     build-essential \
#     libpq-dev \
#     git && \
#     add-apt-repository ppa:deadsnakes/ppa && \
#     apt-get install -y python3.12 python3.12-venv python3.12-dev && \
#     python3.12 -m ensurepip && \
#     python3.12 -m pip install six && \
#     rm -rf /var/lib/apt/lists/*

FROM base AS poetry

# # Install Poetry
RUN python -m pip install --upgrade pip && python3 -m pip install poetry

# Copy only requirements to cache them in docker layer
COPY poetry.lock pyproject.toml README.md /app/

# Project initialization
# RUN poetry config virtualenvs.create false 
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

FROM poetry as prod

COPY . ./