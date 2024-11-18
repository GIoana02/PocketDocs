const express = require('express');
const userController = require('../controllers/userController');

const router = express.Router();

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
router.post('/', userController.createUser);

/**
 * @swagger
 * /api/users/update:
 *   put:
 *     summary: Update a user (demo response)
 *     tags: [Users]
 *     responses:
 *       202:
 *         description: User updated successfully (demo)
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Updated successfully
 */
router.put('/update', userController.updateUser);

module.exports = router;
