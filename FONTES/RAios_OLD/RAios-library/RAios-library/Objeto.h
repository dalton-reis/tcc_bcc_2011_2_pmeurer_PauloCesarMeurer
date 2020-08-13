//
//  Objeto.h
//  FURB RA
//
//  Created by Paulo Cesar Meurer on 8/24/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PontoInteresse.h"

@interface Objeto : NSObject {
@public
    
    /*
     * Variáveis para o desenho da seta. glAngulo È o ângulo que vai rotacionar a seta para que ela,
     * partindo do ponto da câmera, aponte para este ponto de interesse. glSetaX e glSetaY são
     * respectivamente os pontos X e Y aonde vai ser desenhado o centro da seta.
     */
    float m_glAngulo; // Em graus.
    
    float m_glSetaX;
    float m_glSetaY;
    float m_glSetaZ;
    
    // Variáveis para o desenho do ponto dentro do radar.
    float m_glRadarX;
    float m_glRadarY;
    
    // Variáveis para o desenho do ponto de interesse.
    float m_glObjetoX;
    float m_glObjetoY;
    float m_glObjetoZ;
    
    /*************************************************************************************************
     * Atributos de coordenadas geográficas
     */
	double m_geoDistancia; // Distancia em metros para a camera.
    
    // Determina se o ponto está muito distante a ponto de não aparecer na bússola.
	bool m_foraRadar;
	bool m_foraTela;
    
    // Ponto de interesse
    PontoInteresse *m_pontoInteresse;
}

- (id)initWithLocation:(PontoInteresse*)pontoInteresse;
- (void)onDraw;
- (void)onSelect;

@end
