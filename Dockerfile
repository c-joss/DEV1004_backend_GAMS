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

FROM base AS build
RUN npm ci --omit=dev
COPY . .

FROM node:20-alpine AS prod
LABEL org.opencontainers.image.title="gams-backend" \
      org.opencontainers.image.description="GAMS REST API (Express/MongoDB)" \
      org.opencontainers.image.source="https://github.com/c-joss/DEV1004_backend_GAMS"
ENV NODE_ENV=production
RUN addgroup -S gams && adduser -S gams -G gams
WORKDIR /usr/src/app
COPY --from=build --chown=gams:gams /usr/src/app/node_modules ./node_modules
COPY --from=build --chown=gams:gams /usr/src/app ./
USER gams
EXPOSE 5000
CMD ["node", "src/index.js"]