# dhcpleased
Portable version of OpenBSD dhcpleased.

- [x] Builds on OpenBSD 7.7
- [ ] Obtains DHCP lease on OpenBSD 7.7
- [x] Builds on FreeBSD 15
- [x] Obtains DHCP lease on FreeBSD 15
- [x] Builds on macOS 15 Sequoia
- [ ] Obtains DHCP lease on macOS 15 Sequoia

## Dependencies

### OpenBSD
```
pkg_add bison cmake libevent pkgconf
```

### FreeBSD
```
pkg install bison cmake libevent pkgconf
```

### macOS
```
brew install bison cmake libevent pkgconf
```

## Build instructions

```sh
git submodule update --init
cmake -B build
cd build
cmake --build .
```
