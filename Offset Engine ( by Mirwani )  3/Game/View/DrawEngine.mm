//
//  ImGuiDrawView.m
//  IOSPUBG
//
//  Created by DH on 2022/5/2.
//
#include <array>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#include "DrawEngine.hpp"
#include <stdio.h>
#include <string>
#include <vector>
#include "UtfTool.hpp"
#include "MemoryTool.hpp"
#include "OffsetsTool.hpp"


int 自瞄模式= 2;
//int 背敌模式 = 1;
int 圆圈模式 = 0;
int 框架开关 = 2;
int 自瞄部位 = 0;
int 雷达大小 = 400;
int 雷达X = 500;
int 雷达Y = 60;
int 人物美化;
int 枪械美化;

int 圆圈固定 = 200;
int 预警范围 = 38;
float 自瞄速度 = 0.3;
float 命中率 = 1;
float 压枪速率 = 0.4;
float 击打距离 = 300;
float 相机视野 = 80;
float 物资距离 = 80;




using namespace std;

static long GWorld, UName, Engine, PersistentLevel,ShootWeaponComponent,
PlayerController, Character, PlayerCameraManager, ControlRotation,
TinyFont,MediumFont, LargeFont,SubtitleFont, SmallFont, Canvas, STExtraBaseCharacter;

static int MyTeam, ShootMode;

static int totalEnemies = 0;

static float tDis = 0, tDistance = 0, markDistance,markDis, Aimbot_Circle_Radius =180 ,FPS;

static bool needAdjustAim = false, isHookAngle = false, enabledAimbot = false;

static Vector2 CanvasSize, markScreenPos;

static MinimalViewInfo POV;

static Vector3 aimObjInfo;

static FRotator RelativeRotation;

//移动X轴
static void (*AddControllerYawInput)(void *actot, float val);

//旋转
static void (*AddControllerRollInput)(void *actot, float val);

//移动Y轴
static void (*AddControllerPitchInput)(void *actot, float val);

//掩体判断函数原型
static bool (*LineOfSightTo)(void *controller, void *actor, Vector3 bone_point, bool ischeck);

static string CameraManagerClassName ,PlayerControllerClassName;

#pragma mark - 引擎绘制

static void DrawLine(Vector2 startPoint, Vector2 endPoint, float thicknes, int color) {
    reinterpret_cast<void(__fastcall*)(long, struct Vector2, struct Vector2, float, struct FLinearColor) > (GetRealOffset(kDrawLine))(Canvas, startPoint, endPoint, thicknes, FLinearColor(color));
}

static void DrawRectFilled(Vector2 pos, float w, float h, int color) {
    for (float i = 0.f; i < h; i += 1.f)
        DrawLine(Vector2(pos.X, pos.Y + i), Vector2(pos.X + w, pos.Y + i), 1.f, color);
}

static void DrawRect(Vector2 pos, Vector2 size, float thicknes, int color) {
    
    DrawLine(Vector2(pos.X, pos.Y), Vector2(pos.X + size.X, pos.Y), thicknes, color);
    DrawLine(Vector2(pos.X, pos.Y + size.Y), Vector2(pos.X + size.X, pos.Y + size.Y), thicknes, color);
    DrawLine(Vector2(pos.X, pos.Y), Vector2(pos.X, pos.Y + size.Y), thicknes, color);
    DrawLine(Vector2(pos.X + size.X, pos.Y), Vector2(pos.X + size.X, pos.Y + size.Y), thicknes, color);
}

static void DrawText(string text, Vector2 pos, int color, int fontsize = 12) {
    
    if (text.length() == 0) return;
    
    char str[text.length()];
    int i;
    for(i = 0; i < text.length(); i++)
        str[i] = text[i];
    str[i] = '\0';
    
    Write<long>(SmallFont + I64(kLegacyFontSize), fontsize);
    
    reinterpret_cast<void(__fastcall*)(long, long, const class FString&, struct Vector2, struct FLinearColor, float, struct FLinearColor, struct Vector2, bool, bool, bool, struct FLinearColor) > (GetRealOffset(kDrawText  ))(Canvas, SmallFont, FString(str), pos, FLinearColor(color), 0.5f, FLinearColor(0, 0, 0, 1.f), Vector2(), true, false, true, FLinearColor(Colour_黑色));
}

//不剧中文字
static void DrawText2(string text, Vector2 pos, int color, int fontsize = 12) {
    
    if (text.length() == 0) return; //如果文本长度为0，直接返回
    
    char str[text.length()]; //定义一个长度为文本长度的字符数组
    int i;
    for(i = 0; i < text.length(); i++) //将文本内容逐个拷贝到字符数组中
        str[i] = text[i];
    str[i] = '\0'; //在字符数组末尾加上空字符，使其成为一个C字符串
    
    Write<long>(SmallFont + I64(kLegacyFontSize), fontsize); //将字体大小写入指定内存地址，以便后面调用
    
    //使用函数指针调用游戏引擎中的绘制文本函数，参数包括画布对象，字体对象，字符串对象，位置，颜色，深度，阴影颜色，阴影偏移，是否使用阴影，是否使用外边框，是否使用斜体，外边框颜色
    reinterpret_cast<void(__fastcall*)(long, long, const class FString&, struct Vector2, struct FLinearColor, float, struct FLinearColor, struct Vector2, bool, bool, bool, struct FLinearColor) > (GetRealOffset(kDrawText))(Canvas, SmallFont, FString(str), pos, FLinearColor(color), 0.5f, FLinearColor(0, 0, 0, 1.f), Vector2(), false, false, true, FLinearColor(Colour_黑色));
}

// 盒子文字颜色
static void DrawTextWithGoodsColor(const string& text, const Vector2& location, int goodsList) {
    int textColor = GetColorForGoods(goodsList);
    DrawText2(text, location, textColor);
}

static void DrawTitle(string text, Vector2 pos, int color, int fontsize = 40) {
    
    if (text.length() == 0) return;
    
    char str[text.length()];
    int i;
    for(i = 0; i < text.length(); i++)
        str[i] = text[i];
    str[i] = '\0';
    
    if (fontsize != 40) Write<long>(TinyFont + I64(kLegacyFontSize), fontsize);
    
    reinterpret_cast<void(__fastcall*)(long, long, const class FString&, struct Vector2, struct FLinearColor, float, struct FLinearColor, struct Vector2, bool, bool, bool, struct FLinearColor)>(GetRealOffset(kDrawText  ))(Canvas, TinyFont, FString(str), pos, FLinearColor(color), 1.f, FLinearColor(0, 0, 0, 1.f), Vector2(8.f, 8.f), true, false, true, FLinearColor(Colour_黑色));
}

static void DrawCircle(Vector2 pos, float radius, int color, float thicknes = 1) {
    
    int num_segments = 360;
    float a_min = 0;
    float a_max = (M_PI * 2.0f) * ((float)num_segments - 1.0f) / (float)num_segments;
    
    std::vector<struct Vector2> arcPoint;
    
    for (int i = 0; i <= num_segments; i++) {
        const float a = a_min + ((float)i / (float)num_segments) * (a_max - a_min);
        arcPoint.push_back(Vector2(pos .X + cos(a) * radius, pos .Y + sin(a) * radius));
    }
    
    for (int i = 1; i < arcPoint.size(); i++) {
        reinterpret_cast<void(__fastcall*)(long, struct Vector2, struct Vector2, float, struct FLinearColor)> (GetRealOffset(kDrawLine))(Canvas, arcPoint[i-1], arcPoint[i], thicknes, FLinearColor(color));
    }
    // 补全缺口处的线段
    reinterpret_cast<void(__fastcall*)(long, struct Vector2, struct Vector2, float, struct FLinearColor)> (GetRealOffset(kDrawLine))(Canvas, arcPoint.back(), arcPoint.front(), thicknes, FLinearColor(color));
}

static void DrawCircleFilled(Vector2 pos, float radius, int color) {
    
    reinterpret_cast<void(__fastcall*)(long, long, struct Vector2, struct Vector2, int, struct FLinearColor)> (GetRealOffset(kDrawCircleFilled  ))(Canvas, 0, pos, Vector2(radius, radius), 60, FLinearColor(color));
}

// 绘制多边圆形
static void DrawCircle2(Vector2 pos, float radius, int color, float thickness = 1) {
    const float TwoPi = 3.14159265358979323846f * 2.0f;
    const float AngleIncrement = TwoPi / static_cast<float>(16);
    
    Vector2 prevPoint = pos + Vector2(radius, 0.0f);
    
    for (int i = 1; i <= 16; ++i)
    {
        const float Angle = i * AngleIncrement;
        const Vector2 currentPoint = pos + Vector2(radius * cosf(Angle), radius * sinf(Angle));
        
        DrawLine(prevPoint, currentPoint, 1, color);
        prevPoint = currentPoint;
    }
}

//绘制填充三角形
static void DrawFilledTriangle(int x1, int y1, int x2, int y2, int x3, int y3, int color) {
    // 确保y1 <= y2 <= y3
    if (y1 > y2) {
        std::swap(x1, x2);
        std::swap(y1, y2);
    }
    if (y1 > y3) {
        std::swap(x1, x3);
        std::swap(y1, y3);
    }
    if (y2 > y3) {
        std::swap(x2, x3);
        std::swap(y2, y3);
    }
    
    float slope1 = float(x2 - x1) / float(y2 - y1);
    float slope2 = float(x3 - x1) / float(y3 - y1);
    float slope3 = float(x3 - x2) / float(y3 - y2);
    
    float startX = x1;
    float endX = x1;
    
    for (int y = y1; y <= y3; y++) {
        if (y < y2) {
            startX = x1 + (y - y1) * slope1;
            endX = x1 + (y - y1) * slope2;
        } else {
            startX = x2 + (y - y2) * slope3;
            endX = x1 + (y - y1) * slope2;
        }
        
        if (startX > endX) {
            std::swap(startX, endX);
        }
        
        int startX_int = int(startX);
        int endX_int = int(endX);
        
        // 绘制扫描线上的像素点
        for (int x = startX_int; x <= endX_int; x++) {
            DrawLine(Vector2(x, y), Vector2(x, y), 1, color);
        }
    }
}

//绘制子弹条
static void DrawBulletBar(int numBullets, int maxBullets) {
    Vector2 barSize(20, 180);
    Vector2 barPos((CanvasSize.X * 1.5 / 4) - (barSize.X / 2), (CanvasSize.Y / 2) - (barSize.Y / 2));

    DrawRect(barPos, barSize, 1.0f, Colour_白色);

    Vector2 lineStart(barPos.X + 5, barPos.Y + barSize.Y - 5);
    Vector2 lineEnd;
    float lineThickness = 2.0f;

    float interval = barSize.Y / maxBullets;

    for (int i = 0; i < numBullets; ++i) {
        float ratio = static_cast<float>(i) / maxBullets;
        int red = static_cast<int>(255 * ratio);
        int green = static_cast<int>(255 * (1 - ratio));
        int color = (green << 16) | (red << 8) | 0x0000FF;

        lineEnd = Vector2(lineStart.X + 10, lineStart.Y);
        DrawLine(lineStart, lineEnd, lineThickness, color);
        lineStart.Y -= interval;
    }

     //绘制文字（如果子弹数量为0，显示"换弹中"）
    if (numBullets == 0) {
        string text = ("换\n弹\n中");
        Vector2 textPos(barPos.X - 10 + barSize.X, barPos.Y + barSize.Y - 120);  // 调整文字位置以使其位于矩形内部
        int textColor = Colour_红色;

        DrawText(text, textPos, textColor, 12);
    }
}

// 绘制四角方框
static void DrawUnclosedRect(float center_x, float center_y, float center_w, float center_h, int color, float thickness = 1) {
    DrawLine(Vector2{center_x-(center_w/2),center_y-(center_h/2)},Vector2{center_x-(center_w/4),center_y-(center_h/2)}, 1,color);//左上横
    
    DrawLine(Vector2{center_x+(center_w/2),center_y-(center_h/2)},Vector2{center_x+(center_w/4),center_y-(center_h/2)}, 1,color);//右上横
    
    DrawLine(Vector2{center_x-(center_w/2),center_y+(center_h/2)},Vector2{center_x-(center_w/4),center_y+(center_h/2)}, 1,color);//左下横
    
    DrawLine(Vector2{center_x+(center_w/2),center_y+(center_h/2)},Vector2{center_x+(center_w/4),center_y+(center_h/2)}, 1,color);//右下横
    
    DrawLine(Vector2{center_x-(center_w/2),center_y-(center_h/2)},Vector2{center_x-(center_w/2),center_y-(center_h/4)}, 1,color);//左上竖
    
    DrawLine(Vector2{center_x+(center_w/2),center_y-(center_h/2)},Vector2{center_x+(center_w/2),center_y-(center_h/4)}, 1,color);//右上竖
    
    DrawLine(Vector2{center_x-(center_w/2),center_y+(center_h/2)},Vector2{center_x-(center_w/2),center_y+(center_h/4)}, 1,color);//左下竖
    
    DrawLine(Vector2{center_x+(center_w/2),center_y+(center_h/2)},Vector2{center_x+(center_w/2),center_y+(center_h/4)}, 1,color);//右下竖
    
}

#pragma mark - 坐标转换
static bool ProjectWorldLocationToScreen(const struct Vector3 WorldLocation, bool bPlayerViewportRelative, struct Vector2* ScreenLocation);
static void BoxConversion(Vector3 worldLocation, VectorRect *rect) {
    Vector3 worldLocation2 = worldLocation;
    worldLocation2.Z += 90.f;
    
    Vector2 calculate; // 计算物体坐标在屏幕上的位置
    ProjectWorldLocationToScreen(worldLocation, true, &calculate);
    Vector2 calculate2; // 计算物体坐标在屏幕上的位置
    ProjectWorldLocationToScreen(worldLocation2, true, &calculate2); // 计算矩形框左上角坐标在屏幕上的位置
    
    rect->h = calculate.Y - calculate2.Y;
    rect->w = rect->h / 2.5;
    rect->x = calculate.X - rect->w;
    rect->y = calculate2.Y;
    rect->w = rect->w * 2;
    rect->h = rect->h * 2;
}

