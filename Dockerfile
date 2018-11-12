#FROM node:11.1.0 as builder
#RUN apk update && apk add --no-cache make git
#
#COPY nginx.conf /etc/nginx/nginx.conf
#
#### Create app directory
##WORKDIR /usr
###
##RUN ls
###
##COPY frontend/package.json src
##COPY frontend/package-lock.json src
###
##RUN ls
##WORKDIR \\usr\\src
###
##RUN ls
###
##RUN npm install
##RUN npm install -g @angular/cli@7.0.4
###
###
##COPY . .
#
#RUN ls
#
#RUN cd /frontend ng build
#
#WORKDIR /usr/share/nginx/html
#
#RUN ls
#
#COPY frontend/dist/frontend .
#
#RUN ls

# STEP 1 build static website
FROM node:11.1.0 as builder
#RUN apk update && apk add --no-cache make git
# Create app directory
WORKDIR /src

RUN ls
# Install app dependencies
COPY frontend/package.json app
COPY frontend/package-lock.json app

WORKDIR /src/app
RUN ls
RUN npm set progress=false && npm install
# Copy project files into the docker image
COPY .  .
RUN npm run build

# STEP 2 build a small nginx image with static website
FROM nginx:alpine
## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*
## From 'builder' copy website to default nginx public folder
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]