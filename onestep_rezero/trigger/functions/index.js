const functions = require("firebase-functions");
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = "SM0LVJM1EL";
const ALGOLIA_ADMIN_KEY = "888bc2148de8f405c5862451f002d21e";

var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);

admin.initializeApp();

function replaceAll(str, searchStr, replaceStr) {
    return str.split(searchStr).join(replaceStr);
}
 
exports.createProduct = functions.firestore.document('university/{universityId}/product/{productId}').onCreate(async (snap, context) =>{
    const newValue = snap.data();
    newValue.objectID = snap.id;

    var ref = replaceAll(snap.ref.parent.path, "/", "_");
    var index = client.initIndex(ref);
    index.saveObject(newValue);
    }
);

exports.updateProduct = functions.firestore.document('university/{universityId}/product/{productId}').onUpdate(async (snap, context) =>{
    const afterUpdate = snap.after.data();
    afterUpdate.objectID = snap.after.id;

    var ref = replaceAll(snap.ref.parent.path, "/", "_");
    var index = client.initIndex(ref);
    index.saveObject(afterUpdate);
    }
);

exports.deleteProduct = functions.firestore.document('university/{universityId}/product/{productId}').onDelete(async (snap, context) =>{
    const oldID = snap.id;

    var ref = replaceAll(snap.ref.parent.path, "/", "_");
    var index = client.initIndex(ref);
    index.deleteObject(oldID);
    }
);