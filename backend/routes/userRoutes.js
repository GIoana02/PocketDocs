const express = require('express');
const userController = require('../controllers/userController');
const authenticateToken  = require('../middlewares/authMiddleware'); // Middleware for JWT authentication

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
 *               - password
 *               - cnp
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *               phone_number:
 *                 type: string
 *               password_hash:
 *                 type: string
 *                 description: User's password
 *               cnp:
 *                 type: string
 *                 description: 13-digit unique CNP
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
 * /api/users/updated:
 *   put:
 *     summary: Update an existing user's details
 *     tags: [Users]
 *     security:
 *       - bearerAuth: [] # Requires JWT for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - user_id
 *             properties:
 *               name:
 *                 type: string
 *                 description: Updated name of the user
 *               email:
 *                 type: string
 *                 description: Updated email of the user
 *               phone_number:
 *                 type: string
 *                 description: Updated phone number of the user
 *     responses:
 *       200:
 *         description: User updated successfully
 *       400:
 *         description: Bad request, e.g., missing fields or invalid input
 *       401:
 *         description: Unauthorized, e.g., missing or invalid JWT token
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */

router.put('/updated', authenticateToken, userController.updateUser);

/**
 * @swagger
 * /api/users/login:
 *   post:
 *     summary: Login a user
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 description: The user's email
 *               password:
 *                 type: string
 *                 description: The user's password
 *     responses:
 *       200:
 *         description: Login successful with a JWT token
 *       401:
 *         description: Invalid credentials
 */
router.post('/login', userController.login);

/**
 * @swagger
 * /api/users/delete:
 *   delete:
 *     summary: Delete the authenticated user's account
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User account deleted successfully
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.delete('/delete', authenticateToken, userController.deleteAccount);

/**
 * @swagger
 * /api/users/change-password:
 *   patch:
 *     summary: Change the user's password
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - current_password
 *               - new_password
 *             properties:
 *               current_password:
 *                 type: string
 *                 description: The current password of the user
 *               new_password:
 *                 type: string
 *                 description: The new password to set
 *     responses:
 *       200:
 *         description: Password changed successfully
 *       400:
 *         description: Current password is incorrect
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.patch('/change-password', authenticateToken, userController.changePassword);


module.exports = router;
