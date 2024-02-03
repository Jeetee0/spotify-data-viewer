# Use a smaller, Alpine-based image for the production environment
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

COPY src src
COPY index.html .
COPY jsconfig.json .
COPY package-lock.json .
COPY package.json .
COPY vite.config.js .

# Install project dependencies
RUN npm install
RUN npm run build

# Expose the port that your app will run on
EXPOSE 5173

# Command to run your production-ready application
CMD ["npm", "run", "dev"]
