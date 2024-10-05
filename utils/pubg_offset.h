//
// Created by XBK on 2022/1/16.
//
namespace PubgOffset {
    //NetDriver* NetDriver
    //NetConnection* ServerConnection
    //STExtraPlayerController* PlayerController
    int PlayerControllerOffset[3] = {0x38, 0x78, 0x30};
    namespace PlayerControllerParam {
        //STExtraBaseCharacter* STExtraBaseCharacter;
        int SelfOffset = 0x25d0;
        //Rotator ControlRotation
        int MouseOffset = 0x460;
        //PlayerCameraManager* PlayerCameraManager
        int CameraManagerOffset = 0x4c8;
    int BlT = 0x498;
     
    namespace CameraManagerParam{
            //TViewTarget ViewTarget
            int PovOffset = 0x1020 + 0x10;
        }
        namespace ControllerFunction {
            int LineOfSightToOffset = 0x780;
// goc 718
        }
    }
    //Level* PersistentLevel
    int ULevelOffset = 0x30;
    namespace ULevelParam {
        //LineBatchComponenet* PersistentLineBatcher
        int ObjectArrayOffset = 0xA0;
        //成员数量
        int ObjectCountOffset = 0xA8;
    }
 
    namespace ObjectParam {
        int ClassIdOffset = 0x18;
        int ClassNameOffset = 0xC;
 
        namespace PlayerFunction {
            int AddControllerYawInputOffset = 0x860;
            int AddControllerRollInputOffset = 0x858;
            int AddControllerPitchInputOffset = 0x868;
        }
        //uint64 CurrentStates;
        int StatusOffset = 0xf60;
        //int TeamID
        int TeamOffset = 0x928;
        //FString PlayerName
        int NameOffset = 0x8e0;
        //bool bIsAI
        int RobotOffset = 0x9d9;
        //float Health
        int HpOffset = 0xda0;
        int MoveCoordOffset = 0xB0;
         
     
    int isDead = 0xdbc;  //  char bdead
    int HpmaxOffset = 0xda4; //float Healthmax;
        int MeshOffset = 0x490;  //SkeletalMeshComponent* Mesh;
        namespace MeshParam{
            //Character* CharacterOwner;
            int HumanOffset = 0x1b0;
            //StaticMesh* StaticMesh;
            int BonesOffset = 0x860;
        }
        //bool bIsWeaponFiring
        int OpenFireOffset = 0x1608;
        //bool bIsGunADS
        int OpenTheSightOffset = 0x1031;
        int WeaponOneOffset = 0x2740 + 0x20; //struct FAnimStatusKeyList LastUpdateStatusKeyList;
        namespace WeaponParam{
            int MasterOffset = 0xB0;
 
 
//enum class EShootWeaponShootMode ShootMode;
            int ShootModeOffset = 0xEd0;
//struct UShootWeaponEntity* ShootWeaponEntityComp;
            int WeaponAttrOffset = 0xFF8;
            namespace WeaponAttrParam{
// float BulletFireSpeed;
                int BulletSpeedOffset = 0x4F8;
//    float RecoilKickADS
                int RecoilOffset = 0xC48;
            }
        }
        //struct TArray<struct FPickUpItemData> PickUpDataList;
        int GoodsListOffset = 0x8a0;
        namespace GoodsListParam {
            int DataBase = 0x38;
        }
        //SceneComponent* RootComponent;
        int CoordOffset = 0x1b0;
        namespace CoordParam {
            int HeightOffset = 0x17C;
 
 
//struct AStairsActor* TargetStairsActor; // Offset: 0x210 // Size: 0x08
            int CoordOffset = 0x184;
        }
    }
}
