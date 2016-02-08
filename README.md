SwiftRestModel
==============

[![Build Status](https://travis-ci.org/Rentlio/SwiftRestModel.svg?branch=master)](https://travis-ci.org/Rentlio/SwiftRestModel)

SwiftRestModel is a small helper class for communicating with RESTful APIs using Alamofire and SwiftyJSON.

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [HTTPStatusCodes](https://github.com/rhodgkins/SwiftHTTPStatusCodes)

## Integration

You can use [Cocoapods](http://cocoapods.org) to install `SwiftRestModel` by adding it to your `Podfile`:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'SwiftRestModel'
```

## Example Project
You'll need to install [Cocoapods](http://cocoapods.org) first.

Grab the source code, and then install dependencies.
```bash
$ git clone git@github.com:Rentlio/SwiftRestModel.git
$ cd SwiftRestModel
$ pod install
$ open SwiftRestModel.xcworkspace
```

App Transport Security is blocking a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Basic Usage

#### Making a Request
```swift
let model = SwiftRestModel(rootUrl: "http://jsonplaceholder.typicode.com/posts")

model.fetch()
// GET "/posts"
```

#### Success Handling
```swift
model.fetch(success: {
    response in
    print(response)
    // or print(model.data)
})
```

#### Error Handling
```swift
model.fetch(error: {
    response in
    print(response)
})
```

## Methods
- fetch()
- save()
- destory()
- request()

#### Create
```swift
model.save(data: ["foo": "bar"])
// POST "/posts" {foo: bar}
```

Default parameters:
- data: [:]
- [encoding](https://github.com/Alamofire/Alamofire#parameter-encoding): .JSON
- success: nil
- error: nil

#### Read
```swift
model.fetch(data: ["foo": "bar"])
// GET "/posts?foo=bar"
```

Default parameters:
- data: [:]
- success: nil
- error: nil

#### Update
```swift
model.data["id"] = 1

model.save(data: ["foo": "bar"])
// PUT "/posts/1" {foo: bar}
```

Default parameters:
- data: [:]
- [encoding](https://github.com/Alamofire/Alamofire#parameter-encoding): .JSON
- success: nil
- error: nil

#### Delete
```swift
model.destroy()
// DELETE "/posts/1"
```

Default parameters:
- success: nil
- error: nil

#### Request
```swift
model.request(
    method  : "get",
    url     : "http://jsonplaceholder.typicode.com/posts",
    data    : ["foo": "bar"],
    headers : ["Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="],
    encoding: .URL,
    success : {
        response in
        print(response)
    },
    error   : {
        response in
        print(response)
    }
)
// GET "/posts?foo=bar"
```

Default parameters:
- method: "get"
- url: ""
- data: [:]
- headers: [:]
- [encoding](https://github.com/Alamofire/Alamofire#parameter-encoding): .URL
- success: nil
- error: nil

## Models
Subclass SwiftRestModel to organize your API models

```swift
class Posts: SwiftRestModel {
    
    let url = "http://jsonplaceholder.typicode.com/posts"
    
    init() {
        super.init(rootUrl: self.url)
    }
    
    // Custom Endpoint
    func fetchFirst(data data: Dictionary<String, AnyObject> = [:], success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        self.request(method: "get", url: self.rootUrl + "/first", data: data, success: success, error: error)
    }
    
}
```

```swift
let posts = Posts()

posts.fetch()
// GET "/posts"

posts.fetchFirst()
// GET "/posts/first"

posts.fetchFirst(
    data   : ["foo": "bar"],
    success: {
        response in
        print(response)
    },
    error  : {
        response in
        print(response)
    }
)
// GET "/posts/first?foo=bar"
```

## Branches

- master - The production branch. Clone or fork this repository for the latest copy.
- develop - The active development branch. Pull requests should be directed to this branch.

## Contribution

Ready to submit a fix or a feature? Submit a pull request! And _please_:

- If code changes, run the tests and make sure everything still works.
- Write new tests for new functionality.
- Update documentation comments where applicable.
- Maintain the existing style.

## Contact

- [Juraj Hilje](https://github.com/jurajhilje), [@juraj_hilje](https://twitter.com/juraj_hilje)

## License
See [LICENSE](https://github.com/Rentlio/SwiftRestModel/blob/master/LICENSE).