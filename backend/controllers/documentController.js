const documentService = require('../services/documentService');
const validTypes = ['CI', 'Passport', 'Health Insurance', 'Travel Insurance', 'Car Insurance', 'Driver ID'];
const fs = require('fs');
const path = require('path');

exports.createDocument = async (req, res, next) => {
  try {
    const { title, type } = req.body;
    const filePath = req.file?.path;

    if (!title || !type || !filePath) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }

    // Logic to save document in the database
    const document = await documentService.createDocument({
      user_id: req.user.id, // Retrieved from the authenticated token
      title,
      type,
      file_path: filePath,
    });

    res.status(201).json({ message: 'Document uploaded successfully', document });
  } catch (error) {
    next(error);
  }
};


exports.updateDocument = async (req, res, next) => {
  try {
    const { document_id } = req.params;
    const { title, status, expiry_date } = req.body;
    const user_id = req.user.id; // Retrieved from the authenticated token

    // Find the document to update
    const document = await documentService.getDocument(user_id, document_id);
    if (!document) {
      return res.status(404).json({ message: 'Document not found.' });
    }

    const updatedData = { title, status, expiry_date };

    // If a new file is uploaded, save it and replace the old file
    if (req.file) {
      const userFolder = path.join(__dirname, '../uploads', user_id);
      if (!fs.existsSync(userFolder)) {
        fs.mkdirSync(userFolder, { recursive: true });
      }

      const newFilePath = path.join(userFolder, req.file.filename);

      // Move the new file to the user's folder
      fs.renameSync(req.file.path, newFilePath);

      // Delete the old file
      if (document.file_path && fs.existsSync(document.file_path)) {
        fs.unlinkSync(document.file_path);
      }

      updatedData.file_path = newFilePath;
    }

    // Update the document in the database
    const updatedDocument = await documentService.updateDocument(document_id, updatedData);

    res.status(200).json({ message: 'Document updated successfully.', document: updatedDocument });
  } catch (error) {
    next(error);
  }
};

exports.getDocument = async (req, res, next) => {
  try {
    const { document_id } = req.params;
    const document = await documentService.getDocument(req.user.user_id, document_id);
    res.status(200).json({ document });
  } catch (error) {
    next(error);
  }
};

exports.getDocumentForDownload = async (req, res, next) => {
  try {
    const { document_id } = req.params;
    console.log(document_id);
    const document = await documentService.getDocument(document_id);

    if (!document) {
      return res.status(404).json({ message: 'Document not found.' });
    }

    req.filePath = document.file_path;
    next();
  } catch (error) {
    next(error);
  }
};

exports.deleteDocument = async (req, res, next) => {
  try {
    const { document_id } = req.params;
    await documentService.deleteDocument(req.user.id, document_id);
    res.status(200).json({ message: 'Document deleted successfully.' });
  } catch (error) {
    next(error);
  }
};

exports.filterDocuments = async (req, res, next) => {
  try {
    const { type, status, title, startDate, endDate } = req.query;
    const userId = req.user.id;

    const filters = { user_id: userId };

    if (type) filters.type = type;
    if (status) filters.status = status;
    if (title) filters.title = { [Op.like]: `%${title}%` };
    if (startDate || endDate) {
      filters.created_at = {};
      if (startDate) filters.created_at[Op.gte] = new Date(startDate);
      if (endDate) filters.created_at[Op.lte] = new Date(endDate);
    }

    const documents = await documentService.filterDocuments(filters);
    res.status(200).json({ documents });
  } catch (error) {
    next(error);
  }
};

exports.getAllUserDocuments = async (req, res, next) => {
  try {
    const userId = req.user.id; // Retrieve the user ID from the token
    const documents = await documentService.getAllDocumentsByUser(userId);

    res.status(200).json({ documents });
  } catch (error) {
    next(error);
  }
};
