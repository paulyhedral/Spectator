//
//  PSMObserver.h
//  Spectator
//
//  Created by Paul Schifferer on 1/26/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import Foundation;


typedef void (^PSMObservationCallback)(NSString* keyPath, id object, NSDictionary* change);

@interface PSMObserver : NSObject

@property (nonatomic, copy) NSString* keyPath;
@property (nonatomic, strong) id object;
@property (nonatomic, copy) PSMObservationCallback updateBlock;

- (instancetype)initWithKeyPath:(NSString*)keyPath
                         object:(id)object
                        options:(NSKeyValueObservingOptions)options
                    updateBlock:(PSMObservationCallback)updateBlock;

+ (instancetype)observerWithKeyPath:(NSString*)keyPath
                             object:(id)object
                            options:(NSKeyValueObservingOptions)options
                        updateBlock:(PSMObservationCallback)updateBlock;

@end