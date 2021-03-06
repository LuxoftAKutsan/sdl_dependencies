# Copyright (c) 2016, Ford Motor Company
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the
# distribution.
#
# Neither the name of the Ford Motor Company nor the names of its contributors
# may be used to endorse or promote products derived from this software
# without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Sources helpers provide functionality to collect headers, source files
# or any other files depends on current build settings (OS, Architecture, SDK).
#
# Files could be included or excluded to/from build for some platform by
# platform-specific suffix adding to filename. For example file
# sdl_source_file_posix_x86_qt.cc will be added only to build with parameters:
# OS=posix ARCH=x86 SDK=qt but file sdl_source_file_win.cc to all builds
# with OS=win option enabled. Suffixes could be mixed within filename randomly.
#
# Full list of supported suffixes:
# posix
# win
# x86
# x64
# qt

# include(${CMAKE_SOURCE_DIR}/tools/cmake/helpers/platform.cmake)

function(filter_files_by_name FILES IGNORE_NAMES)
  set(FILES_LOCAL ${${FILES}})
  foreach(FILE_ENTRY ${${FILES}})
    foreach(IGNORE_ENTRY ${IGNORE_NAMES})
      if(${FILE_ENTRY} MATCHES ${IGNORE_ENTRY})
        list(REMOVE_ITEM FILES_LOCAL ${FILE_ENTRY})
      endif()
    endforeach()
  endforeach()
  set(${FILES} ${FILES_LOCAL} PARENT_SCOPE)
endfunction()

function(filter_files_by_suffix FILES IGNORE_SUFFIXES)
  set(FILES_LOCAL ${${FILES}})
  foreach(FILE_ENTRY ${${FILES}})
    foreach(IGNORE_ENTRY ${IGNORE_SUFFIXES})
      if((${FILE_ENTRY} MATCHES "_${IGNORE_ENTRY}_") OR (${FILE_ENTRY} MATCHES "_${IGNORE_ENTRY}\\."))
        list(REMOVE_ITEM FILES_LOCAL ${FILE_ENTRY})
      endif()
    endforeach()
  endforeach()
  set(${FILES} ${FILES_LOCAL} PARENT_SCOPE)
endfunction()


function(filter_files FILES IGNORE_NAMES)
  set(FILES_LOCAL ${${FILES}})
  filter_files_by_name(FILES_LOCAL "${IGNORE_NAMES}")
  set(${FILES} ${FILES_LOCAL} PARENT_SCOPE)
endfunction()

function(collect_sources SOURCES PATHS)
  set(OPTIONAL_ARG ${ARGN})
  set(HEADERS_LOCAL)
  set(SOURCES_LOCAL)
  
  foreach(PATH_ENTRY ${PATHS})
    file(GLOB_RECURSE SOURCES_TO_FILTER "${PATH_ENTRY}/*.c" "${PATH_ENTRY}/*.cc" "${PATH_ENTRY}/*.cpp")
    filter_files(SOURCES_TO_FILTER "${OPTIONAL_ARG}")
    list(APPEND SOURCES_LOCAL ${SOURCES_TO_FILTER})
    set(SOURCES_TO_FILTER)
  endforeach()

  set(${SOURCES} ${SOURCES_LOCAL} PARENT_SCOPE)
endfunction()
