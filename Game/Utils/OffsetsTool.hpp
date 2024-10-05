//
//  Offsets.hpp
//  UE4
//
//  Created by DH on 2022/5/9.
//
//死全家的GG爆 狗逼一个 操他妈的血逼
#ifndef Offsets_hpp
#define Offsets_hpp

#include <stdio.h>
#include <string>
//死全家的GG爆 狗逼一个 操他妈的血逼
using namespace std;

namespace Offsets {
#define kUWorld "0x105C3091C"
#define kGNames "0x104381848"
#define kEngine "0x109451A30"

#define kHOOKPostRender "0x107680710"
#define kDrawLine "0x10552B448"
#define kDrawText "0x1058D4484"
#define kDrawCircleFilled "0x1058D48E8"
#define kProject "0x106C9FBA8"

#define kLineOfSight_1 "0x109153078"    //IDLineOfSight
#define kLineOfSight_2 "0x10943B1F8"   // Hit
#define kLineOfSight_3 "0x1053813E8"  //LineOfSightToFunc1
#define kLineOfSight_4 "0x105384E70" //LineOfSightToFun2
#define kLineOfSight_5 "0x1053946B8"//LineOfSightToFunc3

#define kPersistentLevel "0x90"
#define kActorList "0xA0"
#define kGameState "0x868"
#define kNetDriver "0x98"
#define kServerConnection "0x88"
#define klocalPlayerController "0x30"

#define kmySelf "0x558"
#define kweaponManagerComponent  "0x2a10"
#define kcachedCurUseWeapon  "0x308"
#define kshootWeaponComponent  "0x1178"
#define kownerShootWeapon  "0x2d8"
#define kshootWeaponEntityComp  "0x13c0"

#define wuhou  "0x1738"
#define judian1  "0x179c"
#define judian2  "0x17a0"
#define judian3  "0x17a4"
#define judian4  "0x17a8"
#define fangdou1  "0x1868"
#define fangdou2  "0x1884"
#define shunji  "0x1304"

#define kPlayerController "0xa8"
#define kPlayerCameraManager "0x5d0"
#define kCameraCacheEntry "0x5b0"

#define kPawn "0x548"
#define kControlRotation "0x570"
#define kBulletTrack "0x27e0"


#define kMyTeam "0x9b8"

#define kLegacyFontSize "0x134"
#define kGameDeviationFactor "0x17a4"
#define kCanvas "0x588"
#define kSizeX "0x40"
#define kSizeY "0x44"

#define kCameraCache "0x5b0"
#define kViewTarget "0x1130"

#define kReplicatedWorldTimeSeconds "0x56c"

#define kRootComponent "0x268"
#define kLocation "0x1b0"

#define kMoveVelocity "0xec4"
#define kComponentVelocity "0x200"
#define kRelativeScale3D "0x194"
#define kRepMovement "0x170"
#define kRelativeRotation "0x188"

#define kHealth "0xD98"
#define kHealthMax "0xD9C"
#define kbDead "0xDB4"
#define kbIsGunADS "0x1029"

#define kPlayerName "0x8D8"
#define kTeamID "0x920"
#define kbIsAI "0x9D1"
#define kMesh "0x488"
#define kStaticMesh "0x1B0"

#define kbIsWeaponFiring "0x1e30"
#define kCurrentWeaponReplicated "0x5d8"
#define kWeaponManagerComponent "0x2a10"
#define kShootWeaponEntityComp "0x13c0"
#define kShootWeaponComponent "0x1178"
#define kWeaponId "0x110"

#define kBulletFireSpeed "0x1304"
#define kRecoilKickADS "0x1868"
#define kShootMode "0x11a4"

#define kVehicleCommon "0xa58"
#define kHP "0x1b8"
#define kHPMax "0x1b4"
#define kFuel "0x1dc"
#define kFuelMax "0x1d8"


#define kLineOfSightTo "0x768"
#define kYaw "0x830"
#define kRoll "0x828"
#define kPitch "0x838"

#define kCurBullet "0x1198"
#define kCurMaxBullet "0x119c"

#define kCurrentVehicle "0xfe0"
#define kPoseState "0x1e40"

#define kExplosionTime "0x7ac"

#define kPickUpDataList "0x9c0"

#define kScopeFov "0x1029"
#define kHeight1 "0x17c"

}

