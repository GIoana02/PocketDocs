const { sequelize } = require('./models');

sequelize.sync({ alter: true })
  .then(() => {
    console.log('Database & tables created!');
  })
  .catch((err) => console.error('Error syncing database:', err));
