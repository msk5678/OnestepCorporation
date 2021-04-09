const functions = require("firebase-functions");
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = "SM0LVJM1EL";
const ALGOLIA_ADMIN_KEY = "888bc2148de8f405c5862451f002d21e";
const ALGOLIA_INDEX_NAME = "products";

var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
var index = client.initIndex(ALGOLIA_INDEX_NAME);

admin.initializeApp();

exports.createProduct = functions.firestore.document('products/{productId}').onCreate(async (snap, context) =>{
    const newValue = snap.data();
    newValue.objectID = snap.id;
    
    index.saveObject(newValue);
    }
);

exports.updateProduct = functions.firestore.document('products/{productId}').onUpdate(async (snap, context) =>{
    const afterUpdate = snap.after.data();
    afterUpdate.objectID = snap.after.id;
    
    index.saveObject(afterUpdate);
    }
);

exports.deleteProduct = functions.firestore.document('products/{productId}').onDelete(async (snap, context) =>{
    const oldID = snap.id;
    
    index.deleteObject(oldID);
    }
);


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
