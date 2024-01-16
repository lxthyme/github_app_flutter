import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart' deferred as app_localizations_en;
import 'app_localizations_zh.dart' deferred as app_localizations_zh;

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome To Flutter'**
  String get welcomeMessage;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'GSYGithubApp'**
  String get app_name;

  /// No description provided for @app_ok.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get app_ok;

  /// No description provided for @app_cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get app_cancel;

  /// No description provided for @app_empty.
  ///
  /// In en, this message translates to:
  /// **'Empty(oﾟ▽ﾟ)o'**
  String get app_empty;

  /// No description provided for @app_licenses.
  ///
  /// In en, this message translates to:
  /// **'licenses'**
  String get app_licenses;

  /// No description provided for @app_close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get app_close;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'version'**
  String get app_version;

  /// No description provided for @app_back_tip.
  ///
  /// In en, this message translates to:
  /// **'Exit？'**
  String get app_back_tip;

  /// No description provided for @app_not_new_version.
  ///
  /// In en, this message translates to:
  /// **'No new version.'**
  String get app_not_new_version;

  /// No description provided for @app_version_title.
  ///
  /// In en, this message translates to:
  /// **'Update Version'**
  String get app_version_title;

  /// No description provided for @nothing_now.
  ///
  /// In en, this message translates to:
  /// **'Nothing'**
  String get nothing_now;

  /// No description provided for @loading_text.
  ///
  /// In en, this message translates to:
  /// **'Loading···'**
  String get loading_text;

  /// No description provided for @option_web.
  ///
  /// In en, this message translates to:
  /// **'browser'**
  String get option_web;

  /// No description provided for @option_copy.
  ///
  /// In en, this message translates to:
  /// **'copy'**
  String get option_copy;

  /// No description provided for @option_share.
  ///
  /// In en, this message translates to:
  /// **'share'**
  String get option_share;

  /// No description provided for @option_web_launcher_error.
  ///
  /// In en, this message translates to:
  /// **'url error'**
  String get option_web_launcher_error;

  /// No description provided for @option_share_title.
  ///
  /// In en, this message translates to:
  /// **'share form GSYGitHubFlutter： '**
  String get option_share_title;

  /// No description provided for @option_share_copy_success.
  ///
  /// In en, this message translates to:
  /// **'Copy Success'**
  String get option_share_copy_success;

  /// No description provided for @login_text.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_text;

  /// No description provided for @oauth_text.
  ///
  /// In en, this message translates to:
  /// **'OAuth'**
  String get oauth_text;

  /// No description provided for @login_out.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get login_out;

  /// No description provided for @login_deprecated.
  ///
  /// In en, this message translates to:
  /// **'The API via password authentication will remove on November 13, 2020 by Github'**
  String get login_deprecated;

  /// No description provided for @home_reply.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get home_reply;

  /// No description provided for @home_change_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get home_change_language;

  /// No description provided for @home_change_grey.
  ///
  /// In en, this message translates to:
  /// **'Grey App'**
  String get home_change_grey;

  /// No description provided for @home_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get home_about;

  /// No description provided for @home_check_update.
  ///
  /// In en, this message translates to:
  /// **'CheckUpdate'**
  String get home_check_update;

  /// No description provided for @home_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get home_history;

  /// No description provided for @home_user_info.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get home_user_info;

  /// No description provided for @home_change_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get home_change_theme;

  /// No description provided for @home_language_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get home_language_default;

  /// No description provided for @home_language_zh.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get home_language_zh;

  /// No description provided for @home_language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get home_language_en;

  /// No description provided for @switch_language.
  ///
  /// In en, this message translates to:
  /// **'select language'**
  String get switch_language;

  /// No description provided for @home_theme_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get home_theme_default;

  /// No description provided for @home_theme_1.
  ///
  /// In en, this message translates to:
  /// **'Theme1'**
  String get home_theme_1;

  /// No description provided for @home_theme_2.
  ///
  /// In en, this message translates to:
  /// **'Theme2'**
  String get home_theme_2;

  /// No description provided for @home_theme_3.
  ///
  /// In en, this message translates to:
  /// **'Theme3'**
  String get home_theme_3;

  /// No description provided for @home_theme_4.
  ///
  /// In en, this message translates to:
  /// **'Theme4'**
  String get home_theme_4;

  /// No description provided for @home_theme_5.
  ///
  /// In en, this message translates to:
  /// **'Theme5'**
  String get home_theme_5;

  /// No description provided for @home_theme_6.
  ///
  /// In en, this message translates to:
  /// **'Theme6'**
  String get home_theme_6;

  /// No description provided for @login_username_hint_text.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get login_username_hint_text;

  /// No description provided for @login_password_hint_text.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get login_password_hint_text;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login Success'**
  String get login_success;

  /// No description provided for @network_error_401.
  ///
  /// In en, this message translates to:
  /// **'Http 401'**
  String get network_error_401;

  /// No description provided for @network_error_403.
  ///
  /// In en, this message translates to:
  /// **'Http 403'**
  String get network_error_403;

  /// No description provided for @network_error_404.
  ///
  /// In en, this message translates to:
  /// **'Http 404'**
  String get network_error_404;

  /// No description provided for @network_error_422.
  ///
  /// In en, this message translates to:
  /// **'Request Body Error，Please Check Github ClientId or Account/PW'**
  String get network_error_422;

  /// No description provided for @network_error_timeout.
  ///
  /// In en, this message translates to:
  /// **'Http timeout'**
  String get network_error_timeout;

  /// No description provided for @network_error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Http unknown error'**
  String get network_error_unknown;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'network error'**
  String get network_error;

  /// No description provided for @github_refused.
  ///
  /// In en, this message translates to:
  /// **'Github Api Error[OS Error: Connection refused]. Please switch networks or try again later '**
  String get github_refused;

  /// No description provided for @load_more_not.
  ///
  /// In en, this message translates to:
  /// **'nothing'**
  String get load_more_not;

  /// No description provided for @load_more_text.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get load_more_text;

  /// No description provided for @home_dynamic.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get home_dynamic;

  /// No description provided for @home_trend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get home_trend;

  /// No description provided for @home_my.
  ///
  /// In en, this message translates to:
  /// **'My'**
  String get home_my;

  /// No description provided for @trend_user_title.
  ///
  /// In en, this message translates to:
  /// **'China User Trend'**
  String get trend_user_title;

  /// No description provided for @trend_day.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get trend_day;

  /// No description provided for @trend_week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get trend_week;

  /// No description provided for @trend_month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get trend_month;

  /// No description provided for @trend_all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get trend_all;

  /// No description provided for @user_tab_repos.
  ///
  /// In en, this message translates to:
  /// **'repos'**
  String get user_tab_repos;

  /// No description provided for @user_tab_fans.
  ///
  /// In en, this message translates to:
  /// **'fan'**
  String get user_tab_fans;

  /// No description provided for @user_tab_focus.
  ///
  /// In en, this message translates to:
  /// **'focus'**
  String get user_tab_focus;

  /// No description provided for @user_tab_star.
  ///
  /// In en, this message translates to:
  /// **'star'**
  String get user_tab_star;

  /// No description provided for @user_tab_honor.
  ///
  /// In en, this message translates to:
  /// **'honor'**
  String get user_tab_honor;

  /// No description provided for @user_dynamic_group.
  ///
  /// In en, this message translates to:
  /// **'Members,'**
  String get user_dynamic_group;

  /// No description provided for @user_dynamic_title.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get user_dynamic_title;

  /// No description provided for @user_focus.
  ///
  /// In en, this message translates to:
  /// **'Focused'**
  String get user_focus;

  /// No description provided for @user_un_focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get user_un_focus;

  /// No description provided for @user_focus_no_support.
  ///
  /// In en, this message translates to:
  /// **'Not Support。'**
  String get user_focus_no_support;

  /// No description provided for @user_create_at.
  ///
  /// In en, this message translates to:
  /// **'Create at：'**
  String get user_create_at;

  /// No description provided for @user_orgs_title.
  ///
  /// In en, this message translates to:
  /// **'organization'**
  String get user_orgs_title;

  /// No description provided for @repos_tab_readme.
  ///
  /// In en, this message translates to:
  /// **'readme'**
  String get repos_tab_readme;

  /// No description provided for @repos_tab_info.
  ///
  /// In en, this message translates to:
  /// **'info'**
  String get repos_tab_info;

  /// No description provided for @repos_tab_file.
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get repos_tab_file;

  /// No description provided for @repos_tab_issue.
  ///
  /// In en, this message translates to:
  /// **'issue'**
  String get repos_tab_issue;

  /// No description provided for @repos_tab_activity.
  ///
  /// In en, this message translates to:
  /// **'activity'**
  String get repos_tab_activity;

  /// No description provided for @repos_tab_commits.
  ///
  /// In en, this message translates to:
  /// **'commits'**
  String get repos_tab_commits;

  /// No description provided for @repos_tab_issue_all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get repos_tab_issue_all;

  /// No description provided for @repos_tab_issue_open.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get repos_tab_issue_open;

  /// No description provided for @repos_tab_issue_closed.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get repos_tab_issue_closed;

  /// No description provided for @repos_option_release.
  ///
  /// In en, this message translates to:
  /// **'release'**
  String get repos_option_release;

  /// No description provided for @repos_option_branch.
  ///
  /// In en, this message translates to:
  /// **'branch'**
  String get repos_option_branch;

  /// No description provided for @repos_fork_at.
  ///
  /// In en, this message translates to:
  /// **'Fork at '**
  String get repos_fork_at;

  /// No description provided for @repos_create_at.
  ///
  /// In en, this message translates to:
  /// **'create at '**
  String get repos_create_at;

  /// No description provided for @repos_last_commit.
  ///
  /// In en, this message translates to:
  /// **'last commit at '**
  String get repos_last_commit;

  /// No description provided for @repos_all_issue_count.
  ///
  /// In en, this message translates to:
  /// **'all Issue：'**
  String get repos_all_issue_count;

  /// No description provided for @repos_open_issue_count.
  ///
  /// In en, this message translates to:
  /// **'open Issue：'**
  String get repos_open_issue_count;

  /// No description provided for @repos_close_issue_count.
  ///
  /// In en, this message translates to:
  /// **'close Issue：'**
  String get repos_close_issue_count;

  /// No description provided for @repos_issue_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get repos_issue_search;

  /// No description provided for @repos_no_support_issue.
  ///
  /// In en, this message translates to:
  /// **'No Supprot Issue'**
  String get repos_no_support_issue;

  /// No description provided for @issue_reply.
  ///
  /// In en, this message translates to:
  /// **'reply'**
  String get issue_reply;

  /// No description provided for @issue_edit.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get issue_edit;

  /// No description provided for @issue_open.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get issue_open;

  /// No description provided for @issue_close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get issue_close;

  /// No description provided for @issue_lock.
  ///
  /// In en, this message translates to:
  /// **'lock'**
  String get issue_lock;

  /// No description provided for @issue_unlock.
  ///
  /// In en, this message translates to:
  /// **'unlock'**
  String get issue_unlock;

  /// No description provided for @issue_reply_issue.
  ///
  /// In en, this message translates to:
  /// **'reply Issue'**
  String get issue_reply_issue;

  /// No description provided for @issue_commit_issue.
  ///
  /// In en, this message translates to:
  /// **'commit Issue'**
  String get issue_commit_issue;

  /// No description provided for @issue_edit_issue.
  ///
  /// In en, this message translates to:
  /// **'edit issue'**
  String get issue_edit_issue;

  /// No description provided for @issue_edit_issue_commit.
  ///
  /// In en, this message translates to:
  /// **'edit reply'**
  String get issue_edit_issue_commit;

  /// No description provided for @issue_edit_issue_edit_commit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get issue_edit_issue_edit_commit;

  /// No description provided for @issue_edit_issue_delete_commit.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get issue_edit_issue_delete_commit;

  /// No description provided for @issue_edit_issue_copy_commit.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get issue_edit_issue_copy_commit;

  /// No description provided for @issue_edit_issue_content_not_be_null.
  ///
  /// In en, this message translates to:
  /// **'Could\'t not be empty'**
  String get issue_edit_issue_content_not_be_null;

  /// No description provided for @issue_edit_issue_title_not_be_null.
  ///
  /// In en, this message translates to:
  /// **'Could\'t not be empty'**
  String get issue_edit_issue_title_not_be_null;

  /// No description provided for @issue_edit_issue_title_tip.
  ///
  /// In en, this message translates to:
  /// **'please input title'**
  String get issue_edit_issue_title_tip;

  /// No description provided for @issue_edit_issue_content_tip.
  ///
  /// In en, this message translates to:
  /// **'please input content'**
  String get issue_edit_issue_content_tip;

  /// No description provided for @notify_title.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notify_title;

  /// No description provided for @notify_tab_all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get notify_tab_all;

  /// No description provided for @notify_tab_part.
  ///
  /// In en, this message translates to:
  /// **'part'**
  String get notify_tab_part;

  /// No description provided for @notify_tab_unread.
  ///
  /// In en, this message translates to:
  /// **'unread'**
  String get notify_tab_unread;

  /// No description provided for @notify_unread.
  ///
  /// In en, this message translates to:
  /// **'unread'**
  String get notify_unread;

  /// No description provided for @notify_readed.
  ///
  /// In en, this message translates to:
  /// **'read'**
  String get notify_readed;

  /// No description provided for @notify_status.
  ///
  /// In en, this message translates to:
  /// **'status'**
  String get notify_status;

  /// No description provided for @notify_type.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get notify_type;

  /// No description provided for @search_title.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_title;

  /// No description provided for @search_tab_repos.
  ///
  /// In en, this message translates to:
  /// **'Repos'**
  String get search_tab_repos;

  /// No description provided for @search_tab_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get search_tab_user;

  /// No description provided for @release_tab_release.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get release_tab_release;

  /// No description provided for @release_tab_tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get release_tab_tag;

  /// No description provided for @user_profile_name.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get user_profile_name;

  /// No description provided for @user_profile_email.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get user_profile_email;

  /// No description provided for @user_profile_link.
  ///
  /// In en, this message translates to:
  /// **'link'**
  String get user_profile_link;

  /// No description provided for @user_profile_org.
  ///
  /// In en, this message translates to:
  /// **'company'**
  String get user_profile_org;

  /// No description provided for @user_profile_location.
  ///
  /// In en, this message translates to:
  /// **'location'**
  String get user_profile_location;

  /// No description provided for @user_profile_info.
  ///
  /// In en, this message translates to:
  /// **'info'**
  String get user_profile_info;

  /// No description provided for @search_type.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get search_type;

  /// No description provided for @search_sort.
  ///
  /// In en, this message translates to:
  /// **'sort'**
  String get search_sort;

  /// No description provided for @search_language.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get search_language;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return lookupAppLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

Future<AppLocalizations> lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return app_localizations_en.loadLibrary().then((dynamic _) => app_localizations_en.AppLocalizationsEn());
    case 'zh': return app_localizations_zh.loadLibrary().then((dynamic _) => app_localizations_zh.AppLocalizationsZh());
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
