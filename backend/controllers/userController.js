const userService = require('../services/userService');

exports.createUser = async (req, res, next) => {
  try {
    const user = await userService.createUser(req.body);
    res.status(201).json({ message: 'User created successfully!', user });
  } catch (error) {
    next(error); // Pass error to error handling middleware
  }
};

exports.updateUser = async (req, res, next) => {
  try {
    const { user_id, ...updatedData } = req.body; // Destructure user_id for clarity

    if (!user_id) {
      return res.status(400).json({ message: 'User ID is required to update user.' });
    }

    const updatedUser = await userService.updateUser(user_id, updatedData);

    res.status(200).json({ message: 'User updated successfully', user: updatedUser });
  } catch (error) {
    next(error); // Pass error to middleware
  }
};
