# Bisto Challenge

This is a small project to fulfill [Bitso's](https://bitso.com/) iOS Developer challenge.

## Runing Instructions
The project uses SPM as a package manager. So it's just necessary to make sure all packages are installed (there are only two).

## Architecture
This project, given it's small complexity, uses an MVVM pattern with a small twist. It takes some characteristics from [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture), by using a `ViewModelProtocol`
```
protocol ViewModel: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    func send(action: Action)
}
```
This allows the `View` to send all necessary view-layer event to the view model via the `.send(action: Action)` method. This just simplifys communication by creating a very straightforward way of communication. Likewise, the UI can act accordonaly depending on the `State`. Can be specially useful if combined with associated values, to reduce the amount of necessary `@Published` properties.

## Testing
There are test coverage in place for:
* String formatting
* Cache solution
* Artwork List View Model
* Artowrk + Artist Details View Model

## TODO
There are still some points worth fixing
* Better cache strategy: Even though the cache works as expected, since there is no "expiration date", and the artworks endpoint it's constantly getting updated, it can happen that the cache response becomes very outdated.
  * Solution: Add a network-check to determine if at app start there's internet connection, if so then just rely on that to fetch the most up-to-date data and just otherwise and, while the app is in use, rely on the cache. 
