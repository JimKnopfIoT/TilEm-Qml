if(NOT DEFINED QMLAPP_TARGET)
    set(QMLAPP_TARGET QmlApp)
endif()
string(TOLOWER ${QMLAPP_TARGET} QMLAPP_TARGET_TOLOWER)

project(${QMLAPP_TARGET})
add_custom_target(${QMLAPP_TARGET})

set(out ${CMAKE_CURRENT_BINARY_DIR}/out )
file(MAKE_DIRECTORY ${out})

set(QML
    CalcPage.qml
    TilEm.qml)

set(CLICK
    manifest.json
    TilEm.json
    TilEm.desktop)

foreach(_file ${QML} ${CLICK})
add_custom_command(
    TARGET ${QMLAPP_TARGET}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${_file} ${out}/${_file}
    DEPENDS ${_file})
endforeach()

set(_target ${QMLAPP_TARGET})

install(FILES ${QML} ${CLICK} DESTINATION ${DATA_DIR})
