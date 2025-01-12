const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('pocketDocs', 'docuser', 'userpassword', {
  host: 'db',
  dialect: 'mysql',
  port: 3306,
  logging: false,
});

module.exports = sequelize;
