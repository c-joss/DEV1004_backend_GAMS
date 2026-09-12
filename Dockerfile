FROM node:20-alpine AS base
WORKDIR /usr/src/app
COPY package*.json ./

FROM base AS dev
ENV NODE_ENV=development
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm", "run", "dev"]

FROM dev AS test
CMD ["npm", "test"]