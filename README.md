SwiftRestModel
==============
SwiftRestModel is a small helper class for communicating with RESTful APIs using Alamofire and SwiftyJSON.

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [HTTPStatusCodes](https://github.com/rhodgkins/SwiftHTTPStatusCodes)

## Example Project
You'll need to install [Cocoapods](http://cocoapods.org) first.

Grab the source code, and then install dependencies.
```
$ git clone git@github.com:Rentlio/SwiftRestModel.git
$ cd SwiftRestModel
$ pod install
$ open SwiftRestModel.xcworkspace
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
    encoding: ParameterEncoding.URL,
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
- encoding: ParameterEncoding.URL
- success: nil
- error: nil