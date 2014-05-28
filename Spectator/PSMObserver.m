//
//  PSMObserver.m
//  Spectator
//
//  Created by Paul Schifferer on 1/26/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

#import "PSMObserver.h"


static NSMutableDictionary* observers;

@implementation PSMObserver {

@private
    NSString* _observationContext;

}

- (instancetype)initWithKeyPath:(NSString*)keyPath
                         object:(id)object
                        options:(NSKeyValueObservingOptions)options
                    updateBlock:(PSMObservationCallback)updateBlock {
    self = [super init];
    if(self) {
        self.keyPath = keyPath;
        self.object = object;
        self.updateBlock = updateBlock;

        _observationContext = [[NSUUID UUID] UUIDString];
        [object addObserver:self
                 forKeyPath:keyPath
                    options:options
                    context:(__bridge void*)_observationContext];
    }

    return self;
}

+ (instancetype)observerWithKeyPath:(NSString*)keyPath
                             object:(id)object
                            options:(NSKeyValueObservingOptions)options
                        updateBlock:(PSMObservationCallback)updateBlock {

    PSMObserver* observer = [[PSMObserver alloc] initWithKeyPath:keyPath
                                                          object:object
                                                         options:options
                                                     updateBlock:updateBlock];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observers = [NSMutableDictionary new];
    });

    NSString* key = [NSString stringWithFormat:@"%p:%@", object, keyPath];
    observers[key] = observer;

    return observer;
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {

    if(context != (__bridge void*)_observationContext) {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }

    _updateBlock(keyPath, object, change);
}

- (void)dealloc {

    NSString* key = [NSString stringWithFormat:@"%p:%@", self, _keyPath];
    [observers removeObjectForKey:key];

    [_object removeObserver:self
                 forKeyPath:_keyPath
                    context:(__bridge void*)_observationContext];
}

@end