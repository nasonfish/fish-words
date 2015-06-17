project (fish-words)

cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/fish-words")

set (EXEC_NAME "fish-words")
set (RELEASE_NAME "A password manager.")
set (VERSION "0.1")
set (VERSION_INFO "Initial commit")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED gtk+-3.0 glib-2.0 libnotify)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)

include(ValaVersion)

ensure_vala_version("0.16, MINIMUM")

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/prompt.vala
    src/passwords.vala

PACKAGES
    gtk+-3.0
    glib-2.0
    libnotify
)

add_executable(${EXEC_NAME} ${VALA_C})

install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/fish-words.desktop DESTINATION ${DATADIR}/applications/)
