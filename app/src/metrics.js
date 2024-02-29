const AWS = require('aws-sdk');
const config = require(`../settings/${process.env.ENVIRONMENT}`);


const cw = new AWS.CloudWatch({ apiVersion: '2010-08-01', region: 'sa-east-1' });
let countAccess = 0;

module.exports = {
    countAccess: function (req, res, next) {
        countAccess++;
        next();
    }
};

function putMetricData() {
    const params = {
        MetricData: [
            {
                MetricName: 'Count Access',
                Dimensions: [
                    {
                        Name: 'All',
                        Value: 'Count Access'
                    },
                ],
                Unit: 'Count',
                Value: countAccess
            },
        ],
        Namespace: 'ecs-alb-login-server'
    };
    cw.putMetricData(params, (err, data) => {
        if (err) {
            console.log('Error sending metric data to CloudWatch: ', err);
        } else {
            console.log('Metric data sent to CloudWatch: ', data);
        }
    });

    countAccess = 0;
}

setInterval(
    putMetricData,
    config.cwMetricsIntervalInMinutes * 60 * 1000
);
