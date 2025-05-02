# Use a specific, lightweight Node.js 20 LTS version
FROM node:20.12.2-alpine3.19

# Create app directory
WORKDIR /nodeapp

# Copy package.json and package-lock.json for efficient caching
COPY package*.json ./

# Install dependencies using npm ci for reproducibility
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Run as non-root user for security
RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup
USER nodeuser

# Set production environment
ENV NODE_ENV=production

# Expose port 3000
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]