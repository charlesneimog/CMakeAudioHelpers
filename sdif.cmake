set(SDIF_PARENT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Libraries)

set(SDIF_LIB ${CMAKE_BINARY_DIR}/sdif.tar.gz)
if(NOT EXISTS ${SDIF_LIB})
  message(STATUS "Downloading Sdif")
  file(DOWNLOAD https://sourceforge.net/projects/sdif/files/latest/download
       ${SDIF_LIB})
endif()

file(ARCHIVE_EXTRACT INPUT ${CMAKE_BINARY_DIR}/sdif.tar.gz DESTINATION
     ${CMAKE_BINARY_DIR}/)

# get folder of sdif source

# Search for the SDIF directory matching the pattern
file(GLOB SDIF_DIRS "${CMAKE_BINARY_DIR}/SDIF-*-src")

# Ensure exactly one directory matches the pattern
list(LENGTH SDIF_DIRS SDIF_COUNT)
if(SDIF_COUNT EQUAL 1)
  list(GET SDIF_DIRS 0 SDIF_DIR)
else()
  message(
    FATAL_ERROR
      "Expected exactly one SDIF directory matching the pattern, found ${SDIF_COUNT}"
  )
endif()

set(SDIF_DIR ${SDIF_DIR}/sdif/)
set(sdif_SOURCES
    ${SDIF_DIR}/SdifCheck.c
    ${SDIF_DIR}/SdifConvToText.c
    ${SDIF_DIR}/SdifErrMess.c
    ${SDIF_DIR}/SdifFGet.c
    ${SDIF_DIR}/SdifFile.c
    ${SDIF_DIR}/SdifFPrint.c
    ${SDIF_DIR}/SdifFPut.c
    ${SDIF_DIR}/SdifFrame.c
    ${SDIF_DIR}/SdifFrameType.c
    ${SDIF_DIR}/SdifFRead.c
    ${SDIF_DIR}/SdifFScan.c
    ${SDIF_DIR}/SdifFWrite.c
    ${SDIF_DIR}/SdifGlobals.c
    ${SDIF_DIR}/SdifHard_OS.c
    ${SDIF_DIR}/SdifHash.c
    ${SDIF_DIR}/SdifHighLevel.c
    ${SDIF_DIR}/SdifList.c
    ${SDIF_DIR}/SdifMatrix.c
    ${SDIF_DIR}/SdifMatrixType.c
    ${SDIF_DIR}/SdifNameValue.c
    ${SDIF_DIR}/SdifPreTypes.c
    ${SDIF_DIR}/SdifPrint.c
    ${SDIF_DIR}/SdifRWLowLevel.c
    ${SDIF_DIR}/SdifSelect.c
    ${SDIF_DIR}/SdifSignatureTab.c
    ${SDIF_DIR}/SdifStreamID.c
    ${SDIF_DIR}/SdifString.c
    ${SDIF_DIR}/SdifTest.c
    ${SDIF_DIR}/SdifTextConv.c
    ${SDIF_DIR}/SdifTimePosition.c)

# run configure.sh script
file(GLOB SDIF_ROOT "${CMAKE_BINARY_DIR}/SDIF-*") # Captura o diretório extraído
if(NOT SDIF_ROOT)
  message(FATAL_ERROR "SDIF source directory not found!")
endif()

message(STATUS "SDIF_DIR: ${SDIF_DIR}")
add_library(sdif_static STATIC ${sdif_SOURCES})
set_target_properties(sdif_static PROPERTIES COMPILE_FLAGS "-DSDIF_IS_STATIC")
include_directories(${SDIF_ROOT}/include)
include_directories(${SDIF_DIR}/)

# set LITTLE_ENDIAN
include(CheckCSourceCompiles)
set(ENDIAN_CHECK_SOURCE "int main() { return 1; }")

check_c_source_compiles("union { int i; char c; } u; u.i = 1; return u.c == 1;"
                        HAVE_LITTLE_ENDIAN)

if(HAVE_LITTLE_ENDIAN)
  add_definitions(-DHOST_ENDIAN_LITTLE)
else()
  add_definitions(-DHOST_ENDIAN_BIG)
endif()

set_target_properties(sdif_static PROPERTIES LIBRARY_OUTPUT_DIRECTORY
                                             ${CMAKE_SOURCE_DIR})
set_target_properties(sdif_static PROPERTIES POSITION_INDEPENDENT_CODE ON)