static FTransform GetMatrixConversion(long address) {
    FTransform ret;
    ret.Rotation.x = Read<float>(address);
    ret.Rotation.y = Read<float>(address + 4);
    ret.Rotation.z = Read<float>(address + 8);
    ret.Rotation.w = Read<float>(address + 12);
    
    ret.Translation.X = Read<float>(address + 16);
    ret.Translation.Y = Read<float>(address + 20);
    ret.Translation.Z = Read<float>(address + 24);
    
    ret.Scale3D.X = Read<float>(address + 32);
    ret.Scale3D.Y = Read<float>(address + 36);
    ret.Scale3D.Z = Read<float>(address + 40);
    return ret;
}

static Vector3 GetBoneWithRotation(long mesh, int ID, FTransform publicObj) {
    FTransform BoneMatrix;
    BoneMatrix = GetMatrixConversion(Read<long>(mesh + I64(kStaticMesh)) + ID * 0x30);
    
    D3DXMATRIX LocalSkeletonMatrix = ToMatrixWithScale(BoneMatrix.Rotation, BoneMatrix.Translation, BoneMatrix.Scale3D);
    D3DXMATRIX PartTotheWorld = ToMatrixWithScale(publicObj.Rotation, publicObj.Translation, publicObj.Scale3D);
    D3DXMATRIX NewMatrix = MatrixMultiplication(LocalSkeletonMatrix, PartTotheWorld);
    
    Vector3 BoneCoordinates;
    BoneCoordinates.X = NewMatrix._41;
    BoneCoordinates.Y = NewMatrix._42;
    BoneCoordinates.Z = NewMatrix._43;
    
    return BoneCoordinates;
}

static int GetCenterOffsetForVector(Vector2 point) {
    
    return sqrt(pow(point.X - CanvasSize.X/2, 2.0) + pow(point.Y - CanvasSize.Y/2, 2.0));
}


static bool isScreenVisible(Vector2 LocationScreen, Vector2 CanvasSize) {
    if (LocationScreen.X > 0 && LocationScreen.X < CanvasSize.X &&
        LocationScreen.Y > 0 && LocationScreen.Y < CanvasSize.Y) return true;
    else return false;
}

static bool GetInsideFov(float ScreenWidth, float ScreenHeight, Vector2 PlayerBone, float FovRadius) {
    Vector2 Cenpoint;
    Cenpoint.X = PlayerBone.X - (ScreenWidth / 2);
    Cenpoint.Y = PlayerBone.Y - (ScreenHeight / 2);
    if (Cenpoint.X * Cenpoint.X + Cenpoint.Y * Cenpoint.Y <= FovRadius * FovRadius) return true;
    return false;
}

// 计算两个角度之间的差异
static float getAngleDifference(float angle1, float angle2) {
    float diff = fmod(angle2 - angle1 + 180, 360) - 180;
    return diff < -180 ? diff + 360 : diff;
}

// 根据符号改变数值的正负
static float change(float num) {
    if (num < 0) {
        return abs(num);
    } else if (num > 0) {
        return num - num * 2;
    }
    return num;
}

// 旋转角度以查看目标
static Vector2 rotateAngleView(Vector3 selfCoord, Vector3 targetCoord) {
    
    float osx = targetCoord.X - selfCoord.X;
    float osy = targetCoord.Y - selfCoord.Y;
    float osz = targetCoord.Z - selfCoord.Z;
    
    return {(float) (atan2(osy, osx) * 180 / M_PI), (float) (atan2(osz, sqrt(osx * osx + osy * osy)) * 180 / M_PI)};
}

// 获取三维空间中自身和目标之间的距离
static float get3dDistance(Vector3 self, Vector3 object, float divice) {
    Vector3 xyz;
    xyz.X = self.X - object.X;
    xyz.Y = self.Y - object.Y;
    xyz.Z = self.Z - object.Z;
    return sqrt(pow(xyz.X, 2) + pow(xyz.Y, 2) + pow(xyz.Z, 2)) / divice;
}


#pragma mark - 追踪数据

static FRotator ToRotator(const Vector3 &local, const Vector3 &target) {
    Vector3 rotation = local - target;
    float hyp = sqrt(rotation.X * rotation.X + rotation.Y * rotation.Y);
    FRotator newViewAngle;
    
    newViewAngle.Pitch = -atan(rotation.Z / hyp) * (180.f / (float) 3.14159265358979323846);
    newViewAngle.Yaw = atan(rotation.Y / rotation.X) * (180.f / (float) 3.14159265358979323846);
    newViewAngle.Roll = (float) 0.f;
    if (rotation.X >= 0.f)
        newViewAngle.Yaw += 180.0f;
    return newViewAngle;
}

// 追踪算法
static Tracking bulletTrack(Vector3 MyLoc, bool isCusimg) {
    FRotator aim_angle;
    Tracking trackData;
    //自己位置
    Vector3 MyLocation;
    if (isCusimg) {
        MyLocation = MyLoc;
    } else {
        MyLocation = POV.Location;
    }
    
    FRotator TargetRot = ToRotator({MyLocation.X, MyLocation.Y, MyLocation.Z}, {aimObjInfo.X, aimObjInfo.Y, aimObjInfo.Z});
    trackData.aim_angle = {TargetRot.Pitch,TargetRot.Yaw,0};
    
    return trackData;
}

//追踪函数原型
void (*UpdateVolleyShootParameters)(void *shootWeaponAddr, Vector3 TargetLoc, Vector3* StartLoc, Rotator* BulletRot, Vector3* BulletDir);

void NewBulletTracking(void *shootWeaponAddr, Vector3 TargetLoc, Vector3* StartLoc, Rotator* BulletRot, Vector3* BulletDir) {
    if (isHookAngle) {
        Tracking angle = bulletTrack(*StartLoc, true);
        BulletRot->X = angle.aim_angle.X;
        BulletRot->Y = angle.aim_angle.Y;
    }
    return UpdateVolleyShootParameters(shootWeaponAddr, TargetLoc, StartLoc, BulletRot, BulletDir);
}

static Rotator (*CalcShootRot)(void *shootWeaponAddr);
bool bIsGunADS = Read<int>(Character + I64(kbIsGunADS)) == 257 || Read<int>(Character + I64(kbIsGunADS)) == 1;
static Rotator NewCalcShootRot(void *shootWeaponAddr) {
    Rotator ret {};
    if (CalcShootRot) {
        ret = CalcShootRot(shootWeaponAddr);
    }
    int i = 0;
    if (!isHookAngle) {
        if (bIsGunADS) {
            goto _rot;
        }
        
        while (!isHookAngle && i < 8) {
            usleep(1000);
            i++;
        }
    }
    
    if (isHookAngle) {
        Tracking angle = bulletTrack({0,0,0}, false);
        return angle.aim_angle;
    }
_rot:
    return ret;
}


#pragma mark - 自瞄数据
static void SetControlRotation(long Object,  Vector3 AimPos) {
    
//    if(!Character) return;
    
    //自己武器组件
    long WeaponManagerComponent = Read<long>(Character + I64(kWeaponManagerComponent));
    if (!IsValidAddress(WeaponManagerComponent)) return;
    long CurrentWeaponReplicated = Read<long>(WeaponManagerComponent + I64(kCurrentWeaponReplicated));
    if (!IsValidAddress(CurrentWeaponReplicated)) return;
    long ShootWeaponComponent = Read<long>(CurrentWeaponReplicated + I64(kShootWeaponComponent));
    if (!IsValidAddress(ShootWeaponComponent)) return;
    long ShootWeaponEntityComp = Read<long>(CurrentWeaponReplicated + I64(kShootWeaponEntityComp));
    if (!IsValidAddress(ShootWeaponEntityComp)) return;
    
    // 武器射击模式
    int ShootMode = Read<int>(CurrentWeaponReplicated + I64(kShootMode));
    

    //判断自瞄启动模式
    switch (自瞄模式) {
        case 0: //单发模式为开镜自瞄-自动模式为开火自瞄
            if (ShootMode >= 1020) enabledAimbot = Read<int>(Character + I64(kbIsWeaponFiring)) == 1;
            else enabledAimbot = Read<int>(Character + I64(kbIsGunADS)) == 257 || Read<int>(Character + I64(kbIsGunADS)) == 1;
            break;
        case 1: //开镜自瞄
            enabledAimbot = Read<int>(Character + I64(kbIsGunADS)) == 257 || Read<int>(Character + I64(kbIsGunADS)) == 1;
            break;
        case 2: //开火自瞄
            enabledAimbot = Read<int>(Character + I64(kbIsWeaponFiring)) == 1;
            break;
    }
    
    //启动自瞄
    if (enabledAimbot) {
        // 根组件
        long RootComponent = Read<long>(Object + I64(kRootComponent));
        if (!IsValidAddress(RootComponent)) return;
        
        long ControlRotation = PlayerController + I64(kControlRotation);
        
        long selfFunction = Read<long>(Character + 0);
        
        // 函数偏移
        AddControllerYawInput = (void (*)(void *, float)) (Read<long>(selfFunction + I64(kYaw)));
        AddControllerRollInput = (void (*)(void *, float)) (Read<long>(selfFunction + I64(kRoll)));
        AddControllerPitchInput = (void (*)(void *, float)) (Read<long>(selfFunction + I64(kPitch)));
        
        // 子弹飞行时间
        float BulletFireSpeed = Read<float>(ShootWeaponEntityComp + I64(kBulletFireSpeed));
        float secFlyTime = get3dDistance(POV.Location, AimPos, BulletFireSpeed) * 1.2;
        
        // 移动速度
        Vector3 Velocity;
        long CurrentVehicle = Read<long>(Object + I64(kCurrentVehicle));//判断是否开车
        if (IsValidAddress(CurrentVehicle)) {
            Vector3 LinearVelocity = Read<Vector3>(CurrentVehicle + I64(kRepMovement));//载具向量
            Velocity = LinearVelocity;
        } else {
            Vector3 ComponentVelocity = Read<Vector3>(RootComponent + I64(kComponentVelocity));//人物向量
            Velocity = ComponentVelocity;
        }
        
        // 预判位置
        AimPos.X += Velocity.X * secFlyTime;
        AimPos.Y += Velocity.Y * secFlyTime;
        AimPos.Z += Velocity.Z * secFlyTime;
        
        // 目标位置角度
        Vector2 aimbotMouse = rotateAngleView(POV.Location, AimPos);
        
        
        //开火压枪
        if (Read<int>(Character + I64(kbIsWeaponFiring)) == 1) {
            //枪械压枪幅度
            float recoil = Read<float>(ShootWeaponEntityComp + I64(kRecoilKickADS));
            float recoilTimes = 压枪速率 - get3dDistance(POV.Location, AimPos, 10000);
            recoilTimes += get3dDistance(POV.Location, AimPos, 10000) * 0.2;
            
            //步枪启动压枪
            if (ShootMode >=1020) aimbotMouse.Y -= recoilTimes * recoil;
        }
        
        //判断是否是有效数
        if (!isfinite(aimbotMouse.X) || !isfinite(aimbotMouse.Y)) {
            return;
        }
        
        //准星移动的角度
        Vector2 aimbotMouseMove;
        //计算角度
        //getAngleDifference 读内存里的准星角度和计算得到的准星角度进行运算,得到角度差
        //change是调整角度 正数变负数, 负数变整数
        // * 自瞄速度 就是 * 0.1 让准星慢慢移动到指定位置,类似触摸自瞄  * 1就是强锁了
        //这里是类触摸的关键,* 0.1就是得到的角度差的10%,一次移动角度差的10% 就让准星慢慢移动到敌人了
        
            
            aimbotMouseMove.X = change(getAngleDifference(aimbotMouse.X, Read<float>(ControlRotation + 0x4)) * 自瞄速度);
            aimbotMouseMove.Y = change(getAngleDifference(aimbotMouse.Y, Read<float>(ControlRotation)) * 自瞄速度);
            
            
            //判断计算得到的角度是不是一个有效数
            if (!isfinite(aimbotMouseMove.X) || !isfinite(aimbotMouseMove.Y)) {
                return;
            }
            
            
//        if (自瞄开关) {
//            //移动鼠标,我这里用的增量自瞄,是传入的角度差 比如游戏的角度在180度,我上面计算的角度差是-10 这里传入-10就让180-10了
//            if (AddControllerYawInput != NULL) {
//                AddControllerYawInput(reinterpret_cast<void *>(Character), aimbotMouseMove.X);
//            }
//            if (AddControllerPitchInput != NULL) {
//                AddControllerPitchInput(reinterpret_cast<void *>(Character), aimbotMouseMove.Y);
//            }
//            if (AddControllerRollInput != NULL) {
//                AddControllerRollInput(reinterpret_cast<void *>(Character), 0);
//            }
//        }
    }
    //函数追踪
    bool bIsPressingFireBtn = Read<int>(Character + I64(kbIsWeaponFiring)) == 1;
    bool bIsGunADS = Read<int>(Character + I64(kbIsGunADS)) == 257 || Read<int>(Character + I64(kbIsGunADS)) == 1;

    

    
    float yq = 压枪速率;
    Vector3 lockBoneV3 = AimPos;
    Vector3 diffV3 = lockBoneV3 - POV.Location;
    float pitch = atan2f(diffV3.Z, sqrt(diffV3.X * diffV3.X + diffV3.Y * diffV3.Y)) * 57.29577951308f;
    float yaw = atan2f(diffV3.Y, diffV3.X) * 57.29577951308f;
    if(自瞄开关 && bIsPressingFireBtn){
        if (IsValidAddress(ControlRotation)) {
            if (Read<float>(ControlRotation) != 0) {
                if(bIsGunADS){
                Write<float>(ControlRotation, pitch - yq);
                }else {
                    Write<float>(ControlRotation, pitch);
                }
            }
            if (Read<float>(ControlRotation + 0x4) != 0) {
                Write<float>(ControlRotation + 0x4, yaw);
            }
        }
    }
    
    //Object!= 0 &&
    if (AimPos.X != 0 && AimPos.Y != 0 && AimPos.Z != 0 < (Aimbot_Circle_Radius || 圆圈固定)) {
        if (追踪开关) {
            if (bIsPressingFireBtn || bIsGunADS || 静默开关) {
//                if (Character > 0) {
                    if (ShootWeaponEntityComp) {
                        
                        aimObjInfo = AimPos;
                        isHookAngle = true;
                        
                        uintptr_t shootWeaponVtable = Read<long>(ShootWeaponComponent + 0x0);
                       
                        if (CalcShootRot == nullptr) {
                            *(uintptr_t *) &CalcShootRot = Read<long>(shootWeaponVtable + 0x5f0);
                        }
                       
                        if (CalcShootRot != nullptr) {
                            *(uintptr_t *) (shootWeaponVtable + 0x5f0) = (uintptr_t)NewCalcShootRot;
                        }
                    }
//                }
            }
        } else {
            isHookAngle = false;
        }
    }else {
        isHookAngle = false;
    }
}
#pragma mark - 自瞄玩家
float currentAimRadius = 160;
float targetAimRadius = 130;
float transitionSpeed = 2; // 调整这个值来控制过渡的速度
//float fixedAimRadius = 100;
static void SetAimRadius(float distance) {
    if (distance <= 1) {
        targetAimRadius = 160;
    } else if (distance >= 260) {
        targetAimRadius = 50;
    } else {
        float t = (distance - 1) / (160 - 1);
        targetAimRadius = 160 - t * (100 - 50);
    }
    
    if (currentAimRadius != targetAimRadius) {


        // 根据过渡速度调整半径
        float step = transitionSpeed;
        if (currentAimRadius < targetAimRadius) {
            currentAimRadius = fmin(currentAimRadius + step, targetAimRadius);
        } else {
            currentAimRadius = fmax(currentAimRadius - step, targetAimRadius);
        }
        Aimbot_Circle_Radius = currentAimRadius;
    }
}

