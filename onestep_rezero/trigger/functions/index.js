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

    // console.log("@@@@" + admin.firestore.Timestamp.now())

    console.log(countValue.count)

    if (countValue.count === '5') {
        
        await databaseTest.collection('user').doc(countValue.reportedUid).collection('report').doc('point').get().then(value => {
            count = value.data()['reportPoint'];
        })
        
        // const db = await databaseTest.collection('user').where('uid', '==', countValue.reportedUid).get();
        // const db = await databaseTest.collection('user').where('uid', '==', countValue.reportedUid).collection('report').doc('point').get();

        // db.forEach(async testValue => {
        //     count = testValue.data()['reportPoint'];
        // })

        console.log('!!!!' + count);
        // console.log('????' + countValue.reportedUid);
        count += 1;
        await databaseTest.doc('user/' + countValue.reportedUid+'/report/point').update({
            "reportPoint" : count,
        })
    }

});

exports.onUpdateReportPoint = functions.firestore.document('user/{userId}/report/point').onUpdate(async (snapshot, context) =>{
    const afterReportPointValue = snapshot.after.data();
    const beforeReportPointValue = snapshot.before.data();
    console.log('after ' + afterReportPointValue.reportPoint)
    console.log('before ' + beforeReportPointValue.reportPoint)

    if (afterReportPointValue.reportPoint === 5) {
        console.log('ZZZZZZZZZZZZZZZ')
        
        await databaseTest.doc('user/' + context.params.userId).update({
            "reportPoint": 1,
            "reportTime" : admin.firestore.Timestamp.now(),
        })
    }
    }
);