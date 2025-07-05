part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final String reply;
  ChatSuccess(this.reply);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}