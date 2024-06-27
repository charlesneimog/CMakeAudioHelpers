set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Include FetchContent module
include(FetchContent)

# Fetch GSL repository
FetchContent_Declare(
  gsl
  GIT_REPOSITORY https://github.com/ampl/gsl.git
  GIT_TAG v2.7)

set(GSL_DISABLE_TESTS ON)

FetchContent_MakeAvailable(gsl)

# Set properties for the GSL target
set_target_properties(
  gsl PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
                 POSITION_INDEPENDENT_CODE ON)
