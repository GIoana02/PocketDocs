const swaggerJSDoc = require('swagger-jsdoc');

// Swagger definition
const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'PocketDocs API', // API title
    version: '1.0.0',       // API version
    description: 'API documentation for PocketDocs', // API description
  },
  servers: [
    {
      url: 'http://localhost:3005', // Server URL
    },
  ],
};

// Options for the swagger docs
const options = {
  swaggerDefinition,
  apis: ['./index.js'], // Path to the API docs (adjust based on your file structure)
};

// Initialize swagger-jsdoc
const swaggerSpec = swaggerJSDoc(options);

module.exports = swaggerSpec;
