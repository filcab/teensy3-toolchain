# This toolchain definition file is also heavily based on BigCheese's
# nucleo-toolchain

# We assume the following variables are setup:
#   TEENSY3_TARGET: Target to use for compilation
#   TEENSY3_PREFIX: Prefix to use for installation, and which contains the
#                   binutils for arm-none-eabi
#   TOOLCHAIN_DIR:  The root of our toolchain, with build and src
#                   directories.
if (NOT DEFINED TOOLCHAIN_DIR)
  # Sadly try_compile doesn't propagate CMAKE_TOOLCHAIN_FILE, so we can't
  # use it to derive the TOOLCHAIN_DIR.
  #get_filename_component(TOOLCHAIN_DIR "${CMAKE_TOOLCHAIN_FILE}" PATH)
  set(XXX_TOOLCHAIN_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
  if ("${TOOLCHAIN_DIR}" MATCHES "src/pdclib$")
    # fix our source, when this file is used with a plain pdclib build
    get_filename_component(XXX_PARENT_DIR "${TOOLCHAIN_DIR}" DIRECTORY)
    get_filename_component(XXX_PARENT_DIR "${XXX_PARENT_DIR}" DIRECTORY)
    set(XXX_TOOLCHAIN_DIR "${XXX_PARENT_DIR}")
  endif()
  set(TOOLCHAIN_DIR "${XXX_TOOLCHAIN_DIR}" CACHE PATH "Toolchain directory")
endif()

if (NOT DEFINED TEENSY3_PREFIX)
  set(TEENSY3_PREFIX "${TOOLCHAIN_DIR}/prefix" CACHE PATH "Prefix to use for the teensy3 toolchain")
endif()

if (NOT DEFINED TEENSY3_TARGET)
  set(TEENSY3_TARGET "arm-none-eabi" CACHE STRING "Target to use for teensy3")
endif()

# Prioritize the built binutils programs
set(CMAKE_FIND_ROOT_PATH "${TEENSY3_PREFIX}")
#set(CMAKE_PREFIX_PATH "${TOOLCHAIN_DIR}/${TEENSY3_TARGET}" ${CMAKE_PREFIX_PATH})

set(CMAKE_INSTALL_PREFIX "${TEENSY3_PREFIX}" CACHE PATH "Install prefix for the built libraries")

set(CMAKE_SYSTEM_NAME Generic)

# Let's avoid forcing the compiler if we can. We'll assume the compiler is
# clang and it can generate code for a cortex-m4
#include(CMakeForceCompiler)
#CMAKE_FORCE_C_COMPILER(arm-none-eabi-clang GNU)
#CMAKE_FORCE_CXX_COMPILER(arm-none-eabi-clang++ GNU)

set(TEENSY3_FLAGS "--target=${TEENSY3_TARGET} -mcpu=cortex-m4 -mthumb -D__MK20DX128__ -DF_CPU=48000000" CACHE STRING "Teensy3 specific flags")
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

#set(DEFAULT_OBJECTS "\"${TOOLCHAIN_DIR}/../lib/init.o\"")
#set(LINK_LINE "arm-none-eabi-ld -T \"${TOOLCHAIN_DIR}/STM32F103RB.ld\" -nostdlib -nodefaultlib -gc-sections <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> ${DEFAULT_OBJECTS} <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -lpdc -lcore -lperipherals -lclang_rt.arm")

#set(CMAKE_C_LINK_EXECUTABLE ${LINK_LINE})

#set(CMAKE_CXX_LINK_EXECUTABLE ${LINK_LINE})
