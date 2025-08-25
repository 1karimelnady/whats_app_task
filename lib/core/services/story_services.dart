import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_app_task/features/stories/model/story.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> uploadStory(Story story) async {
    await _firestore.collection('stories').add(story.toMap());
  }

  Future<void> markStoryAsViewed(String storyId, String userId) async {
    await _firestore.collection('stories').doc(storyId).update({
      'viewedBy': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> deleteStory(String storyId) async {
    await _firestore.collection('stories').doc(storyId).delete();
  }
}
