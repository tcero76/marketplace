FROM node:24.0.1 AS base
WORKDIR /app
COPY package*.json .
RUN npm install

FROM base AS dev
WORKDIR /app
COPY . .
EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host"]

FROM base AS build
WORKDIR /app

ARG VITE_HOST
ARG VITE_WS
ARG VITE_CLIENT_ID
ARG VITE_MOCK

ENV VITE_HOST=$VITE_HOST
ENV VITE_WS=$VITE_WS
ENV VITE_CLIENT_ID=$VITE_CLIENT_ID
ENV VITE_MOCK=$VITE_MOCK
COPY . .
RUN npm run build

FROM nginx:stable-alpine AS prod
COPY --from=build /app/dist /usr/share/nginx/html
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
