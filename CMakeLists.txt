cmake_minimum_required(VERSION 3.10)

project(dhcpleased)

find_package(BISON)

if(BISON_FOUND)
  bison_target(dhcpleased parse.y ${CMAKE_CURRENT_BINARY_DIR}/parse.tab.c)
endif()

include_directories(/usr/local/include)
link_directories(/usr/local/lib)

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

add_library(
	compat 
	compat/imsg-buffer.c
	compat/imsg.c
	compat/imsg.h
	compat/queue.h
)

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

target_include_directories(dhcpleased PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(dhcpleased PRIVATE compat)
target_link_libraries(dhcpleased compat event)
