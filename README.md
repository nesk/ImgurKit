# JPImgurKit

__JPImgurKit__ is an Objective-C library created to easily handle [Imgur](http://imgur.com) API requests within iOS and OS X apps, it is built on [AFNetworking](http://afnetworking.com/) and its [OAuth extension](https://github.com/AFNetworking/AFOAuth2Client). The project is at an early stage, I'm currently prototyping the classes so __don't use this library__ unless you want to test it.

## Todo

This todo list currently exists to list specific aspects of the library, not all the endpoints of the [Imgur API](http://api.imgur.com/) that should be handled.

### All classes

* In case of overload (error >500), the requests should be resend a couple of time
* If the overload still persists, an error should be returned through the `failure` block

### All models

* Create a method to only specify the ID (will be useful later but that's pretty hard to explain with my English level...)
* Allow only one execution of the `setObjectPropertiesWithJSONObject:` to initialize the object (this will probably need a pretty big rework of all the models)
* Must use the error parameter of the `JSONObjectWithData:options:error:` from the `NSJSONSerialization` class

### JPImgurClient

* Enable anonymous navigation

### JPImgurBasicAlbum

* Should the `deletehash` property be in read/write access?

### JPImgurAlbum

* An album could be incomplete, this must be handled (see the [Album model](http://api.imgur.com/models/album))

### JPImgurImage

* Add a progress callback for file uploads (impossible for URL uploads)

### Tests

* The `testAuthenticateUsingOAuthWithPIN` method must handle iOS
* Add a test for the `URLWithSize` method from the `JPImgurBasicImage` class