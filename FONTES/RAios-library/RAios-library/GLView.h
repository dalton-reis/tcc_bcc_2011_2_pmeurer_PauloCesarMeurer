/*!
 *  GLView.h
 *  FURB RA
 *
 *  Created by Paulo Cesar Meurer on 8/2/11.
 *
 *  Classe criada para representar a camada de vídeo da aplicação
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GLESComum.h"
#import "GLRenderEngine.h"
#import "RAEngine.h"

@interface GLView : UIView {
    EAGLContext* m_context; // Ponteiro para o objeto EAGL que gerencia o contexto de renderização do OpenGL
                            // EAGL é uma API específica da Apple que liga o iOS ao OpenGL.
                            // Antes de uma aplicação chamar qualquer função do OpenGL ES, ela deve inicializar
                            // um objeto EAGLContext e setar ele como o contexto atual.
    
    CADisplayLink       *m_displayLink;     // loop de desenho
    GLRenderEngine      *m_glRenderEngine;  // motor de desenho
    RAEngine            *m_raEngine;        // motor de realidade aumentada. Contém a lista de objetos a serem renderizados
    
    // controle da taxa de frames por segundo
    CFAbsoluteTime      m_currTime;
    CFAbsoluteTime      m_lastCurrTime;
    int                 m_frameRate;
    bool                m_bHabilitarFPS;
    
    // controle do vsync
    CFAbsoluteTime      m_startDraw;
    CFAbsoluteTime      m_endDraw;
}

- (id)initWithFrame:(CGRect)frame resourceProvider:(RAEngine*)engine;
- (void)drawView:(CADisplayLink*)displayLink;
- (void)habilitarFPS:(bool)habilitarFPS;
- (void)habilitarTexturas:(BOOL)habilitarTexturas;
- (void)stopDrawView;

@end
