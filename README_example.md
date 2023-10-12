# App name
App description.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [API Documentation](#api-documentation)
- [Known Issues](#known-issues)

## Installation
There are 2 flavors: dev and prod. Flavors are defined for this project, configuration for studio is located in **.run** folder. Internal configs are defined in **app_config.dart** file.  
Additional run agrs for flavor **prod** example: *--dart-define envFlavor=prod*

**keystore** file and **properties** file for Android are included in the repo.

## Usage
1. Before building an app do not forget to *increase build number* (and version if needed).  
   Run ***increment_build_number.sh*** script before every new build.  
   Usage example:  
   *zsh increment_build_number.sh*

2. You should add flavors to flutter commands, for example:  
   *flutter build ios --dart-define=envFlavor=dev --flavor dev*

### iOS Package Name
The package name for the iOS version of the app:  
[ios package name for prod] - prod  
[ios package name for dev] - dev  
There are 2 apps located on a [account name] apple developer account.

### Android Package Name
The package name for the Android version of the app:  
[android package name for prod] - prod  
[android package name for dev] - dev  

## Dependencies
A list of any external libraries or frameworks that the project relies on, along with their versions.

## API Documentation
[Figma designs](...)  
[Api docs](...)
[Figma widgets decomposition](...)
...

## Coding conventions 
Project is build based on clean architecture. State management: BLoC (cubit).

## Known Issues
...

## Testing
Currently to automated tests.
