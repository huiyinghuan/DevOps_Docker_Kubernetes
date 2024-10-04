# Use the official Golang image
FROM golang:1.23.2

WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# # Download dependencies
# RUN go mod tidy

# Copy the source code
COPY . .

# Expose the port the server runs on
EXPOSE 8080

# Command to run the Go server
CMD ["go", "run", "main.go"]
