const jwt = require('jsonwebtoken');

exports.generateToken = (user) => {
  console.log('Generating token for user:', user); // Debug the user object

  const payload = {
    id: user.user_id,
    email: user.email,
  };

  return jwt.sign(payload, process.env.JWT_SECRET || 'your-secret-key', {
    expiresIn: '1h',
  });
};