static bool ProjectWorldLocationToScreen(const struct Vector3 WorldLocation, bool bPlayerViewportRelative, struct Vector2* ScreenLocation) {
    if (!IsValidAddress(PlayerController)) return false;
    const auto function_address = reinterpret_cast<void*>(GetRealOffset(kProject));//0x106AFE29C
    if (function_address) {
        return reinterpret_cast<bool(__fastcall*)(long, const struct Vector3*, const struct Vector2*, bool)>(function_address)(PlayerController, &WorldLocation, ScreenLocation, bPlayerViewportRelative);
    }
    return false;
}

static string GetFName(long actor) {
    int32_t FNameID = Read<int32_t>(actor + 0x18);
    if (FNameID > 0 && FNameID < 2000000) {
        char *buf = (char *)malloc(64);
        uintptr_t UName = Read<long>(GetRealOffset(kGNames));
        if (IsValidAddress(UName)) {
            uintptr_t pageAddr = Read<long>(UName + ((FNameID / 0x4000) * 8));
            uintptr_t nameAddr = Read<long>(pageAddr + ((FNameID % 0x4000) * 8));
            Read_data(nameAddr + 0xe, 64, buf);
            return buf;
        }
    }
    return "";
}

static string GetClassName(int FNameID) {
    char *buf = (char *)malloc(64);
    if (FNameID > 0 && FNameID < 2000000) {
        int page = FNameID / 16384;
        int index = FNameID % 16384;
        if (IsValidAddress(UName)) {
            uintptr_t pageAddr = Read<long>(UName + page * sizeof(uintptr_t));
            uintptr_t nameAddr = Read<long>(pageAddr + index * sizeof(uintptr_t)) + 0xE;
            Read_data(nameAddr, 64, buf);
        }
    }
    return buf;
}

static string GetPlayerName(long player) {
    string n = "";
    long PlayerName = Read<long>(player + I64(kPlayerName));
    if (IsValidAddress(PlayerName)) {
        UTF8 name[32] = "";
        UTF16 buf16[16] = {0};
        Read_data(PlayerName, 28, buf16);
        Utf16_To_Utf8(buf16, name, 28, strictConversion);
        n = string((const char *)name);
    }
    return n;
}

static Vector3 GetRelativeLocation(long actor) {
    return Read<Vector3>(Read<long>(actor + I64(kRootComponent)) + I64(kLocation));
}

#pragma mark - 掩体数据
static bool GetLineOfSightTo(Vector3 Coord) {
    
    if (LineOfSightTo == nullptr || !isfinite(Coord .X) || !isfinite(Coord .Y) || !isfinite(Coord.Z)) {
        return false;
    }
    if (isContain(CameraManagerClassName, "PlayerCameraManager") != 0 && isContain(PlayerControllerClassName, "PlayerController") != 0) {
        return LineOfSightTo(reinterpret_cast<void *>(PlayerController), reinterpret_cast<void *>(PlayerCameraManager), Coord, false);
    }
    return false;
}

#pragma mark - 游戏数据
static void GetModuleBaseAddress() {
    
    GWorld = Read<long>(GetRealOffset(kUWorld));
    
    UName = Read<long>(GetRealOffset(kGNames));
    
    Engine = Read<long>(GetRealOffset(kEngine));
    
    if (!IsValidAddress(GWorld) || !IsValidAddress(UName) || !IsValidAddress(Engine)) return;
    
    PersistentLevel = Read<long>(GWorld + I64(kPersistentLevel));
    
    if (!IsValidAddress(PersistentLevel)) return;
    
    long NetDriver = Read<long>(GWorld + I64(kNetDriver));
    if (!IsValidAddress(NetDriver)) return;
    
    long ServerConnection = Read<long>(NetDriver + I64(kServerConnection));
    if (!IsValidAddress(ServerConnection)) return;
    
    PlayerController = Read<long>(ServerConnection + I64(kPlayerController));
    
    
    if (!IsValidAddress(PlayerController)) PlayerController = Read<long>(ServerConnection + I64(klocalPlayerController));
    if (!IsValidAddress(PlayerController)) return;

    // 获取掩体判断地址
    LineOfSightTo = (bool (*)(void *, void *, Vector3, bool)) (Read<long>(Read<long>(PlayerController + 0x0) + I64(kLineOfSightTo)));
    
    Character = Read<long>(PlayerController + I64(kPawn));
    
    PlayerCameraManager = Read<long>(PlayerController + I64(kPlayerCameraManager));
    if (!IsValidAddress(PlayerCameraManager)) return;
    
    ControlRotation = PlayerController + I64(kControlRotation);
    
    CameraManagerClassName = GetClassName(Read<int>(PlayerCameraManager + 0x18));
    PlayerControllerClassName = GetClassName(Read<int>(PlayerController + 0x18));
    
    MyTeam = (int)Read<long>(PlayerController + I64(kMyTeam));
    
    POV = Read<MinimalViewInfo>(PlayerCameraManager + I64(kViewTarget) + 0x10);
    
    
    long mySelf = Read<long>(PlayerController + I64(kmySelf));
     
    long weaponManagerComponent = Read<long>(mySelf + I64(kweaponManagerComponent));
    long cachedCurUseWeapon  = Read<long>(weaponManagerComponent + I64(kcachedCurUseWeapon));
    long shootWeaponComponent = Read<long>(cachedCurUseWeapon + I64(kshootWeaponComponent));
    long ownerShootWeapon = Read<long>(shootWeaponComponent + I64(kownerShootWeapon));
    long shootWeaponEntityComp = Read<long>(ownerShootWeapon + I64(kshootWeaponEntityComp));
    
    if (无后开关) {


        Write<float>(shootWeaponEntityComp + I64(wuhou), 0);

    }
    
    if (聚点开关) {
        Write<float>(shootWeaponEntityComp + I64(judian1), 0);
        Write<float>(shootWeaponEntityComp + I64(judian2), 0);
        Write<float>(shootWeaponEntityComp + I64(judian3), 0);
        Write<float>(shootWeaponEntityComp + I64(judian4), 0);
    }
    
    if (防抖开关) {
        Write<float>(shootWeaponEntityComp + I64(fangdou1), 0);
        Write<float>(shootWeaponEntityComp + I64(fangdou2), 0);
    }

    if (瞬击开关) {
        Write<float>(shootWeaponEntityComp + I64(shunji), 800000);
    }
    
    
//    FPS = *(float*)(GetRealOffset(fps));
    
//    STExtraBaseCharacter = Read<long>(PlayerController + 0x2cf0);//0x2ca0 float AutoSprintRequestCD;
}


#pragma mark - 3DBox
static void Draw3DBox(Vector3 origin, Vector3 extends, int color) {
    origin -= extends / 2;

    Vector3 one = origin;
    Vector3 two = origin;   two.X += extends.X;
    Vector3 three = origin; three.X += extends.X; three.Y += extends.Y;
    Vector3 four = origin;  four.Y += extends.Y;

    Vector3 five = one;     five.Z += extends.Z;
    Vector3 six = two;      six.Z += extends.Z;
    Vector3 seven = three;  seven.Z += extends.Z;
    Vector3 eight = four;   eight.Z += extends.Z;

    Vector2 s1, s2, s3, s4, s5, s6, s7, s8;

    ProjectWorldLocationToScreen(one, true, &s1);
    ProjectWorldLocationToScreen(two, true, &s2);
    ProjectWorldLocationToScreen(three, true, &s3);
    ProjectWorldLocationToScreen(four, true, &s4);
    ProjectWorldLocationToScreen(five, true, &s5);
    ProjectWorldLocationToScreen(six, true, &s6);
    ProjectWorldLocationToScreen(seven, true, &s7);
    ProjectWorldLocationToScreen(eight, true, &s8);

    DrawLine(s1, s2, 1, color);
    DrawLine(s2, s3, 1, color);
    DrawLine(s3, s4, 1, color);
    DrawLine(s4, s1, 1, color);

    DrawLine(s5, s6, 1, color);
    DrawLine(s6, s7, 1, color);
    DrawLine(s7, s8, 1, color);
    DrawLine(s8, s5, 1, color);

    DrawLine(s1, s5, 1, color);
    DrawLine(s2, s6, 1, color);
    DrawLine(s3, s7, 1, color);
    DrawLine(s4, s8, 1, color);
}

static TEnumAsByte<ESTEPoseState> playerstate;

// 朝向3DBox
static void Get3DBox(Vector3 origin, int color) {
    // 定义盒子的缩放和位置信息
    Vector3 boxRescaling = { 0 /*厚度*/, 0 /*顶部*/, 0 /*底部*/ };
    float yy = 0;

    // 根据玩家状态设置盒子缩放和位置
    if (playerstate == ESTEPoseState::ESTEPoseState__Stand || playerstate == ESTEPoseState::ESTEPoseState__Sprint) {
        boxRescaling = {60, 180.f, 5}; yy = 60;
    }

    if (playerstate == ESTEPoseState::ESTEPoseState__Crouch || playerstate == ESTEPoseState::ESTEPoseState__CrouchSprint) {
        boxRescaling = {60, 120.f, 5}; yy = 60;
    }

    if (playerstate == ESTEPoseState::ESTEPoseState__Prone || playerstate == ESTEPoseState::ESTEPoseState__Crawl) {
        boxRescaling = {60, 60.f, 5}; yy = 180;
    }

    if (playerstate == ESTEPoseState::ESTEPoseState__Dying) {
        boxRescaling = {100, 80.f, 5}; yy = 100; //150
    }
    // 定义各个点的坐标
    Vector3 b1, b2, b3, b4, t1, t2, t3, t4;
    b1.Z = b2.Z = b3.Z = b4.Z = origin.Z + boxRescaling.Z;

    float yaw = RelativeRotation.Yaw; //敌人朝向

#define TORAD(x) ((x) * (M_PI / 180.f))

    b1.X = origin.X + cosf(DEG2RAD(yaw + 45.f)) * boxRescaling.X;
    b1.Y = origin.Y + sinf(DEG2RAD(yaw + 45.f)) * yy;

    b2.X = origin.X + cosf(DEG2RAD(yaw + 135.f)) * boxRescaling.X;
    b2.Y = origin.Y + sinf(DEG2RAD(yaw + 135.f)) * yy;

    b3.X = origin.X + cosf(DEG2RAD(yaw + 225.f)) * boxRescaling.X;
    b3.Y = origin.Y + sinf(DEG2RAD(yaw + 225.f)) * yy;

    b4.X = origin.X + cosf(DEG2RAD(yaw + 315.f)) * boxRescaling.X;
    b4.Y = origin.Y + sinf(DEG2RAD(yaw + 315.f)) * yy;

    t1.X = origin.X + cosf(DEG2RAD(yaw + 45.f)) * boxRescaling.X;
    t1.Y = origin.Y + sinf(DEG2RAD(yaw + 45.f)) * yy;

    t2.X = origin.X + cosf(DEG2RAD(yaw + 135.f)) * boxRescaling.X;
    t2.Y = origin.Y + sinf(DEG2RAD(yaw + 135.f)) * yy;

    t3.X = origin.X + cosf(DEG2RAD(yaw + 225.f)) * boxRescaling.X;
    t3.Y = origin.Y + sinf(DEG2RAD(yaw + 225.f)) * yy;

    t4.X = origin.X + cosf(DEG2RAD(yaw + 315.f)) * boxRescaling.X;
    t4.Y = origin.Y + sinf(DEG2RAD(yaw + 315.f)) * yy;

#undef TORAD

    t1.Z = t2.Z = t3.Z = t4.Z = origin.Z + boxRescaling.Y;

    // 定义各个点在屏幕上的坐标
    Vector2 b11, b22, b33, b44, t11, t22, t33, t44;
    ProjectWorldLocationToScreen(b1, true, &b11);
    ProjectWorldLocationToScreen(b2, true, &b22);
    ProjectWorldLocationToScreen(b3, true, &b33);
    ProjectWorldLocationToScreen(b4, true, &b44);

    ProjectWorldLocationToScreen(t1, true, &t11);
    ProjectWorldLocationToScreen(t2, true, &t22);
    ProjectWorldLocationToScreen(t3, true, &t33);
    ProjectWorldLocationToScreen(t4, true, &t44);

    // 绘制盒子的边线
    DrawLine(b11, b22, 1, color);
    DrawLine(b22, b33, 1, color);
    DrawLine(b33, b44, 1, color);
    DrawLine(b44, b11, 1, color);

    // 绘制盒子的竖直连线
    DrawLine(b11, t11, 1, color);
    DrawLine(b22, t22, 1, color);
    DrawLine(b33, t33, 1, color);
    DrawLine(b44, t44, 1, color);

    // 绘制顶部平行连线
    DrawLine(t11, t22, 1, color);
    DrawLine(t22, t33, 1, color);
    DrawLine(t33, t44, 1, color);
    DrawLine(t44, t11, 1, color);
}

