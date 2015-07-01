//
//  AddressObject.h
//  Soundalizer
//
//  Created by Jonas Jongejan on 29/06/15.
//
//

#import <Foundation/Foundation.h>

@interface AddressObject : NSObject <NSCoding>{
    NSString * address;
    float mappingMin;
    float mappingMax;
}
@property (retain) NSString * address;
@property float mappingMin;
@property float mappingMax;
@end
