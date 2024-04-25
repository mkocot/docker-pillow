ARG WHEELS=/wheels
ARG PACKAGE_NAME=pillow
ARG PACKAGE_VERSION=10.2.0

FROM python:3.11-bullseye as builder

ARG PACKAGE_NAME
ARG PACKAGE_VERSION
ARG WHEELS
ENV PYTHONUNBUFFERED=1
ENV LC_ALL C
ENV LANG C
ENV LANGUAGE C

RUN apt-get update && \
    apt-get install -y \
	build-essential

RUN python -m venv /venv && \
    /venv/bin/python -m pip install -U pip wheel && \
    MAKEFLAGS="-j$(nproc)" /venv/bin/python -m pip wheel \
    	--no-cache-dir --wheel-dir ${WHEELS} "${PACKAGE_NAME}==${PACKAGE_VERSION}"

FROM scratch
ARG WHEELS
COPY --from=builder ${WHEELS} ${WHEELS}
