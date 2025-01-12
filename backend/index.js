const express = require('express');
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger/swagger'); // Adjust path if needed
const userRoutes = require('./routes/userRoutes'); // Import routes
const documentRoutes = require('./routes/documentRouter');
const errorMiddleware = require('./middlewares/errorMiddleware');
const { sequelize } = require('./db/index'); // Sequelize setup
const cors = require('cors');
const path = require('path')
console.log("Restarted App")
const app = express();
app.use(cors());

// Serve static files
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
const PORT = 3005;

// Middleware
app.use(bodyParser.json());
// Enable CORS

// Swagger Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Routes
app.use('/api/users', userRoutes);
app.use('/api/documents', documentRoutes)

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
