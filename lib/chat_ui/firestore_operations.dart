import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveChatMessageToFirestore({
  required String chatTitle,
  required String userMessage,
  required String aiResponse,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? userId = currentUser?.uid;

  if (userId == null) {
    print("Error: User not logged in. Cannot save chat message.");
    return;
  }

  // Get reference to chat session document using user ID and chat title as document ID
  DocumentReference chatSessionRef = firestore
      .collection('chat_history') // Top-level collection: chat_history
      .doc(userId) // Document ID: User ID
      .collection('user_chats') // Subcollection: user_chats
      .doc(chatTitle); // Document ID: Chat Title

  WriteBatch batch = firestore.batch();
  DocumentSnapshot chatSessionDoc = await chatSessionRef.get();
      
  // Get the current server timestamp once and use it for both messages
  Timestamp currentTimestamp = Timestamp.now();

  Map<String, dynamic> newUserMessageFirestore = {
    'role': 'user',
    'message': userMessage,
    'timestamp': currentTimestamp, // Set timestamp here
  };
  Map<String, dynamic> newAiMessageFirestore = {
    'role': 'ai',
    'message': aiResponse,
    'timestamp': currentTimestamp, // Set timestamp here
  };

  if (chatSessionDoc.exists) {
    // Chat session exists, append new messages and update last_updated
    batch.update(chatSessionRef, {
      'messages': FieldValue.arrayUnion(
          [newUserMessageFirestore, newAiMessageFirestore]),
      'last_updated': currentTimestamp, // Use currentTimestamp for last_updated
    });
  } else {
    // Chat session doesn't exist, create new session
    batch.set(chatSessionRef, {
      'title': chatTitle, // User-defined title
      'createdAt': currentTimestamp, // Use currentTimestamp for createdAt
      'last_updated': currentTimestamp, // Use currentTimestamp for last_updated
      'messages': [newUserMessageFirestore, newAiMessageFirestore],
    });
  }
  await batch.commit();
}

