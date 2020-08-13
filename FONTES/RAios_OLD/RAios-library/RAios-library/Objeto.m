//
//  Objeto.m
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/24/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import "Objeto.h"


@implementation Objeto

// caso chame o contrutor padrão
- (id)init{
    return [self initWithLocation:nil];
}

- (id)initWithLocation:(PontoInteresse*)pontoInteresse{
    if((self = [super init])){
        m_pontoInteresse  = pontoInteresse;
        if(m_pontoInteresse)
            [m_pontoInteresse retain];
        
        m_geoDistancia    = NAN;
    
        m_glAngulo        = NAN;
    
        m_glSetaX         = NAN;
        m_glSetaY         = NAN;
        m_glSetaZ         = NAN;
    
        m_glRadarX        = NAN;
        m_glRadarY        = NAN;
    
        m_glObjetoX       = NAN;
        m_glObjetoY       = NAN;
        m_glObjetoZ       = NAN;
    }
    return self;
}

- (void)dealloc{
    [m_pontoInteresse release];
    
    [super dealloc];
}

- (void)onDraw{
    [m_pontoInteresse onDraw];
    
}

- (void)onSelect{
    [m_pontoInteresse onSelect];
}

@end
