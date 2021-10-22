#!/bin/sh

tar -jxf stream-2013-01-17.tar.bz2

if [ "X$CFLAGS_OVERRIDE" = "X" ]
then
    CFLAGS="$CFLAGS -march=native"
else
    CFLAGS="$CFLAGS_OVERRIDE"
fi

STREAM_ARRAY_SIZE=10000000
L3_CACHE_SIZE=`getconf LEVEL3_CACHE_SIZE`
SIZE_BASED_ON_L3=$((L3_CACHE_SIZE * 4))

if [ $SIZE_BASED_ON_L3 -gt $STREAM_ARRAY_SIZE ]
then
     STREAM_ARRAY_SIZE=$SIZE_BASED_ON_L3
fi

cc stream.c -DSTREAM_ARRAY_SIZE=$STREAM_ARRAY_SIZE -DNTIMES=100 $CFLAGS -o stream-bin
echo $? > ~/install-exit-status

cc stream.c -DSTREAM_ARRAY_SIZE=$STREAM_ARRAY_SIZE -DNTIMES=100 $CFLAGS -fopenmp -o stream-bin-threaded
echo $? > ~/install-exit-status

echo "#!/bin/sh
./stream-bin > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > stream
chmod +x stream

THREADED_DIR="../stream-1.3.2-threaded"
mkdir -p ${THREADED_DIR}
cp -r . ${THREADED_DIR}
cd ${THREADED_DIR}

echo "#!/bin/sh
export OMP_NUM_THREADS=\$NUM_CPU_CORES
./stream-bin-threaded > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > stream-1.3.2-threaded
chmod +x stream-1.3.2-threaded
