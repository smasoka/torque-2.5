module load ci
echo "About to make the modules"
cd $WORKSPACE/$NAME-$VERSION
ls
echo $?

make install # DESTDIR=$SOFT_DIR

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
   puts stderr "\tAdds Torque Resource Manager 2.5.13 to your environment"
}

module load gcc/$GCC_VERSION

module-whatis   "$NAME $VERSION."
setenv       TORQUE_VERSION       $VERSION
setenv       TORQUE_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path    PATH            $::env(TORQUE_DIR)/bin
prepend-path    PATH            $::env(TORQUE_DIR)/include
prepend-path    PATH            $::env(TORQUE_DIR)/bin
prepend-path    MANPATH         $::env(TORQUE_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(TORQUE_DIR)/lib
MODULE_FILE
) > modules/$VERSION
mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME/$VERSION

# Testing module
module avail
module list

echo "PATH"
echo $PATH
echo "LD_LIBRARY_PATH"
echo $LD_LIBRARY_PATH

module load $NAME/$VERSION
module list

echo "PATH"
echo $PATH
echo "LD_LIBRARY_PATH"
echo $LD_LIBRARY_PATH

which qsub

# Add a test to check

