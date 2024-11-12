const { DataTypes } = require('sequelize');
const sequelize = require('./database');
const User = require('./User');

const Document = sequelize.define('Document', {
  document_id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4
  },
  user_id: {
    type: DataTypes.UUID,
    allowNull: false
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  type: {
    type: DataTypes.ENUM('CI', 'Passport', 'Health Insurance', 'Travel Insurance', 'Car Insurance', 'Driver ID'),
    allowNull: false
  },
  file_path: {
    type: DataTypes.STRING,
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('active', 'expired'),
    defaultValue: 'active'
  },
  expiry_date: {
    type: DataTypes.DATE
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  updated_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  is_encrypted: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
}, {
  timestamps: true,
});

Document.belongsTo(User, { foreignKey: 'user_id' });
module.exports = Document;
