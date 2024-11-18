const userService = require('../services/userService');

exports.createUser = async (req, res, next) => {
  try {
    const user = await userService.createUser(req.body);
    res.status(201).json({ message: 'User created successfully!', user });
  } catch (error) {
    next(error); // Pass error to error handling middleware
  }
};

exports.updateUser  = (req, res) =>{
    res.status(202).json({message: "Updated successfully"});
}