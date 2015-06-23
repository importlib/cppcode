macro(check desc actual expect)
  if(NOT "x${actual}" STREQUAL "x${expect}")
    message(SEND_ERROR "${desc}: got \"${actual}\", not \"${expect}\"")
  endif()
endmacro()

set(filename "/path/to/filename.ext.in")
set(expect_DIRECTORY "/path/to")
set(expect_NAME "filename.ext.in")
set(expect_EXT ".ext.in")
set(expect_NAME_WE "filename")
set(expect_PATH "/path/to")
foreach(c DIRECTORY NAME EXT NAME_WE PATH)
  get_filename_component(actual_${c} "${filename}" ${c})
  check("${c}" "${actual_${c}}" "${expect_${c}}")
endforeach()

get_filename_component(test_slashes "c:\\path\\to\\filename.ext.in" DIRECTORY)
check("DIRECTORY from backslashes" "${test_slashes}" "c:/path/to")

get_filename_component(test_winroot "c:\\filename.ext.in" DIRECTORY)
check("DIRECTORY in windows root" "${test_winroot}" "c:/")

get_filename_component(test_absolute "/path/to/a/../filename.ext.in" ABSOLUTE)
check("ABSOLUTE" "${test_absolute}" "/path/to/filename.ext.in")

get_filename_component(test_absolute "/../path/to/filename.ext.in" ABSOLUTE)
check("ABSOLUTE .. in root" "${test_absolute}" "/path/to/filename.ext.in")
get_filename_component(test_absolute "c:/../path/to/filename.ext.in" ABSOLUTE)
check("ABSOLUTE .. in windows root" "${test_absolute}" "c:/path/to/filename.ext.in")

get_filename_component(test_cache "/path/to/filename.ext.in" DIRECTORY CACHE)
check("CACHE 1" "${test_cache}" "/path/to")
get_filename_component(test_cache "/path/to/other/filename.ext.in" DIRECTORY CACHE)
check("CACHE 2" "${test_cache}" "/path/to")
unset(test_cache CACHE)
get_filename_component(test_cache "/path/to/other/filename.ext.in" DIRECTORY CACHE)
check("CACHE 3" "${test_cache}" "/path/to/other")
