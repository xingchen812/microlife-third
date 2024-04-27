if(NOT PROJECT_MICROLIFE_THIRD_ROOT)
    message(FATAL_ERROR "Variable PROJECT_MICROLIFE_THIRD_ROOT is not defined!")
endif()

file(GLOB PROJECT_MICROLIFE_THIRD_LUA_SRC ${PROJECT_MICROLIFE_THIRD_ROOT}/lua/src/*.c)
list(FILTER PROJECT_MICROLIFE_THIRD_LUA_SRC EXCLUDE REGEX "src/luac\\.c$")
list(FILTER PROJECT_MICROLIFE_THIRD_LUA_SRC EXCLUDE REGEX "src/lua\\.c$")
include_directories(${PROJECT_MICROLIFE_THIRD_ROOT}/lua/src)

find_package(ZLIB REQUIRED)
find_package(libuv CONFIG REQUIRED)
find_package(OpenSSL REQUIRED)
add_library(uwebsockets STATIC
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/crypto/openssl.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/crypto/sni_tree.cpp
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/eventing/asio.cpp
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/eventing/epoll_kqueue.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/eventing/gcd.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/eventing/libuv.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/io_uring/io_context.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/io_uring/io_loop.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/io_uring/io_socket.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/bsd.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/context.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/loop.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/quic.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/socket.c
	${PROJECT_MICROLIFE_THIRD_ROOT}/usockets/udp.c
)
target_include_directories(uwebsockets PRIVATE ${PROJECT_MICROLIFE_THIRD_ROOT}/usockets)
target_link_libraries(uwebsockets INTERFACE ZLIB::ZLIB)
target_link_libraries(uwebsockets PRIVATE $<IF:$<TARGET_EXISTS:libuv::uv_a>,libuv::uv_a,libuv::uv>)
target_link_libraries(uwebsockets PRIVATE OpenSSL::SSL)
target_link_libraries(uwebsockets PRIVATE OpenSSL::Crypto)
target_compile_definitions(uwebsockets PRIVATE WITH_ZLIB=1)
target_compile_definitions(uwebsockets PRIVATE WITH_LTO=1)
target_compile_definitions(uwebsockets PRIVATE WITH_LIBUV=1)
target_compile_definitions(uwebsockets PRIVATE LIBUS_USE_OPENSSL)
set_target_properties(uwebsockets PROPERTIES PREFIX "" OUTPUT_NAME uwebsockets)
set_target_properties(uwebsockets PROPERTIES
	RUNTIME_OUTPUT_DIRECTORY ${PROJECT_MICROLIFE_BIN_ROOT}
	LIBRARY_OUTPUT_DIRECTORY ${PROJECT_MICROLIFE_BIN_ROOT}
)
