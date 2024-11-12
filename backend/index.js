const express = require('express');
const bodyParser = require('body-parser');
const { sequelize } = require('./db/models'); // Import Sequelize instance
const User = require('./db/models/User'); // Import the User model
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger');

const app = express();
const PORT = 3005;

// Middleware
app.use(bodyParser.json()); // Parses JSON requests

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Dummy route for testing
app.get('/', (req, res) => {
  res.send('Welcome to PocketDocs API!');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
  console.log(`Swagger docs available at http://localhost:${PORT}/api-docs`);
})
// Test database connection
sequelize.authenticate()
  .then(() => console.log('Database connected!'))
  .catch(err => console.error('Database connection error:', err));


/**
 * @swagger
 * /api/users:
 *   post:
 *     summary: Create a new user
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *               - phone_number
 *               - password_hash
 *             properties:
 *               name:
 *                 type: string
 *                 description: The user's name
 *               email:
 *                 type: string
 *                 description: The user's email
 *               phone_number:
 *                 type: string
 *                 description: The user's phone number
 *               password_hash:
 *                 type: string
 *                 description: The user's hashed password
 *     responses:
 *       201:
 *         description: User created successfully
 *       400:
 *         description: Missing required fields
 *       500:
 *         description: Internal server error
 */
app.post('/api/users', async (req, res) => {
  try {
    const { name, email, phone_number, password_hash } = req.body;
    if (!name || !email || !phone_number || !password_hash) {
      return res.status(400).json({ message: 'All fields are required.' });
    }
    const newUser = await User.create({ name, email, phone_number, password_hash });
    res.status(201).json({ message: 'User created successfully!', user: newUser });
  } catch (err) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});
