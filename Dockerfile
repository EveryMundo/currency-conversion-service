# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md
FROM ubuntu:latest

LABEL maintainer="daniel@everymundo.com"

RUN apt-get autoremove
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils curl git build-essential
RUN apt install python -y
RUN apt-get autoremove
# RUN useradd -ms /bin/bash node
# USER node
# Install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN bash -c 'source $HOME/.nvm/nvm.sh   && \
    nvm install 11.2                    && \
    nvm use default                     && \
    npm install -g npm@latest           && \
    PYTHON=/usr/bin/python2.7 npm install --prefix "$HOME/.nvm/" -g node-gyp@latest && \
    PYTHON=/usr/bin/python2.7 npm install --prefix "$HOME/.nvm/" -g bunyan@latest pino-pretty@latest'

RUN mkdir -p /home/node/microservice
WORKDIR /home/node/microservice
COPY ./package*.json /home/node/microservice/
RUN bash -c 'source $HOME/.nvm/nvm.sh && npm audit && npm i --production'
RUN mkdir /home/node/microservice/logs/
COPY . /home/node/microservice
COPY .env* /home/node/microservice/
# RUN rm -rf .git

ENV TINI_VERSION v0.16.1
# USER root
RUN chmod 777 -R /home/node/microservice/logs
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# USER node
ENTRYPOINT ["/tini", "--"]

# Run your program under Tini
CMD ["/home/node/microservice/init-cluster.sh"]