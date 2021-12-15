#!/bin/bash

##
# https://fio.readthedocs.io/en/latest/fio_doc.html
##

#/tmp/test-mount
test_folder=""
if [ ! -d "$1" ]; then
    if [ ! -z "$TEST_FOLDER_PATH" ]; then
        test_folder=$TEST_FOLDER_PATH
    fi
else
    test_folder=$1
fi

test_filepath=$test_folder/fio-testfile

function cleanup() {
    test_name=$1

    rm -f $test_filepath

    if [ ! -z "$test_name" ]; then
        rm -f $test_folder/$test_name.*
    fi
}

if [ ! -d "$test_folder" ]; then
    echo "Folder '$test_folder' does not exist! Cannot proceed."
    exit -1
fi
cd $test_folder
echo "Will use test folder '$test_folder' ..."

## https://docs.oracle.com/en-us/iaas/Content/Block/References/samplefiocommandslinux.htm

echo -e "\n\n"
echo "== IOPS Performance Tests"

echo -e "-----------------------------------\n"
echo "= Test random reads - 1MB"
fio --size=1m --direct=1 --readwrite=randread --blocksize=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1
cleanup "iops-test-job"

echo -e "-----------------------------------\n"
echo "= Test random reads - 5kB"
fio --size=5k --direct=1 --readwrite=randread --blocksize=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1 
cleanup "iops-test-job"

echo -e "-----------------------------------\n"
echo "= Test sequential reads - 1MB"
fio --size=1m --direct=1 --readwrite=read --blocksize=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1
cleanup "iops-test-job"

echo -e "-----------------------------------\n"
echo "= Test sequential reads - 5kB"
fio --size=5k --direct=1 --readwrite=read --blocksize=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1
cleanup "iops-test-job"

echo -e "-----------------------------------\n"
echo "= Test file random read/writes - 1GB"
fio --filename=$test_filepath --size=1g --direct=1 --readwrite=randrw --blocksize=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1
cleanup

echo -e "-----------------------------------\n"
echo "= Test file random read/writes - 1MB"
fio --filename=$test_filepath --size=1m --direct=1 --readwrite=randrw --blocksize=4k --ioengine=libaio --iodepth=256 --runtime=120 --numjobs=4 --time_based --group_reporting --name=iops-test-job --eta-newline=1
cleanup


echo -e "\n\n"
echo "== Throughput Performance Tests"

echo -e "-----------------------------------\n"
echo "= Test random reads - 1MB"
fio --size=1m --direct=1 --readwrite=randread --blocksize=64k --ioengine=libaio --iodepth=64 --runtime=120 --numjobs=4 --time_based --group_reporting --name=throughput-test-job --eta-newline=1
cleanup "throughput-test-job"

echo -e "-----------------------------------\n"
echo "= Test random reads - 65kB"
fio --size=65k --direct=1 --readwrite=randread --blocksize=64k --ioengine=libaio --iodepth=64 --runtime=120 --numjobs=4 --time_based --group_reporting --name=throughput-test-job --eta-newline=1
cleanup "throughput-test-job"

echo -e "-----------------------------------\n"
echo "= Test sequential reads - 1MB"
fio --size=1m --direct=1 --readwrite=read --blocksize=64k --ioengine=libaio --iodepth=64 --runtime=120 --numjobs=4 --time_based --group_reporting --name=throughput-test-job --eta-newline=1
cleanup "throughput-test-job"

echo -e "-----------------------------------\n"
echo "= Test sequential reads - 65kB"
fio --size=65k --direct=1 --readwrite=read --blocksize=64k --ioengine=libaio --iodepth=64 --runtime=120 --numjobs=4 --time_based --group_reporting --name=throughput-test-job --eta-newline=1
cleanup "throughput-test-job"

echo -e "-----------------------------------\n"
echo "= Test file random read/writes - 1GB"
fio --filename=$test_filepath --size=1g --direct=1 --readwrite=randrw --blocksize=64k --ioengine=libaio --iodepth=64 --runtime=120 --numjobs=4 --time_based --group_reporting --name=throughput-test-job --eta-newline=1 
cleanup

echo -e "-----------------------------------\n"
echo "= Test file random read/writes - 1MB"
fio --filename=$test_filepath --size=1m --direct=1 --readwrite=randrw --blocksize=64k --ioengine=libaio --iodepth=64 --runtime=120 --numjobs=4 --time_based --group_reporting --name=throughput-test-job --eta-newline=1 
cleanup

echo -e "\n\n"
echo "== Latency Performance Tests"

echo -e "-----------------------------------\n"
echo "= Test random reads for latency - 1MB"
fio --size=1m --direct=1 --readwrite=randread --blocksize=4k --ioengine=libaio --iodepth=1 --numjobs=1 --time_based --group_reporting --name=readlatency-test-job --runtime=120 --eta-newline=1
cleanup "readlatency-test-job"

echo -e "-----------------------------------\n"
echo "= Test random reads for latency - 5kB"
fio --size=5k --direct=1 --readwrite=randread --blocksize=4k --ioengine=libaio --iodepth=1 --numjobs=1 --time_based --group_reporting --name=readlatency-test-job --runtime=120 --eta-newline=1
cleanup "readlatency-test-job"

## https://docs.gitlab.com/ee/administration/operations/filesystem_benchmarking.html

echo -e "\n\n"
echo "== performs 4KB reads and writes using a 75%/25% split within the file, with 64 operations running at a time - 1GB"
fio --filename=$test_filepath --size=1g --direct=1 --readwrite=randrw --blocksize=4k --ioengine=libaio --iodepth=64 --randrepeat=1 --gtod_reduce=1 --rwmixread=75 --name=iops-test2-job
cleanup


# echo 3 > /proc/sys/vm/drop_caches
# dd if=/dev/zero of=/tmp/testfile.bin bs=1M count=10000 conv=fsync status=progress oflag=dsync

# echo 3 > /proc/sys/vm/drop_caches
# dd if=/tmp/testfile.bin of=/dev/null bs=1M status=progress iflag=dsync
