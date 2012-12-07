//
//  AS3.m
//
//  Created by Todsaporn Banjerdkit (katopz) on 12/2/12.
//
//

#import "AS3.h"

@implementation AS3

+(FREObject) toString:(NSString*)nsstr
{
    // Convert NSString to char.
    const char* str = [nsstr UTF8String];
    
    // Prepare for AS3
    FREObject as3Str;
	FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &as3Str);
    
    // Return data back to ActionScript
	return as3Str;
}

+(NSString*) toNSString:(FREObject*)str
{
    // Temporary values to hold our actionscript code.
    uint32_t retStrLength;
    const uint8_t *retStr;
    
    // Turn our actionscrpt code into native code.
    FREGetObjectAsUTF8(str, &retStrLength, &retStr);
    
    // Get str as NSString
    NSString* nsStr = [NSString stringWithUTF8String:(char*)retStr];
    [nsStr retain];
    
    return [nsStr autorelease];
}

@end
