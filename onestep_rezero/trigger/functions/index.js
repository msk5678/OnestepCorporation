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
exports.onDealReportCreate = functions.database.ref('/report/{reportedUid}/{firstReportTime}}/deal/{postUid}/value/{timestamp}').onCreate(async (snapshot, context) => {
    const countValue = snapshot.val();
    var ReportPoint;
    var postReportPoint;
    
    // // 들어온 신고 case 뭔지 파악해서 case count
    // switch (countValue.case) {
    //     case '1':
    //         const firstCase = snapshot.ref.parent.parent.child('firstCase')
    //         await firstCase.transaction(count => {
    //             return count + 1;
    //         })
    //         break;
    //     case '2':
    //         const secondeCase = snapshot.ref.parent.parent.child('secondCase')
    //         await secondeCase.transaction(count => {
    //             return count + 1;
    //         })
    //         break;
    //     case '3':
    //         const thirdeCase = snapshot.ref.parent.parent.child('thirdeCase')
    //         await thirdeCase.transaction(count => {
    //             return count + 1;
    //         })
    //     break;
    //     case '4':
    //         const fourCase = snapshot.ref.parent.parent.child('fourCase')
    //         await fourCase.transaction(count => {
    //             return count + 1;
    //         })
    //         break;
    //     default:
    //         break;
    // }

    // report 총 몇갠지 count
    // parent 할때마다 위에서 접근한 경로 ('/report/{reportedUid}/deal/{postUid}/value/{timestamp}')
    // 뒤에서 한칸씩 올라가는거 같음

    const countRef = snapshot.ref.parent.parent.parent.parent.child('reportCount')
    await countRef.transaction(count => {
        ReportPoint = count + 1;
        return ReportPoint;
    })
    
    // board -> 
    const countRef2 = snapshot.ref.parent.parent.parent.parent.parent.parent.parent.child('board').child('test')
    await countRef2.transaction(count =>{
        postReportPoint = count + 1;
        return postReportPoint;
    })
    
    // board report count 5 -> 제재 넣어야하는데 접근 어케하노 -> ㅎㅎ 성공
    if(postReportPoint === 5){
        console.log('hihihihihi')
        admin.database().ref('board/').update({
            'test1' : 1,
        })
    }

    // // case count
    // postFirstCasePoint = (await snapshot.ref.parent.parent.child('firstCase').get()).val();
    // postSecondCasePoint = (await snapshot.ref.parent.parent.child('secondCase').get()).val();
    // postThirdCasePoint = (await snapshot.ref.parent.parent.child('thirdCase').get()).val();
    // postFourCasePoint = (await snapshot.ref.parent.parent.child('fourCase').get()).val();


    // // post 신고가 들어왔는데 그게 그 post의 5번째 신고다 -> user report ++
    if (ReportPoint === 25) {
        await databaseTest.doc('user/' + countValue.reportedUid).update({
            // reprt 컬렉션 -> point -> reportPoint 안에 필드 두개 같이 두고 싶은데 그럼 무한루프돔 
            "reportState": 1,
            "reportTime" : admin.firestore.Timestamp.now(),
        })
        // await databaseTest.collection('user').doc(countValue.reportedUid).collection('report').doc(countValue.reportedUid).get().then(value => {
        //     realTimeCountTest = value.data()['reportPoint'];
        //     postFirstCasePoint += value.data()['dealCase']['first'];
        //     postSecondCasePoint += value.data()['dealCase']['second'];
        //     postThirdCasePoint += value.data()['dealCase']['third'];
        //     postFourCasePoint += value.data()['dealCase']['four'];
        // })
        // realTimeCountTest += 1;
        // await databaseTest.doc('user/' + countValue.reportedUid+'/report/'+countValue.reportedUid).update({
        //     "reportPoint": realTimeCountTest,
        //     "dealCase.first": postFirstCasePoint,
        //     "dealCase.second": postSecondCasePoint,
        //     "dealCase.third": postThirdCasePoint,
        //     "dealCase.four": postFourCasePoint,
        // })
    }

  
});

exports.onUserReportCreate = functions.database.ref('/report/{reportedUid}/{firstReportTime}}/user/{postUid}/value/{timestamp}').onCreate(async (snapshot, context) => {
    const countValue = snapshot.val();
    var ReportPoint;
    

    const countRef = snapshot.ref.parent.parent.parent.parent.child('reportCount')
    await countRef.transaction(count => {
        ReportPoint = count + 1;
        return ReportPoint;
    })

    // // post 신고가 들어왔는데 그게 그 post의 5번째 신고다 -> user report ++
    if (ReportPoint === 25) {
        await databaseTest.doc('user/' + countValue.reportedUid).update({
            // reprt 컬렉션 -> point -> reportPoint 안에 필드 두개 같이 두고 싶은데 그럼 무한루프돔 
            "reportState": 1,
            "reportTime" : admin.firestore.Timestamp.now(),
        })
    }
});

// realTime에서 post 5번 신고 먹어서 user에 reportPoint 1개 올라가면 일로옴 (update)
// update 하고 나서 reportPoint 가 5면 제재
// 일정시간 지나면 다시 되돌리는거 해야함
// exports.onUpdateReportPoint = functions.firestore.document('user/{userId}/report/{reportId}').onUpdate(async (snapshot, context) =>{
//     const afterReportPointValue = snapshot.after.data();
//     const beforeReportPointValue = snapshot.before.data();
//     console.log('after ' + afterReportPointValue.reportPoint)
//     console.log('before ' + beforeReportPointValue.reportPoint)

//     if (afterReportPointValue.reportPoint === 5) {
        
//         await databaseTest.doc('user/' + context.params.userId).update({
//             // reprt 컬렉션 -> point -> reportPoint 안에 필드 두개 같이 두고 싶은데 그럼 무한루프돔 
//             "reportState": 1,
//             "reportTime" : admin.firestore.Timestamp.now(),
//         })
//     }
//     }
// );

// 'every 1 minutes' -> 1분마다 확인 -> 비효율 -> 이야기해보고 하루 기준으로 확인하면 될듯?
// ex) 신고 제재 기간이 1주일이면 그 기간이 지날때 자동으로 제재 해제하기 위한 트리거
// 604800000 -> 1주일을 ms 로 변경한 값
// every 24 hours
exports.checkReportTime = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
    const query = await databaseTest.collection('user').get();
    query.forEach(async eachGroup => {
        var reportTime = eachGroup.data()['reportTime'];
  
        // user 안에 있는 reportTime 확인해서 제재기간 지났으면 제재 해제
        if (admin.firestore.Timestamp.fromMillis(Date.now() - 604800000) > reportTime) {
            await databaseTest.doc('user/' + eachGroup.data()['uid']).update({
                "reportState": 0,
                "reportTime" : 0,
            })
        }
    })
})