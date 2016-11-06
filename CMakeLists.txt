cmake_minimum_required(VERSION 3.5)
project(yalmip LANGUAGES NONE VERSION 20160919)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING
    "Choose the type of build; options are Debug Release RelWithDebInfo MinSizeRel"
    FORCE
  )
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY
    STRINGS
      Debug
      Release
      RelWithDebInfo
      MinSizeRel
  )
endif()

configure_file(addpath_yalmip.m.in addpath_yalmip.m @ONLY)
configure_file(rmpath_yalmip.m.in rmpath_yalmip.m @ONLY)

include(GNUInstallDirs)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/addpath_yalmip.m"
  "${CMAKE_CURRENT_BINARY_DIR}/rmpath_yalmip.m"
  DESTINATION matlab)

install(FILES yalmip/license.txt
  DESTINATION ${CMAKE_INSTALL_DOCDIR}
  RENAME LICENSE)
