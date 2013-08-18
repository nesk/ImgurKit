# JPImgurKit

__JPImgurKit__ is an Objective-C library created to easily handle [Imgur](http://imgur.com) API requests within iOS and OS X apps, it is built on [AFNetworking](http://afnetworking.com/) and its [OAuth extension](https://github.com/AFNetworking/AFOAuth2Client). The project is at an early stage, I'm currently prototyping the classes so __don't use this library__ unless you want to test it.

## Todo

This todo list currently exists to list specific aspects of the library, not all the endpoints of the [Imgur API](http://api.imgur.com/) that should be handled.

### Whole project

* Must redefine the classes prefix, `JPImgur` is to long, `JPIK` could be a better solution
* Rework indentation

### All models

* Must use the error parameter of the `JSONObjectWithData:options:error:` from the `NSJSONSerialization` class

## Album and Image models

* The non-basic classes should return non-basic images but this requires to make two request to Imgur, the user must be warned about this

### JPImgurClient

* Enable anonymous navigation
* Add rate limits informations

### JPImgurBasicAlbum

* Should the `deletehash` property be in read/write access?

### JPImgurAlbum

* An album could be incomplete, this must be handled (see the [Album model](http://api.imgur.com/models/album))

### JPImgurImage

* Add a progress callback for file uploads (impossible for URL uploads)

### Tests

* The `testAuthenticateUsingOAuthWithPIN` method must handle iOS
* Add a test for the `URLWithSize` method from the `JPImgurBasicImage` class