const Document = require('../db/models/Document');
const { Op } = require('sequelize');

exports.createDocument = async (documentData) => {
  return await Document.create(documentData);
};

exports.updateDocument = async (document_id, updatedData) => {
  const document = await Document.findByPk(document_id);
  if (!document) {
    throw new Error(`Document with ID ${document_id} not found.`);
  }

  await document.update(updatedData);
  return document;
};

exports.getDocument = async (document_id) => {
  const document = await Document.findByPk(document_id);
  if (!document) {
    throw new Error(`Document with ID ${document_id} not found.`);
  }
  return document;
};

exports.deleteDocument = async (document_id) => {
  const document = await Document.findByPk(document_id);
  if (!document) {
    throw new Error(`Document with ID ${document_id} not found.`);
  }
  await document.destroy();
};

exports.filterDocuments = async (filters) => {
  return await Document.findAll({ where: filters });
};

exports.getAllDocumentsByUser = async (userId) => {
  return await Document.findAll({
    where: { user_id: userId },
    attributes: ['document_id', 'title', 'type', 'status', 'expiry_date', 'file_path', 'created_at', 'updated_at'],
  });
};
