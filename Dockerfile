# STAGE 1 - BUILD
FROM node:22-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# STAGE 2 - RUN
FROM node:22-alpine
WORKDIR /app

RUN apk add --no-cache curl postgresql-client

RUN mkdir -p /app/uploads/avatar

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

EXPOSE 3000

CMD ["node", "dist/main.js"]
