## HOW TO USE TEMPLATE

### 1. COPY FILES TO THE NEW PROJECT
1. **.run and .vscode folder** to the root of the project
2. **localization_gen.sh** to the root of the project
3. **lib folder** to the root of the project
4. **assets and fonts folder** to the root of the project
5. **desired content from pubspec.yaml** to the pubspec.yaml

### 2. GET PACKAGES

### 3. FIX IMPORTS ACCORDING TO THE NEW PROJECT

### 4. CONFIG STYLES (FONTS, COLORS, PIXEL RESIZER..)

### 5. CONFIG APP_CONFIG.DART

### 6. DELETE EVERYTHING YOU DO NOT NEED

# A Clean Architecture Template for Flutter App

This template is made to minimize the efforts of new project creation and configuration. It has pre-installed packages (which will be listed below), flavors and some base helper classes.

This project is also a clean architecture structure demo.

**/features/sample_feature** is an example of file structure and configuration of a real app feature.
## Flavors

This project has **prod** and **dev** flavors installed. They will be imported to the development environment via **.run** & **.vscode** folders. Configuration for each flavor can be customized in **app_config.dart** file.

IOS flavors need to be additionaly configured in XCode. [This article can be used.](https://medium.com/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b)
## Packages
**The core packages are:**
- [dio](https://pub.dev/packages/dio)
- [get_it](https://pub.dev/packages/get_it) (our service locator)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [equatable](https://pub.dev/packages/equatable)
- [internet_connection_checker](https://pub.dev/packages/internet_connection_checker) (for internet error processing).

**The helper packages:**
- [easy_localization](https://pub.dev/packages/easy_localization) & [easy_localization_loader](https://pub.dev/packages/easy_localization_loader) (used for localization)
- [responsive_sizer](https://pub.dev/packages/responsive_sizer) (You can customize num extension in **/core/util/pixel_sizer.dart**. Here you can set the figma layout height/width and make widgets more responsive, e.g. SizedBox(height: 20.ph))
- [bot_toast](https://pub.dev/packages/bot_toast) (used for showing snackbars etc without context)
- [flutter_svg](https://pub.dev/packages/flutter_svg)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
## Helper classes
### Requests handling
There is a bunch of classes for handling requests. 

**/core/errors** & **core/models** - some models for error handling and **RepositoryRequestHandler** (example is in the **sample_feature**). In models folder general models for the whole project can be stored.

**/core/interceptors** - some request interceptors such as error processing tool **ErrorLoggerInterceptor** or a class for authorization token incerceptor which can be connected to the shared preferences local repository.

**/core/network** - a tool for internet connection checking.
### Style classes
**/core/style** - colors, paddings, borders, text styles etc. *Example of text style usage: Text("My text", style: fontInstanse.s14.w600.black).*
### Other helper tools
**/core/helper** - storage config, images and icons listing, extensions, text masks etc.

**/core/util** - tools for opening urls, pop ups, bottom sheets, showing notifications via bot_toast etc. 
There is also a **PaginationScrollController** [class for infinite pagination on scroll, I have an article about it.](https://medium.com/@m1nori/flutter-pagination-without-any-packages-8c24095555b3)

There is a tool in the root of the project called **localization_gen.sh** - it can be used to make translations generation process easier. Run it in the terminal after you've added a new key-value pair to a translation file.
### Widgets
**/core/widgets** is used to store general widgets, like base app bars, text fields, pop up templates etc. It already includes a **CvgIcon** and **CIcon** widgets, which seem to me pretty useful.

