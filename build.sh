#!/bin/bash -e
#SOURCE_FILE=$NAME-$VERSION.tar.gz
# We will build the code from the github repo, but if we want specific versions,
# a new Jenkins job will be created for the version number and we'll provide
# the URL to the tarball in the configuration.
SOURCE_REPO="http://wpfilebase.s3.amazonaws.com/torque"
# We pretend that the $SOURCE_FILE is there, even though it's actually a dir.
NAME="torque"
VERSION="2.5.13"
SOURCE_FILE="$NAME-$VERSION.tar.gz"

module load ci
module load gcc/$GCC_VERSION

echo "REPO_DIR is "
echo $REPO_DIR
echo "SRC_DIR is "
echo $SRC_DIR
echo "WORKSPACE is "
echo $WORKSPACE
echo "SOFT_DIR is"
echo $SOFT_DIR

mkdir -p $WORKSPACE
mkdir -p $SRC_DIR
mkdir -p $SOFT_DIR

#  Download the source file

if [[ ! -e $SRC_DIR/$SOURCE_FILE ]] ; then
  echo "seems like this is the first build - Let's get the $SOURCE_FILE from $SOURCE_REPO and unarchive to $WORKSPACE"
  mkdir -p $SRC_DIR
  echo "Downloading from: $SOURCE_REPO/$SOURCE_FILE"
  wget $SOURCE_REPO/$SOURCE_FILE -O $SRC_DIR/$SOURCE_FILE
  #tar -xvzf $SRC_DIR/$SOURCE_FILE -C $WORKSPACE  
else
  echo "continuing from previous builds, using source at " $SRC_DIR/$SOURCE_FILE
fi

echo "untar the tarball"
tar -xvzf $SRC_DIR/$SOURCE_FILE -C $WORKSPACE
echo "change to working directory"
cd $WORKSPACE/$NAME-$VERSION

echo "cleaning up previous builds"
#make distclean
echo "Configuring the build"
CC=`which gcc` CXX=`which g++` ./configure --prefix=${SOFT_DIR} --without-tcl --with-server-home=${SOFT_DIR}/spool
echo "Running the build"
make all
