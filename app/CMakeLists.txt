if(NOT DEFINED QMLAPP_TARGET)
    set(QMLAPP_TARGET QmlApp)
endif()
string(TOLOWER ${QMLAPP_TARGET} QMLAPP_TARGET_TOLOWER)

project(${QMLAPP_TARGET})
add_custom_target(${QMLAPP_TARGET})

configure_file(manifest.json.cmake ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)

set(QML_SRC
    CalcPage.qml
    FolderPage.qml
    TilEm.qml)

set(CLICK_SRC
    TilEm.apparmor
    TilEm.desktop
    tilem.png
    TilEm-hub.json)

set("${QMLAPP_TARGET}_FILES" ${QML_SRC} ${CLICK_SRC})
set("${QMLAPP_TARGET}_FILES" ${${QMLAPP_TARGET}_FILES} PARENT_SCOPE)

qtcreator_add_project_resources(${${QMLAPP_TARGET}_FILES} manifest.json.cmake)

set(_target ${QMLAPP_TARGET})

install(FILES ${QML_SRC} ${CLICK_SRC} ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION ${CMAKE_INSTALL_DATADIR})
