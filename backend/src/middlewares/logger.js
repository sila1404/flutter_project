// src/middleware/logger.js
const logger = (req, res, next) => {
    const dateTime = new Date()
        .toISOString()
        .replace(/T/, " ")
        .replace(/\..+/, "");
    console.log(`${dateTime} - ${req.method} ${req.url}`);
    next();
};

export default logger