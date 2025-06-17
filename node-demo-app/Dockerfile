FROM node:20-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --omit=dev

COPY .  .

EXPOSE 3000

RUN addgroup app && adduser -S -G app app
USER app

CMD [ "node", "src/index.js" ]

