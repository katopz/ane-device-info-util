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

//------------------------------------
//
// Helper Methods.
//
//------------------------------------

FREObject toString(NSString* nsstr)
{
    FREObject as3Str = nil;
    
    if(nsstr)
    {
        // Convert NSString to char.
        const char* str = [nsstr UTF8String];
    
        // Prepare for AS3
        FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &as3Str);
    }
    
    // Return data back to ActionScript
	return as3Str;
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
    
    NSString* ssid = nil;
    
    if (dicRef)
        ssid = CFDictionaryGetValue(dicRef, kCNNetworkInfoKeySSID);
        
    // Return data back to ActionScript
	return toString(ssid);
}

FREObject getCurrentMACAddress(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
    
    NSString* macaddr = nil;
    
    if (dicRef)
        macaddr = CFDictionaryGetValue(dicRef, kCNNetworkInfoKeyBSSID);
    
    // Return data back to ActionScript
	return toString(macaddr);
}

FREObject getCurrentDeviceName(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    UIDevice* device = [UIDevice currentDevice];
    
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