#pragma mark - 平面圆
static void Draw2DPlaneCircle(Vector3 center, float radius, int color) {
    int numSegments = 360; // 圆上的分段数

    for (int i = 0; i < numSegments; i++) {
        float angle1 = (i / (float)numSegments) * 2 * M_PI;
        float angle2 = ((i + 1) / (float)numSegments) * 2 * M_PI;

        Vector3 p1 = center + Vector3(radius * cos(angle1), radius * sin(angle1), 0);
        Vector3 p2 = center + Vector3(radius * cos(angle2), radius * sin(angle2), 0);
        Vector2 p33, p44;
        ProjectWorldLocationToScreen(p1, true, &p33);
        ProjectWorldLocationToScreen(p2, true, &p44);
        DrawLine(p33,p44, 1, color);
    }
}

#pragma mark -  预警数据
static void VectorAnglesRadar(Vector3& forward, Vector3& angles)
{
    if (forward.X == 0.f && forward.Y == 0.f)
    {
        angles.X = forward.Z > 0.f ? -90.f : 90.f;
        angles.Y = 0.f;
    }
    else
    {
        angles.X = RAD2DEG(atan2(-forward.Z,  forward.Size()));
        angles.Y = RAD2DEG(atan2(forward.Y, forward.X));
    }
    angles.Z = 0.f;
}

#pragma mark -  三角预警数据
static void RotateTriangle(std::array<Vector3, 3>& points, float rotation)
{
    const auto points_center = (points.at(0) + points.at(1) + points.at(2) ) / 3;
    for (auto& point : points)
    {
        point = point - points_center;

        const auto temp_x = point.X;
        const auto temp_y = point.Y;

        const auto theta = DEG2RAD(rotation);
        const auto c = cosf(theta);
        const auto s = sinf(theta);

        point.X = temp_x * c - temp_y * s;
        point.Y = temp_x * s + temp_y * c;

        point = point + points_center;
    }
}


#pragma mark -  三角绘图数据
static void DrawTriangle(int x1, int y1, int x2, int y2, int x3, int y3,float thickness, int color) {
    DrawLine(Vector2(x1, y1), Vector2(x2, y2), thickness, color);
    DrawLine(Vector2(x2, y2), Vector2(x3, y3), thickness, color);
    DrawLine(Vector2(x3, y3), Vector2(x1, y1), thickness, color);

}

#pragma mark -  箭头预警数据
static void RotateArrow(std::array<Vector2, 7>& points, float rotation)
{
    const auto points_center = (points.at(0) + points.at(1) + points.at(2) + points.at(3) + points.at(4) + points.at(5) + points.at(6)) / 7;
    for (auto& point : points)
    {
        point = point - points_center;

        const auto temp_x = point.X;
        const auto temp_y = point.Y;

        const auto theta = DEG2RAD(rotation);
        const auto c = cosf(theta);
        const auto s = sinf(theta);

        point.X = temp_x * c - temp_y * s;
        point.Y = temp_x * s + temp_y * c;

        point = point + points_center;
    }
}
#pragma mark -  箭头绘图数据
static void DrawArrows(Vector2 xy1, Vector2 xy2, Vector2 xy3,Vector2 xy4, Vector2 xy5 , Vector2 xy6 , Vector2 xy7, float thickness, int color) {

    DrawLine(xy1, xy2, thickness ,color);
    DrawLine(xy2, xy3, thickness ,color);
    DrawLine(xy3, xy7, thickness ,color);
    DrawLine(xy7, xy6, thickness ,color);
    DrawLine(xy6, xy5, thickness ,color);
    DrawLine(xy5, xy4, thickness ,color);
    DrawLine(xy4, xy1, thickness ,color);

}
void FixTriangle(float& XPos, float& YPos, int screenDist){

    if(XPos > (CanvasSize.X - 100)) {
        XPos = CanvasSize.X;
        XPos -= screenDist;
    }

    if(XPos < 100) {
        XPos = 16;
        XPos += screenDist;
    }

    if(YPos > (CanvasSize.Y - 100)) {
        YPos = CanvasSize.Y;
        YPos -= screenDist;
    }
    if(YPos < 100) {
        YPos = 16;
        YPos += screenDist;
    }
}

#pragma mark - 雷达数据
static Vector3 WorldToRadar(float Yaw, Vector3 Origin, Vector3 LocalOrigin, float PosX, float PosY, Vector3 Size, bool& outbuff) {
    bool flag = false;
    double num = (double)Yaw;
    double num2 = num * 0.017453292519943295;
    float num3 = (float)cosl(num2);
    float num4 = (float)sin(num2);
    float num5 = Origin.X - LocalOrigin.X;
    float num6 = Origin.Y - LocalOrigin.Y;

    Vector3 vector;
    vector.X = (num6 * num3 - num5 * num4) / 150.f;
    vector.Y = (num5 * num3 + num6 * num4) / 150.f;

    Vector3 vector2;
    vector2.X = vector.X + PosX + Size.X / 2.f;
    vector2.Y = -vector.Y + PosY + Size.Y / 2.f;

    bool flag2 = vector2.X > PosX + Size.X;
    if (flag2) {
        vector2.X = PosX + Size.X;
    } else {
        bool flag3 = vector2.X < PosX;
        if (flag3) {
            vector2.X = PosX;
        }
    }
    bool flag4 = vector2.Y > PosY + Size.Y;
    if (flag4) {
        vector2.Y = PosY + Size.Y;
    } else {
        bool flag5 = vector2.Y < PosY;
        if (flag5) {
            vector2.Y = PosY;
        }
    }
    bool flag6 = vector2.Y == PosY || vector2.X == PosX;
    if (flag6) {
        flag = true;
    }
    outbuff = flag;
    return vector2;
}

static Vector3 WorldToRadar1(float Yaw, Vector3 Origin, Vector3 LocalOrigin, float PosX, float PosY, Vector3 Size, bool& outbuff) {

    double num = (double)Yaw;
    double num2 = num * 0.017453292519943295;
    float num3 = (float)cosl(num2);
    float num4 = (float)sin(num2);
    float num5 = Origin.X - LocalOrigin.X;
    float num6 = Origin.Y - LocalOrigin.Y;

    Vector3 vector;
    vector.X = (num6 * num3 - num5 * num4) / 150.f;
    vector.Y = (num5 * num3 + num6 * num4) / 150.f;

    float distance = Vector2(vector.X, vector.Y).Size();

    float radius = Size.X / 2.f;

    if (distance > radius) {

        float normalizedX = vector.X / distance;
        float normalizedY = vector.Y / distance;
        vector.X = normalizedX * radius;
        vector.Y = normalizedY * radius;
    }

    Vector3 vector2;
    vector2.X = vector.X + PosX + radius;
    vector2.Y = -vector.Y + PosY + radius;

    outbuff = distance > radius;

    return vector2;
}

#pragma mark - 雷达
static void DrawRadar(uintptr_t player, bool isAi, int xAxis, int yAxis, int width, int height) {
    Vector3 EntityLocation = GetRelativeLocation(player);

    bool isVisible = GetLineOfSightTo(EntityLocation);
    float Distance = Vector3::Distance(EntityLocation, POV.Location) / 100;

    bool out = false;

    Vector2 pos = Vector2(xAxis, yAxis);
    Vector2 size = Vector2(width, height);
    Vector2 RadarCenter = Vector2(pos.X + (size.X / 2), pos.Y + (size.Y / 2));

    DrawCircle(RadarCenter, size.X / 2, Colour_浅蓝, 1);

    DrawLine(Vector2(pos.X, RadarCenter.Y), Vector2(pos.X + size.X, RadarCenter.Y), 1, Colour_红色);

    DrawLine(Vector2(RadarCenter.X, RadarCenter.Y), Vector2(RadarCenter.X, pos.Y + size.Y), 1, Colour_红色);

    DrawCircleFilled(RadarCenter, 5, Colour_黄色);

    float angle1 = 40.0f;
    float angle2 = 140.0f;

    // 倍镜视野
    float ChScopeFov = Read<float>(Character + I64(kScopeFov));

    if (ChScopeFov >= 11 && ChScopeFov <= 70) {
        float angleDelta = (70 - ChScopeFov) * 0.6f; // 这里可以根据需要调整增加的步长

        angle1 += angleDelta;
        angle2 -= angleDelta;
    }

    float radius = size.X / 2.0f;

    Vector2 upperPoint1 = RadarCenter + Vector2(cosf(DEG2RAD(angle1)) * radius, -sinf(DEG2RAD(angle1)) * radius);
    Vector2 upperPoint2 = RadarCenter + Vector2(cosf(DEG2RAD(angle2)) * radius, -sinf(DEG2RAD(angle2)) * radius);

    // Draw the lines
    DrawLine(RadarCenter, upperPoint1, 1, Colour_绿色);
    DrawLine(RadarCenter, upperPoint2, 1, Colour_绿色);

    Vector3 single = WorldToRadar1(POV.Rotation.Yaw, EntityLocation, POV.Location, pos.X, pos.Y, Vector3(size.X, size.Y, 0), out);

    if (Distance >= 0.f && Distance < 400) {
        float yaw = RelativeRotation.Yaw;
        Vector2 directionEnd = Vector2(single.X + 30 * cosf(DEG2RAD(yaw)), single.Y + 30 * sinf(DEG2RAD(yaw)));
        DrawLine(Vector2(single.X, single.Y), directionEnd, 1, PlayerColos(isVisible, isAi));
        DrawCircleFilled(Vector2(directionEnd.X, directionEnd.Y), 2, PlayerColos(isVisible, isAi));

        DrawCircleFilled(Vector2(single.X, single.Y), 11, PlayerColos(isVisible, isAi));
        DrawCircle(Vector2(single.X, single.Y), 11, Colour_黑色);
        DrawText(string_format("%.0f", Distance), Vector2(single.X - 1, single.Y - 7), Colour_白色,10);
    }

}

