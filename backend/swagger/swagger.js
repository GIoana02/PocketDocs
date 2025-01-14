const swaggerJSDoc = require('swagger-jsdoc');

const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'API Documentation',
    version: '1.0.0',
    description: 'API for managing users',
  },
  servers: [
    {
      url: 'http://localhost:3005', // Your app's base URL
    },
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT', // Optional, for documentation purposes
      },
    },
  },
  security: [
    {
      bearerAuth: [], // Apply globally if needed
    },
  ],
};

const options = {
  swaggerDefinition,
  apis: ['./routes/*.js', './controllers*.js'], // Path to your annotated files
};

module.exports = swaggerJSDoc(options);
