const sequelize = require('./database');

//Importing models
const User = require('./User');
const Document = require('./Document');
const Notification = require('./Notifications');
const Sharing = require('./Sharing');

// Creating relationships
User.hasMany(Document, { foreignKey: 'user_id' });
Document.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Notification, { foreignKey: 'user_id' });
Notification.belongsTo(User, { foreignKey: 'user_id' });

Document.hasMany(Sharing, { foreignKey: 'document_id' });
Sharing.belongsTo(Document, { foreignKey: 'document_id' });

// Export models
module.exports = {
  sequelize,
  User,
  Document,
  Notification,
  Sharing,
};
