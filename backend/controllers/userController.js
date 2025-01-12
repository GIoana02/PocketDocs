const userService = require('../services/userService');
const { generateToken } = require('../utils/authUtils'); // Utility for generating JWTs
const bcrypt = require('bcrypt');

exports.createUser = async (req, res, next) => {
  try {
    console.log('Incoming request body:', req.body); // Debugging log
    const user = await userService.createUser(req.body);
    res.status(201).json({ message: 'User created successfully!', user });
  } catch (error) {
    console.error('Error creating user:', error.message); // Debugging log
    next(error); // Pass error to error handling middleware
  }
};


exports.updateUser = async (req, res, next) => {
  try {
    // Extract `user_id` from the token instead of the request body
    const user_id = req.user.id;
    const { ...updatedData } = req.body;

    console.log('Updating user with ID:', user_id, 'with data:', updatedData);

    if (!user_id) {
      return res.status(400).json({ message: 'User ID is required to update user.' });
    }

    const updatedUser = await userService.updateUser(user_id, updatedData);

    res.status(200).json({ message: 'User updated successfully', user: updatedUser });
  } catch (error) {
    console.error('Error updating user:', error.message); // Debugging
    next(error);
  }
};


exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await userService.login(email, password);

    // Generate JWT token
    const token = generateToken(user);

    res.status(200).json({ message: 'Login successful', token });
  } catch (error) {
    next(error);
  }
};

exports.deleteAccount = async (req, res, next) => {
  try {
    const user_id = req.user.id; // Get user ID from the token
    await userService.deleteAccount(user_id);
    res.status(200).json({ message: 'User account deleted successfully.' });
  } catch (error) {
    next(error);
  }
};

exports.changePassword = async (req, res, next) => {
  try {
    const { current_password, new_password } = req.body;

    if (!current_password || !new_password) {
      return res.status(400).json({ message: 'Current and new passwords are required.' });
    }

    const user_id = req.user.id; // Get user ID from the token
    const result = await userService.changePassword(user_id, current_password, new_password);

    if (!result) {
      return res.status(400).json({ message: 'Current password is incorrect.' });
    }

    res.status(200).json({ message: 'Password changed successfully.' });
  } catch (error) {
    next(error);
  }
};



