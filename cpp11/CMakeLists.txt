cmake_minimum_required(VERSION 3.7.2 FATAL_ERROR)

if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
    message( FATAL_ERROR "Do not run `cmake .`! Run `git clean -f` and then just `make`" )
endif()

project(learning)

set( CMAKE_VERBOSE_MAKEFILE on )

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic -Wextra -Wno-c99-extensions")

file(GLOB APP_SOURCES RELATIVE ${CMAKE_SOURCE_DIR} *.cpp)
foreach( testsourcefile ${APP_SOURCES} )
    string(REPLACE ".cpp" "" testname ${testsourcefile})
    add_executable( ${testname} ${testsourcefile} )
    set_property(TARGET ${testname} PROPERTY CXX_STANDARD 17)
    set_property(TARGET ${testname} PROPERTY CXX_STANDARD_REQUIRED ON)
    set_target_properties(${testname} PROPERTIES DEBUG_POSTFIX "_d")
    set_target_properties(${testname} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")
endforeach( testsourcefile ${APP_SOURCES} )

# get_cmake_property(_variableNames VARIABLES)
# foreach (_variableName ${_variableNames})
#  message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
