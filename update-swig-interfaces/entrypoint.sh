#!/bin/bash

# rm -rf interfaces/*/interface/*
COMMON_CMAKE_OPTIONS="-DHELICS_SWIG_GENERATE_INTERFACE_FILES_ONLY=ON -DHELICS_OVERWRITE_INTERFACE_FILES=ON -DHELICS_BUILD_EXAMPLES=OFF -DHELICS_ENABLE_ZMQ_CORE=OFF -DHELICS_BUILD_TESTS=OFF -DHELICS_BUILD_APP_EXECUTABLES=OFF -DHELICS_DISABLE_BOOST=ON -DHELICS_ENABLE_SWIG=ON"

if [[ "${INPUT_MATLAB}" == "true" ]];
then
    rm -rf interfaces/matlab/interface/*
    mkdir build_matlab
    pushd build_matlab
    cmake -DHELICS_BUILD_MATLAB_INTERFACE=ON -DSWIG_EXECUTABLE=/root/swig-matlab/bin/swig ${COMMON_CMAKE_OPTIONS} ..
    make -j2 mfile_overwrite
    popd
fi

if [[ "${INPUT_JAVA}" == "true" ]];
then
    rm -rf interfaces/java/interface/*
    mkdir build_java_interface
    pushd build_java_interface
    cmake -DHELICS_BUILD_JAVA_INTERFACE=ON ${COMMON_CMAKE_OPTIONS} ..
    make -j2 javafile_overwrite
    popd
fi

if [[ "${INPUT_PYTHON}" == "true" ]];
then
    rm -rf interfaces/python/interface/* || true
    mkdir build_python_interface
    pushd build_python_interface
    cmake -DHELICS_BUILD_PYTHON_INTERFACE=ON ${COMMON_CMAKE_OPTIONS} ..
    make -j2 pythonfile_overwrite
    popd
fi

if [[ "${INPUT_CSHARP}" == "true" ]];
then
    rm -rf interfaces/csharp/interface/* || true
    mkdir build_csharp_interface
    pushd build_csharp_interface
    cmake -DHELICS_BUILD_CSHARP_INTERFACE=ON ${COMMON_CMAKE_OPTIONS} ..
    make -j2 csharpfile_overwrite
    popd
fi

if [[ "${INPUT_OCTAVE}" == "true" ]];
then
    rm -rf interfaces/octave/interface/* || true
    mkdir build_octave_interface
    pushd build_octave_interface
    cmake -DHELICS_BUILD_OCTAVE_INTERFACE=ON ${COMMON_CMAKE_OPTIONS} ..
    make -j2 octavefile_overwrite
    popd
fi