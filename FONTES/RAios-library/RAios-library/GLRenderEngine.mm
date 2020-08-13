/*!
 *  GLRenderEngine.mm
 *  FURB RA
 *
 *  Created by Paulo Cesar Meurer on 8/10/11.
 *
 *  Classe criada para efetuar as operações gráficas
 */

#import "GLRenderEngine.h"
#import "glu.h"
#import "math.h"
#import "SetaDraw.h"
#import "Objeto.h"
#import "GLTextRenderer.h"

//PFS
static const Point3D vertices[] = {
    { 0.0,  480.0, 0.0},
    { 0.0,  445.0, 0.0},
    { 35.0,  480.0, 0.0},
    { 35.0,  445.0, 0.0},
    
};

static const GLfloat texCoordsB[] = {    
    0.0, 1.0,
    1.0, 1.0,
    0.0, 0.0,
    1.0, 0.0,
};

static const GLfloat texCoordsA[] = {
    0.0, 1.0,
    1.0, 1.0,
    0.0, 0.0,
    1.0, 0.0,
};

@implementation GLRenderEngine

#pragma mark -
#pragma mark Inicialização

// Não permite instanciar a classe diretamente
- (id)init{
    return nil;
}

- (id)initForContext:(EAGLContext*)context fromDrawable:(CAEAGLLayer*)eaglLayer{
    self = [super init];
    if(self){
        
        m_zFar = 20;
        m_zNear = 1;
        
        m_bHabilitarTexturas = true;
        
        // documentação do OpenGL ES da Apple
        //developer.apple.com/library/ios/#documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/OpenGLESontheiPhone/OpenGLESontheiPhone.html
        
        // gera um identificador para o renderBuffer
        glGenRenderbuffersOES(1, &m_renderBuffer);
        
        // vincula o renderBuffer no pipeline
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_renderBuffer);
        
        // Antes de renderizar qualquer coisa é necessário alocar espaço de armazenamento para o renderBuffer
        // enviando uma mensagem para o EAGLContext
        // utiliza a largura, altura e o formato de pixel do layer (eaglLayer)
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
        
        // gera um identificador para o frameBuffer
        glGenFramebuffersOES(1, &m_frameBuffer);
        
        // vincula o frameBuffer no pipeline
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_frameBuffer);
        
        // vincula o renderBuffer ao frameBuffer
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, m_renderBuffer);
        
        // checa o status do frame buffer
        if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
            NSLog(@"Erro ao criar o frame buffer %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
            return nil;
        }
    }
    return self;
}

