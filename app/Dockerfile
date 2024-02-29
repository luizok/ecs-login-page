FROM node:21-alpine3.18

RUN apk --no-cache add curl

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
WORKDIR /app
RUN npm install

COPY index.js /app/index.js
COPY src/ /app/src/
COPY public/ /app/public/

ENTRYPOINT [ "node", "index.js" ]
