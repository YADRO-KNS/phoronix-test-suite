#!/bin/sh

unzip -o coremark-20190727.zip
cd coremark-master
if [ $OS_TYPE = "BSD" ]
then
    gmake XCFLAGS="$CFLAGS -DMULTITHREAD=1 -DUSE_FORK=1" compile PORT_DIR=linux64
    gmake XCFLAGS="$CFLAGS -DMULTITHREAD=$NUM_CPU_CORES -DUSE_FORK=1" compile PORT_DIR=linux64
else
    make XCFLAGS="$CFLAGS -DMULTITHREAD=1 -DUSE_FORK=1" compile
    make XCFLAGS="$CFLAGS -DMULTITHREAD=$NUM_CPU_CORES -DUSE_FORK=1" OUTNAME="coremark-threaded.exe" compile
fi

echo $? > ~/install-exit-status
cd ~

echo "#!/bin/sh
cd coremark-master
./coremark.exe > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > coremark
chmod +x coremark

THREADED_DIR="../coremark-1.0.1-threaded"
mkdir -p ${THREADED_DIR}
cp -r . ${THREADED_DIR}
cd ${THREADED_DIR}

echo "#!/bin/sh
cd coremark-master
./coremark-threaded.exe > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > coremark-1.0.1-threaded
chmod +x coremark-1.0.1-threaded
