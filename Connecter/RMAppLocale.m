//
//  RMAppLocale.m
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshot.h"

#import "RMAppLocale.h"

@implementation RMAppLocale

- (id)init
{
    self = [super init];
    if (self) {
        self.localeName = @"en-US";
    }
    return self;
}

- (id)initWithXMLElement:(NSXMLElement *)xmlElement;
{
    self = [super init];
    if (self) {
        self.shouldDeleteLocale = NO;
        
        if ([[xmlElement name] isEqualToString:@"locale"]) {
            self.localeName = [[xmlElement attributeForName:@"name"] stringValue];
            
            self.title = [[[xmlElement elementsForName:@"title"] firstObject] stringValue];
            self.appDescription = [[[xmlElement elementsForName:@"description"] firstObject] stringValue];
            self.whatsNew = [[[xmlElement elementsForName:@"version_whats_new"] firstObject] stringValue];
            self.softwareURL = [[[xmlElement elementsForName:@"software_url"] firstObject] stringValue];
            self.supportURL = [[[xmlElement elementsForName:@"support_url"] firstObject] stringValue];
            self.privacyURL = [[[xmlElement elementsForName:@"privacy_url"] firstObject] stringValue];
            
            // keywords
            NSMutableArray *keywordsArray = [NSMutableArray array];
            NSXMLElement *keywordElements = [[xmlElement elementsForName:@"keywords"] firstObject];
            for (NSXMLElement *element in [keywordElements children]) {
                [keywordsArray addObject:[element stringValue]];
            }
            self.keywords = [keywordsArray copy];
            
            // screenshots
            NSMutableArray *screenshots = [NSMutableArray array];
            NSXMLElement *screenshotsElement = [[xmlElement elementsForName:@"software_screenshots"] firstObject];
            NSArray *screenshotElements = [screenshotsElement children];
            for (NSXMLElement *screenshotElement in screenshotElements) {
                [screenshots addObject:[[RMAppScreenshot alloc] initWithXMLElement:screenshotElement]];
            }
            self.screenshots = screenshots;
        }
    }
    return self;
}

- (NSXMLElement *)xmlRepresentation;
{
    NSXMLElement *locale = [NSXMLElement elementWithName:@"locale"];
    
    if (self.shouldDeleteLocale) {
        [locale setAttributesWithDictionary:@{@"name":self.localeName,
                                              @"remove":@"true"}];
    } else {
        [locale setAttributesWithDictionary:@{@"name":self.localeName}];
        
        [locale addChild:[NSXMLElement elementWithName:@"title"
                                           stringValue:self.title]];
        
        [locale addChild:[NSXMLElement elementWithName:@"description"
                                           stringValue:self.appDescription]];
        
        [locale addChild:[NSXMLElement elementWithName:@"version_whats_new"
                                           stringValue:self.whatsNew]];
        
        [locale addChild:[NSXMLElement elementWithName:@"software_url"
                                           stringValue:self.softwareURL]];
        
        [locale addChild:[NSXMLElement elementWithName:@"support_url"
                                           stringValue:self.supportURL]];
        
        [locale addChild:[NSXMLElement elementWithName:@"privacy_url"
                                           stringValue:self.privacyURL]];
        
        // keywords
        NSXMLElement *keywords = [NSXMLElement elementWithName:@"keywords"];
        NSArray *keywordStrings = self.keywords;
        for (NSString *keywordString in keywordStrings) {
            [keywords addChild:[NSXMLElement elementWithName:@"keyword"
                                                 stringValue:keywordString]];
        }
        [locale addChild:keywords];
        
        // screenshots
        NSXMLElement *screenshots = [NSXMLElement elementWithName:@"software_screenshots"];
        for (RMAppLocale *screenshot in self.screenshots) {
            NSXMLElement *screenshotElement = [screenshot xmlRepresentation];
            [screenshots addChild:screenshotElement];
        }
        [locale addChild:screenshots];
    }
    
    return locale;
}

@end

