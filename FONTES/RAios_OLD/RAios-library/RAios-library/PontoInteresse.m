//
//  PontoInteresse.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/24/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "PontoInteresse.h"
#import "PainelDraw.h"

@implementation PontoInteresse
 @synthesize geoLat      = m_geoLat;
 @synthesize geoLon      = m_geoLon;
 @synthesize sDescricao  = m_sDescricao;

-(id)init{
    // caso seja chamado o construtor padrão
    return [self initWithDescricao:@"" latitude:NAN longitude:NAN];
}

-(id)initWithDescricao:(NSString *)desc latitude:(float)lat longitude:(float)lon{
    
    if((self = [super init])){
        m_sDescricao      = desc;
        m_geoLat          = lat;
        m_geoLon          = lon;
    }
    
    return self;
}

-(void)dealloc{
    [m_sDescricao release];
    [super dealloc];
}

- (void)onDraw{
    [PainelDraw renderPainelWithString:m_sDescricao];
}

- (void)onSelect{
    NSString *msg = [[NSString alloc]initWithFormat:@"%@", m_sDescricao];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Furb RA" message:msg delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    [msg release];
}


@end
