module.exports = (err, req, res, next) => {
  if (err.name === 'SequelizeValidationError' || err.name === 'SequelizeUniqueConstraintError') {
    return res.status(400).json({ message: err.errors[0].message });
  }

  console.error(err);
  res.status(500).json({ message: err.message || 'Internal Server Error' });
};
