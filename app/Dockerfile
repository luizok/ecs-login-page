FROM node:21-alpine3.18


COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
WORKDIR /app
RUN npm install

COPY index.js /app/index.js
COPY src/ /app/src/

ENTRYPOINT [ "node", "index.js" ]
