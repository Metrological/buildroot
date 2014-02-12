cmake_minimum_required(VERSION 2.8)

find_package(PkgConfig)

pkg_check_modules(WebKitNix WebKitNix REQUIRED)
pkg_check_modules(GLIB glib-2.0 REQUIRED)
pkg_check_modules(CAIRO cairo REQUIRED)

include_directories(nixbrowser_INCLUDES
    ${WebKitNix_INCLUDE_DIRS}
    ${GLIB_INCLUDE_DIRS}
    ${CAIRO_INCLUDE_DIRS}
)

link_directories(
    ${WebKitNix_LIBRARY_DIRS}
    ${GLIB_LIBRARY_DIRS}
    ${CAIRO_LIBRARY_DIRS}
)

add_executable(nixbrowser main.cpp)
target_link_libraries(nixbrowser
    ${GLIB_LIBRARIES}
    ${WebKitNix_LIBRARIES}
    GLESv2
    EGL
    bcm_host
    vcos
    vchiq_arm
)

install(TARGETS nixbrowser RUNTIME DESTINATION bin)
