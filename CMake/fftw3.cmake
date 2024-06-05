set(FFTW3_VERSION "3.3.10")

option(BUILD_SHARED_LIBS OFF)
option(BUILD_TESTS OFF)
option(DISABLE_FORTRAN ON)

set(FFTW3_FILE ${CMAKE_BINARY_DIR}/fftw-${FFTW3_VERSION}.tar.gz)
if (NOT EXISTS ${FFTW3_FILE})
    message(STATUS "Downloading FFTW3")
    file(DOWNLOAD https://www.fftw.org/fftw-${FFTW3_VERSION}.tar.gz ${FFTW3_FILE})
endif()

file(ARCHIVE_EXTRACT
    INPUT ${CMAKE_BINARY_DIR}/fftw-${FFTW3_VERSION}.tar.gz
    DESTINATION ${CMAKE_BINARY_DIR}/
)

add_subdirectory(${CMAKE_BINARY_DIR}/fftw-3.3.10)
set_target_properties(fftw3 PROPERTIES POSITION_INDEPENDENT_CODE ON)
include_directories(${CMAKE_BINARY_DIR}/fftw-3.3.10/api)
