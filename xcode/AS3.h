//
//  AS3.h
//
//  Created by Todsaporn Banjerdkit (katopz) on 12/2/12.
//
//

#ifndef AS3_h
#define AS3_h

#import "FlashRuntimeExtensions.h"

@interface AS3
+(FREObject)toString:(NSString*)nsstr;
+(NSString*)toNSString:(FREObject*)str;
@end

#endif
