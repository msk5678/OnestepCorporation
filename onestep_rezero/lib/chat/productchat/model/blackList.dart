class BlackList {
  String blockFromUid;
  String blockToUid;
  String blockTime;

  BlackList({
    this.blockFromUid,
    this.blockToUid,
    this.blockTime,
  });

  BlackList.forMapSnapshot(dynamic snapshot) {
    blockFromUid = snapshot['blockFromUid'];
    blockToUid = snapshot["blockToUid"];
    blockTime = snapshot["blockTime"];
  }
}
