#!/bin/bash
echo "packing ane-device-info-util..."
cd /Volumes/exFAT/anes/ane-device-info-util/as3/bin
adt -package -target ane device-info-util.ane extension.xml -swc device-info-util.swc -platform iPhone-ARM library.swf libDeviceInfoUtil.a
echo "Done!"