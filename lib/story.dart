class Story {
  final String title;
  final String content;
  final String image;

  Story({
    required this.title,
    required this.content,
    required this.image,
  });

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      title: map['title'],
      content: map['content'],
      image: map['image'], 
    );
  }
}
