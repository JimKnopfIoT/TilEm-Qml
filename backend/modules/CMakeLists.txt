function(resolve_lib lib lib_list)
    get_filename_component(resolved ${lib}
        REALPATH)
    set(${lib_list} ${${lib_list}} ${resolved} PARENT_SCOPE)
endfunction(resolve_lib)

find_package(Qt5Qml REQUIRED)
find_package(Qt5Quick REQUIRED)

add_subdirectory(TilEm)
add_subdirectory(Utils)