#endif /* Offsets_hpp */
～～～～～～～～～～～～～～～～～～～
//
//  PUBGOffsets.h
//  libShadowTrackerExtraDylib
//
//  Created by y on 2022/4/12.
//

#ifndef PUBGOffsets_hpp
#define PUBGOffsets_hpp

#include <stdio.h>
#include <string.h>



#define kPersistentLevel "0x30"      // Class: World. -> Level* PersistentLevel;
#define kNetDriver "0x38"            // Class: World. -> NetDriver* NetDriver;
#define kServerConnection "0x78"     // Class: NetDriver. -> NetConnection* ServerConnection;
#define kPlayerController "0x98"     // Class: NetConnection. -> Actor* OwningActor;
#define klocalPlayerController "0x30"

#define kPawn "0x438"//0x430                // Class: Controller. -> Pawn* Pawn;
#define kCharacter "0x448"//0x440           // Class: Controller. -> Character* Character;
#define kControlRotation "0x460"//0x458     // Class: Controller. -> Rotator ControlRotation;

#define kMyTeam "0x898"//0x890              // Class: UAEPlayerController. -> int TeamID;

#define kCameraCache "0x4a0"//0x470         // Class: PlayerCameraManager. -> CameraCacheEntry CameraCache;
#define kViewTarget "0x1020"//0xff0          // Class: PlayerCameraManager. -> TViewTarget ViewTarget;

#define kPlayerCameraManager "0x4c8"//0x4c0 // Class: PlayerController. -> PlayerCameraManager* PlayerCameraManager;
#define kMyHUD "0x4c0"//0x4b8               // Class: PlayerController. -> HUD* MyHUD;

#define kLegacyFontSize "0x134"         // Class: Font. -> int LegacyFontSize;设置字体的大小
#define kCanvas "0x478"//0x470               // Class: HUD. -> Canvas* Canvas;
#define kSizeX "0x40"                // Class: Canvas. -> int SizeX;
#define kSizeY "0x44"               // Class: Canvas. -> int SizeY;

#define kHealth "0xda0"//0xd98    // Class: STExtraCharacter. -> float Health;血量
#define kHealthMax "0xda4"//0xd9c // Class: STExtraCharacter. -> float HealthMax;最大血量
#define kbDead "0xdbc"//0xdb4     // Class: STExtraCharacter. -> bool bDead;判断死亡
#define kbIsGunADS "0x1031"//0x1029 // Class: STExtraCharacter. -> bool bIsGunADS;开镜自瞄
#define kCurrentVehicle "0xde8"//0xde0   // Class: STExtraCharacter. -> STExtraVehicleBase* CurrentVehicle;交通工具控制
#define kPoseState "0x1610"//未调用//0x15d8  //Class: STExtraBaseCharacter.STExtraCharacter.UAECharacter.Character.Pawn.Actor.Object  -> enum class ESTEPoseState PoseState;姿态
#define kNearDeatchComponent "0x1910"//未调用//0x18c0// Class: STExtraCharacter. -> STCharacterNearDeathComp* NearDeatchComponent;倒地状态 X
#define kBreathMax "0x16c"//未调用 // Class: STCharacterNearDeathComp. -> float BreathMax;倒地血量 X

#define kbHidden "0x88"//未调用    // Class: Actor. -> bool bHidden;对象是否隐藏 X
#define kPlayerName "0x8e0"//0x8d8// Class: UAECharacter. -> FString PlayerName;名字
#define kNation "0x8e8"//未调用//0x8b8// Class: UAECharacter. -> struct FString Nation;;国家
#define kTeamID "0x928"//0x920    // Class: UAECharacter. -> int TeamID;队伍
#define kbIsAI "0x9d9"//0x9d1     // Class: UAECharacter. -> bool bIsAI;人机
#define kbIsMLAI "0x9d2"//未调用//0x9a2     // Class: UAECharacter. -> bool bIsMLAI;智能人机
#define kMLAIPlayer "0x910"//未调用//0x8e0// Class: UAECharacter. -> struct FString MLAIPlayerUID;智能人机
#define kMesh "0x490"//0x488      // Class: Character. -> SkeletalMeshComponent* Mesh;
#define kStaticMesh "0x860"//未调用//0x820// Class: StaticMeshComponent. -> StaticMesh* StaticMesh; X
#define kLastRenderTime "0x410"//未调用//0x400// float LastRenderTime;
#define kVelocity "0x12c"//未调用 // Class: MovementComponent. -> Vector Velocity;3D速度向量 X

