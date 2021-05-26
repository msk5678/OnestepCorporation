const functions = require("firebase-functions");
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');
const { database } = require("firebase-admin");

const ALGOLIA_APP_ID = "SM0LVJM1EL";
const ALGOLIA_ADMIN_KEY = "888bc2148de8f405c5862451f002d21e";

var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);

admin.initializeApp();

const databaseTest = admin.firestore();

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

exports.onReportCreate = functions.database.ref('/report/{reportedUid}/deal/{postUid}/{timestamp}').onCreate(async (snapshot, context) => {
    const countValue = snapshot.val();
    var count;

    console.log(countValue.count)
    if (countValue.count === '5') {
        console.log('!!!!')

        // const query = await databaseTest.collection('user').document('112293538348632094935').get();
        const db = await databaseTest.collection('user').where('uid', '==', '112293538348632094935').get();

        db.forEach(async testValue => {
            count = testValue.data()['reportPoint'];
        })

        console.log('!!!!' + count);

        await databaseTest.doc('user/' + '112293538348632094935').update({
            "reportPoint" : 1,
        })
    }
});

// exports.onUserReportTest = functions.database.document('user/{}')