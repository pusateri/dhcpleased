# dhcpleased
Portable version of OpenBSD dhcpleased.

- [x] Builds on FreeBSD 15
- [x] Obtains DHCP lease on FreeBSD 15
- [x] Builds on macOS 15 Sequoia
- [ ] Obtains DHCP lease on macOS 15 Sequoia

## Dependencies

### FreeBSD
```
pkg install cmake
pkg install pkgconf
pkg install libevent
```

### macOS
```
brew install cmake
brew install pkgconf
brew install libevent
```

## Build instructions

```sh
git submodule update --init
cmake -B build
cd build
cmake --build .
```
