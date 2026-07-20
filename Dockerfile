#base image, using alpine for a smaller image
#TODO: Use a multi-stage build to reduce the size of the image
FROM golang:1.26.5-alpine3.24

WORKDIR /app

COPY api .

RUN go mod download


RUN go build -o main main.go

RUN adduser -D -u 10001 appuser && \
    chown -R appuser:appuser /app

USER appuser

EXPOSE 8001

CMD ["./main"]