- (BOOL)initializeEngine:(CGRect)frame{
    
    // Guarda o frame
    m_frame = frame;
    
    // inicializa a viewport
    glViewport(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    glGetIntegerv( GL_VIEWPORT, m_viewport );
    
    // inicializa a matriz de projeção
    glMatrixMode(GL_PROJECTION);

    // configura o frustum
    float aspect = CGRectGetWidth(frame)/CGRectGetHeight(frame);
    glFrustumf(-aspect, aspect, -1, 1, m_zNear, m_zFar);
    glGetFloatv( GL_PROJECTION_MATRIX, m_projection );
    
    // configura a matriz modelo
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glGetFloatv( GL_MODELVIEW_MATRIX, m_modelview );
    
    // habilita os atributos de posição e cor para os vertices
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    // para suportar a renderização de texturas
    //glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    return YES;
}

#pragma mark -
#pragma mark Gerencia de memória

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Desenho

- (void)habilitarTexturas:(BOOL)habilitarTexturas{
    m_bHabilitarTexturas = habilitarTexturas;
}

-(void) renderObjects:(NSMutableArray *)objects toRoll:(float)roll toAzimuth:(float)azimuth orientacaoDispositivo:(UIDeviceOrientation)orientacao desenharFPS:(bool)desenharPFS fps:(int)fps{
    
    glLoadIdentity();
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    // verifica se é para desenhar as setas ou o objeto
    bool bDesenharSetas = (orientacao == UIDeviceOrientationFaceUp);
    
    // Rotaciona conforme a orientação
    if(bDesenharSetas){
        glRotatef(azimuth, 0.0f, 0.0f, 1.0f);
    }
    else{
        glRotatef(roll, 0.0f, 1.0f, 0.0f); //Rotate Up And Down To Look Up And Down
        glRotatef(azimuth, 0.0f, 0.0f, 1.0f);
    }
    
    // guarda a model view matrix
    glGetFloatv( GL_MODELVIEW_MATRIX, m_modelview );
    
    if(bDesenharSetas)
    {
        // Limpa o renderBuffer para o fundo opaco
        glClearColor(0, 0, 0, 1);
    }
    else{
        // Limpa o renderBuffer para o fundo transparente
        glClearColor(0, 0, 0, 0);
    }
    
    // desenha os pontos de interesse
    for (Objeto* obj in objects) {
        
        // verifica se o ponto está visivel
        if (obj->m_foraTela) {
            continue;
        }
        
        // insere a matriz de transformação corrente na pilha, por causa das transformações
        glPushMatrix();
        
        if(bDesenharSetas)
        {
            // alinha o ângulo e a posição para desenhar a seta
            glTranslatef(obj->m_glSetaX, obj->m_glSetaY, obj->m_glSetaZ);
            glRotatef(-obj->m_glAngulo, 0.0f, 0.0f, 1.0f);
            
            if(m_bHabilitarTexturas)
                [SetaDraw renderSetaForAngle:-obj->m_glAngulo forDistance:obj->m_geoDistancia];
            else
                [SetaDraw renderSetaForAngle:-obj->m_glAngulo];
        }
        else
        {
            // alinha o ângulo e a posição para desenhar o objeto
            glTranslatef(obj->m_glObjetoX, obj->m_glObjetoY, obj->m_glObjetoZ);
            glRotatef(90.0, 1.0f, 0.0f, 0.0f);
            glRotatef(-obj->m_glAngulo, 0.0f, 1.0f, 0.0f);
            
            [obj onDraw];
        }
        
        // retira a matriz do topo da pilha e torna esta última a matriz de transformação corrente
        glPopMatrix();
    }

    // desenha o FPS
    if(desenharPFS)
        [self drawFPS:fps];
}

- (void)drawFPS:(int)fps{
    // teste - INI
    [self switchToOrtho];
    
     glColor4f(1.0, 1.0, 1.0, 1.0);
     glLoadIdentity();
    
    // renderiza o texto
    NSString *str = [[NSString alloc]initWithFormat:@"%d fps", fps];
    UIFont *font = [UIFont systemFontOfSize:20];
    [GLTextRenderer renderText:str forFont:font vertexCoord:(GLvoid*)&vertices textureCoord:(GLvoid*)texCoordsB redValue:1.0 greenValue:1.0 blueValue:1.0 alphaValue:1.0];
    [str release];
     
    /*//////////////////////////////////////////////////////////////////////////
    // cria a textura com o texto a ser exibido
    NSString *str = [[NSString alloc]initWithFormat:@"%d fps", fps];
    UIFont *font = [UIFont systemFontOfSize:20];
    CGSize size = [str sizeWithFont:font];
    
    NSInteger i;
    
    size_t width = size.width;
    if((width != 1) && (((int)width) & (((int)width) - 1))) {
        i = 1;
        while(i < width)
            i *= 2;
        width = i;
    }
    
    size_t height = size.height;
    if((height != 1) && (((int)height) & (((int)height) - 1))) {
        i = 1;
        while(i < height)
            i *= 2;
        height = i;
    }
    
    NSInteger BitsPerComponent = 8;
    
    int bpp = BitsPerComponent / 2;
    int byteCount = width * height * bpp;
    uint8_t *data = (uint8_t*) calloc(byteCount, 1);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 BitsPerComponent,
                                                 bpp * width,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextTranslateCTM(context, 0.0f, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    UIGraphicsPushContext(context);
    
    [str drawInRect:CGRectMake(0,
                               0,
                               size.width,
                               size.height)
           withFont:font
      lineBreakMode:UILineBreakModeWordWrap
          alignment:UITextAlignmentCenter];
    UIGraphicsPopContext();
    CGContextRelease(context);
    ///////////////////////////////////////////////////////////////////////////
    
    // renderiza a textura criada
    
    // habilita o array de coordenadas de textura 
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
	// Create a new texture from the camera frame data, display that using the shaders
    GLuint		texture[1];
	glGenTextures(1, &texture[0]);
	glBindTexture(GL_TEXTURE_2D, texture[0]);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
    // isto é necessário para texturas que não são potência de dois
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
    // utiliza BRGA para gerar o quadro com a textura
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, [[NSData dataWithBytesNoCopy:data length:byteCount freeWhenDone:YES] bytes]);
    
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    
    glTexCoordPointer(2, GL_FLOAT, 0, texCoordsB);
    
    // desenha os triangulos com a textura
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // desabilita a primitiva de array de coordenadas de textura
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // delete a textura criada
    glDeleteTextures(1, &texture[0]);
     */
     
     [self switchBackToFrustum];
     // teste - FIM
}

#pragma mark -
#pragma mark Detecção de colisão

// Funções inline www.tiexpert.net/programacao/c/funcoes-inline.php
static inline bool verificaColisao( Point3D point, Point3D center, float raio){
    return (pow(point.x - center.x, 2) + pow(point.y - center.y, 2) + pow(point.z - center.z, 2)) < pow(raio, 2);
}

- (bool)checkCollision:(NSMutableArray*)objects touchX:(float)x touchY:(float)y orientacaoDispositivo:(UIDeviceOrientation)orientacao{
    
    // verifica se é para checar as setas ou o objeto
    bool bChecarSetas = (orientacao == UIDeviceOrientationFaceUp);
    
    Point3D nearPoint;
	Point3D farPoint;
	Point3D rayVector;
    
    y = (float)m_viewport[3] - y;
	
	//Retreiving position projected on near plan
	gluUnProject( x, y , 0, m_modelview, m_projection, m_viewport, &nearPoint.x, &nearPoint.y, &nearPoint.z);
    
	//Retreiving position projected on far plan
	gluUnProject( x, y,  1, m_modelview, m_projection, m_viewport, &farPoint.x, &farPoint.y, &farPoint.z);
	
	//Processing ray vector
	rayVector.x = farPoint.x - nearPoint.x;
	rayVector.y = farPoint.y - nearPoint.y;
	rayVector.z = farPoint.z - nearPoint.z;
    
    float rayLength = sqrtf(POW2(rayVector.x) + POW2(rayVector.y) + POW2(rayVector.z));
	
	//normalizing ray vector
	rayVector.x /= rayLength;
	rayVector.y /= rayLength;
	rayVector.z /= rayLength;
    
    Point3D collisionPoint;
    Point3D objectCenter;
	
	//Iterating over ray vector to check collisions
    float RAY_ITERATIONS = m_zFar * 10;
	for(int i = 0; i < RAY_ITERATIONS; i++)
	{
		collisionPoint.x = rayVector.x * rayLength/RAY_ITERATIONS*i;
		collisionPoint.y = rayVector.y * rayLength/RAY_ITERATIONS*i;
		collisionPoint.z = rayVector.z * rayLength/RAY_ITERATIONS*i;
        
        for(Objeto* obj in objects){
            
            // verifica se está fora da tela
            if(obj->m_foraTela){
                continue;
            }
            
            if(bChecarSetas){// checa a colisão com a seta
                objectCenter.x = obj->m_glSetaX;
                objectCenter.y = obj->m_glSetaY;
                objectCenter.z = obj->m_glSetaZ;
                
                //Checking collision 
                if( verificaColisao(collisionPoint, objectCenter, 2.0f)){
                    [obj onSelect];
                    return true;
                }
            }
            else{// checa a colisão com o painel
                objectCenter.x = obj->m_glObjetoX;
                objectCenter.y = obj->m_glObjetoY;
                objectCenter.z = obj->m_glObjetoZ;
                
                //Checking collision 
                if( verificaColisao(collisionPoint, objectCenter, 1.5f)){
                    [obj onSelect];
                    return true;
                }
            }
        }
	}
    
    return false;
}

#pragma mark -
#pragma mark Modo de Projeção

-(void)switchBackToFrustum 
{
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);			
	glPopMatrix();							
	glMatrixMode(GL_MODELVIEW);			
}

-(void)switchToOrtho 
{
    glDisable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);			
	glPushMatrix();							
	glLoadIdentity();						
	glOrthof(0, CGRectGetWidth(m_frame), 0, CGRectGetHeight(m_frame), -5, 1);		
	glMatrixMode(GL_MODELVIEW);										
    glLoadIdentity();		
}

@end
