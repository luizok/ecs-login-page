const { MemoryStore } = require('express-session');


module.exports = {
    cwMetricsIntervalInMinutes: 9999,
    sessionDurationInMinutes: 5,
    storeManager: new MemoryStore()
}
