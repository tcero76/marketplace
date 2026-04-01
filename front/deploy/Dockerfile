FROM node:20-slim AS base
WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./
COPY next.config.ts ./

FROM base AS dev
RUN npm install
COPY . .
EXPOSE 3000
CMD npm run dev
FROM base AS builder
RUN npm ci --only=production
COPY . .
RUN npm run build
FROM node:20-alpine AS production
WORKDIR /app
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
USER node
EXPOSE 3000
CMD npm run start
