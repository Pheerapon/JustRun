const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const logger = functions.logger;

// On sign up.
exports.processSignUp = functions.auth.user().onCreate(user => {
  console.log(user);
  // Check if user meets role criteria:
  // Your custom logic here: to decide what roles and other `x-hasura-*` should the user get
  let customClaims;
  if (user.email && (user.email.indexOf('anhdung2881999@gmail.com') !== -1 || user.email.indexOf('dankuanmei@gmail.com') !== -1)) {
    customClaims = {
      'https://hasura.io/jwt/claims': {
        'x-hasura-default-role': 'admin',
        'x-hasura-allowed-roles': ['user', 'admin'],
        'x-hasura-user-id': user.uid
      }
    };
    console.log("admin: ", customClaims);
  }
  else {
    customClaims = {
      'https://hasura.io/jwt/claims': {
        'x-hasura-default-role': 'user',
        'x-hasura-allowed-roles': ['user'],
        'x-hasura-user-id': user.uid
      }
    };
    console.log("user: ", customClaims);
  }

  // Set custom user claims on this newly created user.
  return admin.auth().setCustomUserClaims(user.uid, customClaims)
    .then(() => {
      // Update real-time database to notify client to force refresh.
      const metadataRef = admin.database().ref("metadata/" + user.uid);
      // Set the refresh time to the current UTC timestamp.
      // This will be captured on the client to force a token refresh.
      return metadataRef.set({refreshTime: new Date().getTime()});
    })
    .catch(error => {
      console.log(error);
    });
});


exports.siwa = functions.https.onRequest((request, response) => {
  logger.log(`siwa request: ${util.inspect(request)}`);

  const redirect = `intent://callback?${new URLSearchParams(
    request.body
  ).toString()}#Intent;package=${
    'dev.timistudio.habitrun'
  };scheme=signinwithapple;end`;

  logger.log(`Redirecting to ${redirect}`);

  response.redirect(307, redirect);
})
