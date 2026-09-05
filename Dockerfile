FROM node:22-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci || npm install
COPY . .
ARG VITE_AUTH_URL
ARG VITE_AMBULANCE_NUMBER
ENV VITE_AUTH_URL=$VITE_AUTH_URL
ENV VITE_AMBULANCE_NUMBER=$VITE_AMBULANCE_NUMBER
RUN npm run build

FROM node:22-alpine AS runner
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 8080
CMD ["npx", "vite", "preview", "--host", "0.0.0.0", "--port", "8080"]
