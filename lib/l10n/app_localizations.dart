import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Lino Chat'**
  String get app_name;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get no_data;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @error_navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation Error'**
  String get error_navigation;

  /// No description provided for @page_not_found.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get page_not_found;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get create_account;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get logout_confirm;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @complete_profile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get complete_profile;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @profile_picture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profile_picture;

  /// No description provided for @add_profile_picture.
  ///
  /// In en, this message translates to:
  /// **'Add Profile Picture'**
  String get add_profile_picture;

  /// No description provided for @change_picture.
  ///
  /// In en, this message translates to:
  /// **'Change Picture'**
  String get change_picture;

  /// No description provided for @username_available.
  ///
  /// In en, this message translates to:
  /// **'Username available'**
  String get username_available;

  /// No description provided for @username_taken.
  ///
  /// In en, this message translates to:
  /// **'Username not available'**
  String get username_taken;

  /// No description provided for @username_checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get username_checking;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @new_chat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get new_chat;

  /// No description provided for @new_group.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get new_group;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @last_seen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get last_seen;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'typing...'**
  String get typing;

  /// No description provided for @message_sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get message_sent;

  /// No description provided for @message_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get message_delivered;

  /// No description provided for @message_read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get message_read;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @delete_message.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get delete_message;

  /// No description provided for @delete_chat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get delete_chat;

  /// No description provided for @delete_chat_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this chat?'**
  String get delete_chat_confirm;

  /// No description provided for @add_friend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get add_friend;

  /// No description provided for @friend_requests.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get friend_requests;

  /// No description provided for @sent_requests.
  ///
  /// In en, this message translates to:
  /// **'Sent Requests'**
  String get sent_requests;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @remove_friend.
  ///
  /// In en, this message translates to:
  /// **'Remove Friend'**
  String get remove_friend;

  /// No description provided for @remove_friend_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this friend?'**
  String get remove_friend_confirm;

  /// No description provided for @send_friend_request.
  ///
  /// In en, this message translates to:
  /// **'Send Friend Request'**
  String get send_friend_request;

  /// No description provided for @friend_request_sent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friend_request_sent;

  /// No description provided for @friend_request_message.
  ///
  /// In en, this message translates to:
  /// **'Message with request (optional)'**
  String get friend_request_message;

  /// No description provided for @search_username.
  ///
  /// In en, this message translates to:
  /// **'Search by username'**
  String get search_username;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get user_not_found;

  /// No description provided for @already_friends.
  ///
  /// In en, this message translates to:
  /// **'Already friends'**
  String get already_friends;

  /// No description provided for @friend_request_pending.
  ///
  /// In en, this message translates to:
  /// **'Friend request pending'**
  String get friend_request_pending;

  /// No description provided for @group_name.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get group_name;

  /// No description provided for @group_description.
  ///
  /// In en, this message translates to:
  /// **'Group Description'**
  String get group_description;

  /// No description provided for @create_group.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get create_group;

  /// No description provided for @add_members.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get add_members;

  /// No description provided for @group_members.
  ///
  /// In en, this message translates to:
  /// **'Group Members'**
  String get group_members;

  /// No description provided for @group_admin.
  ///
  /// In en, this message translates to:
  /// **'Group Admin'**
  String get group_admin;

  /// No description provided for @leave_group.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get leave_group;

  /// No description provided for @leave_group_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to leave this group?'**
  String get leave_group_confirm;

  /// No description provided for @delete_group.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get delete_group;

  /// No description provided for @delete_group_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to permanently delete this group?'**
  String get delete_group_confirm;

  /// No description provided for @make_admin.
  ///
  /// In en, this message translates to:
  /// **'Make Admin'**
  String get make_admin;

  /// No description provided for @remove_member.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get remove_member;

  /// No description provided for @member_count.
  ///
  /// In en, this message translates to:
  /// **'member'**
  String get member_count;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get no_notifications;

  /// No description provided for @mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get mark_all_read;

  /// No description provided for @friend_request_notification.
  ///
  /// In en, this message translates to:
  /// **'New friend request'**
  String get friend_request_notification;

  /// No description provided for @friend_accepted_notification.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get friend_accepted_notification;

  /// No description provided for @new_message_notification.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get new_message_notification;

  /// No description provided for @group_invite_notification.
  ///
  /// In en, this message translates to:
  /// **'You were added to a group'**
  String get group_invite_notification;

  /// No description provided for @group_message_notification.
  ///
  /// In en, this message translates to:
  /// **'New group message'**
  String get group_message_notification;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @voice_message.
  ///
  /// In en, this message translates to:
  /// **'Voice Message'**
  String get voice_message;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @document_picker.
  ///
  /// In en, this message translates to:
  /// **'Document Picker'**
  String get document_picker;

  /// No description provided for @record_voice.
  ///
  /// In en, this message translates to:
  /// **'Record Voice'**
  String get record_voice;

  /// No description provided for @file_too_large.
  ///
  /// In en, this message translates to:
  /// **'File too large'**
  String get file_too_large;

  /// No description provided for @max_file_size.
  ///
  /// In en, this message translates to:
  /// **'Maximum file size'**
  String get max_file_size;

  /// No description provided for @unsupported_file.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type'**
  String get unsupported_file;

  /// No description provided for @account_settings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get account_settings;

  /// No description provided for @privacy_settings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacy_settings;

  /// No description provided for @notification_settings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notification_settings;

  /// No description provided for @language_settings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get language_settings;

  /// No description provided for @theme_settings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get theme_settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @system_mode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system_mode;

  /// No description provided for @react_to_message.
  ///
  /// In en, this message translates to:
  /// **'React to message'**
  String get react_to_message;

  /// No description provided for @reactions.
  ///
  /// In en, this message translates to:
  /// **'Reactions'**
  String get reactions;

  /// No description provided for @field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_required;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email;

  /// No description provided for @password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password too short'**
  String get password_too_short;

  /// No description provided for @passwords_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_not_match;

  /// No description provided for @username_too_short.
  ///
  /// In en, this message translates to:
  /// **'Username too short'**
  String get username_too_short;

  /// No description provided for @username_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid username'**
  String get username_invalid;

  /// No description provided for @name_too_short.
  ///
  /// In en, this message translates to:
  /// **'Name too short'**
  String get name_too_short;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet;

  /// No description provided for @connection_error.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connection_error;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get server_error;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
