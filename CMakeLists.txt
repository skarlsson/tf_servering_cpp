cmake_minimum_required (VERSION 3.6.2)

SET(CMAKE_VERBOSE_MAKEFILE ON)
# EN: Build the Tensorflow Serving stubs. We build from here
#     instead of using add_subdirectory so that we don't need a
#     modified fork of the official tensorflow/serving repository.
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/serving_cmake ${CMAKE_MODULE_PATH})
set(SERVING_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/serving)

# EN: By default the protobuf compiler cmake submodule only works from within
#     the same directory. We get past this by providing an override to specify
#     the actual base directory to compile from.
set(BASE_PROTO_SOURCE_DIR_OVERRIDE ${SERVING_SOURCE_DIR})

find_package(Protobuf REQUIRED)
find_package(GRPC REQUIRED)
find_package(TensorflowCC REQUIRED COMPONENTS Static)

find_package(Boost COMPONENTS program_options filesystem system REQUIRED)
set(BOOST_LIBS
        ${Boost_PROGRAM_OPTIONS_LIBRARY}
        ${Boost_FILESYSTEM_LIBRARY}
        ${Boost_SYSTEM_LIBRARY}
        pthread
        rt
        c
        )

set(TFS_PROTOS
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/regression.proto
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/inference.proto
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/input.proto
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/model.proto
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/get_model_metadata.proto
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/classification.proto
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/predict.proto
        ${SERVING_SOURCE_DIR}/tensorflow_serving/apis/prediction_service.proto
        )

set(PROTOBUF_IMPORT_DIRS
        ${SERVING_SOURCE_DIR}/tensorflow/
        )


set(PROTO_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/proto-src)
file(MAKE_DIRECTORY ${PROTO_SRC_DIR})

include_directories(${PROTO_SRC_DIR}
        /usr/local/include/tensorflow
        /usr/local/include/tensorflow/tensorflow/contrib/makefile/gen/proto
        /usr/local/include/eigen3
        /usr/local/include/eigen3/unsupported
        )
link_directories(/usr/local/lib/tensorflow_cc)

set(PROTOBUF_GENERATE_CPP_APPEND_PATH OFF)
set(GRPC_GENERATE_CPP_APPEND_PATH OFF)
PROTOBUF_GENERATE_CPP(PROTO_SRCS PROTO_HDRS ${PROTO_SRC_DIR} ${TFS_PROTOS})
GRPC_GENERATE_CPP(GRPC_SRCS GRPC_HDRS ${PROTO_SRC_DIR} ${TFS_PROTOS})

add_library(tfserving STATIC ${PROTO_SRCS} ${GRPC_SRCS})
add_custom_target(tfserving_headers DEPENDS ${PROTO_HDRS} ${GRPC_HDRS})
add_dependencies(tfserving tfserving_headers)

target_include_directories(tfserving PUBLIC ${PROTO_SRC_DIR})

INSTALL(TARGETS tfserving
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        )

add_executable(tf_inception_client
        ${CMAKE_CURRENT_SOURCE_DIR}/inception_client.cc
        )
add_dependencies(tf_inception_client
        tfserving_headers
        )


target_link_libraries(tf_inception_client
        ${BOOST_LIBS}
        tfserving
        tensorflow-core
        nsync
        gRPC::grpc++_reflection
        protobuf::libprotobuf

        )

INSTALL(TARGETS tf_inception_client RUNTIME DESTINATION bin)
