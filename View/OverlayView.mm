//
//  DrawView.m
//  PubgDolphins
//
//  Created by xbk on 2022/4/24.
//
#import "OverlayView.h"
#import "jijia.h"
#import "ZGScreenInfoz.h"
//#import "LLToastView.h"
@implementation OverlayView
- (instancetype)initWithFrame:(CGRect)frame :(ModuleControl*)control :(mao*)draw :(mi*)menu {
    
    self.moduleControl = control;
    
    self.mao = draw;
    self.mi = menu;
    
 
    
    if (self = [super initWithFrame:frame]) {
        //清空颜色
        self.backgroundColor = [UIColor clearColor];
        //设置帧率限制
        self.preferredFramesPerSecond = 120;
        
        
        self.device = MTLCreateSystemDefaultDevice();
        if (!self.device) {
            return NULL;
        }
        self.delegate = self;
        
        self.commandQueue = [self.device newCommandQueue];
        self.loader = [[MTKTextureLoader alloc] initWithDevice: self.device];

        IMGUI_CHECKVERSION();
        ImGui::CreateContext();
        //
        ImGuiIO& io = ImGui::GetIO();
        ImFontConfig config;
        config.FontDataOwnedByAtlas = false;
        io.Fonts->AddFontFromMemoryTTF((void *)jijia_data, jijia_size, 30.0f, NULL,
        io.Fonts->GetGlyphRangesChineseFull());
        
        
        io.DisplaySize.x =  self.frame.size.width * UIScreen.mainScreen.nativeScale;
        io.DisplaySize.y =  self.frame.size.height * UIScreen.mainScreen.nativeScale;
        
        // Setup Dear ImGui style
        setDarkTheme();
        
        // Setup Renderer backend
        ImGui_ImplMetal_Init(self.device);
        
        [self.mao initImageTexture:self.device];
        [self.mi setOverlayView:self];
        
    }
    return self;
}

+ (void)load
{
    
    
    //   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //[LLToastView showToastViewWithImage:nil title:@"👃杀手👃"];
//
//   });
}

- (void)drawInMTKView:(MTKView *)view {
    
    //清除颜色
    view.clearColor = MTLClearColorMake(0.0f, 0.0f, 0.0f, 0.0f);
    //计算fps
    struct timespec current_timespec;
    static double g_Time = 0.0;
    clock_gettime(CLOCK_MONOTONIC, &current_timespec);
    double current_time = (double)(current_timespec.tv_sec) + (current_timespec.tv_nsec / 1000000000.0);
    ImGui::GetIO().DeltaTime = g_Time > 0.0 ? (float)(current_time - g_Time) : (float)(1.0f / 120.0f);
    g_Time = current_time;
    
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();
        
        if(self.moduleControl->menuStatus){
            [self.mi drawMenuWindow];
        }
        [self.mao drawDrawWindow];
   
        
        //渲染
        ImGui::Render();
        ImDrawData *drawData = ImGui::GetDrawData();
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"SwiftGUI"];
        ImGui_ImplMetal_RenderDrawData(drawData, commandBuffer, renderEncoder);
        
        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

-(void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size {
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self && !self.moduleControl->menuStatus) {
        return nil; // 此处返回空即不相应任何事件
    }
    return hitView;
}

-(void)updateIOWithTouchEvent:(UIEvent *)event {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self];
    ImGuiIO &io = ImGui::GetIO();
    io.AddMousePosEvent(touchLocation.x * UIScreen.mainScreen.nativeScale, touchLocation.y * UIScreen.mainScreen.nativeScale);
    
    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled) {
            hasActiveTouch = YES;
            break;
        }
    }
    io.AddMouseButtonEvent(0, hasActiveTouch);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

@end
