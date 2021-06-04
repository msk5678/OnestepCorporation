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

// deal -> 거래신고 : 신고 들어올때 각 post 에 5번까지 count -> if count === 5 -> user에 reportPoint++
// {} 있는거랑 없는거 차이는 없는거는 예를 들어 report 는 이름이 report 인 친구들을 찾는거고
// {reportedUid}, reportedUid는 아무런 의미가 없고(아무거나 써도 ㄱㅊ), report 다음에 있는 모든 애들을 가르킴 
// report 안에 있는 모든 유저 대상
exports.onReportCreate = functions.database.ref('/report/{reportedUid}/deal/{postUid}/value/{timestamp}').onCreate(async (snapshot, context) => {
    const countValue = snapshot.val();
    var postReportPoint;
    var postFirstCasePoint;
    var postSecondCasePoint;
    var postThirdCasePoint;
    var postFourCasePoint;
    
    // 들어온 신고 case 뭔지 파악해서 case count
    switch (countValue.case) {
        case '1':
            const firstCase = snapshot.ref.parent.parent.child('firstCase')
            await firstCase.transaction(count => {
                return count + 1;
            })
            break;
        case '2':
            const secondeCase = snapshot.ref.parent.parent.child('secondCase')
            await secondeCase.transaction(count => {
                return count + 1;
            })
            break;
        default:
            break;
    }

    // report 총 몇갠지 count
    const countRef = snapshot.ref.parent.parent.child('reportCount')
    await countRef.transaction(count => {
        postReportPoint = count + 1;
        return postReportPoint;
    })

    // 이거 쓰는데는 5번째 신고당해서 user report ++ 해주는 동시에 case count 친것도 같이 update 시켜줘야해서 map 형식이든 뭐든 
    // first, second ... case 유형들 다 넘겨줘야함
    // firstCase value 
    console.log('value ' + (await snapshot.ref.parent.parent.child('firstCase').get()).val());

    postFirstCasePoint = (await snapshot.ref.parent.parent.child('firstCase').get()).val();
    postSecondCasePoint = (await snapshot.ref.parent.parent.child('secondCase').get()).val();
    postThirdCasePoint = (await snapshot.ref.parent.parent.child('thirdCase').get()).val();
    postFourCasePoint = (await snapshot.ref.parent.parent.child('fourCase').get()).val();


    // 신고가 들어왔는데 5번째 신고다 -> user report ++
    if (postReportPoint === 5) {
        await databaseTest.collection('user').doc(countValue.reportedUid).collection('report').doc(countValue.reportedUid).get().then(value => {
            realTimeCountTest = value.data()['reportPoint'];
        })
        realTimeCountTest += 1;
        await databaseTest.doc('user/' + countValue.reportedUid+'/report/'+countValue.reportedUid).update({
            "reportPoint": realTimeCountTest,
            "dealCase.first": postFirstCasePoint,
            "dealCase.second": postSecondCasePoint,
            "dealCase.third": postThirdCasePoint,
            "dealCase.four": postFourCasePoint,
        })
    }
});

// realTime에서 post 5번 신고 먹어서 user에 reportPoint 1개 올라가면 일로옴 (update)
// update 하고 나서 reportPoint 가 5면 제재
// 일정시간 지나면 다시 되돌리는거 해야함
exports.onUpdateReportPoint = functions.firestore.document('user/{userId}/report/{reportId}').onUpdate(async (snapshot, context) =>{
    const afterReportPointValue = snapshot.after.data();
    const beforeReportPointValue = snapshot.before.data();
    console.log('after ' + afterReportPointValue.reportPoint)
    console.log('before ' + beforeReportPointValue.reportPoint)

    if (afterReportPointValue.reportPoint === 5) {
        console.log('ZZZZZZZZZZZZZZZ')
        
        await databaseTest.doc('user/' + context.params.userId).update({
            "reportPoint": 1,
            // reprt 컬렉션 -> point -> reportPoint 안에 필드 두개 같이 두고 싶은데 그럼 무한루프돔 
            // user -> report 컬렉션 -> point, time 으로 doc 2개 두고 -> 각 reportPoint, reportTime 이렇게 해야할거같은데
            // 일단 이렇게 해서 시간되면 자동으로 update 되는거 먼저 하고 db 옮기기
            "reportTime" : admin.firestore.Timestamp.now(),
        })
    }
    }
);

exports.checkReportTime = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
    // const weekOldTimestamp = admin.firestore.Timestamp.fromMillis(Date.now() - 604800000);
    // const query = await databaseTest.collection('user').where('reportTime', '<=', admin.firestore.Timestamp.now()).get();
    const query = await databaseTest.collection('user').get();
    query.forEach(async eachGroup => {
        console.log('time hi');
        var nickName = eachGroup.data()['nickName'];
        var test = eachGroup.data()['reportTime'];
        var test2 = eachGroup.data()['reportPoint'];

        if (admin.firestore.Timestamp.now() >= test + 604800000) {
            console.log('uid = ' + nickName);
            console.log('test = ' + test);
            console.log('test2 = ' + test2);
        }
    })
})