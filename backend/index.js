const express = require('express');
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger/swagger'); // Adjust path if needed
const userRoutes = require('./routes/userRoutes'); // Import routes
const errorMiddleware = require('./middlewares/errorMiddleware');
const { sequelize } = require('./db/index'); // Sequelize setup

const app = express();
const PORT = 3005;

// Middleware
app.use(bodyParser.json());

// Swagger Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Routes
app.use('/api/users', userRoutes);

// Error handling middleware
app.use(errorMiddleware);

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
  console.log(`Swagger docs available at http://localhost:${PORT}/api-docs`);
});

// Test database connection
sequelize.authenticate()
  .then(() => console.log('Database connected!'))
  .catch(err => console.error('Database connection error:', err));
