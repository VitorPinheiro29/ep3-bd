FROM node:18-alpine

WORKDIR /usr/app

RUN npm i nodemon -g

COPY package*.json .

RUN npm i

COPY . .

EXPOSE 3333

CMD [ "npm", "run", "dev" ]