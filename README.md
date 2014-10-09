# UCmFit

This projects shows an example of using both historical and live data from the CoreMotion MotionActivity and Step Counting APIs. Additionally accelerometer, rotation, and GPS data are collected and written to a file in documents. The data is then presented in app laying out a daily diary of a user's motion activity.

## Structure

The project consists of two main views and a 3 classes describing a ranged query (AAPLMotionActivityQuery), the data model (AAPLActivityDataManager), and an activity segment (AAPLSignificantActivity) respectively.  They are:
1. AAPLMasterViewController.{h,m}
2. AAPLDetailViewController.{h,m}
3. AAPLMotionActivityQuery.{h,m}
4. AAPLActivityDataManager.{h,m}

## What's Important

The AAPLActivityDataManager controls all requests to the motion activity and step counting APIs and this is where you should start first.  In this class we will go over:
1. Checking for API availability
2. Checking for Motion Activity authorization.
3. Querying for historical activity (this is how your app gains access to data that was accumulated when your app is not in the foreground)
4. Requesting live updates.

In addition, we present some simple filtering mechanisms that we encourage you to play around with.

## Requirements

### Build

IOS 7 SDK

### Runtime

IOS 7 SDK or later
