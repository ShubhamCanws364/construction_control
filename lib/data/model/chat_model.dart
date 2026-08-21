
class ChatMessage {
  final String? id;
  final String? text;
  final String? filePath;
  final String? imageData;
  final bool isMe;

  ChatMessage({
    this.text,
    this.id,
    this.filePath,
    this.imageData,
    this.isMe = false,}) ;
}
