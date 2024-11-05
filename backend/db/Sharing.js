const Sharing = sequelize.define('Sharing', {
  sharing_id: { type: DataTypes.UUID, primaryKey: true, defaultValue: DataTypes.UUIDV4 },
  document_id: { type: DataTypes.UUID, allowNull: false },
  shared_with: { type: DataTypes.STRING, allowNull: false },
  access_type: { type: DataTypes.ENUM('view-only', 'download'), allowNull: false },
  expiry_date: { type: DataTypes.DATE },
  created_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
});

Sharing.belongsTo(Document, { foreignKey: 'document_id' });
module.exports = Sharing;
