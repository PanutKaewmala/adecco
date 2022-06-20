FROM node:14-alpine3.11
ARG build_mode

# Change Timezone to GMT+7
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Location of source code
ENV PROJECT_ROOT /opt/app
RUN mkdir -p $PROJECT_ROOT
WORKDIR $PROJECT_ROOT

# install angular cli
RUN npm install -g @angular/cli@12 typescript@4

# Installing packages
COPY ./package.json .
COPY ./package-lock.json .
RUN npm install

# Copy necessary source files for the build process
COPY ./angular.json .
COPY ./tsconfig.json .
COPY ./tsconfig.app.json .
COPY ./tsconfig.eslint.json .
COPY ./tslint.json .
COPY ./src ./src
COPY ./e2e ./e2e

# Override entrypoint
ENTRYPOINT [""]
