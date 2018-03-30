# Blizanac

Blizanac means "twin" in Croatian.  This app will find your celebrity doppelganger or look-alike.  Take or select a photo and the app will use machine learning technology to show you which celebrity you most look like and the confidence (percentage) of the match.

## Prerequisites
You will need a phone with a camera and an internet connection.  Because of the size of the machine learning file, you will need at least 750 mb of space on your phone.

## Installation
Open the Blizanac.xcworkspace file in Xcode, connect a phone to the computer, build the project, and run it on the phone.


Please download the celebface.mlmodel file separately, move it into the /Blizanac/Blizanac/ directory (same level as the AppDelegate.swift file) before building and running the project in Xcode.  The approximately 580 mb mlmodel file can be downloaded here: [Google Drive link](https://drive.google.com/open?id=13c_FtvSMpReY0Lf35RUVR_XTjtpktziK).

## Usage
After starting Blizanac, tap on either the "Take a selfie" or "Photo Library" button to select a photo.  When you are done cropping the photo, tap on "Use Photo" and the app will present the results to you.  The results will include your photo, the percentage and name of the celebrity match, as well as an image and summary of the celebrity from wikipedia (if available).

If the photo does not match a celebrity or the match is less than 1%, you will have to try again.  For best results, use tightly cropped photos and try to get as much of the face as possible in the frame.

Blizanac will save and persist each successful result into a table view for later viewing.  To access the table view, go to the main menu and tap on "Recent".  You can also delete entries in the table view by swiping.

## Built With
 - CoreML, Vision - Apple's machine learning frameworks
 - RealmSwift - for data persistence
 - Alamofire - networking library
 - SwiftyJSON - JSON parsing library
 - SDWebImage - asynchronous image downloader
 - ChameleonFramework - color framework for iOS

## License
Copyright (c) 2018 Brian Jahng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Acknowledgments
Blizanac uses the VGG Face CNN descriptor model (Caffe) trained from using 2.6 million images of celebrities collected from the web.

Deep Face Recognition
Omkar M. Parkhi, Andrea Vedaldi, Andrew Zisserman
BMVC 2015
http://www.robots.ox.ac.uk/~vgg/software/vgg_face/
