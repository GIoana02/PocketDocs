const swaggerJSDoc = require('swagger-jsdoc');

const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'docWallet API',
    version: '1.0.0',
    description: 'API documentation for docWallet',
  },
  servers: [
    {
      url: 'http://localhost:3005',
    },
  ],
};

const options = {
  swaggerDefinition,
  apis: ['./routes/*.js'], // Path to your annotated files
};

module.exports = swaggerJSDoc(options);
