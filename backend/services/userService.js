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

exports.updateUser = async (id, updatedData) => {
  if(!id){
    throw new Error('User Id is required for update')
  }

  const user = await User.findByPk(id);
  if(!user){
    throw new Error(`User with ID ${id} not found.`);
  }
  console.log(user.toJSON());

  const validUpdates = {};
  for (const key in updatedData) {
    if (key !== 'user_id' && updatedData[key] !== undefined) {
      validUpdates[key] = updatedData[key];
    }
  }
  await user.update(updatedData);
  return user;
}