const multer = require('multer');
const path = require('path');
const fs = require('fs');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const user_id = req.user.id; // Ensure the user ID is set in the request (from the token)
    const userFolder = path.join(__dirname, '../uploads', user_id);

    // Ensure the user's folder exists
    fs.mkdirSync(userFolder, { recursive: true });

    cb(null, userFolder);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, `${file.fieldname}-${uniqueSuffix}${path.extname(file.originalname)}`);
  },
});

const upload = multer({ storage });
module.exports = upload;
