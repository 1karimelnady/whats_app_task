import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_app_task/features/stories/model/story.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all stories
  Stream<List<Story>> getAllStories() {
    return _firestore
        .collection('stories')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Story.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get stories for a user
  Stream<List<Story>> getUserStories(String userId) {
    return _firestore
        .collection('stories')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Story.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Upload a new story
  Future<void> uploadStory(Story story) async {
    await _firestore.collection('stories').add(story.toMap());
  }

  // Mark story as viewed
  Future<void> markStoryAsViewed(String storyId, String userId) async {
    await _firestore.collection('stories').doc(storyId).update({
      'viewedBy': FieldValue.arrayUnion([userId]),
    });
  }

  // Delete a story
  Future<void> deleteStory(String storyId) async {
    await _firestore.collection('stories').doc(storyId).delete();
  }
}
