//
//  DeviceInfoUtil.m
//  DeviceInfoUtil
//
//  Created by Todsaporn Banjerdkit on 12/2/12.
//  Copyright (c) 2012 Todsaporn Banjerdkit. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>

#import "FlashRuntimeExtensions.h"

// for getMACAddress
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

//------------------------------------
//
// Helper Methods.
//
//------------------------------------

FREObject toString(NSString *nsstr)
{
    FREObject as3Str = nil;
      
    if(nsstr != nil)
    {
        // Convert NSString to char.
        const char *str = [nsstr UTF8String];
    
        // Prepare for AS3
        FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &as3Str);
    }
    
    // Return data back to ActionScript
	return as3Str;
}

NSString *getMACAddress()
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

//------------------------------------
//
// Core Methods.
//
//------------------------------------

FREObject getCurrentSSID(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
    
    NSString *ssid = nil;
    
    if (dicRef)
        ssid = CFDictionaryGetValue(dicRef, kCNNetworkInfoKeySSID);
    
    // Return data back to ActionScript
	return toString(ssid);
}

// Credit
// https://github.com/mateuszmackowiak/NativeAlert/blob/master/XCode/NativeAlert/NativeAlert.m

FREObject getCurrentMACAddress(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    return toString(getMACAddress());
}

FREObject getCurrentDeviceName(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    UIDevice *device = [UIDevice currentDevice];
    
    // Return data back to ActionScript
	return toString([device name]);
}

//------------------------------------
//
// Required Methods.
//
//------------------------------------

// The context initializer is called when the runtime creates the extension context instance.

void DeviceInfoUtilContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
	*numFunctionsToTest = 3;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*3);
    
	func[0].name = (const uint8_t*)"getCurrentSSID";
	func[0].functionData = NULL;
	func[0].function = &getCurrentSSID;
    
    func[1].name = (const uint8_t*)"getCurrentMACAddress";
	func[1].functionData = NULL;
	func[1].function = &getCurrentMACAddress;
	
    func[2].name = (const uint8_t*)"getCurrentDeviceName";
	func[2].functionData = NULL;
	func[2].function = &getCurrentDeviceName;
    
	*functionsToSet = func;
}

// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().

void DeviceInfoUtilContextFinalizer(FREContext ctx)
{
	return;
}

// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void DeviceInfoUtilExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &DeviceInfoUtilContextInitializer;
	*ctxFinalizerToSet = &DeviceInfoUtilContextFinalizer;
}

// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void DeviceInfoUtilExtFinalizer(void* extData)
{
	return;
}