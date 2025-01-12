const bcrypt = require('bcrypt');
const User = require('../db/models/User');
const Document = require('../db/models/Document')
const fs = require('fs');
const path = require('path');

exports.createUser = async (userData) => {
  const { name, email, phone_number, password_hash, cnp } = userData;

  if (!name || !email || !phone_number || !password_hash || !cnp) {
    throw new Error('All fields are required.');
  }

  // Hash the password before saving
  const hashedPassword = await bcrypt.hash(password_hash, 10);

  // Create user
  const newUser = await User.create({
    cnp,
    name,
    email,
    phone_number,
    password_hash: hashedPassword,
  });
  return newUser;
};


exports.updateUser = async (id, updatedData) => {
  console.log('Service: Fetching user by ID:', id);

  const user = await User.findByPk(id);
  if (!user) {
    console.error('Service: User not found with ID:', id);
    throw new Error(`User with ID ${id} not found.`);
  }

  console.log('Service: Found user:', user.toJSON());

  const validUpdates = {};
  for (const key in updatedData) {
    if (updatedData[key] !== undefined) {
      validUpdates[key] = updatedData[key];
    }
  }

  console.log('Service: Updating user with:', validUpdates);
  await user.update(validUpdates);

  return user;
};


exports.login = async (email, password) => {
  const user = await User.findOne({ where: { email } });
  if (!user) {
    throw new Error('Invalid email or password.');
  }

  const isPasswordValid = await bcrypt.compare(password, user.password_hash);
  if (!isPasswordValid) {
    throw new Error('Invalid email or password.');
  }

  return user;
};

exports.deleteAccount = async (user_id) => {
  // Find the user
  const user = await User.findByPk(user_id);
  if (!user) {
    throw new Error('User not found.');
  }

  // Delete associated documents
  const documents = await Document.findAll({ where: { user_id } });
  for (const doc of documents) {
    if (doc.file_path && fs.existsSync(doc.file_path)) {
      fs.unlinkSync(doc.file_path); // Delete file from filesystem
    }
    await doc.destroy();
  }

  // Delete user
  await user.destroy();
};

exports.changePassword = async (user_id, current_password, new_password) => {
  const user = await User.findByPk(user_id);
  if (!user) {
    throw new Error('User not found.');
  }

  // Check current password
  const isMatch = await bcrypt.compare(current_password, user.password_hash);
  if (!isMatch) {
    return false; // Current password is incorrect
  }

  // Hash new password
  const hashedPassword = await bcrypt.hash(new_password, 10);

  // Update password
  await user.update({ password_hash: hashedPassword });

  return true; // Password changed successfully
};
