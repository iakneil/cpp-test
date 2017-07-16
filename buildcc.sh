#!/bin/bash

BuildPath=.
TinyXML=/home/qwn/tinyxml
CPPCheckReport=cppcheckreport.xml
CPPCheckApp=/usr/bin/cppcheck
CPPNCSSReport=cppncssreport.xml
CPPNCSSApp=/usr/share/cppncss/bin/cppncss
GCOVReport=gcovreport.xml
GCOVRApp=/usr/bin/gcovr

SRCDir=.
RunPath=$BuildPath

GTestReport=gtestreport.xml

echo "clean server"
make clean
rm *.gcov > /dev/null
rm $CPPCheckReport > /dev/null
rm $CPPNCSSReport > /dev/null
rm $GCOVReport > /dev/null
rm $GTestReport > /dev/null

echo "make..."
make

if [ -r "$BuildPath" ]; then
    echo "Make Success"
    echo "Make CPPCheck Report $CPPCheckReport"
    $CPPCheckApp -v --enable=all --xml -I $TinyXML $SRCDir  2> $CPPCheckReport

    echo "Make CPPNCSS Report $CPPNCSSReport"
    #mkdir ./cppncss > /dev/null
    $CPPNCSSApp -r -v -x -k -f=$CPPNCSSReport ./

    echo "Run Test Program, Make Test Report"
    $RunPath/sample1_unittest --gtest_output=xml:$GTestReport > /dev/null

    echo "Make GCovr"
    $GCOVRApp -x -r . > $GCOVReport
else
    echo "Make Fail!"
fi
