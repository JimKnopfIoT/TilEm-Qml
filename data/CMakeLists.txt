if(NOT DEFINED DATA_TARGET)
    set(DATA_TARGET Data)
endif()
string(TOLOWER ${DATA_TARGET} DATA_TARGET_TOLOWER)

project(${DATA_TARGET})
add_custom_target(${DATA_TARGET})

set(out ${CMAKE_CURRENT_BINARY_DIR}/out )
file(MAKE_DIRECTORY ${out})

set(SKINS
    skins/ti82.skn
    skins/ti83pfr.skn
    skins/ti83.skn
    skins/ti84p.skn
    skins/ti76.skn
    skins/ti82stats.skn
    skins/ti83pse.skn
    skins/ti84p2.skn
    skins/ti85.skn
    skins/ti81.skn
    skins/ti83pfr2.skn
    skins/ti83p.skn
    skins/ti84pse.skn
    skins/ti86.skn)

foreach(_file ${SKINS} keybindings.ini)
add_custom_command(
    TARGET ${DATA_TARGET}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${_file} ${out}/${_file}
    DEPENDS ${_file})
endforeach()

install(FILES ${SKINS} keybindings.ini DESTINATION ${DATA_DIR})
