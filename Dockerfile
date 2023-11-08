### Build Stage ###
FROM golang:1.21.1-alpine3.18 AS BUILD

### LABEL INSTRUCTION (hanya metadata) ###
LABEL authors="eep"
LABEL company="PT Mekar Investama Sampoerna" reachMe="https://github.com/EchoEdyP"

# Set the working directory inside the container
WORKDIR /go/src/app

# Copy the Go modules manifests
COPY go.mod ./

### Copy the source code into the container (build stage) ###
COPY . .

### RUN INSTRUCTION (Build Stage) ###
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o repayment-utility-service ./main.go

### Production Stage ###
FROM alpine:3.18

# Set the working directory inside the container
WORKDIR /app

# Install curl
RUN apk --no-cache add curl

# Copy only the necessary files from the build stage
COPY --from=BUILD /go/src/app/repayment-utility-service .

# Define environment variable for USER_SERVICE_URL
ENV USER_SERVICE_URL=user-service.mekar-test.xyz

### CMD INSTRUCTION (if container run) ###
CMD ["./repayment-utility-service"]