#pragma mark - 玩家信息
static void GetPlayerInfo(long player, VectorRect rect, Vector2 RootScreen, string playerName, float Health, float distance, bool isAI,int TeamID) {
    
    if (血量开关) {
        
//        float dw = 100; // 矩形的宽度
//        float lineHeight = 2.5; // 线条的高度
//        float spaceHeight = 1.0; // 空白的高度
//        float rectHeight = lineHeight * 2 + spaceHeight; // 矩形的总高度
//        float dx = rect.x + rect.w * 0.5 - dw * 0.5; // 矩形的x坐标位置
//        float dy = rect.y - rectHeight * 2; // 矩形的y坐标位置
//        float HealthRatio = Health / 100;
//        float percent = dw * HealthRatio;


//        DrawCircle(Vector2(dx+45, dy-36), 20,isAI ? Colour_透明绿黄 : Colour_透明绿色,5);
//        DrawText(string_format("%.0f", Health), Vector2(dx+45, dy-40), Colour_白色);
        

        
        DrawText(string_format("血量:%.f", Health), Vector2(rect.x + rect.w/2, rect.y-70), isAI ? Colour_黄色 : Colour_红色);
        
    }
    
    if (名字开关) {
        // 距离
        DrawText(string_format("%.0f米", distance), Vector2(rect.x + rect.w/2, RootScreen.Y + 10), isAI ? Colour_黄色 : Colour_红色);
        //队标跟名字
        DrawText(string_format("%02d %s", TeamID, playerName.c_str()), Vector2(rect.x + rect.w/2, rect.y-30), isAI ? Colour_黄色 : Colour_红色);
    }
    
}
#pragma mark - 玩家数据
static void GetPYMaerData(long player) {
    
    if (player == Character) return;
    
    
    // 对象坐标
    long RootComponent = Read<long>(player + I64(kRootComponent));
    if (!IsValidAddress(RootComponent)) return;
    
    // 对象朝向
    RelativeRotation = Read<FRotator>(RootComponent + I64(kRelativeRotation));
    
    //对象高度
    float objectHeight = Read<float>(RootComponent + I64(kHeight1));
    
    if (objectHeight < 20) {
        return;
    }
    
    //判断高度
    if (objectHeight < 50) {
        objectHeight -= 18;
    } else if (objectHeight > 80) {
        objectHeight += 12;
    }
    
    // 判断死亡
    bool bDead = Read<bool>(player + I64(kbDead)) & 1;
    if (bDead) return;
    
    // 团队号
    int TeamID = Read<int>(player + I64(kTeamID));
    int MyTeam = Read<int>(PlayerController + I64(kMyTeam));
    if (TeamID == MyTeam) return;
    
    // 判断人机
    bool bIsAI = false;
    bIsAI = Read<bool>(player + I64(kbIsAI)) != 0;
    
    // 世界坐标
    Vector3 LocationWorldPos = GetRelativeLocation(player);
    Vector2 LocationScreen;
    ProjectWorldLocationToScreen(LocationWorldPos, true, &LocationScreen);
    
    //宽度和高度
    Vector2 width;
    ProjectWorldLocationToScreen(Vector3(LocationWorldPos.X,LocationWorldPos.Y,LocationWorldPos.Z + 100), true, &width);
    Vector2 height;
    ProjectWorldLocationToScreen(Vector3(LocationWorldPos.X,LocationWorldPos.Y,LocationWorldPos.Z + objectHeight), true, &height);
    
    Vector2 Playersize;
    Playersize.X = (LocationScreen.Y - width.Y) / 2;
    Playersize.Y = LocationScreen.Y - height.Y;
    
    // 距离
    float distance = Vector3::Distance(LocationWorldPos, POV.Location) / 100;
    if (distance > 600) return;
    
    float Health = Read<float>(player + I64(kHealth));
    float HealthMax = Read<float>(player + I64(kHealthMax));
    
    VectorRect rect;
    BoxConversion(LocationWorldPos, &rect);
    
    // 敌人数量统计
    totalEnemies++;
    
    if (ProjectWorldLocationToScreen(LocationWorldPos, true, &LocationScreen) && isScreenVisible(LocationScreen, Vector2(CanvasSize.X, CanvasSize.Y))) {
        
        // 取屏幕上最靠近屏幕中心点的敌人坐标
        tDis = GetCenterOffsetForVector(Vector2(rect.x, rect.y));
        if (tDistance <= CanvasSize.Y && tDis < markDis) {
            markDis = tDis;
            SetAimRadius(distance);
        }
        
        // 自己持枪武器
        long MyShootWeaponEntityComp = 0;
        long WeaponManagerComponent = Read<long>(Character + I64(kWeaponManagerComponent));
        if (IsValidAddress(WeaponManagerComponent)) {
            long CurrentWeaponReplicated = Read<long>(WeaponManagerComponent + I64(kCurrentWeaponReplicated));
            if (IsValidAddress(CurrentWeaponReplicated)) {
                int CurBullet1 = Read<int>(CurrentWeaponReplicated + I64(kCurBullet));
                int CurMaxBullet1 = Read<int>(CurrentWeaponReplicated + I64(kCurMaxBullet));
                ShootWeaponComponent = Read<long>(CurrentWeaponReplicated + I64(kShootWeaponComponent));
                ShootMode = Read<int>(CurrentWeaponReplicated + I64(kShootMode));
                MyShootWeaponEntityComp = Read<long>(CurrentWeaponReplicated + I64(kShootWeaponEntityComp));
                if (IsValidAddress(MyShootWeaponEntityComp)) {
                    //子弹条
                    DrawBulletBar(CurBullet1, CurMaxBullet1);
                }
            }
        }
        
#pragma mark - 骨骼数据
        // 人物骨骼
        long Mesh = Read<long>(player + I64(kMesh));
        if (!IsValidAddress(Mesh)) return;
        
        FTransform RelativeScale3D = GetMatrixConversion(Mesh + I64(kRelativeScale3D) + 0xC);
        
//        int Bone[18] = {6,5,4,3,2,1,12,13,14,33,34,35,53,54,55,57,58,59};
//        bool Visible[18];
        int Bone[18] = {6,4,1,12,13,14,33,34,35,53,54,55,57,58,59,60,61,62};
        bool Visible [18];
        
        Vector2 Bones_Pos[18];
        Vector3 Hitpart[18];
        
        Vector2 打击点屏幕坐标;
        Vector3 打击点世界坐标, root;
        
        for (int i = 0; i < 18; i++) {
            Vector3 pos = GetBoneWithRotation(Mesh, Bone[i], RelativeScale3D);
            
            Hitpart[i] = pos;
            Visible[i] = GetLineOfSightTo(pos);
            ProjectWorldLocationToScreen(pos, true, &Bones_Pos[i]);
        }
        
        switch (自瞄部位) {
            case 0:{
                for (int i = 0; i < 18; i++) {
                    if (Visible[i]) {
                        if (ShootMode <=1020) {
                            // 狙击枪攻击头部
                            打击点屏幕坐标 = Bones_Pos[i];
                            打击点世界坐标 = Hitpart[i];
                        } else {
                            // 其它枪 / 按順序攻击其它部位
                            if (Visible[0] && Visible[1] && Visible[2]) {
                                打击点屏幕坐标 = Bones_Pos[i];
                                打击点世界坐标 = Hitpart[i];
                            }else if (Visible[0] && Visible[1]) {
                                打击点屏幕坐标 = Bones_Pos[1];
                                打击点世界坐标 = Hitpart[1];
                            }else{
                                打击点屏幕坐标 = Bones_Pos[i];
                                打击点世界坐标 = Hitpart[i];
                            }
                        }
                        break;
                    }
                }
                break;
            }
            case 1:{
                
                int Bone1[] = {6,5,4,3,2,1,11,12,13,14,33,34,35,36,56,57,58,60,61,62};
                int numBones = sizeof(Bone1) / sizeof(Bone1[0]);
                
                Vector3 Hitpart1[20];
                
                for (int i = 0; i < numBones; i++) {
                    int randomIndex = arc4random_uniform(numBones);
                    int randomBone = Bone[randomIndex];
                    
                    Vector3 pos = GetBoneWithRotation(Mesh, randomBone, RelativeScale3D);
                    Hitpart1[i] = pos;
                    
                }
                
                for (int i = 0; i < numBones; i++) {
                    if (Visible[i]) {
                        if (ShootMode <=1020) {
                            // 狙击枪攻击头部
                            打击点屏幕坐标 = Bones_Pos[i];
                            打击点世界坐标 = Hitpart[i];
                        } else {
                            // 其它枪 / 按順序攻击其它部位
                            if (Visible[0] && Visible[1] && Visible[2]) {
                                打击点屏幕坐标 = Bones_Pos[i];
                                打击点世界坐标 = Hitpart1[i];
                            }else if (Visible[0] && Visible[1]) {
                                打击点屏幕坐标 = Bones_Pos[1];
                                打击点世界坐标 = Hitpart1[1];
                            }else{
                                打击点屏幕坐标 = Bones_Pos[i];
                                打击点世界坐标 = Hitpart1[i];
                            }
                        }
                        break;
                    }
                }
                break;
            }
        }
        
        
        Vector2 RootScreen;
        ProjectWorldLocationToScreen(GetBoneWithRotation(Mesh, 0, RelativeScale3D), true, &RootScreen);
        
        
        if (骨骼开关) {
            // 绘画骨骼
            DrawLine(Vector2(Bones_Pos[0].X, Bones_Pos[0].Y), Vector2(Bones_Pos[1].X, Bones_Pos[1].Y), 1, BoneColos(Visible[0] , Visible[1] , bIsAI));
            DrawLine(Vector2(Bones_Pos[1].X, Bones_Pos[1].Y), Vector2(Bones_Pos[2].X, Bones_Pos[2].Y), 1, BoneColos(Visible[1] , Visible[2], bIsAI));
            DrawLine(Vector2(Bones_Pos[1].X, Bones_Pos[1].Y), Vector2(Bones_Pos[3].X, Bones_Pos[3].Y), 1, BoneColos(Visible[1] , Visible[3], bIsAI));
            DrawLine(Vector2(Bones_Pos[3].X, Bones_Pos[3].Y), Vector2(Bones_Pos[4].X, Bones_Pos[4].Y), 1, BoneColos(Visible[3] , Visible[4], bIsAI));
            DrawLine(Vector2(Bones_Pos[4].X, Bones_Pos[4].Y), Vector2(Bones_Pos[5].X, Bones_Pos[5].Y), 1, BoneColos(Visible[4] , Visible[5], bIsAI));
            DrawLine(Vector2(Bones_Pos[1].X, Bones_Pos[1].Y), Vector2(Bones_Pos[6].X, Bones_Pos[6].Y), 1, BoneColos(Visible[1] , Visible[6], bIsAI));
            DrawLine(Vector2(Bones_Pos[6].X, Bones_Pos[6].Y), Vector2(Bones_Pos[7].X, Bones_Pos[7].Y), 1, BoneColos(Visible[6] , Visible[7], bIsAI));
            DrawLine(Vector2(Bones_Pos[7].X, Bones_Pos[7].Y), Vector2(Bones_Pos[8].X, Bones_Pos[8].Y), 1, BoneColos(Visible[7] , Visible[8], bIsAI));
            DrawLine(Vector2(Bones_Pos[2].X, Bones_Pos[2].Y), Vector2(Bones_Pos[9].X, Bones_Pos[9].Y), 1, BoneColos(Visible[2] , Visible[9], bIsAI));
            DrawLine(Vector2(Bones_Pos[9].X, Bones_Pos[9].Y), Vector2(Bones_Pos[10].X, Bones_Pos[10].Y), 1, BoneColos(Visible[9] , Visible[10], bIsAI));
            DrawLine(Vector2(Bones_Pos[10].X, Bones_Pos[10].Y), Vector2(Bones_Pos[11].X, Bones_Pos[11].Y), 1, BoneColos(Visible[10] , Visible[11], bIsAI));
            DrawLine(Vector2(Bones_Pos[2].X, Bones_Pos[2].Y), Vector2(Bones_Pos[12].X, Bones_Pos[12].Y), 1, BoneColos(Visible[2] , Visible[12], bIsAI));
            DrawLine(Vector2(Bones_Pos[12].X, Bones_Pos[12].Y), Vector2(Bones_Pos[13].X, Bones_Pos[13].Y), 1, BoneColos(Visible[12] , Visible[13], bIsAI));
//            DrawLine(Vector2(Bones_Pos[13].X, Bones_Pos[13].Y), Vector2(Bones_Pos[14].X, Bones_Pos[14].Y), 1, BoneColos(Visible[13] , Visible[14], bIsAI));
            

//            DrawLine(Vector2(Bones_Pos[14].X, Bones_Pos[14].Y), Vector2(Bones_Pos[15].X, Bones_Pos[15].Y), 1, BoneColos(Visible[16], Visible[17], bIsAI));
            
            DrawLine(Vector2(Bones_Pos[15].X, Bones_Pos[15].Y), Vector2(Bones_Pos[16].X, Bones_Pos[16].Y), 1, BoneColos(Visible[17], Visible[17], bIsAI));
            DrawLine(Vector2(Bones_Pos[16].X, Bones_Pos[16].Y), Vector2(Bones_Pos[17].X, Bones_Pos[17].Y), 1, BoneColos(Visible[17], Visible[17], bIsAI));
            

//            DrawLine(Vector2(Bones_Pos[1].X, Bones_Pos[1].Y), Vector2(Bones_Pos[2].X, Bones_Pos[2].Y), 1, BoneColos(Visible[1], Visible[2], bIsAI));
//            DrawLine(Vector2(Bones_Pos[2].X, Bones_Pos[2].Y), Vector2(Bones_Pos[3].X, Bones_Pos[3].Y), 1, BoneColos(Visible[2], Visible[3], bIsAI));
//            DrawLine(Vector2(Bones_Pos[3].X, Bones_Pos[3].Y), Vector2(Bones_Pos[4].X, Bones_Pos[4].Y), 1, BoneColos(Visible[3], Visible[4], bIsAI));
//            DrawLine(Vector2(Bones_Pos[4].X, Bones_Pos[4].Y), Vector2(Bones_Pos[5].X, Bones_Pos[5].Y), 1, BoneColos(Visible[4], Visible[5], bIsAI));
//
//            DrawLine(Vector2(Bones_Pos[2].X, Bones_Pos[2].Y), Vector2(Bones_Pos[6].X, Bones_Pos[6].Y), 1, BoneColos(Visible[2], Visible[6], bIsAI));
//            DrawLine(Vector2(Bones_Pos[6].X, Bones_Pos[6].Y), Vector2(Bones_Pos[7].X, Bones_Pos[7].Y), 1, BoneColos(Visible[6], Visible[7], bIsAI));
//            DrawLine(Vector2(Bones_Pos[7].X, Bones_Pos[7].Y), Vector2(Bones_Pos[8].X, Bones_Pos[8].Y), 1, BoneColos(Visible[7], Visible[8], bIsAI));
//
//            DrawLine(Vector2(Bones_Pos[2].X, Bones_Pos[2].Y), Vector2(Bones_Pos[9].X, Bones_Pos[9].Y), 1, BoneColos(Visible[2], Visible[9], bIsAI));
//            DrawLine(Vector2(Bones_Pos[9].X, Bones_Pos[9].Y), Vector2(Bones_Pos[10].X, Bones_Pos[10].Y), 1, BoneColos(Visible[9], Visible[10], bIsAI));
//            DrawLine(Vector2(Bones_Pos[10].X, Bones_Pos[10].Y), Vector2(Bones_Pos[11].X, Bones_Pos[11].Y), 1, BoneColos(Visible[10], Visible[11], bIsAI));
//
//            DrawLine(Vector2(Bones_Pos[5].X, Bones_Pos[5].Y), Vector2(Bones_Pos[12].X, Bones_Pos[12].Y), 1, BoneColos(Visible[5], Visible[12], bIsAI));
//            DrawLine(Vector2(Bones_Pos[12].X, Bones_Pos[12].Y), Vector2(Bones_Pos[13].X, Bones_Pos[13].Y), 1, BoneColos(Visible[12], Visible[13], bIsAI));
//            DrawLine(Vector2(Bones_Pos[13].X, Bones_Pos[13].Y), Vector2(Bones_Pos[14].X, Bones_Pos[14].Y), 1, BoneColos(Visible[13], Visible[14], bIsAI));
//
//            DrawLine(Vector2(Bones_Pos[5].X, Bones_Pos[5].Y), Vector2(Bones_Pos[15].X, Bones_Pos[15].Y), 1, BoneColos(Visible[5], Visible[15], bIsAI));
//            DrawLine(Vector2(Bones_Pos[15].X, Bones_Pos[15].Y), Vector2(Bones_Pos[16].X, Bones_Pos[16].Y), 1, BoneColos(Visible[15], Visible[16], bIsAI));
//            DrawLine(Vector2(Bones_Pos[16].X, Bones_Pos[16].Y), Vector2(Bones_Pos[17].X, Bones_Pos[17].Y), 1, BoneColos(Visible[16], Visible[17], bIsAI));
            
        }
        
        GetPlayerInfo(player, rect, RootScreen, GetPlayerName(player), Health / HealthMax * 100, distance, bIsAI, TeamID);
        
        // 绘画持枪武器
       bool isWeaponId = false;
        WeaponManagerComponent = Read<long>(player + I64(kWeaponManagerComponent));

        if (IsValidAddress(WeaponManagerComponent)) {
            long CurrentWeaponReplicated = Read<long>(WeaponManagerComponent + I64(kCurrentWeaponReplicated));
            if (IsValidAddress(CurrentWeaponReplicated)) {
                int CurBullet = Read<int>(CurrentWeaponReplicated + I64(kCurBullet));
                int CurMaxBullet = Read<int>(CurrentWeaponReplicated + I64(kCurMaxBullet));
                long ShootWeaponEntityComponent = Read<long>(CurrentWeaponReplicated + I64(kShootWeaponEntityComp));
                if(IsValidAddress(ShootWeaponEntityComponent)) {
                    string WeaponName = GetWeaponIDName(Read<int>(ShootWeaponEntityComponent + I64(kWeaponId)));
                    string text = string_format("%s&%d/%d", WeaponName.c_str(), CurBullet, CurMaxBullet);
                    if (!WeaponName.empty()) {
                        isWeaponId = true;
                        if (持枪开关) {
                        DrawText(text, Vector2(rect.x + rect.w/2, rect.y - 50), bIsAI ? Colour_白色:Colour_黄色);
                        }
                    }

                }
            }
        }
        
        
        if (射线开关) {
            int offsetY = isWeaponId ? 53 : 31;
            DrawLine(Vector2(CanvasSize.X/2, 10), Vector2(rect.x + rect.w/2, rect.y - offsetY-30), 1, PColos(GetLineOfSightTo(LocationWorldPos), bIsAI));
            // 射线开关
        }
#pragma mark - 绘画3D盒子
        switch (框架开关) {
            case 0:{ //绘制三维框
                // 绘画3D盒子
                bool IsCurrentVehicle = false;  // 定义布尔变量IsCurrentVehicle，初始值为false
                // 读取玩家当前所在的车辆的地址，并判断其是否有效
                uintptr_t CurrentVehicle = Read<uintptr_t>(player + I64(kCurrentVehicle));
                if (IsValidAddress(CurrentVehicle))
                    IsCurrentVehicle = true;

                // 如果玩家不在车内
                if (!IsCurrentVehicle) {
                    playerstate = Read<TEnumAsByte<ESTEPoseState>>(player + I64(kPoseState));
                    switch (playerstate) {
                        case ESTEPoseState::ESTEPoseState__Stand: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 90); break;
                        case ESTEPoseState::ESTEPoseState__Sprint: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 90); break;
                        case ESTEPoseState::ESTEPoseState__Crouch: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 70); break;
                        case ESTEPoseState::ESTEPoseState__CrouchSprint: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 70); break;
                        case ESTEPoseState::ESTEPoseState__Prone: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 70); break;
                        case ESTEPoseState::ESTEPoseState__Crawl: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 70); break;
                        case ESTEPoseState::ESTEPoseState__SwimSprint: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 60); break;
                        case ESTEPoseState::ESTEPoseState__Dying: LocationWorldPos = Vector3(LocationWorldPos.X, LocationWorldPos.Y, LocationWorldPos.Z - 60); break;
                        default: break;
                    }
                    Get3DBox(LocationWorldPos, PColos(GetLineOfSightTo(LocationWorldPos), bIsAI));

                }
                break;
            }
            case 1:{

                DrawUnclosedRect(LocationScreen.X, LocationScreen.Y, Playersize.X + Playersize.X, Playersize.Y + Playersize.Y, PColos(GetLineOfSightTo(LocationWorldPos), bIsAI));


                break;
            }

            case 2:{

                break;
            }
        }
        
