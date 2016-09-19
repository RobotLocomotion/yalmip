cmake_minimum_required(VERSION 2.8.12)
project(yalmip NONE)

configure_file(addpath_yalmip.m.in addpath_yalmip.m @ONLY)
configure_file(rmpath_yalmip.m.in rmpath_yalmip.m @ONLY)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/addpath_yalmip.m"
  "${CMAKE_CURRENT_BINARY_DIR}/rmpath_yalmip.m"
  DESTINATION matlab)
