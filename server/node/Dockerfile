FROM node

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
RUN npm install --only=production
#RUN npm install babel-cli

# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY dist/ .

EXPOSE 4000
CMD [ "node", "index.js" ]