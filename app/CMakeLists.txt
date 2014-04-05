if(NOT DEFINED QMLAPP_TARGET)
    set(QMLAPP_TARGET QmlApp)
endif()
string(TOLOWER ${QMLAPP_TARGET} QMLAPP_TARGET_TOLOWER)

project(${QMLAPP_TARGET})
add_custom_target(${QMLAPP_TARGET})

set(out ${CMAKE_CURRENT_BINARY_DIR}/out )
file(MAKE_DIRECTORY ${out})

configure_file(manifest.json.cmake ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)

set(QML_SRC
    CalcPage.qml
    TilEm.qml)

set(CLICK_SRC
    TilEm.json
    TilEm.desktop
    TilEm.url-dispatcher
    tilem.png)

tilem_add_project_resources(${QML_SRC} ${CLICK_SRC} manifest.json.cmake)

foreach(_file ${QML_SRC} ${CLICK_SRC})
add_custom_command(
    TARGET ${QMLAPP_TARGET}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${_file} ${out}/${_file}
    DEPENDS ${_file})
endforeach()
add_custom_command(
    TARGET ${QMLAPP_TARGET}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/manifest.json ${out}/manifest.json
    DEPENDS manifest.json)

set(_target ${QMLAPP_TARGET})

install(FILES ${QML_SRC} ${CLICK_SRC} ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION ${DATA_DIR})
