function(resolve_lib lib lib_list)
    get_filename_component(resolved ${lib}
        REALPATH)
    set(${lib_list} ${${lib_list}} ${resolved} PARENT_SCOPE)
endfunction(resolve_lib)
