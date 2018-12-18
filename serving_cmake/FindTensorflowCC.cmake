# Locate and configure the tensorflow_cc library
#
# Adds the following targets:
#
#  tensorflow_cc - tensorflow_cc library

# Find TF include dir
find_path(TENSORFLOW_INCLUDE_DIR tensorflow tensorflow/tensorflow/contrib/makefile/gen/proto)
mark_as_advanced(TENSORFLOW_INCLUDE_DIR)

# Find Eigen include dir (included with TF)
find_path(EIGEN_INCLUDE_DIR eigen3 eigen3/unsupported)
mark_as_advanced(EIGEN_INCLUDE_DIR)
	
# Find TF library
#find_library(TENSORFLOW_CC_LIBRARY NAMES tensorflow_cc)
#mark_as_advanced(TENSORFLOW_CC_LIBRARY)
#add_library(TensorflowCC::Shared UNKNOWN IMPORTED)
#set_target_properties(TensorflowCC::Shared PROPERTIES
#    INTERFACE_INCLUDE_DIRECTORIES "${TENSORFLOW_INCLUDE_DIR};${EIGEN_INCLUDE_DIR}"
#    IMPORTED_LOCATION ${TENSORFLOW_CC_LIBRARY}
#)

find_library(TENSORFLOW_CC_LIBRARY NAMES tensorflow_cc)
mark_as_advanced(TENSORFLOW_CC_LIBRARY)
add_library(TensorflowCC::Static UNKNOWN IMPORTED)
set_target_properties(TensorflowCC::Static PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${TENSORFLOW_INCLUDE_DIR};${EIGEN_INCLUDE_DIR}"
    IMPORTED_LOCATION ${TENSORFLOW_CC_LIBRARY}
)

# Find TF fwk library
#find_library(TENSORFLOW_FWK_LIBRARY NAMES tensorflow_framework)
#mark_as_advanced(TENSORFLOW_FWK_LIBRARY)
#add_library(TensorflowCC::Framework UNKNOWN IMPORTED)
#set_target_properties(TensorflowCC::Framework PROPERTIES
#    INTERFACE_INCLUDE_DIRECTORIES "${TENSORFLOW_INCLUDE_DIR};${EIGEN_INCLUDE_DIR}"
#    INTERFACE_LINK_LIBRARIES "-lrt"
#    IMPORTED_LOCATION ${TENSORFLOW_FWK_LIBRARY}
#)

#include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
#FIND_PACKAGE_HANDLE_STANDARD_ARGS(TensorflowCC DEFAULT_MSG
#    TENSORFLOW_CC_LIBRARY TENSORFLOW_FWK_LIBRARY)

#include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
#FIND_PACKAGE_HANDLE_STANDARD_ARGS(TensorflowCC DEFAULT_MSG
#    TENSORFLOW_CC_LIBRARY)
