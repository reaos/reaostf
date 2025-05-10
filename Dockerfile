##### Build Stage #####
FROM node:22-alpine AS build

# Set the working directory in the container
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache build-base cmake git musl python3

# Copy config and source files
COPY package*.json bower.json .bowerrc gulpfile.js webpack.config.js ./
COPY bin ./bin
COPY lib ./lib
COPY res ./res
COPY vendor ./vendor

# Install app dependencies in one layer
RUN npm install && npm run prepare

##### Runtime Stage #####
FROM node:22-alpine

# Set the working directory in the container
WORKDIR /app

# Install the required packages
RUN apk add --no-cache coreutils musl

# Copy the build stage files to the runtime stage
COPY --from=build /app .