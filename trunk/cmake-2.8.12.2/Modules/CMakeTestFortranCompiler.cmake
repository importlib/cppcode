
#=============================================================================
# Copyright 2004-2012 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

if(CMAKE_Fortran_COMPILER_FORCED)
  # The compiler configuration was forced by the user.
  # Assume the user has configured all compiler information.
  set(CMAKE_Fortran_COMPILER_WORKS TRUE)
  return()
endif()

include(CMakeTestCompilerCommon)

# Remove any cached result from an older CMake version.
# We now store this in CMakeFortranCompiler.cmake.
unset(CMAKE_Fortran_COMPILER_WORKS CACHE)

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that that selected Fortran compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.
if(NOT CMAKE_Fortran_COMPILER_WORKS)
  PrintTestCompilerStatus("Fortran" "")
  file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testFortranCompiler.f "
        PROGRAM TESTFortran
        PRINT *, 'Hello'
        END
  ")
  try_compile(CMAKE_Fortran_COMPILER_WORKS ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testFortranCompiler.f
    OUTPUT_VARIABLE OUTPUT)
  # Move result from cache to normal variable.
  set(CMAKE_Fortran_COMPILER_WORKS ${CMAKE_Fortran_COMPILER_WORKS})
  unset(CMAKE_Fortran_COMPILER_WORKS CACHE)
  set(FORTRAN_TEST_WAS_RUN 1)
endif()

if(NOT CMAKE_Fortran_COMPILER_WORKS)
  PrintTestCompilerStatus("Fortran" "  -- broken")
  file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the Fortran compiler works failed with "
    "the following output:\n${OUTPUT}\n\n")
  message(FATAL_ERROR "The Fortran compiler \"${CMAKE_Fortran_COMPILER}\" "
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n ${OUTPUT}\n\n"
    "CMake will not be able to correctly generate this project.")
else()
  if(FORTRAN_TEST_WAS_RUN)
    PrintTestCompilerStatus("Fortran" "  -- works")
    file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the Fortran compiler works passed with "
      "the following output:\n${OUTPUT}\n\n")
  endif()

  # Try to identify the ABI and configure it into CMakeFortranCompiler.cmake
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerABI.cmake)
  CMAKE_DETERMINE_COMPILER_ABI(Fortran ${CMAKE_ROOT}/Modules/CMakeFortranCompilerABI.F)

  # Test for Fortran 90 support by using an f90-specific construct.
  if(NOT DEFINED CMAKE_Fortran_COMPILER_SUPPORTS_F90)
    message(STATUS "Checking whether ${CMAKE_Fortran_COMPILER} supports Fortran 90")
    file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testFortranCompilerF90.f90 "
      PROGRAM TESTFortran90
      integer stop ; stop = 1 ; do while ( stop .eq. 0 ) ; end do
      END PROGRAM TESTFortran90
")
    try_compile(CMAKE_Fortran_COMPILER_SUPPORTS_F90 ${CMAKE_BINARY_DIR}
      ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testFortranCompilerF90.f90
      OUTPUT_VARIABLE OUTPUT)
    if(CMAKE_Fortran_COMPILER_SUPPORTS_F90)
      message(STATUS "Checking whether ${CMAKE_Fortran_COMPILER} supports Fortran 90 -- yes")
      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
        "Determining if the Fortran compiler supports Fortran 90 passed with "
        "the following output:\n${OUTPUT}\n\n")
      set(CMAKE_Fortran_COMPILER_SUPPORTS_F90 1)
    else()
      message(STATUS "Checking whether ${CMAKE_Fortran_COMPILER} supports Fortran 90 -- no")
      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
        "Determining if the Fortran compiler supports Fortran 90 failed with "
        "the following output:\n${OUTPUT}\n\n")
      set(CMAKE_Fortran_COMPILER_SUPPORTS_F90 0)
    endif()
    unset(CMAKE_Fortran_COMPILER_SUPPORTS_F90 CACHE)
  endif()

  # Re-configure to save learned information.
  configure_file(
    ${CMAKE_ROOT}/Modules/CMakeFortranCompiler.cmake.in
    ${CMAKE_PLATFORM_INFO_DIR}/CMakeFortranCompiler.cmake
    @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
    )
  include(${CMAKE_PLATFORM_INFO_DIR}/CMakeFortranCompiler.cmake)

  if(CMAKE_Fortran_SIZEOF_DATA_PTR)
    foreach(f ${CMAKE_Fortran_ABI_FILES})
      include(${f})
    endforeach()
    unset(CMAKE_Fortran_ABI_FILES)
  endif()
endif()
