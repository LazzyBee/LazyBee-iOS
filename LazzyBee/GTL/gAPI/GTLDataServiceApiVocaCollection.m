/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLDataServiceApiVocaCollection.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   LazzyBee Backend Api (dataServiceApi/v1.1)
// Description:
//   This is an API
// Classes:
//   GTLDataServiceApiVocaCollection (0 custom class methods, 1 custom properties)

#import "GTLDataServiceApiVocaCollection.h"

#import "GTLDataServiceApiVoca.h"

// ----------------------------------------------------------------------------
//
//   GTLDataServiceApiVocaCollection
//

@implementation GTLDataServiceApiVocaCollection
@dynamic items;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"items" : [GTLDataServiceApiVoca class]
  };
  return map;
}

@end
