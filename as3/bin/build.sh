#!/bin/bash
echo "packing ane-device-info-util..."
adt -package -target ane device-info-util.ane extension.xml -swc device-info-util.swc -platform iPhone-ARM library.swf libDeviceInfoUtil.a
echo "Done!"