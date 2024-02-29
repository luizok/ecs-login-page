const { MemoryStore } = require('express-session');


module.exports = {
    cwMetricsIntervalInMinutes: 1,
    sessionDurationInMinutes: 5,
    storeManager: new MemoryStore()
}
