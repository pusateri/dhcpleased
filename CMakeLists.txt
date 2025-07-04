cmake_minimum_required(VERSION 3.10)

project(dhcpleased)

find_package(BISON REQUIRED)
if(BISON_FOUND)
    bison_target(dhcpleased parse.y ${CMAKE_CURRENT_BINARY_DIR}/parse.tab.c)
endif()

find_package(PkgConfig)

include(CheckSymbolExists)
check_symbol_exists(timespecsub "sys/time.h" HAVE_TIMESPECSUB)
check_symbol_exists(reallocarray "stdlib.h" HAVE_REALLOCARRAY)
check_symbol_exists(__OpenBSD__ "stdio.h" HAVE_OPENBSD)

set(
    HEADER_FILES
    bpf.h
    checksum.h
    control.h
    dhcpleased.h
    engine.h
    frontend.h
    log.h
)

if(NOT HAVE_OPENBSD)
    add_library(
        compat 
        compat/imsg-buffer.c
        compat/imsg.c
        compat/imsg.h
        compat/queue.h
        compat/reallocarray.c
        compat/reallocarray.h
    )
endif()

if(HAVE_REALLOCARRAY)
    list(APPEND CMAKE_C_FLAGS "-DHAVE_REALLOCARRAY")
endif()

if(HAVE_TIMESPECSUB)
    list(APPEND CMAKE_C_FLAGS "-DHAVE_TIMESPECSUB")
else()
    add_library(
        timespec
        timespec/timespec.c
        timespec/timespec.h
    )
endif()

list(JOIN CMAKE_C_FLAGS " " CMAKE_C_FLAGS)

add_executable(
    dhcpleased
    bpf.c
    checksum.c
    control.c
    dhcpleased.c
    engine.c
    frontend.c
    log.c
    printconf.c
    ${HEADER_FILES}
    ${BISON_dhcpleased_OUTPUTS}
)

pkg_check_modules(LIBEVENT REQUIRED libevent)

target_include_directories(
    dhcpleased
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
    PRIVATE ${LIBEVENT_INCLUDE_DIRS}
)

if(NOT HAVE_OPENBSD)
    target_include_directories(
        dhcpleased
        PRIVATE compat
    )
endif()

if(NOT HAVE_TIMESPECSUB)
    target_include_directories(
        dhcpleased
        PRIVATE timespec
    )
endif()

if(HAVE_OPENBSD)
    target_link_libraries(dhcpleased util)
else()
    target_link_libraries(dhcpleased compat)
endif()

if(NOT HAVE_TIMESPECSUB)
    target_link_libraries(dhcpleased timespec)
endif()

target_link_libraries(dhcpleased ${LIBEVENT_LDFLAGS})
