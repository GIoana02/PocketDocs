const express = require('express');
const documentController = require('../controllers/documentController');
const upload = require('../middlewares/uploadMiddleware');
const authenticateToken = require('../middlewares/authMiddleware');
const serveFile = require('../middlewares/serveFileMiddleware');

const router = express.Router();

/**
 * @swagger
 * /api/documents/upload:
 *   post:
 *     summary: Upload a new document
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - document
 *               - type
 *               - title
 *             properties:
 *               title:
 *                 type: string
 *                 description: Title of the document
 *               type:
 *                 type: string
 *                 enum: [IDs, Insurances, Car Documents, House Documents]
 *                 description: Type of the document
 *               document:
 *                 type: string
 *                 format: binary
 *                 description: The document file to upload
 *     responses:
 *       201:
 *         description: Document uploaded successfully
 */
router.post('/upload', authenticateToken, upload.single('document'), documentController.createDocument);

/**
 * @swagger
 * /api/documents/update/{document_id}:
 *   put:
 *     summary: Update an existing document
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: document_id
 *         required: true
 *         schema:
 *           type: string
 *         description: UUID of the document to update
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               status:
 *                 type: string
 *                 enum: [active, expired]
 *               expiry_date:
 *                 type: string
 *                 format: date
 *               document:
 *                 type: string
 *                 format: binary
 *                 description: The new document file to replace the old one
 *     responses:
 *       200:
 *         description: Document updated successfully
 */
router.put('/update/:document_id', authenticateToken, upload.single('document'), documentController.updateDocument);

/**
 * @swagger
 * /api/documents/display/{document_id}:
 *   get:
 *     summary: Get a document by its ID
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: document_id
 *         required: true
 *         schema:
 *           type: string
 *         description: UUID of the document to retrieve
 *     responses:
 *       200:
 *         description: Document retrieved successfully
 */
router.get('/display/:document_id', authenticateToken, documentController.getDocument);

/**
 * @swagger
 * /api/documents/download/{document_id}/file:
 *   get:
 *     summary: Serve a document file
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: document_id
 *         required: true
 *         schema:
 *           type: string
 *         description: UUID of the document to retrieve
 *     responses:
 *       200:
 *         description: Document file served successfully
 *         content:
 *           application/octet-stream:
 *             schema:
 *               type: string
 *               format: binary
 *       404:
 *         description: Document or file not found
 *       500:
 *         description: Internal server error
 */
router.get('/download/:document_id/file', authenticateToken, documentController.getDocumentForDownload, serveFile('filePath'));

/**
 * @swagger
 * /api/documents/delete/{document_id}:
 *   delete:
 *     summary: Delete a document
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: document_id
 *         required: true
 *         schema:
 *           type: string
 *         description: UUID of the document to delete
 *     responses:
 *       200:
 *         description: Document deleted successfully
 */
router.delete('/delete/:document_id', authenticateToken, documentController.deleteDocument);

/**
 * @swagger
 * /api/documents/filter:
 *   get:
 *     summary: Filter documents by criteria
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [IDs, Insurances, Car Documents, House Documents]
 *         description: Filter by document type
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [active, expired]
 *         description: Filter by document status
 *       - in: query
 *         name: title
 *         schema:
 *           type: string
 *         description: Search by document title
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by creation date (start)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter by creation date (end)
 *     responses:
 *       200:
 *         description: List of filtered documents
 */
router.get('/filter', authenticateToken, documentController.filterDocuments);

/**
 * @swagger
 * /api/documents:
 *   get:
 *     summary: Get all documents for the authenticated user
 *     tags: [Documents]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of all documents for the user
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   document_id:
 *                     type: string
 *                   title:
 *                     type: string
 *                   type:
 *                     type: string
 *                   status:
 *                     type: string
 *                   expiry_date:
 *                     type: string
 *                     format: date
 *                   file_path:
 *                     type: string
 *                     description: Path to the file
 *                   created_at:
 *                     type: string
 *                     format: date-time
 *                   updated_at:
 *                     type: string
 *                     format: date-time
 *       401:
 *         description: Unauthorized, missing or invalid token
 *       500:
 *         description: Internal server error
 */
router.get('/', authenticateToken, documentController.getAllUserDocuments);


module.exports = router;
