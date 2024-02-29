const { MemoryStore } = require('express-session');


module.exports = {
    cwMetricsIntervalInMinutes: 60,
    sessionDurationInMinutes: 60,
    storeManager: new MemoryStore()
}
