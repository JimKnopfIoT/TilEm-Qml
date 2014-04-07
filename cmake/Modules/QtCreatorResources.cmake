macro( qtcreator_add_project_resources resources )
  add_custom_target( ${PROJECT_NAME}_Resources ALL SOURCES ${ARGN} )
endmacro()
