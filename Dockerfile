FROM node:20-alpine AS base
LABEL org.opencontainers.image.title="gams-backend" \
      org.opencontainers.image.description="GAMS REST API (Express/MongoDB)" \
      org.opencontainers.image.source="https://github.com/c-joss/DEV1004_backend_GAMS"
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