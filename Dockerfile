# A multi-step building process.

# The building phase
FROM node:alpine as builder
WORKDIR /app
COPY ./frontend/package.json .
RUN npm install
COPY ./frontend .
RUN npm run build

# The Production Server Phase. We don't need to specify stage unless there is more.
# Starting another FROM indicates to Docker that the previous phase has ended.
FROM nginx
# AWS EB will look for exposed ports
EXPOSE 80
#Notice that we're copying files from the previous build stage. Everything else from the previous image will be dumped.
COPY --from=builder /app/dist /usr/share/nginx/html
