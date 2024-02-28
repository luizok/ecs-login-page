const AWS = require('aws-sdk');
const cw = new AWS.CloudWatch({ apiVersion: '2010-08-01', region: 'sa-east-1' });

module.exports = {
    putMetricData: async function (req, res, next) {
        const params = {
            MetricData: [
                {
                    MetricName: 'PageViews',
                    Dimensions: [
                        {
                            Name: 'PageURL',
                            Value: 'www.example.com'
                        },
                    ],
                    Unit: 'None',
                    Value: 1.0
                },
            ],
            Namespace: 'Site/Example'
        };

        // cw.putMetricData(params, (err, data) => {
        //     if (err) {
        //         console.log(err, err.stack);
        //     } else {
        //         console.log('Metric data sent successfully');
        //     }
        // });

        next();
    }
};