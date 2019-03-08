FROM node:11.10.1-alpine as builder 
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf

# create log dir configured in nginx.conf
RUN mkdir -p /var/log/app_engine
COPY --from=builder /app/build /usr/share/nginx/html

# Create a simple file to handle heath checks
RUN mkdir -p /usr/share/nginx/html/_ah && \
    echo "healthy" > /usr/share/nginx/html/_ah/health

RUN chmod -R a+r /usr/share/nginx/html
