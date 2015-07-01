//
//  AddressObject.m
//  Soundalizer
//
//  Created by Jonas Jongejan on 29/06/15.
//
//

#import "AddressObject.h"

@implementation AddressObject
@synthesize mappingMax,mappingMin,address;

-(id)init{
    if(!self.address) self.address = @"/address";    
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeFloat:self.mappingMin forKey:@"mappingMin"];
    [aCoder encodeFloat:self.mappingMax forKey:@"mappingMax"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    if(self){
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.mappingMin = [aDecoder decodeFloatForKey:@"mappingMin"];
        self.mappingMax = [aDecoder decodeFloatForKey:@"mappingMax"];
    }
    return self;
}


@end
