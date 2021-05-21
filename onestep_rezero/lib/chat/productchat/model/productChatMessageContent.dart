class ProductChatMessageContent {
  String title;
  String price;
  String imageUrl;

  ProductChatMessageContent({
    this.title,
    this.price,
    this.imageUrl,
  });

  ProductChatMessageContent.forMapSnapshot(dynamic snapshot) {
    if (snapshot["type"] == 3) {
      title = snapshot['content']['title'];
      price = snapshot['content']['price'];
      imageUrl = snapshot['content']['imageUrl'];
    } else if (snapshot["type"] == 1) {
      imageUrl = snapshot['content'];
    } else if (snapshot["type"] == 0) {
      title = snapshot['content'];
    }
  }
}
