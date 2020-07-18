# stronk
[![Build Status](https://dev.azure.com/kkjasoncheung/stronk-mobile/_apis/build/status/not-monday.mobile?branchName=master)](https://dev.azure.com/kkjasoncheung/stronk-mobile/_build/latest?definitionId=2&branchName=master)

This is the mobile app for stronk!
More details to come :)

## Getting Started

### Setting up firebase
1. Make sure you have a Firebase project set up
2. Follow the instructions [here](https://firebase.google.com/docs/flutter/setup?platform=android) to add this app to your project
3. Download the `google-services.json` file and copy it to `android/app`
4. Run the build utility to generate necessary modules
```
# for one time builds
flutter pub run build_runner build

# for a watcher that generates files each time there's a change
flutter pub run build_runner watch
```



### Setting up backend (for dev)
1. Make sure you have the [Stronk backend](https://github.com/not-monday/stronk-backend) running
2. Copy the `config_example` and rename it `config.yml`
3. Fill in the fields

## TODO
- Firebase auth needs to be set up for IOS as well. Unfortunately, I don't have a mac to test this