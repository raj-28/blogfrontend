# Use a slim Node.js image as the base image
FROM node:14-alpine AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Set NODE_OPTIONS to increase heap memory
ENV NODE_OPTIONS="--max-old-space-size=8192"

# Copy the remaining source code to the container
COPY . .

# Build the React app
RUN npm run build

# Use a lightweight Nginx image as the base image for serving the static files
FROM nginx:alpine

# Copy the built React app from the 'build' stage to the Nginx server directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to allow external access to the Nginx server
EXPOSE 80

# Start Nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]
