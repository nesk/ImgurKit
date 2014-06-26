The development of this project has stopped. However, Geoff MacDonald refactored it into a new project named [ImgurSession](https://github.com/geoffmacd/ImgurSession), go check it out.

# ImgurKit

__ImgurKit__ is an Objective-C library created to easily handle [Imgur](http://imgur.com) API requests within iOS and OS X apps, it is built on [AFNetworking](http://afnetworking.com/) and its [OAuth extension](https://github.com/AFNetworking/AFOAuth2Client). [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) is also used to provide some easily chainable asynchronous methods. The project is at an early stage, I'm currently prototyping the classes so __don't use this library__ unless you want to test it.

## Todo

This todo list currently exists to list specific aspects of the library, not all the endpoints of the [Imgur API](http://api.imgur.com/) that should be handled.

### Whole project

* Rework indentation
* Add some source-code documentation for every class/method. Probably based on [appledoc](http://gentlebytes.com/appledoc/) syntax.

### Album and Image models

* The non-basic classes should return non-basic albums/images but this requires to make two request to Imgur, the user must be warned about this

### IKClient

* Enable anonymous navigation
* Add rate limits informations
* The various `sharedInstance...` class methods are confusing. They must be removed and replaced by a single method.

### IKAlbum

* An album could be incomplete, this must be handled (see the [Album model](http://api.imgur.com/models/album))

### IKImage

* Add a progress callback for file uploads (impossible for URL uploads)

### Tests

* The `testAuthenticateUsingOAuthWithPIN` method must handle iOS
* Add a test for the `URLWithSize` method from the `IKBasicImage` class
* Add a library to provide promises, which will simplify the tests. Once the library is added, the `testAuthorizationURLAsync` test should be rewrite to use all the authentication types available.
