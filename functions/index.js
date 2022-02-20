const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
// Using Express
const express = require('express');
const app = express();
app.use(express.json());
const { resolve } = require("path");

const escapeHtml = require('escape-html');
const stripe = require('stripe')(functions.config().stripe.testkey);

//-----live mode 
//const stripe = require('stripe')(functions.config().stripe.secret); 

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions


// exports.createCustomerOnStripe = functions.firestore
// .document('client/{clientId}')
// .onCreate((snap, context) => {
//     console.log('client id: ' + snap.id);
//     const newValue = snap.data();
//     const customer = stripe.customers.create({
//         description: newValue.email,
//     }).then(() => {
//         console.log('Write succeeded!');
//       });;
//     console.log('cusId' + customer.id);
// });

// exports.createStripeCustomer = functions.firestore.document('client/{clientId}').onCreate(async (snap, context) => {
//     const customer = await stripe.customers.create({ email: snap.data().email});

//     await admin.firestore().collection('client').doc(snap.id).set({
//         cusId: customer.id,
//     }, { merge: true });
//     return;
// });

exports.createStripeCus = functions.firestore
  .document('client/{clientId}')
  .onCreate( async (snap, context) => {
      console.log('client created email and id: ' +snap.id);
    const customer = await stripe.customers.create({email: snap.data().email});

    admin.firestore().collection('client').doc(snap.id).set({
        cusId: customer.id,
    }, { merge: true });
    //return;
  });

exports.setupIntent = functions.https.onRequest(async (req, response) => {
    const { cusId } = req.body;

    switch (req.get('content-type')) {
        case 'application/x-www-form-urlencoded': {
            const setupIntent = await stripe.setupIntents.create({
                customer: cusId,
                usage: "on_session"
            },
                function (err, setupIntent) {
                    functions.logger.info("SetupIntent: " + setupIntent, { structuredData: true });

                    if (err != null) {
                        console.log(err);
                        response.send({ err: err });
                    }
                    else {
                        const clientSecret = setupIntent.client_secret;
                        console.log("CLIENT SECRET: " + clientSecret);
                        response.send({ client_secret: clientSecret });
                    }
                }
            );
        }
    }
});


exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
    const { paymentMethodType, currency, total, cusId, pmId } = req.body;

    switch (req.get('content-type')) {

        // POST request
        case 'application/x-www-form-urlencoded':
            {
                console.log("IN FORM");
                try {
                    const params = {
                        amount: Math.round(total * 100),
                        currency: currency,
                        customer: cusId,
                        payment_method: pmId,
                        payment_method_types: ['card'],
                        off_session: false,
                        confirm: true,
                    }
                    if (paymentMethodType === 'acss_debit') {
                        params.payment_method_options = {
                            acss_debit: {
                                mandate_options: {
                                    payment_schedule: 'sporadic',
                                    transaction_type: 'personal',
                                },
                            },
                        }
                    }
                    console.log("Creating payment intent");
                    const paymentIntent = await stripe.paymentIntents.create(params);
                    console.log("payment intent id: " + paymentIntent.id);
                    console.log("CLIENT SEC: " + paymentIntent.client_secret);


                    if (
                        paymentIntent.status === 'requires_action' &&
                        paymentIntent.next_action.type === 'use_stripe_sdk'
                    ) {
                        // Tell the client to handle the action
                        res.status(200).json({
                            result: false,
                            requires_action: true,
                            pi_cs: paymentIntent.client_secret
                        });
                    } else if (paymentIntent.status === 'succeeded') {
                        // The payment didn’t need any additional actions and completed!
                        // Handle post-payment fulfillment
                        res.status(200).json({
                            result: true,
                        });

                    } else {
                        // Invalid status
                        res.status(200).json({
                            result: false,
                            error: 'Invalid PaymentIntent status'
                        });
                    }
                } catch (e) {
                    return res.send({
                        error: {
                            message: e.message,
                        },
                    });
                }
                break;
            }

    }
})

exports.confirmCardPayment = functions.https.onRequest(async (req, res) => {
    const { pId } = req.body;


    switch (req.get('content-type')) {

        // POST request
        case 'application/x-www-form-urlencoded':
            {
                console.log("IN confirm payment intent");
                // To create a PaymentIntent for confirmation, see our guide at: https://stripe.com/docs/payments/payment-intents/creating-payment-intents#creating-for-automatic
                try {
                    const paymentIntent = await stripe.paymentIntents.confirm(
                        pId,
                        { payment_method: 'pm_card_visa' },
                    );
                    console.log('PI-confirm res = ' + paymentIntent.status);
                    return res.send({
                        result: paymentIntent.status
                    });
                }
                catch (e) {
                    console.log('PI-confirm EXCEPTION = ' + e);
                    return res.send({
                        result: e
                    });
                }


                // stripe.confirmCardPayment(pi_cs, {
                //         payment_method: pmId,
                //     })
                //     .then(function (result) {
                //         result.err;
                //         res.json({
                //             res: result
                //         })
                //         // Handle result.error or result.paymentIntent
                //     });
            }
    }
})

exports.myPaymentMethods = functions.https.onRequest(async (req, res) => {
    const { cusId } = req.body;
    switch (req.get('content-type')) {
        case 'application/x-www-form-urlencoded':
            {
                const paymentMethods = await stripe.paymentMethods.list({
                    customer: cusId,
                    type: 'card',
                },
                    function (err, paymentMethods) {

                        if (err != null) {
                            console.log(err);
                        }
                        else {
                            res.json({
                                paymentMethods: paymentMethods
                            })
                        }
                    }
                );
                break;
            }
    }
})


exports.paymentSheet = functions.https.onRequest(async (req, res) => {
    const { cusId, total } = req.body;

    switch (req.get('content-type')) {
        case 'application/x-www-form-urlencoded':
            {
                const ephemeralKey = await stripe.ephemeralKeys.create(
                    { customer: cusId },
                    { apiVersion: '2020-08-27' }
                );
                const paymentIntent = await stripe.paymentIntents.create({
                    amount: Math.round(total * 100),
                    currency: 'eur',
                    customer: cusId,
                });
                res.send({
                    paymentIntent: paymentIntent.client_secret,
                    ephemeralKey: ephemeralKey.secret,
                    customer: cusId,
                });
                break;
            }
    }

})

exports.stripePayment = functions.https.onRequest(async (req, res) => {
    const paymentIntent = await stripe.paymentIntents.create({
        amount: 150,
        currency: 'usd'
    },
        function (err, paymentIntent) {

            if (err != null) {
                console.log(err);
            }
            else {
                res.json({
                    paymentIntent: paymentIntent.client_secret
                })
            }
        }
    )
})
