# syntax=docker/dockerfile:1

# Reference Dockerfile for Go backend APIs (Gin, Echo, Fiber, stdlib net/http, etc.).
# Copy to your project root as Dockerfile and adjust MAIN_PACKAGE if needed.
#
# Default:  ./cmd/server
# Root main: ARG MAIN_PACKAGE=.
# Custom:    ARG MAIN_PACKAGE=./cmd/api

FROM golang:1.24-alpine AS builder
RUN apk add --no-cache ca-certificates git
WORKDIR /src

ARG CGO_ENABLED=0
ARG MAIN_PACKAGE=./cmd/server
ARG LDFLAGS="-s -w"

ENV CGO_ENABLED=${CGO_ENABLED}

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -ldflags="${LDFLAGS}" -o /out/server "${MAIN_PACKAGE}"

FROM alpine:3.21 AS runner
RUN apk add --no-cache ca-certificates wget
WORKDIR /app

RUN addgroup --system --gid 1001 app && \
    adduser --system --uid 1001 --ingroup app app

COPY --from=builder --chown=app:app /out/server ./server

USER app
EXPOSE 8080
ENV PORT=8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:${PORT}/health || exit 1

CMD ["./server"]
