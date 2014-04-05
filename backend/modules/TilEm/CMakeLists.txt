if(NOT DEFINED TILEM_TARGET)
    set(TILEM_TARGET TilEm)
endif()
string(TOLOWER ${TILEM_TARGET} TILEM_PROJECT_TOLOWER)

project(${TILEM_TARGET})

if(NOT DEFINED TILEM_VERSION_MAJOR)
    set(TILEM_VERSION_MAJOR 1)
endif()
if(NOT DEFINED TILEM_VERSION_MINOR)
    set(TILEM_VERSION_MINOR 0)
endif()
if(NOT DEFINED TILEM_URI)
    set(TILEM_URI ${TILEM_TARGET})
endif()

option(QMLDUMP "Dump qml info so it's loadable by the QtCreator editor" ON)

set(out ${CMAKE_CURRENT_BINARY_DIR}/out )
file(MAKE_DIRECTORY ${out})

set(LIB_DIR "${out}/lib/${BUILD_ARCH}")
file(MAKE_DIRECTORY ${LIB_DIR})

set(TILEM_PLUGIN_DIR "${LIB_DIR}/${TILEM_TARGET}")
file(MAKE_DIRECTORY ${TILEM_PLUGIN_DIR})
file(COPY "qmldir" DESTINATION "${TILEM_PLUGIN_DIR}/")

find_package(Glib REQUIRED)
find_package(GObject REQUIRED)
find_package(LIBC REQUIRED)
find_package(GDK-PixBuf REQUIRED)
find_package(TiCalcs2 REQUIRED)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/backend.h.in ${CMAKE_CURRENT_BINARY_DIR}/backend.h)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/backend.cpp.in ${CMAKE_CURRENT_BINARY_DIR}/backend.cpp)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
if(NOT DEFINED EMU_TARGET)
    set(EMU_TARGET "Emu")
endif()
include_directories(${${EMU_TARGET}_SOURCE_DIR})

# set(LIBS_TO_COPY ${Glib_LIBRARIES} ${GObject_LIBRARIES} ${LIBC_LIBRARIES} ${GDK-PixBuf_LIBRARIES} ${TiCalcs_LIBRARIES} )
set(LIBS_TO_COPY ${TiCalcs2_LIBRARIES} )
set(LIBS_TO_INCLUDE ${Glib_LIBRARIES} ${GObject_LIBRARIES} ${LIBC_LIBRARIES} ${GDK-PixBuf_LIBRARIES})
foreach(lib ${LIBS_TO_COPY})
    resolve_lib(${lib} RESOLVED_LIBS_TO_COPY)
endforeach(lib)

if(NOT DEFINED EMU_TARGET)
    set(EMU_TARGET Emu)
endif()

set(LIBS ${RESOLVED_LIBS_TO_COPY} ${LIBS_TO_INCLUDE} ${EMU_TARGET} )
MESSAGE("LIBS: ${LIBS}")

file(COPY ${RESOLVED_LIBS_TO_COPY} DESTINATION ${LIB_DIR})

include_directories(
    ${CMAKE_BINARY_DIR}
    ${Glib_INCLUDE_DIRS}
    ${GObject_INCLUDE_DIRS}
    ${GDK-PixBuf_INCLUDE_DIRS}
    ${TiCalcs2_INCLUDE_DIRS}
    ${emu_SOURCE_DIR}
)

set(tilem_HDRS
    ${CMAKE_CURRENT_BINARY_DIR}/backend.h
    ${CMAKE_CURRENT_SOURCE_DIR}/calcscreen.h
    ${CMAKE_CURRENT_SOURCE_DIR}/linkbuffer.h
    ${CMAKE_CURRENT_SOURCE_DIR}/calc.h
    ${CMAKE_CURRENT_SOURCE_DIR}/calclink.h
    ${CMAKE_CURRENT_SOURCE_DIR}/calcthread.h
    ${CMAKE_CURRENT_SOURCE_DIR}/settings.h
    ${CMAKE_CURRENT_SOURCE_DIR}/skin.h
    ${CMAKE_CURRENT_SOURCE_DIR}/skinimage.h
    ${CMAKE_CURRENT_SOURCE_DIR}/skinops.h)

set(tilem_SRCS
    ${CMAKE_CURRENT_BINARY_DIR}/backend.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/calcscreen.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/calcthread.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/calc.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/calclink.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/settings.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/skin.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/skinimage.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/skinops.c)

add_library(${TILEM_TARGET} SHARED
    ${tilem_MOC_SRCS}
    ${tilem_SRCS}
)

qt5_use_modules(${TILEM_TARGET} Gui Core Qml Quick)

target_link_libraries(${TILEM_TARGET}
    ${LIBS}
)

set(CMAKE_BUILD_TYPE Release)

GET_TARGET_PROPERTY(TILEM_LIB_NAME ${TILEM_TARGET} LOCATION)
set(CP_LIB_FROM ${TILEM_LIB_NAME})
set(CP_LIB_TO "${TILEM_PLUGIN_DIR}")
add_custom_command(TARGET ${TILEM_TARGET} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "POST BUILD"
    COMMAND ${CMAKE_COMMAND} -E echo "Copy lib to run directory"
    COMMAND ${CMAKE_COMMAND} -E copy
        ${CP_LIB_FROM}
        ${CP_LIB_TO})

if(QMLDUMP)
add_custom_command(TARGET ${TILEM_TARGET} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Run qmlplugindump"
    COMMAND qmlplugindump -notrelocatable ${TILEM_TARGET} 1.0 ${LIB_DIR} > ${CP_LIB_TO}/${TILEM_PROJECT_TOLOWER}.qmltypes)
endif(QMLDUMP)

install(TARGETS ${TILEM_TARGET}
    DESTINATION lib/${BUILD_ARCH}/${TILEM_TARGET} )
install(FILES "qmldir" ${RESOLVED_LIBS_TO_COPY}
    DESTINATION lib/${BUILD_ARCH}/${TILEM_TARGET})
