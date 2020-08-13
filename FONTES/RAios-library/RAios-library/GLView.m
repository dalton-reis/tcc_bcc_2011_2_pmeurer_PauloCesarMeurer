/*!
 *  GLView.mm
 *  FURB RA
 *
 *  Created by Paulo Cesar Meurer on 8/2/11.
 *
 *  Classe criada para representar a camada de vídeo da aplicação
 */

#import "GLView.h"

@implementation GLView

// Para aplicações OpenGL, este método deve ser sempre sobreescrito e retornar um CAEAGLLayer
// Isto deve ser feito porque queremos que a nossa view seja uma camada subjacente de Core Animation.
//developer.apple.com/library/ios/#documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/WorkingwithEAGLContexts/WorkingwithEAGLContexts.html#//apple_ref/doc/uid/TP40008793-CH103-SW1
+ (Class)layerClass{
    return [CAEAGLLayer class];
}

#pragma mark - Inicialização

- (id)initWithFrame:(CGRect)frame resourceProvider:(RAEngine*)engine
{
    self = [super initWithFrame:frame];
    if (self) {
        
        m_raEngine = engine;
        m_bHabilitarFPS = false;
        
        // atribui a propriedade layer da classe UIView para eaglLayer isto é possivel por causa o override do método layerClass
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*) super.layer;    
        
        // indica que não precisa do Quartz para manipular transparência
        eaglLayer.opaque = NO; 
        setBackgroundColor:[UIColor clearColor];
        
        // cria o contexto de renderização e especifica qual versão do OpenGl vai ser utilizada
        m_context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        // seta o contexto EAGL como corrente. Isto significa que qualquer chamada ao OpenGL nesta Thread vai ser
        // amarrada a este contexto
        if(!m_context || ![EAGLContext setCurrentContext:m_context]){
            [self release];
            return nil;
        }
        
        // cria uma instância do motor de renderização
        m_glRenderEngine = [[GLRenderEngine alloc]initForContext:m_context fromDrawable:eaglLayer];
        
        // inicializa a engine de renderização com o tamanho da tela do dispositivo
        if( ! [m_glRenderEngine initializeEngine:frame]){
            NSLog(@"Erro ao inicializar o motor grafico.");
            [self release];
            return nil;
        }
        
        // cria o loop de animação
        // developer.apple.com/library/ios/#documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/WorkingwithEAGLContexts/WorkingwithEAGLContexts.html#//apple_ref/doc/uid/TP40008793-CH103-SW1
        m_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        m_displayLink.frameInterval = 1;
        [m_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

#pragma mark - Gerencia de memória

- (void)dealloc
{
    // encerra o loop de animação
    //[m_displayLink invalidate];
    //[m_displayLink release];
    
    // verifica se o contexto atual é o contexto definido para o OpenGL
    if( [EAGLContext currentContext] == m_context){
        [EAGLContext setCurrentContext:nil];
    }
    
    // libera a memória alocada para m_context
    [m_context release];
    
    // libera a memória alocada para o motor de renderização
    [m_glRenderEngine release];
    
    [super dealloc];
}

#pragma mark - Animação

- (void)habilitarFPS:(bool)habilitarFPS{
    m_bHabilitarFPS = habilitarFPS;
}

- (void)habilitarTexturas:(BOOL)habilitarTexturas{
    [m_glRenderEngine habilitarTexturas:habilitarTexturas];
}

- (void)stopDrawView{
    [m_displayLink invalidate];
}

- (void)drawView:(CADisplayLink*)displayLink{
    
    // contador de FPS
    static int frames = 0;
    static float timeThisSecond = 0;
    m_currTime = CFAbsoluteTimeGetCurrent();
    timeThisSecond = m_currTime - m_lastCurrTime;
    //frames++;
    if( timeThisSecond > 1.0){
        NSLog(@"fps %d", frames);
        m_frameRate = frames;
        frames = 0;
        m_lastCurrTime = m_currTime;
    }
    
    /*/ controle de vsync
    static double bank = 0;
    double frameTime = displayLink.duration * displayLink.frameInterval;
    bank -= frameTime;
    if( bank > 0 )
    {
        return;
    }
    bank = 0;
    m_startDraw = CFAbsoluteTimeGetCurrent();
    */
    
    // renderiza os objetos
    [m_glRenderEngine renderObjects:m_raEngine->m_arrayObjetos toRoll:m_raEngine->m_roll    toAzimuth:m_raEngine->m_azimuth orientacaoDispositivo:m_raEngine->m_deviceOrientation desenharFPS:m_bHabilitarFPS fps:m_frameRate];
    
    // apresenta o conteúdo do frame buffer
    [m_context presentRenderbuffer:GL_RENDERBUFFER];
    
    frames++;
    /*/ controle de vsync
    m_endDraw = CFAbsoluteTimeGetCurrent();
    double elapsed = m_endDraw - m_startDraw;
    bank = elapsed;
    if( elapsed > frameTime )
    {
        bank = frameTime + fmod( elapsed, frameTime );
    }*/
}

#pragma mark - Eventos de toque na tela

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    UITouch*	touch = [[event touchesForView:self] anyObject];
	CGPoint ponto = [touch locationInView:self];
    
    [m_glRenderEngine checkCollision:m_raEngine->m_arrayObjetos touchX:ponto.x touchY:ponto.y orientacaoDispositivo:m_raEngine->m_deviceOrientation];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

@end
