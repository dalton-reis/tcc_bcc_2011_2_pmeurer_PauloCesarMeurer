//
//  PontoInteresse.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/24/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PontoInteresse : NSObject {
	double m_geoLat;
	double m_geoLon;
	NSString *m_sDescricao;
}

 @property double geoLat;
 @property double geoLon;
 @property (nonatomic, retain) NSString *sDescricao;


- (id)initWithDescricao:(NSString*)desc latitude:(float)lat longitude:(float)lon;

- (void)onDraw;
- (void)onSelect;

@end
