# This toolchain definition file is also heavily based on BigCheese's
# nucleo-toolchain

# We assume the following variables are setup:
#   TEENSY3_TARGET: Target to use for compilation
#   TEENSY3_PREFIX: Prefix to use for installation, and which contains the
#                   binutils for arm-none-eabi
#   TOOLCHAIN_DIR:  The root of our toolchain, with build and src
#                   directories.

# If we're using this toolchain definition but haven't defined the three
# base vars, try to make a best-effort definition.
if (NOT DEFINED TOOLCHAIN_DIR)
  set(XXX_TOOLCHAIN_DIR "${CMAKE_SOURCE_DIR}")
  if ("${XXX_TOOLCHAIN_DIR}" MATCHES "src/pdclib$")
    # fix our source, when this file is used with a plain pdclib build
    get_filename_component(XXX_PARENT_DIR "${XXX_TOOLCHAIN_DIR}" DIRECTORY)
    get_filename_component(XXX_PARENT_DIR "${XXX_PARENT_DIR}" DIRECTORY)
    set(XXX_TOOLCHAIN_DIR "${XXX_PARENT_DIR}")
  endif()
  set(TOOLCHAIN_DIR "${XXX_TOOLCHAIN_DIR}" CACHE PATH "Toolchain directory")
  message("-- TOOLCHAIN_DIR (guessed): ${TOOLCHAIN_DIR}")
else()
  set(TOOLCHAIN_DIR "${TOOLCHAIN_DIR}" CACHE PATH "Toolchain directory")
endif()

if (NOT DEFINED TEENSY3_PREFIX)
  set(TEENSY3_PREFIX "${TOOLCHAIN_DIR}/prefix" CACHE PATH "Prefix to use for the teensy3 toolchain")
  message("-- TEENSY3_PREFIX (guessed): ${TEENSY3_PREFIX}")
else()
  set(TEENSY3_PREFIX "${TEENSY3_PREFIX}" CACHE PATH "Prefix to use for the teensy3 toolchain")
endif()

if (NOT DEFINED TEENSY3_TARGET)
  set(TEENSY3_TARGET "arm-none-eabi" CACHE STRING "Target to use for teensy3")
  message("-- TEENSY3_TARGET (guessed): ${TEENSY3_TARGET}")
else()
  set(TEENSY3_TARGET "${TEENSY3_TARGET}" CACHE PATH "Target to use for teensy3")
endif()

# Prioritize the built binutils programs
set(CMAKE_FIND_ROOT_PATH "${TEENSY3_PREFIX}")
set(CMAKE_PREFIX_PATH "${TEENSY3_PREFIX}/${TEENSY3_TARGET}" ${CMAKE_PREFIX_PATH})

set(CMAKE_INSTALL_PREFIX "${TEENSY3_PREFIX}" CACHE PATH "Install prefix for the built libraries")

set(CMAKE_SYSTEM_NAME Generic)

# We have to force the C compiler, otherwise CMake's tests for the
# compiler won't work, since we want to compile a libc and don't have
# access to one.
include(CMakeForceCompiler)
CMAKE_FORCE_C_COMPILER("$ENV{CC}" GNU)
CMAKE_FORCE_CXX_COMPILER("$ENV{CXX}" GNU)
#CMAKE_FORCE_C_COMPILER(clang GNU)
#CMAKE_FORCE_CXX_COMPILER(clang++ GNU)

set(TEENSY3_FLAGS "--target=${TEENSY3_TARGET} -mcpu=cortex-m4 -mthumb \"--sysroot=${TEENSY3_PREFIX}\" -D__MK20DX128__ -DF_CPU=48000000" CACHE STRING "Teensy3 specific flags")
#set(TEENSY3_ARDUINO_FLAGS "-DARDUIO=105 -DTEENSYDUINO=118")
set(COMMON_FLAGS "-ffunction-sections -fdata-sections -fcolor-diagnostics -fno-exceptions ${TEENSY3_FLAGS}" CACHE STRING "Common compilation flags")
set(CMAKE_C_FLAGS "-std=c11 ${COMMON_FLAGS} ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "-std=c++11 ${COMMON_FLAGS} ${CMAKE_CXX_FLAGS}")
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS} ${CMAKE_ASM_FLAGS}")
set(CMAKE_SIZEOF_VOID_P 4)

include_directories(SYSTEM "${TEENSY3_PREFIX}/include")
#include_directories(BEFORE SYSTEM K:/Build/llvm-project/vs11/Release/lib/clang/3.5.0/include)
#include_directories(SYSTEM "${TOOLCHAIN_DIR}/../source/include")
#link_directories("${TOOLCHAIN_DIR}/../lib")

set(DEFAULT_OBJECTS "${TEENSY3_PREFIX}/lib/mk20dx128.o")
set(LINKER_SCRIPT "${TEENSY3_PREFIX}/lib/mk20dx128.ld")
link_directories("${TEENSY3_PREFIX}/lib")

find_program(AR_PROGRAM "${TEENSY3_TARGET}-ar")
find_program(SIZE_PROGRAM "${TEENSY3_TARGET}-size")
find_program(OBJCOPY_PROGRAM "${TEENSY3_TARGET}-objcopy")
find_program(LINKER_PROGRAM "${TEENSY3_TARGET}-ld")
set(LINK_LINE "\"${LINKER_PROGRAM}\" -T\"${LINKER_SCRIPT}\" -nostdlib -nodefaultlib -gc-sections <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> ${DEFAULT_OBJECTS} <OBJECTS> <LINK_LIBRARIES> -lpdc -lteensy-core -o <TARGET>") # -lclang_rt.arm")

set(CMAKE_C_LINK_EXECUTABLE ${LINK_LINE})
set(CMAKE_CXX_LINK_EXECUTABLE ${LINK_LINE})
