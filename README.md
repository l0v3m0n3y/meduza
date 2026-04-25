# meduza
web api for meduza.io Meduza is an independent media outlet covering Russia and the world. What's inside: • Top news of the day 
# main
```swift
import Foundation
import meduza
let client = Meduza()

do {
    let news = try await client.get_news()
    print(news)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
