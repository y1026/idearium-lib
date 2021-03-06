FROM node:6-alpine

# Setup dockerize.
# Keep bash and curl to run the codecov bash script.
ENV DOCKERIZE_VERSION v0.6.0
RUN apk add --no-cache bash curl openssl && \
    curl -sSL https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar -C /usr/local/bin -xzvf - && \
    apk del openssl

# Only install packages if there is an update.
COPY /package.json /yarn.lock /app/
WORKDIR /app
RUN yarn

COPY / /app

CMD dockerize -wait tcp://mongo:27017 -wait tcp://rabbitmq:5672 -wait tcp://redis:6379 -timeout 20s yarn test-app
