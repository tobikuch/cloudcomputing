FROM alpine:latest
EXPOSE 80

RUN apk update && apk add nginx && apk add curl

ENTRYPOINT ["nginx", "-g", "daemon off;"]