#pragma mark - 圆圈攻击范围
        switch (圆圈模式) {
            case 0:{
//                if (Health != 0)
           if (GetInsideFov(CanvasSize.X, CanvasSize.Y, 打击点屏幕坐标, Aimbot_Circle_Radius)) {
                                         tDistance = GetCenterOffsetForVector(打击点屏幕坐标);
                                         if (tDistance <= 圆圈固定 && tDistance < markDistance && distance<=击打距离) {
                                             needAdjustAim = true;
                                             if (needAdjustAim) {
                                                 markDistance = tDistance;
                                                 markScreenPos = 打击点屏幕坐标;
                                                 SetControlRotation(player, 打击点世界坐标);
                    }
                                         }}
                if (倒地开关) {
                    if (GetInsideFov(CanvasSize.X, CanvasSize.Y, 打击点屏幕坐标, Aimbot_Circle_Radius)) {// 判断目标是否在视野内
                        tDistance = GetCenterOffsetForVector(打击点屏幕坐标);// 计算目标距离屏幕中心的距离
                        if (tDistance <= Aimbot_Circle_Radius && tDistance < markDistance && distance<=击打距离) {// 判断目标是否在自瞄范围内并且更靠近玩家
                            needAdjustAim = true;// 符合攻击条件
                            if (needAdjustAim) { // 如果需要瞄准调整
                                Aimbot_Circle_Radius = tDistance;// 记录最近目标距离
                                markScreenPos = 打击点屏幕坐标;// 记录最近目标在屏幕中的位置
                                SetControlRotation(player, 打击点世界坐标);
                            }
                        }
                    }
                }
                break;
            }
            case 1:{
//                if (Health != 0)
                    if (GetInsideFov(CanvasSize.X, CanvasSize.Y, 打击点屏幕坐标, 圆圈固定)) {
                        tDistance = GetCenterOffsetForVector(打击点屏幕坐标);
                        if (tDistance <= 圆圈固定 && tDistance < markDistance && distance<=击打距离) {
                            needAdjustAim = true;
                            if (needAdjustAim) {
                                markDistance = tDistance;
                                markScreenPos = 打击点屏幕坐标;
                                SetControlRotation(player, 打击点世界坐标);
                                
                            }
                        }
                    }
                
                if (倒地开关) {
                    if (GetInsideFov(CanvasSize.X, CanvasSize.Y, 打击点屏幕坐标, 圆圈固定)) {// 判断目标是否在视野内
                        tDistance = GetCenterOffsetForVector(打击点屏幕坐标);// 计算目标距离屏幕中心的距离
                        if (tDistance <= 圆圈固定 && tDistance < markDistance && distance<=击打距离) {// 判断目标是否在自瞄范围内并且更靠近玩家
                            needAdjustAim = true;// 符合攻击条件
                            if (needAdjustAim) { // 如果需要瞄准调整
                                markDistance = tDistance;// 记录最近目标距离
                                markScreenPos = 打击点屏幕坐标;// 记录最近目标在屏幕中的位置
                                SetControlRotation(player, 打击点世界坐标);
                            }
                        }
                    }
                }
                break;
            }
        }
    } else {
          
   
#pragma mark -  背敌预警
//        switch (背敌模式) {
        if(背敌模式) {
                bool shit = false;
                Vector3 EntityPos = WorldToRadar(POV.Rotation .Yaw, LocationWorldPos, POV.Location, NULL, NULL, Vector3(CanvasSize .X, CanvasSize .Y, 0), shit);

                int radar_range = 350;

                float Distance = Vector3::Distance(LocationWorldPos, POV.Location)/100;

                Vector3 forward = {(float)(CanvasSize.X  / 2) - EntityPos.X, (float)(CanvasSize.Y / 2) - EntityPos.Y, 0.f};// 将雷达坐标系中的位置转换为角度
                Vector3 angle;
                VectorAnglesRadar(forward, angle);

                const auto angle_yaw_rad = DEG2RAD(angle .Y + 180.f);
                float new_point_x = (CanvasSize.X / 2) + (radar_range) / 2 * 8 * cosf(angle_yaw_rad);
                float new_point_y = (CanvasSize.Y / 2) + (radar_range) / 2 * 8 * sinf(angle_yaw_rad);

                FixTriangle(new_point_x, new_point_y, 60);

                std::array<Vector3, 1> points
                {
                    Vector3(new_point_x, new_point_y, 0.f),
                };

                if (Health>0) DrawCircleFilled(Vector2(points.at(0).X, points.at(0).Y), 38,PlayerColos(GetLineOfSightTo(LocationWorldPos), bIsAI));
                else DrawCircleFilled(Vector2(points.at(0).X, points.at(0).Y), 38,0xFF00A5FF);

                DrawCircle(Vector2(points.at(0).X, points.at(0).Y), 38,Colour_黑色,2);
                DrawText(string_format("%.0fm", Distance), Vector2(points[0].X, points[0].Y-12), Colour_白色,17);
                
            
   
            
                
//            case 0:{
//                bool shit = false; //初始化一个布尔变量为 false
//                // 将世界坐标系中的位置转换为雷达坐标系中的位置
//                Vector3 EntityPos = WorldToRadar(POV.Rotation .Yaw, LocationWorldPos, POV.Location, NULL, NULL, Vector3(CanvasSize .X, CanvasSize .Y, 0), shit);
//
//                float Distance = Vector3::Distance(LocationWorldPos, POV.Location)/100; // 计算实体与观察者之间的距离
//
//                Vector3 angle; // 定义一个向量
//                Vector3 DD = {(float)(CanvasSize .X  / 2) - EntityPos .X, (float)(CanvasSize .Y / 2) - EntityPos .Y, 0.f};// 将雷达坐标系中的位置转换为角度
//
//                VectorAnglesRadar(DD, angle);
//                int radar_range1 = 预警范围;// 定义一个雷达预警范围
//
//                const auto angle_yaw_rad = DEG2RAD(angle .Y + 180.f);// 将角度转换为弧度
//                // 计算箭头的新位置
//                const auto new_point_x = ((CanvasSize .X / 2) + (radar_range1) / 2 * 8 * cosf(angle_yaw_rad)) + 32;
//                const auto new_point_y = (CanvasSize .Y / 2) + (radar_range1) / 2 * 8 * sinf(angle_yaw_rad);
//                // 定义一个七边形的点集合
//                std::array<Vector2, 7> points
//                {
//                    Vector2(new_point_x  - 20, new_point_y - 20),
//                    Vector2(new_point_x  + 30 , new_point_y),
//                    Vector2(new_point_x  - 20, new_point_y  + 20 ),
//                    Vector2(new_point_x  - 25 , new_point_y - 10),
//                    Vector2(new_point_x  - 65 , new_point_y - 10),
//                    Vector2(new_point_x  - 65 , new_point_y + 10),
//                    Vector2(new_point_x  - 25 , new_point_y + 10),
//                };
//
//                // 旋转七边形的点集合
//                RotateArrow(points, angle .Y + 180.0f);
//                // 根据实体的生命值，画出箭头
//                if (Health>0) DrawArrows(points.at(0) , points.at(1) , points.at(2),points.at(3) , points.at(4)  ,points.at(5), points.at(6), PColos(GetLineOfSightTo(LocationWorldPos), bIsAI), 4);
//                else DrawArrows(points.at(0) , points.at(1) , points.at(2),points.at(3) , points.at(4)  ,points.at(5), points.at(6) , 0xFF00A5FF,4);
//                // 在箭头附近绘制距离文本
//                DrawText(string_format("%.0fm", Distance), Vector2(points[5] .X, points[5] .Y), Colour_白色,15);
//                break;
//            }
//
//            case 1:{
//
//                bool shit = false;
//                Vector3 EntityPos = WorldToRadar(POV.Rotation .Yaw, LocationWorldPos, POV.Location, NULL, NULL, Vector3(CanvasSize .X, CanvasSize .Y, 0), shit);
//
//                int radar_range = 预警范围;
//
//                float Distance = Vector3::Distance(LocationWorldPos, POV.Location)/100;
//
//                Vector3 forward = {(float)(CanvasSize.X  / 2) - EntityPos.X, (float)(CanvasSize.Y / 2) - EntityPos.Y, 0.f};// 将雷达坐标系中的位置转换为角度
//                Vector3 angle;
//                VectorAnglesRadar(forward, angle);
//
//                const auto angle_yaw_rad = DEG2RAD(angle .Y + 180.f);
//                const auto new_point_x = (CanvasSize .X / 2) + (radar_range) / 2 * 8 * cosf(angle_yaw_rad);
//                const auto new_point_y = (CanvasSize .Y / 2) + (radar_range) / 2 * 8 * sinf(angle_yaw_rad);
//
//                std::array<Vector3, 3> points
//                {
//                    Vector3(new_point_x - ((90) / 4 + 3.5f) / 1, new_point_y - ((radar_range) / 4 + 3.5f) / 2, 0.f),
//                    Vector3(new_point_x + ((90) / 2 + 3.5f) / 2, new_point_y, 0.f),
//                    Vector3(new_point_x - ((90) / 4 + 3.5f) / 1, new_point_y + ((radar_range) / 4 + 3.5f) / 2, 0.f)
//                };
//
//                RotateTriangle(points, angle.Y + 180.f);
//
//                if (Health>0) DrawFilledTriangle(points.at(0).X, points.at(0).Y,points.at(1).X, points.at(1).Y,points.at(2).X, points.at(2).Y,PColos(GetLineOfSightTo(LocationWorldPos), bIsAI));
//                else DrawFilledTriangle(points.at(0).X, points.at(0).Y,points.at(1).X, points.at(1).Y,points.at(2).X, points.at(2).Y,0xFF00A5FF);
//
//                DrawTriangle(points.at(0).X, points.at(0).Y,points.at(1).X, points.at(1).Y,points.at(2).X, points.at(2).Y,Colour_黑色,1.0f);
//
//                DrawText(string_format("%.0fm", Distance), Vector2(points[0] .X, points[0] .Y), Colour_白色,13);
//                break;
//            }
//            case 2:{
//
//                bool shit = false;
//                Vector3 EntityPos = WorldToRadar(POV.Rotation .Yaw, LocationWorldPos, POV.Location, NULL, NULL, Vector3(CanvasSize .X, CanvasSize .Y, 0), shit);
//
//                int radar_range = 350;
//
//                float Distance = Vector3::Distance(LocationWorldPos, POV.Location)/100;
//
//                Vector3 forward = {(float)(CanvasSize.X  / 2) - EntityPos.X, (float)(CanvasSize.Y / 2) - EntityPos.Y, 0.f};// 将雷达坐标系中的位置转换为角度
//                Vector3 angle;
//                VectorAnglesRadar(forward, angle);
//
//                const auto angle_yaw_rad = DEG2RAD(angle .Y + 180.f);
//                float new_point_x = (CanvasSize.X / 2) + (radar_range) / 2 * 8 * cosf(angle_yaw_rad);
//                float new_point_y = (CanvasSize.Y / 2) + (radar_range) / 2 * 8 * sinf(angle_yaw_rad);
//
//                FixTriangle(new_point_x, new_point_y, 60);
//
//                std::array<Vector3, 1> points
//                {
//                    Vector3(new_point_x, new_point_y, 0.f),
//                };
//
//                if (Health>0) DrawCircleFilled(Vector2(points.at(0).X, points.at(0).Y), 38,PlayerColos(GetLineOfSightTo(LocationWorldPos), bIsAI));
//                else DrawCircleFilled(Vector2(points.at(0).X, points.at(0).Y), 38,0xFF00A5FF);
//
//                DrawCircle(Vector2(points.at(0).X, points.at(0).Y), 38,Colour_黑色,2);
//                DrawText(string_format("%.0fm", Distance), Vector2(points[0].X, points[0].Y-12), Colour_白色,17);
//
//
//                break;
//            }
        }
    }
    if(雷达开关) {
        DrawRadar(player, bIsAI, 雷达X, 雷达Y, 雷达大小, 雷达大小);
    }
    
}


