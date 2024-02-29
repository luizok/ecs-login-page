const session = require('express-session');
let{ DynamoDBClient } = require('@aws-sdk/client-dynamodb');
let DynamoDBStore = require('connect-dynamodb')({ session: session });


module.exports = {
    cwMetricsIntervalInMinutes: 60,
    sessionDurationInMinutes: 30,
    storeManager: new DynamoDBStore({
        client: new DynamoDBClient({ region: "sa-east-1" }),
        table: process.env.SESSION_TABLE,
        skipThrowMissingSpecialKeys: true,
        hashKey: 'sessionId',
        prefix: 'sessionId-'
    })
}
