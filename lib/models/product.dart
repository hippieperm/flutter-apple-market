class Product {
  final int id;
  final String imageFile; // assets/images/ 아래 파일명
  final String title;
  final String description;
  final String seller;
  final int price;
  final String address;
  int likes;
  int chats;
  bool liked;

  Product({
    required this.id,
    required this.imageFile,
    required this.title,
    required this.description,
    required this.seller,
    required this.price,
    required this.address,
    required this.likes,
    required this.chats,
    this.liked = false,
  });

  Product copyWith({
    int? id,
    String? imageFile,
    String? title,
    String? description,
    String? seller,
    int? price,
    String? address,
    int? likes,
    int? chats,
    bool? liked,
  }) {
    return Product(
      id: id ?? this.id,
      imageFile: imageFile ?? this.imageFile,
      title: title ?? this.title,
      description: description ?? this.description,
      seller: seller ?? this.seller,
      price: price ?? this.price,
      address: address ?? this.address,
      likes: likes ?? this.likes,
      chats: chats ?? this.chats,
      liked: liked ?? this.liked,
    );
  }
}
