# RedditP Dockerfile
# Lightweight Node.js image based on Alpine Linux

FROM node:20-alpine

# Add metadata
LABEL maintainer="redditp"
LABEL description="RedditP - Reddit Slideshow Presentation"
LABEL version="1.0.0"

# Set working directory
WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies without excluding devDependencies (since express is there)
RUN npm install && \
    npm cache clean --force

# Copy application files
COPY . .

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Expose the application port
EXPOSE 8080

# Health check to ensure container is running properly
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the application
CMD ["npm", "start"]