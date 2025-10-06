class SupabaseConfig {
  static const String url = 'https://jnrupagtnzgakmntzsdg.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpucnVwYWd0bnpnYWttbnR6c2RnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkyMTk1MTgsImV4cCI6MjA3NDc5NTUxOH0.0OteFssVdvthR37nfK3e1_Peb4mAMTGORqE0aqm0E44';

  // Storage buckets
  static const String avatarsBucket = 'avatars';
  static const String chatFilesBucket = 'chat-files';

  // File size limits (in bytes)
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int maxAvatarSize = 2 * 1024 * 1024; // 2MB

  // Allowed file types
  static const List<String> allowedImageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi', 'mkv'];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];
  static const List<String> allowedAudioTypes = ['mp3', 'wav', 'aac', 'm4a'];

  static List<String> get allAllowedTypes => [
    ...allowedImageTypes,
    ...allowedVideoTypes,
    ...allowedDocumentTypes,
    ...allowedAudioTypes,
  ];
}