#pragma mark -  载具
static void GetVehicleData(long vehicle, const char* name, int color) {
    long VehicleCommon = Read<long>(vehicle + I64(kVehicleCommon));
    if (!IsValidAddress(VehicleCommon)) return;
    float dw = 40;
    float lineHeight = 2.0;
    float spaceHeight = 1.0;
    float rectHeight = lineHeight * 2 + spaceHeight;
    
    // 血量
    float HP = Read<float>(VehicleCommon + I64(kHP));
    float HPMax = Read<float>(VehicleCommon + I64(kHPMax));
    float Health = HP / HPMax * 100;

    // 车油量
    float Fuel = Read<float>(VehicleCommon + I64(kFuel));
    float FuelMax = Read<float>(VehicleCommon + I64(kFuelMax));
    float Oil = Fuel / FuelMax * 100;

    float Health1 = Health / 100;
    float Oil1 = Oil / 100;

    float percent = dw * Health1;
    float percent1 = dw * Oil1;
    Vector3 worldLocation = GetRelativeLocation(vehicle);
    Vector2 screenLocation;

    if (ProjectWorldLocationToScreen(worldLocation, true, &screenLocation) && isScreenVisible(screenLocation, Vector2(CanvasSize.X, CanvasSize.Y))) { // 屏幕内
        float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
        if (Health != 0 && distance > 10 && distance <= 800) {
            if (isEqual(name, "PG117") && distance > 100) return;
            if (isEqual(name, "Kayak") && distance > 100) return;
            DrawText(string_format("%s[%.0fM]", name, distance), Vector2(screenLocation.X, screenLocation.Y), color ,13);
            DrawRectFilled(Vector2(screenLocation.X-38, screenLocation.Y+23), percent, 4, Colour_红色);
            DrawRect(Vector2(screenLocation.X-38, screenLocation.Y+23), Vector2(dw, rectHeight), lineHeight, Colour_黑色);
            DrawRectFilled(Vector2(screenLocation.X+2, screenLocation.Y+23), percent1, 4, Colour_绿色);
            DrawRect(Vector2(screenLocation.X+2, screenLocation.Y+23), Vector2(dw, rectHeight), lineHeight, Colour_黑色);

        }
    }
}
#pragma mark - 物资
static void GetSuppliesData(long Object, const char* name, int color) {

    Vector3 worldLocation = GetRelativeLocation(Object);
    Vector2 screenLocation;

    if (ProjectWorldLocationToScreen(worldLocation, true, &screenLocation) && isScreenVisible(screenLocation, Vector2(CanvasSize.X, CanvasSize.Y))) { // 屏幕内
        float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
        if (isEqual(name, "Player Box") && distance > 80) return;
        if (distance > 2 && distance <= 物资距离) {
            DrawText(string_format("%s[%.0fM]", name, distance), screenLocation, color ,13);
        }
    }
}

#pragma mark - 盒子
static void GetData(long Object, const char* name, int color) {

    Vector3 worldLocation = GetRelativeLocation(Object);
    Vector2 screenLocation;

    if (ProjectWorldLocationToScreen(worldLocation, true, &screenLocation) && isScreenVisible(screenLocation, Vector2(CanvasSize.X, CanvasSize.Y))) { // 屏幕内
        float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
        if (distance < 700.f) {

            Vector3 extends = Vector3(75, 50, 30);
            Draw3DBox(worldLocation, extends, Colour_珊瑚红);

            DrawText(string_format("%s[%.0fM]", name, distance), screenLocation, color ,13);

        }
    }
}
#pragma mark - 空投
static void GetAirDropData(long Object, const char* name, int color) {
    int goodsListValidCount = 0;
    Vector3 worldLocation = GetRelativeLocation(Object);
    Vector2 screenLocation;

    if (ProjectWorldLocationToScreen(worldLocation, true, &screenLocation) && isScreenVisible(screenLocation, Vector2(CanvasSize.X, CanvasSize.Y))) { // 屏幕内
        float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
        if (distance > 2 && distance <= 3000) {

            DrawText(string_format("%s[%.0fM]", name, distance), screenLocation, color ,13);

        }
    }
}

#pragma mark - 手雷预警
static void GetThrowData(long Object) {

    Vector3 worldLocation = GetRelativeLocation(Object);
    Vector2 screenLocation;
    ProjectWorldLocationToScreen(worldLocation, true, &screenLocation);

    float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
    if (distance < 500.f) {
        DrawCircleFilled(screenLocation,15,Colour_透明红色);
        DrawText(string_format("%.f",distance), Vector2(screenLocation.X-1,screenLocation.Y-9),Colour_白色);

        // 矩形
        DrawRectFilled(Vector2(screenLocation.X-7.5,screenLocation.Y-10), 15, -15, Colour_红色);
        DrawRectFilled(Vector2(screenLocation.X-13,screenLocation.Y-28), 26, 4, Colour_红色);
        DrawCircle(Vector2(screenLocation.X+10,screenLocation.Y-22), 7, Colour_红色);
        DrawTitle(string_format("危险警告(%.fm)",distance), Vector2(CanvasSize.X/2, CanvasSize.Y*0.08f+70), Colour_红色);
        DrawLine(Vector2(CanvasSize.X/2, 10), Vector2(screenLocation.X, screenLocation.Y-10), 1, Colour_红色);

        Draw2DPlaneCircle(worldLocation, 150, Colour_红色);

        Draw2DPlaneCircle(worldLocation, 350, Colour_黄色);

        Draw2DPlaneCircle(worldLocation, 650, Colour_绿色);

        if (screenLocation.X > CanvasSize.X && screenLocation.Y < 0) {//绘制在屏幕右上角
            DrawCircleFilled(Vector2(CanvasSize.X-50, 0 ), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(CanvasSize.X-50, -15 ), Colour_白色 ,18);

        } else if(screenLocation.X > CanvasSize.X && screenLocation.Y > CanvasSize.Y) {//绘制在屏幕右下角
            DrawCircleFilled(Vector2(CanvasSize.X-50, CanvasSize.Y-50 ), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(CanvasSize.X-50, CanvasSize.Y-65 ), Colour_白色 ,18);

        }else if(screenLocation.X < 0 && screenLocation.Y < 0) {//绘制在屏幕左上角
            DrawCircleFilled(Vector2(50, 50 ), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(50, 35), Colour_白色 ,18);

        }else if(screenLocation.X < 0 && screenLocation.Y > CanvasSize.Y) {//绘制在屏幕左下角
            DrawCircleFilled(Vector2(50, CanvasSize.Y-50), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(50, CanvasSize.Y-65), Colour_白色 ,18);

        }else if(screenLocation.X > CanvasSize.X && screenLocation.Y < CanvasSize.Y && screenLocation.Y > 0) {//绘制在屏幕右边框
            DrawCircleFilled(Vector2(CanvasSize.X-50, screenLocation.Y), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(CanvasSize.X-50, screenLocation.Y-15), Colour_白色 ,18);

        }else if(screenLocation.X < 0 && screenLocation.Y < CanvasSize.Y && screenLocation.Y > 0) {//绘制在屏幕左边框
            DrawCircleFilled(Vector2(50, screenLocation.Y), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(50, screenLocation.Y-15), Colour_白色 ,18);

        }else if(screenLocation.Y > CanvasSize.Y && screenLocation.X < CanvasSize.X && screenLocation.X > 0) {//绘制在屏幕下边框
            DrawCircleFilled(Vector2(screenLocation.X, CanvasSize.Y-50), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(screenLocation.X, CanvasSize.Y-65), Colour_白色 ,18);

        }else if(screenLocation.Y < 0 && screenLocation.X < CanvasSize.X && screenLocation.X > 0) {//绘制在屏幕上边框
            DrawCircleFilled(Vector2(screenLocation.X, 50), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(screenLocation.X, 35), Colour_白色 ,18);
        }

    }
}
#pragma mark - 燃烧瓶预警
static void GetThrowDatarsp(long Object) {

    Vector3 worldLocation = GetRelativeLocation(Object);
    Vector2 screenLocation;
    ProjectWorldLocationToScreen(worldLocation, true, &screenLocation);


    float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
    if (distance < 500.f) {

        DrawText(string_format("小心燃烧瓶%.f",distance), Vector2(screenLocation.X-1,screenLocation.Y-9),Colour_红色 ,14);

        Draw2DPlaneCircle(worldLocation, 150, Colour_红色);

        Draw2DPlaneCircle(worldLocation, 350, Colour_黄色);

        Draw2DPlaneCircle(worldLocation, 650, Colour_绿色);

        if (screenLocation.X > CanvasSize.X && screenLocation.Y < 0) {//绘制在屏幕右上角
            DrawCircleFilled(Vector2(CanvasSize.X-50, 0 ), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(CanvasSize.X-50, -15 ), Colour_白色,18);

        } else if(screenLocation.X > CanvasSize.X && screenLocation.Y > CanvasSize.Y) {//绘制在屏幕右下角
            DrawCircleFilled(Vector2(CanvasSize.X-50, CanvasSize.Y-50 ), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(CanvasSize.X-50, CanvasSize.Y-65 ), Colour_白色,18);

        }else if(screenLocation.X < 0 && screenLocation.Y < 0) {//绘制在屏幕左上角
            DrawCircleFilled(Vector2(50, 50 ), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(50, 35), Colour_白色,18);

        }else if(screenLocation.X < 0 && screenLocation.Y > CanvasSize.Y) {//绘制在屏幕左下角
            DrawCircleFilled(Vector2(50, CanvasSize.Y-50), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(50, CanvasSize.Y-65), Colour_白色,18);

        }else if(screenLocation.X > CanvasSize.X && screenLocation.Y < CanvasSize.Y && screenLocation.Y > 0) {//绘制在屏幕右边框
            DrawCircleFilled(Vector2(CanvasSize.X-50, screenLocation.Y), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(CanvasSize.X-50, screenLocation.Y-15), Colour_白色,18);

        }else if(screenLocation.X < 0 && screenLocation.Y < CanvasSize.Y && screenLocation.Y > 0) {//绘制在屏幕左边框
            DrawCircleFilled(Vector2(50, screenLocation.Y), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(50, screenLocation.Y-15), Colour_白色,18);

        }else if(screenLocation.Y > CanvasSize.Y && screenLocation.X < CanvasSize.X && screenLocation.X > 0) {//绘制在屏幕下边框
            DrawCircleFilled(Vector2(screenLocation.X, CanvasSize.Y-50), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(screenLocation.X, CanvasSize.Y-65), Colour_白色,18);

        }else if(screenLocation.Y < 0 && screenLocation.X < CanvasSize.X && screenLocation.X > 0) {//绘制在屏幕上边框
            DrawCircleFilled(Vector2(screenLocation.X, 50), 40, Colour_红色);
            DrawText(string_format("%.0fm", distance), Vector2(screenLocation.X, 35), Colour_白色,18);
        }
    }
}
#pragma mark - 烟雾弹预警
static void GetThrowDataywd(long Object) {

    Vector3 worldLocation = GetRelativeLocation(Object);
    Vector2 screenLocation;
    ProjectWorldLocationToScreen(worldLocation, true, &screenLocation);

    float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
    if (distance < 500.f) {
        DrawText(string_format("烟雾弹%.f",distance), Vector2(screenLocation.X-1,screenLocation.Y-9),Colour_红色,14);

    }
}
#pragma mark - 信号弹预警
static void GetThrowDataxhd(long Object) {
    Vector3 worldLocation = GetRelativeLocation(Object);
    Vector2 screenLocation;
    ProjectWorldLocationToScreen(worldLocation, true, &screenLocation);
    float distance = Vector3::Distance(worldLocation, POV.Location) / 100;
    if (distance < 500.f) {
        //  DrawCircleFilled(screenLocation,15,Colour_透明红色);
        DrawText(string_format("信号弹%.f",distance), Vector2(screenLocation.X-1,screenLocation.Y-9),Colour_红色,13);
    }
}

