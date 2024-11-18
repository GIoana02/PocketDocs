const User = require('../db/models/User');

exports.createUser = async (userData) => {
  const { name, email, phone_number, password_hash } = userData;

  if (!name || !email || !phone_number || !password_hash) {
    throw new Error('All fields are required.');
  }

  // Create user
  const newUser = await User.create({ name, email, phone_number, password_hash });
  return newUser;
};
