project(TimEm)
cmake_minimum_required(VERSION 2.8.10)
set(APPLICATION_NAME tilem)
set(APPLICATION_NAME_LOWER tilem)
set(APPLICAION_URL "https://github.com/labsin/TilEm")
set(APPLICAION_BUGREPORT "https://github.com/labsin/TilEm/issues")
set(APPLICAION_TARNAME tilem)
set(APPLICATION_VERSION_MAJOR 0)
set(APPLICATION_VERSION_MINOR 1)
set(APPLICATION_VERSION_PATCH 1)
set(APPLICATION_VERSION ${APPLICATION_VERSION_MAJOR}.${APPLICATION_VERSION_MINOR}.${APPLICATION_VERSION_PATCH})
set(APPLICATION_STRING ${APPLICATION_TARNAME}-${APPLICATION_VERSION})
set(APPLICAION_EMAIL "Sam Segers <sam.sgrs@gmail.com>")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/")

include(ResolveLibs)

include(CLICKInstallDirs)

# add definitions
include(DefineCMakeDefaults)
include(DefinePlatformDefaults)
include(DefineCompilerFlags)
include(DefineOptions.cmake)
include(CPackConfig.cmake)
include(QtCreatorResources)

# disallow in-source build
include(MacroEnsureOutOfSourceBuild)
macro_ensure_out_of_source_build("${PROJECT_NAME} requires an out of source build. Please create a separate build directory and run 'cmake /path/to/${PROJECT_NAME} [options]' there.")

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

set(TILEM_DIR ${CMAKE_INSTALL_DATADIR}/TilEm)

# config.h
include_directories(${CMAKE_CURRENT_BINARY_DIR}/tilem-core)

# for dh_translations to extract the domain
# (regarding syntax consistency, see http://pad.lv/1181187)
# set (GETTEXT_PACKAGE "tilem")

set(RUN_DIR ${CMAKE_BINARY_DIR}/run)
set(RUN_BINARY_DIR ${RIN_DIR}/lib/${BUILD_ARCH})

set(QMLAPP_TARGET QmlApp)
set(DATA_TARGET Data)
set(TILEM_TARGET TilEm)
set(EMU_TARGET Emu)
set(UTILS_TARGET Utils)
set(RUNDIR_TARGET RunTarget)

set(ONLY_EMU ON CACHE BOOL "Only build emu for static linking")
set(QMLDUMP OFF CACHE BOOL "Dump qml info so it's loadable by the QtCreator editor")

add_subdirectory(tilem-core)
add_subdirectory(backend)
add_subdirectory(app)
add_subdirectory(data)

add_custom_target(${RUNDIR_TARGET} ALL
    DEPENDS ${TILEM_TARGET} ${QMLAPP_TARGET} ${DATA_TARGET} ${UTILS_TARGET} )
foreach(_target ${TILEM_TARGET} ${QMLAPP_TARGET} ${DATA_TARGET} ${UTILS_TARGET} )
add_custom_command(
    TARGET ${RUNDIR_TARGET}
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${${_target}_BINARY_DIR}/out"
        "${RUN_DIR}/"
    COMMAND ${CMAKE_COMMAND} -E echo "COPY RUN: ${_target}"
    COMMAND ${CMAKE_COMMAND} -E echo "FROM: ${${_target}_BINARY_DIR}/out"
        "TO: ${RUN_DIR}/" )
endforeach()

add_custom_target(run
    COMMAND qmlscene -I lib/${BUILD_ARCH_TRIPLET} TilEm.qml
    WORKING_DIRECTORY run/)
