const path = require('path');
const fs = require('fs');
const mime = require('mime-types');

const serveFile = (filePathField) => {
  return (req, res, next) => {
    try {
      const filePath = req[filePathField];

      if (!filePath) {
        return res.status(400).json({ message: 'File path not provided' });
      }

      // Check if the file exists
      if (!fs.existsSync(filePath)) {
        return res.status(404).json({ message: 'File not found on server' });
      }

      // Get the MIME type of the file
      const mimeType = mime.lookup(filePath) || 'application/octet-stream';

      // Set headers for the response
      res.setHeader('Content-Disposition', `inline; filename="${path.basename(filePath)}"`);
      res.setHeader('Content-Type', mimeType);

      // Serve the file
      res.sendFile(filePath, (err) => {
        if (err) {
          next(err); // Pass error to error handling middleware
        }
      });
    } catch (error) {
      next(error);
    }
  };
};
module.exports = serveFile;