#define kRootComponent "0x1b0"                // Class: Actor. -> SceneComponent* RootComponent;场景组件
#define kRelativeLocation "0x184"           // Class: RootComponent. -> Vector RelativeLocation;三维向量 X
#define kRelativeScale3D "0x19c"//未调用           // Class: SceneComponent. -> Vector RelativeScale3D;三维向量 X
#define kComponentVelocity "0x260"        // Class: SceneComponent. -> Vector ComponentVelocity; 三维移动速度
#define kRepMovement "0xb0"    // RepMovement ReplicatedMovement; 载具向量
#define kNearDeathBreath "0x1930"//未调用//0x18e0        // Class: STExtraBaseCharacter. -> float NearDeathBreath;倒地血量
#define kbIsWeaponFiring "0x1608"//0x1600        // Class: STExtraBaseCharacter. -> bool bIsWeaponFiring;开火自瞄
//#define kbIsGunADS "0x1029"
#define kWeaponManagerComponent "0x22b8"//0x2298 // Class: STExtraBaseCharacter. -> CharacterWeaponManagerComponent* WeaponManagerComponent;武器管理组件
#define kCurrentWeaponReplicated "0x500" // Class: WeaponManagerComponent. -> STExtraWeapon* CurrentWeaponReplicated;武器复制状态
#define kShootWeaponComponent "0xe78"//0xec8    // Class: STExtraShootWeapon. -> STExtraShootWeaponComponent* ShootWeaponComponent;武器射击组件 X
#define kShootWeaponEntityComp "0xff8"//0x1048   // Class: STExtraShootWeapon. -> ShootWeaponEntity* ShootWeaponEntityComp;武器实体组件
#define kShootWeaponEntityComponent "0x298"//未调用 // Class: STExtraShootWeaponComponent. -> ShootWeaponEntity* ShootWeaponEntityComponent;武器射击组件  X
#define kWeaponId "0x178"                  // Class: WeaponEntity. -> int WeaponId; //武器ID
#define kBulletFireSpeed "0x4f8"           // Class: ShootWeaponEntity. -> float BulletFireSpeed;子弹速度
#define kRecoilKickADS "0xc48"//0xc58             // Class: ShootWeaponEntity. -> float RecoilKickADS;开镜后坐力

#define kGameDeviationFactor "0xb90"//未调用//0xba0       // Class: ShootWeaponEntity. -> float GameDeviationFactor;子弹据点


#define kShootMode "0xed0"//0xf20           //武器射击模式enum class EShootWeaponShootMode ShootMode; 或者byte ShootMode; //武器射击模式

#define kCurBulletNumInClip "0xef0"//0xea0//未调用  // int CurBulletNumInClip; 弹夹子弹
#define kCurMaxBullet "0xf10"//0xec0//未调用  // int CurMaxBulletNumInOneClip; 最大子弹

#define kVehicleCommon "0xa18"//0xa08  // Class: STExtraVehicleBase. -> VehicleCommonComponent* VehicleCommon; 车辆组件
#define kHP "0x2c4"//0x2a4             // Class: VehicleCommonComponent. -> float HP;车辆血
#define kHPMax "0x2c0"//0x2a0          // Class: VehicleCommonComponent. -> float HPMax;车辆最大血
#define kFuel "0x338"//0x318           // Class: VehicleCommonComponent. -> float Fuel;车辆油
#define kFuelMax "0x334"//0x314        // Class: VehicleCommonComponent. -> float FuelMax;车辆最大油


#define kPickUpDataList "0x960"//未调用//0x848  // PickUpDataList; 盒子列表
#define kGoodsID "0x38"  // 不变; 盒子ID
#define kTableName "0x8c0"//未调用//0x870  // struct FString ItemTableName;;盒子物资数量

#define kCurrentStates "0xf58"//未调用//0xf30  // uint64 CurrentStates;敌人状态
#define kFPS "0x1c4"  //未调用

#define kGameReplayType "0x944"
#define kScopeFov "0x19ac"
#define kPickUpAnim "0x1e28"


#define kPressingFireBtn "0x33d0"

#define kCurrentReloadWeapon "0x2b58"  ///
#define kCachedBulletTrackComponent "0xe28"  ///
#define wuhou    "0x190"  //


#define kYaw "0x860"
#define kRoll "0x868"
#define kPitch "0x858"
#endif /* PUBGOffsets_h */
