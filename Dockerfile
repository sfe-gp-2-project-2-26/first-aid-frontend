FROM node:22-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci || npm install

COPY . .
# Pass build-time vars as ARGs
ARG VITE_AUTH_URL
ARG VITE_AMBULANCE_NUMBER
ENV VITE_AUTH_URL=$VITE_AUTH_URL
ENV VITE_AMBULANCE_NUMBER=$VITE_AMBULANCE_NUMBER

RUN npm run build

FROM node:22-alpine AS runner
WORKDIR /app
COPY --from=builder /app/.output ./.output
COPY --from=builder /app/package.json ./

EXPOSE 8080

CMD ["node", ".output/server/index.mjs"]
