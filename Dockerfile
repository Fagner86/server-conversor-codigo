FROM node:14

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN npm install


# Install flex
RUN apt-get update && apt-get install -y flex

COPY . .

EXPOSE 8080

# Command to run your application
CMD ["node", "server.js"]