#pragma mark - 重置数据
static void RenderESP() {
    
    // 初始化重置数据
    totalEnemies = 0;
    tDistance = 0;
    needAdjustAim = false;
    isHookAngle = false;
    markDistance = CanvasSize.X;
    markScreenPos = Vector2(CanvasSize.X/2, CanvasSize.Y/2);
    
    markDis = CanvasSize.X;
    tDis = 0;
    
    long GWorld = Read<long>(GetRealOffset(kUWorld));
    if (!IsValidAddress(GWorld)) return;
    
    long PersistentLevel = Read<long>(GWorld + I64(kPersistentLevel));
    if (!IsValidAddress(PersistentLevel)) return;
    
    long ActorArray = Read<long>(PersistentLevel + I64(kActorList));
    if (!IsValidAddress(ActorArray)) return;
    
    int ActorCount = Read<int>(PersistentLevel + I64(kActorList) + 0x8);
    if (ActorCount > 0 && ActorCount < 50000) {
        for (int i = 0; i < ActorCount; i++) {
            long actor = Read<long>(ActorArray + i * 8);
            if (IsValidAddress(actor)) {
                string FName = GetFName(actor);
                if (FName.empty()) continue;
#if 0
                Vector3 LocationWorldPos = GetRelativeLocation(actor);
                Vector2 LocationScreen;
                ProjectWorldLocationToScreen(LocationWorldPos, true, &LocationScreen);
                float distance = Vector3::Distance(LocationWorldPos, POV.Location) / 100;
                if (distance <= 5000) {
                    DrawText(FName, LocationScreen, Colour_草绿);
                    
                }
#endif
#pragma mark - 资源数据
                if (isContain(FName, "PlayerPawn") ||
                    isContain(FName, "PlayerCharacter") ||
                    isContain(FName, "PlayerControllertSl") ||
                    isContain(FName, "_PlayerPawn_TPlanAI_C") ||
                    isContain(FName, "CharacterModelTaget") ||
                    isContain(FName, "FakePlayer_AIPawn")) GetPYMaerData(actor);
                //死亡盒子
                if (isContain(FName, "PlayerDeadListWrapper") || isContain(FName, "TrainingBoxList")|| isContain(FName, "CharacterDeadInventoryBox")) GetData(actor,"盒子",Colour_绿黄);
                
                
                //空投
//                if (isContain(FName, "erDeadInventoryBox_")) GetSuppliesData(actor,AirDrop[Replace],Colour_绿黄);
                if (FName == "AirDropListWrapperActor" || FName == "BP_AsinaBox_C") GetAirDropData(actor,"空投",Colour_红色);
                
                
                //枪械
                if (枪械开关) {
                    if (isContain(FName , "BP_Rifle_M416_Wrapper_C")) GetSuppliesData(actor,"M416",0xFFFFF500);


                    if (isContain(FName , "BP_Rifle_M16A4_Wrapper_C")) GetSuppliesData(actor,"M16A4",Colour_青色);


                    if (isContain(FName , "BP_Rifle_M762_Wrapper_C")) GetSuppliesData(actor,"M762",0xFF963EFF);


                    if (isContain(FName , "BP_Rifle_AKM_Wrapper_C")) GetSuppliesData(actor,"AKM",0xFF963EFF);


                    if (isContain(FName , "BP_Rifle_SCAR_Wrapper_C")) GetSuppliesData(actor,"SCAR",0xFFFFF500);


                    if (isContain(FName , "BP_Rifle_QBZ_Wrapper_C")) GetSuppliesData(actor,"QBZ",Colour_青色);


                    if (isContain(FName , "BP_Rifle_Groza_Wrapper_C")) GetSuppliesData(actor,"Groza",Colour_青色);


                    if (isContain(FName , "BP_Rifle_AUG_Wrapper_C")) GetSuppliesData(actor,"AUG",Colour_青色);


                    if (isContain(FName , "BP_Sniper_Mini14_Wrapper_C")) GetSuppliesData(actor,"Mini14",Colour_青色);


                    if (isContain(FName , "BP_Sniper_M24_Wrapper_C")) GetSuppliesData(actor,"M24",Colour_青色);


                    if (isContain(FName , "BP_Sniper_Kar98k_Wrapper_C")) GetSuppliesData(actor,"Kar98k",Colour_青色);


                    if (isContain(FName , "BP_Other_DP28_Wrapper_C")) GetSuppliesData(actor,"DP28",Colour_青色);


                    if (isContain(FName , "BP_Other_MG3_Wrapper_C")) GetSuppliesData(actor,"MG3",Colour_青色);
                }
                
                
                
                if (isContain(FName , "_Pistol_Flaregun_Wrapper_C")) GetSuppliesData(actor,"信号枪",Colour_红色);
                if (isContain (FName , "_Grenade_EmergencyCall_Weapon_Wrapper_C")) GetSuppliesData(actor,"SOS",Colour_红色);
                if (isContain(FName , "_Rifle_HoneyBadger_Wrapper_C")) GetSuppliesData(actor,"蜜獾",Colour_青色);
                if (isContain(FName , "_Other_HuntingBowEA_Wrapper_C")) GetSuppliesData(actor,"猎弓",Colour_青色);
                
                //药品
                if (药品开关) {

                    if (isContain(FName , "FirstAidbox")) GetSuppliesData(actor,"医疗箱",Colour_黄色);
                    if (isContain(FName , "Firstaid")) GetSuppliesData(actor,"急救包",Colour_黄色);

                    if (isContain(FName , "Pills")) GetSuppliesData(actor,"药片",Colour_黄色);

                    if (isContain(FName , "Drink")) GetSuppliesData(actor,"饮料",Colour_黄色);

                    if (isContain(FName , "Injection")) GetSuppliesData(actor,"注射器",Colour_黄色);
                }
                
                //燃烧瓶
                if (isContain(FName , "ProjBurn_")) GetThrowDatarsp(actor);
                //烟雾弹
                if (isContain(FName , "ProjSmoke_")) GetThrowDataywd(actor);
                //信号弹
                if (isContain(FName , "_PlayerFlareGunBullet_C")) GetThrowDataxhd(actor);
                //手雷
                if (isContain(FName , "ProjGrenade_")) GetThrowData(actor);
                
                //投掷物
                if (配件开关) {

                    if (isContain(FName , "Grenade_Burn_Wrapper_C")) GetSuppliesData(actor,"燃烧瓶",Colour_浅蓝);

                    if (isContain(FName , "Grenade_Shoulei_Wrapper_C")) GetSuppliesData(actor,"手雷",Colour_浅蓝);

                    if (isContain(FName , "Grenade_Smoke_Wrapper_C")) GetSuppliesData(actor,"烟雾弹",Colour_浅蓝);

                    //弹药

                    if (isContain(FName , "_Ammo_556mm")) GetSuppliesData(actor,"556mm",0xFFFFF500);


                    if (isContain(FName , "_Ammo_762mm")) GetSuppliesData(actor,"762mm",0xFF963EFF);



                    //三级套


                    if (isContain(FName , "Helmet_Lv3")) GetSuppliesData(actor,"三级头",Colour_桃红);


                    if (isContain(FName , "Armor_Lv3")) GetSuppliesData(actor,"三级甲",Colour_桃红);


                    if (isContain(FName , "Bag_Lv3")) GetSuppliesData(actor,"三级包",Colour_桃红);


                    //倍镜


                    if (isContain(FName , "MZJ_3X")) GetSuppliesData(actor,"3x",Colour_浅蓝);


                    if (isContain(FName , "_MZJ_4X")) GetSuppliesData(actor,"4x",Colour_浅蓝);


                    if (isContain(FName , "_MZJ_6X")) GetSuppliesData(actor,"6x",Colour_浅蓝);


                    if (isContain(FName , "_MZJ_8X")) GetSuppliesData(actor,"8x",Colour_浅蓝);
                }
                
                if (载具开关) {
                    //车辆
                    if (isContain(FName, "_UTV_C")) GetVehicleData(actor, "大蹦蹦", Colour_紫色);//大蹦蹦

                    else if (isContain(FName, "_VH_Bigfoot_C")) GetVehicleData(actor, "大脚车", Colour_紫色);//大脚车

                    else if (isContain(FName, "Buggy")) GetVehicleData(actor, "蹦蹦", Colour_紫色);//蹦蹦

                    else if (isContain(FName, "UAZ")) GetVehicleData(actor, "吉普", Colour_紫色);//吉普

                    else if (isContain(FName, "Dacia")) GetVehicleData(actor,"轿车", Colour_紫色);//轿车

                    else if (isContain(FName, "Scooter")) GetVehicleData(actor, "踏板车", Colour_紫色);//踏板车

                    else if (isContain(FName, "Rony")) GetVehicleData(actor, "皮卡", Colour_紫色);

                    else if (isContain(FName, "MiniBus")) GetVehicleData(actor, "小巴士", Colour_紫色);//小巴士

                    else if (isContain(FName, "Snowmobile")) GetVehicleData(actor, "雪橇", Colour_紫色);//雪橇

                    else if (isContain(FName, "PG117")) GetVehicleData(actor, "大船", Colour_紫色);//大船

                    else if (isContain(FName, "_Motorcycle_")) GetVehicleData(actor, "摩托", Colour_紫色);//摩托
                    else if (isContain(FName, "_Snowbike_C")) GetVehicleData(actor, "摩托", Colour_紫色);//摩托

                    else if (isContain(FName, "_MotorcycleCart_")) GetVehicleData(actor, "三轮摩托", Colour_紫色);//三轮摩托
                    else if (isContain(FName, "_VH_Tuk_1")) GetVehicleData(actor, "三轮摩托", Colour_紫色);//三轮摩托

                    else if (isEqual(FName, "_ny_01_C")) GetVehicleData(actor, "皮卡", Colour_紫色);//皮卡
                    else if (isEqual(FName, "ckUp_07_C")) GetVehicleData(actor, "皮卡", Colour_紫色);//皮卡
                    else if (isContain(FName, "PickUp_0")) GetVehicleData(actor, "皮卡", Colour_紫色);//皮卡

                    else if (isContain(FName, "BRDM")) GetVehicleData(actor,"蟑螂车", Colour_紫色);//蟑螂车

                    else if (isContain(FName, "AquaRail")) GetVehicleData(actor, "摩托艇", Colour_紫色);//摩托艇

                    else if (isContain(FName, "VH_Tank_Beta_C")) GetVehicleData(actor,  "坦克", Colour_紫色);//坦克

                    else if (isContain(FName, "rado_open") || isContain(FName, "rado_close")) GetVehicleData(actor, "跑车", Colour_紫色);//跑车
                    else if (isContain(FName, "Mirado")) GetVehicleData(actor, "跑车", Colour_紫色);//跑车
                    else if (isEqual(FName, "_CoupeRB_Base_C")) GetVehicleData(actor, "跑车", Colour_紫色);//跑车
                    else if (isContain(FName, "_CoupeRB_InBornlsland_C")) GetVehicleData(actor, "跑车", Colour_紫色);//跑车
                    else if (isEqual(FName, "_CoupeRB_1_C")) GetVehicleData(actor,"跑车", Colour_紫色);//跑车

                    else if (isEqual(FName, "_Motorglider_C")) GetVehicleData(actor, "滑翔机", Colour_紫色);//滑翔机

                }
            }
        }
    }
    
#pragma mark - 敌人数量
    //DrawText2(string_format("DH"), Vector2(CanvasSize.X/2, CanvasSize.Y*0.08f-40), Colour_黄色);
    if (totalEnemies != 0) {
        DrawTitle(string_format("%d", totalEnemies), Vector2(CanvasSize.X/2, CanvasSize.Y*0.08f-50), Colour_黄色);
        // 绘画圈圆
        if(自瞄开关){
        switch (圆圈模式) {
            case 0:{
                
                DrawCircle(Vector2(CanvasSize.X/2, CanvasSize.Y/2), Aimbot_Circle_Radius,  Colour_绿色);
                if (fabs(CanvasSize.X/2 - markScreenPos.X) > 1 || fabs(CanvasSize.Y/2 - markScreenPos.Y) > 1) {
                    // 绘画攻击目标线
                    DrawLine(Vector2(CanvasSize.X/2, CanvasSize.Y/2), Vector2(markScreenPos.X, markScreenPos.Y), 1, Colour_绿色);
                    DrawCircleFilled(Vector2(markScreenPos.X, markScreenPos.Y), 3, Colour_黄色);
                }
                break;
            }
            case 1:{
                DrawCircle2(Vector2(CanvasSize.X/2, CanvasSize.Y/2), 圆圈固定,  Colour_红色);
                if (fabs(CanvasSize.X/2 - markScreenPos.X) > 1 || fabs(CanvasSize.Y/2 - markScreenPos.Y) > 1) {
                    // 绘画攻击目标线
                    DrawLine(Vector2(CanvasSize.X/2, CanvasSize.Y/2), Vector2(markScreenPos.X, markScreenPos.Y), 1, Colour_绿色);
                    DrawCircleFilled(Vector2(markScreenPos.X, markScreenPos.Y), 3, Colour_黄色);
                }
                break;
            }
        }
    }
        
    
    }
    
}

int setPageProtection(long target, int protection) {
    void *start = reinterpret_cast<void *>(target & -PAGE_SIZE);
    return mprotect(start, PAGE_SIZE, protection);
}

#pragma mark - PostRender入口
void (*浩克画布)(long ViewPort, long canvas);
void 画布(long ViewPort, long canvas) {
    
    GetModuleBaseAddress();
   
        if (TinyFont == 0) {
            TinyFont = Read<long>(Engine + I64("0x30"));//<Actor*,ActorSet> LifeCycleDependencyMap;
            SmallFont = Read<long>(Engine + I64("0x70"));//FName BoneName;
            
            Write<long>(SmallFont + I64(kLegacyFontSize), 12);
            Write<long>(TinyFont + I64(kLegacyFontSize), 40);
            
            
        MediumFont = Read<long>(Engine + I64("0x90"));//Level* PersistentLevel;
        LargeFont = Read<long>(Engine + I64("0xb0"));//LineBatchComponent* LineBatcher;
        SubtitleFont = Read<long>(Engine + I64("0xd0"));//PhysicsCollisionHandler* PhysicsCollisionHandler;
        
        Write<long>(MediumFont + I64(kLegacyFontSize), 12);
        Write<long>(LargeFont + I64(kLegacyFontSize), 12);
        Write<long>(SubtitleFont + I64(kLegacyFontSize), 12);
    }
    
    Canvas = canvas;
    
    if (IsValidAddress(Canvas)) {
        CanvasSize.X = Read<int>(Canvas + I64(kSizeX));
        CanvasSize.Y = Read<int>(Canvas + I64(kSizeY));
        
        RenderESP();
    }
    
    return 浩克画布(ViewPort, canvas);
}

#pragma mark - 入口函数
uint64_t 字符串加密(const char addr[]) {
    uint64_t var = 0;
    sscanf(addr, "%llx",&var);
    return var;
}
//static void __attribute__((constructor)) initialize()
//{
//
////    NSString *CFBundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
//
////    if ([CFBundleIdentifier isEqualToString:@"ShadowTrackerExtra"]) {
//
//    //19ba20       18ADF8   1BC55C   1BC194
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//
//            uint32_t data = CFSwapInt32(0xC0035FD6);
//            //1.26
//            数据加密(字符串加密("0x18ADF8"), data);
//            数据加密(字符串加密("0x1BC55C"), data);
//            数据加密(字符串加密("0x1BC194"), data);
//
////            [[[UIAlertView alloc]initWithTitle:@"提示" message: @"防封开启成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil]show];
//
//            auto 画布地址 = GetRealOffset(kHOOKPostRender);
//            if (setPageProtection(画布地址, PROT_READ | PROT_WRITE) != -1) {
//                浩克画布 = reinterpret_cast<void (*)(long ViewPort, long canvas)>(*reinterpret_cast<long *>(画布地址));
//                *reinterpret_cast<long *>(画布地址) = reinterpret_cast<long>(画布);
//                setPageProtection(画布地址, PROT_READ);
//            }
//
//
//        });
////    }
//}



#pragma mark - 启动

static NSTimer *时间定时器;

static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        
        auto 画布地址 = GetRealOffset(kHOOKPostRender);
            浩克画布 = reinterpret_cast<void (*)(long ViewPort, long canvas)>(*reinterpret_cast<long *>(画布地址));
            *reinterpret_cast<long *>(画布地址) = reinterpret_cast<long>(画布);
            setPageProtection(画布地址, PROT_READ);

    });
}

//库入口函数
__attribute__((constructor)) static void initialize() {

    //加载视图
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDrop);
    
}


