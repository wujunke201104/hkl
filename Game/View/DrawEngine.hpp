//
//  ImGuiDrawView.h
//  IOSPUBG
//
//  Created by DH on 2022/5/2.
//
#ifndef DrawEngine_hpp
#define DrawEngine_hpp

#define IM_PI                   3.14159265358979323846f
#define RAD2DEG( x )  ( (float)(x) * (float)(180.f / IM_PI) )
#define DEG2RAD( x ) ( (float)(x) * (float)(IM_PI / 180.f) )

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#include "DrawEngine.hpp"
#include <stdio.h>
#include <string>
#include <vector>
//#include "UtfTool.hpp"
#include "MemoryTool.hpp"
#include "OffsetsTool.hpp"
#import "Nctabmenu.h"
#include <random>
#include <string>

#define __fastcall

#define Colour_红色 0xFF0000FF
#define Colour_绿色 0xFF00FF00
#define Colour_粉红 0xFFCBC0FF
#define Colour_蓝色 0xFFFF0000
#define Colour_浅蓝 0xFFFACE87
#define Colour_青色 0xFFFFFF00
#define Colour_碧绿 0xFFAAFF7F
#define Colour_草绿 0xFF00FC7C
#define Colour_橙黄 0xFF00A5FF
#define Colour_橙色 0xFF0066FF
#define Colour_桃红 0xFFB9DAFF
#define Colour_珊瑚红 0xFF507FFF
#define Colour_紫色 0xFFEE677A
#define Colour_石板灰 0xFF908070
#define Colour_白色 0xFFFFFFFF
#define Colour_黑色 0xFF000000
#define Colour_绿黄 0xFFADFF2F
#define Colour_黄色 0xFF00FFFF
#define Colour_透明红色 0x800000FF
#define Colour_透明橙黄 0x8000A5FF
#define Colour_透明绿黄 0x80ADFF2F
#define Colour_透明绿色 0x8000FF00
#define Colour_透明石板灰 0x80908070

using namespace std;

#pragma mark - 字符串工具

static bool isEqual(string s1, const char* check) {
    string s2(check);
    return (s1 == s2);
}

static bool isContain(string str, const char* check) {
    size_t found = str.find(check);
    return (found != string::npos);
}

template<typename ... Args>

static string string_format(const string& format, Args ... args){
    
    size_t size = 1 + snprintf(nullptr, 0, format.c_str(), args ...); // 计算格式化后的字符串长度
    char bytes[size]; // 用于存储格式化后的字符串
    snprintf(bytes, size, format.c_str(), args ...); // 格式化字符串并存储到 bytes 中
    return string(bytes); // 将 bytes 转换成 string 类型并返回
}

#pragma mark - 颜色工具
static int BoneColos(bool b1, bool b2, bool isAi) {
    if (isAi) return b1 || b2 ? Colour_绿色 : Colour_白色;
    else return b1 || b2 ? Colour_绿色 : Colour_红色;
}

static int PColos(bool isVisible, bool isAi) {
    if (isAi) return isVisible ? Colour_绿色 : Colour_白色;
    else return isVisible ? Colour_绿色 : Colour_红色;
}

static int PlayerColos(bool isVisible, bool isAi) {
    if (isAi) return isVisible ? Colour_绿色 : Colour_白色;
    else return isVisible ? Colour_绿色 : Colour_红色;
}

#pragma mark - 手持输出
static string GetWeaponIDName(int WeaponId) {
    switch (WeaponId) {
        case 101001: return "AKM"; break;
        case 101002: return "M16A4"; break;
        case 1010021: return "M16A4"; break;
        case 101003: return "SCAR"; break;
        case 101004: return "M416"; break;
        case 1010043: return "M416"; break;
        case 101005: return "Groza"; break;
        case 1010053: return "Groza"; break;
        case 1010054: return "Groza改进"; break;
        case 1010055: return "Groza精制"; break;
        case 1010056: return "Groza独眼蛇"; break;
        case 1010057: return "Groza钢铁阵线"; break;
        case 101006: return "AUG"; break;
        case 101007: return "QBZ"; break;
        case 101008: return "M762"; break;
        case 101009: return "Mk47"; break;
        case 101010: return "G36C"; break;
        case 101011: return "AC-VA"; break;
        case 101012: return "蜜獾"; break;
        case 101100: return "FAMAS"; break;
        case 101101: return "Abakan"; break;
        case 101102: return "ACE32"; break;
            
        case 102001: return "Uzi"; break;
        case 1020011: return "Uzi"; break;
        case 1020012: return "Uzi"; break;
        case 102002: return "Ump45"; break;
        case 1020021: return "Ump45"; break;
        case 102003: return "Vector"; break;
        case 102004: return "TommyGun"; break;
        case 1020041: return "TommyGun"; break;
        case 102005: return "Bison"; break;
        case 1020051: return "Bison"; break;
        case 102007: return "MP5K"; break;
        case 102105: return "P90"; break;
            
        case 103001: return "Kar98k"; break;
        case 103002: return "M24"; break;
        case 103003: return "AWM"; break;
        case 1030034: return "AWM改进"; break;
        case 1030035: return "AWM精制"; break;
        case 1030036: return "AWM独眼蛇"; break;
        case 1030037: return "AWM钢铁阵线"; break;
        case 103004: return "SKS"; break;
        case 103005: return "VSS"; break;
        case 103006: return "Mini14"; break;
        case 1030061: return "Mini14"; break;
        case 103007: return "MK14"; break;
        case 1030074: return "MK14改进"; break;
        case 1030075: return "MK14精制"; break;
        case 1030076: return "MK14独眼蛇"; break;
        case 1030077: return "MK14钢铁阵线"; break;
        case 1010091: return "MK47"; break;
        case 103008: return "Win94"; break;
        case 1030081: return "Win94"; break;
        case 103009: return "SLR"; break;
        case 103010: return "QBU"; break;
        case 103011: return "Mosinagan"; break;
        case 103012: return "AMR"; break;
        case 103100: return "Mk12"; break;
        
        case 104001: return "S686"; break;
        case 104002: return "S1897"; break;
        case 104003: return "S12K"; break;
        case 1040031: return "S12K"; break;
        case 1040034: return "S12K改进"; break;
        case 1040035: return "S12K精制"; break;
        case 1040036: return "S12K独眼蛇"; break;
        case 1040037: return "S12K钢铁阵线"; break;
        case 104004: return "DBS"; break;
        case 1040041: return "DBS"; break;
        case 1040044: return "DBS改进"; break;
        case 1040045: return "DBS精制"; break;
        case 1040046: return "DBS独眼蛇"; break;
        case 1040047: return "DBS钢铁阵线"; break;
        case 104100: return "SPAS-12"; break;
        
        
        case 105001: return "M249"; break;
        case 1050013: return "M249"; break;
            
        case 105002: return "DP28"; break;
        case 105003: return "MG3"; break;
        case 105010: return "MG3"; break;
        case 1050104: return "MG3改进"; break;
        case 1050105: return "MG3精制"; break;
        case 1050106: return "MG3独眼蛇"; break;
        case 1050107: return "MG3钢铁阵线"; break;
            
        case 106001: return "P92"; break;
        case 106002: return "P1911"; break;
        case 106003: return "R1895"; break;
        case 106004: return "P18C"; break;
        case 106005: return "R45"; break;
        case 106006: return "Shortshot"; break;
        case 106008: return "AutoPisto"; break;
        case 106010: return "DesertEagle"; break;
            
        case 108004: return "平底锅"; break;
        case 108005: return "军用匕首"; break;
        case 108003: return "镰刀"; break;
        case 108002: return "撬棍"; break;
        case 108001: return "大砍刀"; break;
            
        case 602004: return "手雷"; break;
        case 602002: return "烟雾弹"; break;
        case 602003: return "燃烧瓶"; break;
        case 602001: return "震爆弹"; break;
        case 602075: return "铝热弹"; break;
        case 107001: return "十字弩"; break;
        case 107006: return "战术弩"; break;
        case 107007: return "爆炸弩"; break;
            
        default: return ""; break;
    }
}

#pragma mark - 盒子输出
static string PickUpDataName(int goodsListId) {
    switch (goodsListId) {
        case 601006: return "[药品]医疗箱"; break;
        case 601004: return "[药品]绷带"; break;
        case 601005: return "[药品]急救包"; break;
        case 601001: return "[药品]能量饮料"; break;
        case 601002: return "[药品]肾上腺素"; break;
        case 601003: return "[药品]止痛药"; break;
       
        case 503003: return "[护甲]三级甲"; break;
        case 501003: return "[背包]三级包"; break;
        case 502003: return "[头盔]三级头"; break;
        case 501006: return "[背包]三级包"; break;
        case 501009: return "[背包]三级包"; break;
        case 501012: return "[背包]三级包"; break;
        case 501015: return "[背包]三级包"; break;
        case 501104: return "[背包]四级包"; break;
        case 501105: return "[背包]五级包"; break;
        case 501106: return "[背包]六级包"; break;
        case 502104: return "[头盔]四级头"; break;
        case 502105: return "[头盔]五级头"; break;
        case 502106: return "[头盔]六级头"; break;
        case 502107: return "[头盔]四级头(独眼蛇)"; break;
        case 502108: return "[头盔]五级头(独眼蛇)"; break;
        case 502109: return "[头盔]六级头(独眼蛇)"; break;
        case 502110: return "[头盔]四级头(钢铁阵线)"; break;
        case 502111: return "[头盔]五级头(钢铁阵线)"; break;
        case 502112: return "[头盔]六级头(钢铁阵线)"; break;
        case 503104: return "[护甲]四级甲"; break;
        case 503105: return "[护甲]五级甲"; break;
        case 503106: return "[护甲]六级甲"; break;
        case 503107: return "[护甲]四级甲(独眼蛇)"; break;
        case 503108: return "[护甲]五级甲(独眼蛇)"; break;
        case 503109: return "[护甲]六级甲(独眼蛇)"; break;
        case 503110: return "[护甲]四级甲(钢铁阵线)"; break;
        case 503111: return "[护甲]五级甲(钢铁阵线)"; break;
        case 503112: return "[护甲]六级甲(钢铁阵线)"; break;
        case 503113: return "[护甲]一级甲(强化型)"; break;
        case 503114: return "[护甲]二级甲(强化型)"; break;
        case 503115: return "[护甲]三级甲(强化型)"; break;
        
        case 103001: return "[狙击]Kar98k"; break;
        case 103002: return "[狙击]M24"; break;
        case 103003: return "[狙击]AWM"; break;
        case 1030034: return "[狙击]AWM改进"; break;
        case 1030035: return "[狙击]AWM精制"; break;
        case 1030036: return "[狙击]AWM独眼蛇"; break;
        case 1030037: return "[狙击]AWM钢铁阵线"; break;
        case 103004: return "[狙击]SKS"; break;
        case 103005: return "[狙击]VSS"; break;
        case 103006: return "[狙击]Mini14"; break;
        case 1030061: return "[狙击]Mini14"; break;
        case 103007: return "[狙击]MK14"; break;
        case 1030074: return "[狙击]MK14改进"; break;
        case 1030075: return "[狙击]MK14精制"; break;
        case 1030076: return "[狙击]MK14独眼蛇"; break;
        case 1030077: return "[狙击]MK14钢铁阵线"; break;
        case 1010091: return "[狙击]MK47"; break;
        case 103008: return "[狙击]Win94"; break;
        case 1030081: return "[狙击]Win94"; break;
        case 103009: return "[狙击]SLR"; break;
        case 103010: return "[狙击]QBU"; break;
        case 103011: return "[狙击]Mosinagan"; break;
        case 103012: return "[狙击]AMR"; break;
        case 103100: return "[狙击]Mk12"; break;
            
        case 101001: return "[步枪]AKM"; break;
        case 1010011: return "[步枪]AKM（破损）"; break;
        case 1010012: return "[步枪]AKM（修复）"; break;
        case 101002: return "[步枪]M16A4"; break;
        case 1010021: return "[步枪]M16A4"; break;
        case 101003: return "[步枪]SCAR"; break;
        case 101004: return "[步枪]M416"; break;
        case 1010043: return "[步枪]M416"; break;
        case 101005: return "[步枪]Groza"; break;
        case 1010053: return "[步枪]Groza"; break;
        case 1010054: return "[步枪]Groza改进"; break;
        case 1010055: return "[步枪]Groza精制"; break;
        case 1010056: return "[步枪]Groza独眼蛇"; break;
        case 1010057: return "[步枪]Groza钢铁阵线"; break;
        case 101006: return "[步枪]AUG"; break;
        case 101007: return "[步枪]QBZ"; break;
        case 101008: return "[步枪]M762"; break;
        case 101009: return "[步枪]Mk47"; break;
        case 101010: return "[步枪]G36C"; break;
        case 101011: return "[步枪]AC-VA"; break;
        case 101012: return "[步枪]蜜獾自动步枪"; break;
        case 101100: return "[步枪]FAMAS"; break;
        case 101101: return "[步枪]ASM Abakan"; break;
            
        case 105001: return "[机枪]M249"; break;
        case 1050013: return "[机枪]M249"; break;
        case 105002: return "[机枪]DP28"; break;
        case 105003: return "[机枪]MG3"; break;
        case 105010: return "[机枪]MG3"; break;
        case 1050104: return "[机枪]MG3改进"; break;
        case 1050105: return "[机枪]MG3精制"; break;
        case 1050106: return "[机枪]MG3独眼蛇"; break;
        case 1050107: return "[机枪]MG3钢铁阵线"; break;

        case 403045: return "吉利服"; break;
        case 403038: return "吉利服"; break;
        case 403025: return "吉利服"; break;

        case 106007: return "信号枪"; break;
            
        case 303001: return "[弹药]5.56mm"; break;
        case 302001: return "[弹药]7.62mm"; break;
        case 306001: return "[弹药]马格南"; break;
        case 308001: return "[弹药]信号弹"; break;
        case 306002: return "[弹药].50口径"; break;
            
        case 203001: return "[倍镜]红点"; break;
        case 203002: return "[倍镜]全息"; break;
        case 203003: return "[倍镜]二倍镜"; break;
        case 203014: return "[倍镜]三倍镜"; break;
        case 203004: return "[倍镜]四倍镜"; break;
        case 203015: return "[倍镜]六倍镜"; break;
        case 203005: return "[倍镜]八倍镜"; break;
        
        case 201007: return "[配件]消音器(狙击)"; break;
        case 204009: return "[配件]快速扩容(狙击)"; break;
        case 204007: return "[配件]扩容(狙击)"; break;
        case 201011: return "[配件]消音器(步枪)"; break;
        case 204013: return "[配件]快速扩容(步枪)"; break;
        case 204011: return "[配件]扩容(步枪)"; break;
        case 204012: return "[配件]快速弹匣(步枪)"; break;
            
        case 602004: return "[投掷物]手雷"; break;
        case 602002: return "[投掷物]烟雾弹"; break;
        case 602003: return "[投掷物]燃烧瓶"; break;
        case 602001: return "[投掷物]震爆弹"; break;
        case 602075: return "[投掷物]铝热弹"; break;
            
        case 108002: return "[近战]撬棍"; break;
        case 108004: return "[近战]平底锅"; break;
        case 108003: return "[近战]镰刀"; break;
        case 108001: return "[近战]大砍刀"; break;
        case 108024: return "[近战]伸缩钩索"; break;
            
            
        case 1000: return "金币"; break;
        case 3001028: return "现金盒"; break;
        case 3001029: return "零件包"; break;
        case 3001030: return "科技部件"; break;
        case 3001031: return "密码信函（白）"; break;
        case 3001032: return "狗牌"; break;
        case 3001033: return "信号发生器"; break;
        case 3001034: return "燃气瓶"; break;
        case 3001035: return "精密仪器蓝图"; break;
        case 3001036: return "指南针"; break;
        case 3001037: return "明信片"; break;
        case 3001038: return "探测器"; break;
        case 3001039: return "旧式录像带"; break;
        case 3001040: return "Mountain Dew"; break;
        case 3001041: return "The Album"; break;
        case 3001042: return "密码信函（红）"; break;
        case 3001043: return "密码信函（黄）"; break;
        case 3001044: return "密码信函（绿）"; break;
        case 3001045: return "密码信函（黑）"; break;
        case 3001046: return "扑克牌"; break;
        case 3001047: return "军用水壶"; break;
        case 3001048: return "罐头"; break;
        case 3001049: return "净水器"; break;
        case 3001050: return "润滑油"; break;
        case 3001051: return "汽车钥匙"; break;
        case 3001052: return "杂志"; break;
        case 3001053: return "平板电脑"; break;
        case 3001054: return "一根金条"; break;
        case 3001055: return "CPU处理器"; break;
        case 3001056: return "柴油"; break;
        case 3001057: return "机油"; break;
        case 3001058: return "狗牌-独眼蛇"; break;
        case 3001059: return "狗牌-钢铁阵线"; break;
        case 3001060: return "军功"; break;
        case 3001061: return "功勋奖章（铜）"; break;
        case 3001062: return "功勋奖章（银）"; break;
        case 3001063: return "功勋奖章（金）"; break;
        case 3001064: return "生物样本"; break;
        case 3001065: return "GPU处理器"; break;
        case 3001066: return "镜头"; break;
        case 3001067: return "一块金砖"; break;
        case 3001068: return "鼓鼓的现金盒"; break;
        case 3001101: return "便携手札"; break;
        case 3001102: return "小钱箱"; break;
        case 3001103: return "怀表"; break;
        case 3001104: return "便携展示柜"; break;
        case 3001105: return "粉色左轮"; break;
        case 3001106: return "防震耳机"; break;
        case 3001107: return "怡神精油"; break;
        case 3001108: return "旅行手册"; break;
        case 3001109: return "军用手表"; break;
        case 3001110: return "玩具匕首"; break;
        case 3001111: return "爱心项链"; break;
        case 3001112: return "崭新军靴"; break;
        case 3001113: return "笔记本"; break;
        case 3001114: return "破损的地图"; break;
        case 3001115: return "破损的设计图纸"; break;
        case 3006001: return "纳米晶体"; break;
        case 3006002: return "动力装甲蓝图"; break;
        case 3006007: return "身份卡"; break;
        
        case 3020014: return "7.62毫米子弹（高爆）"; break;
        case 3020015: return "7.62毫米子弹（燃烧）"; break;
        case 3020016: return "7.62毫米子弹（毒性）"; break;
        
        case 3030014: return "5.56毫米子弹（高爆）"; break;
        case 3030015: return "5.56毫米子弹（燃烧）"; break;
        case 3030016: return "5.56毫米子弹（毒性）"; break;
            
        default: return "Error"; break;
    }
}

static int GetColorForGoods(int goodsList) {
    switch (goodsList) {
        case 601006: return Colour_黄色; break;  // 医疗箱
        case 601004: return Colour_黄色; break;   // 绷带
        case 601005: return Colour_黄色; break;  // 急救包
        case 601001: return Colour_黄色; break;   // 能量饮料
        case 601002: return Colour_黄色; break;   // 肾上腺素
        case 601003: return Colour_黄色; break;   // 止痛药
        
        case 503003: return Colour_红色; break;   // 三级甲
        case 501003: return Colour_红色; break;   // 三级包
        case 502003: return Colour_红色; break;   // 三级头
        case 501006: return Colour_红色; break;   // 三级包
        case 501009: return Colour_红色; break;   // 三级包
        case 501012: return Colour_红色; break;   // 三级包
        case 501015: return Colour_红色; break;   // 三级包
        case 501104: return Colour_红色; break;
        case 501105: return Colour_红色; break;
        case 501106: return Colour_红色; break;
        case 502104: return Colour_红色; break;
        case 502105: return Colour_红色; break;
        case 502106: return Colour_红色; break;
        case 502107: return Colour_红色; break;
        case 502108: return Colour_红色; break;
        case 502109: return Colour_红色; break;
        case 502110: return Colour_红色; break;
        case 502111: return Colour_红色; break;
        case 502112: return Colour_红色; break;
        case 503104: return Colour_红色; break;
        case 503105: return Colour_红色; break;
        case 503106: return Colour_红色; break;
        case 503107: return Colour_红色; break;
        case 503108: return Colour_红色; break;
        case 503109: return Colour_红色; break;
        case 503110: return Colour_红色; break;
        case 503111: return Colour_红色; break;
        case 503112: return Colour_红色; break;
        case 503113: return Colour_红色; break;
        case 503114: return Colour_红色; break;
        case 503115: return Colour_红色; break;
            
        case 103001: return Colour_红色; break;   // Kar98k
        case 103002: return Colour_红色; break;   // M24
        case 103003: return Colour_红色; break;   // AWM
        case 1030034: return Colour_红色; break;   // AWM改进
        case 1030035: return Colour_红色; break;   // AWM精制
        case 1030036: return Colour_红色; break;   // AWM独眼蛇
        case 1030037: return Colour_红色; break;   // AWM钢铁阵线
        case 103004: return Colour_橙色; break;   // SKS
        case 103005: return Colour_橙色; break;   // VSS
        case 103006: return Colour_橙色; break;   // Mini14
        case 1030061: return Colour_橙色; break;   // Mini14
        case 103007: return Colour_橙色; break;   // MK14
        case 1030074: return Colour_橙色; break;   // MK14改进
        case 1030075: return Colour_橙色; break;   // MK14精制
        case 1030076: return Colour_橙色; break;   // MK14独眼蛇
        case 1030077: return Colour_橙色; break;   // MK14钢铁阵线
        case 1010091: return Colour_橙色; break;   // MK47
        case 103008: return Colour_红色; break;   // Win94
        case 1030081: return Colour_红色; break;   // Win94
        case 103009: return Colour_橙色; break;   // SLR
        case 103010: return Colour_橙色; break;   // QBU
        case 103011: return Colour_红色; break;   // Mosinagan
        case 103012: return Colour_红色; break;   // AMR
        case 103100: return Colour_红色; break;   // Mk12狙击
        
        case 101001: return 0xFF963EFF; break;   // AKM
        case 1010011: return 0xFF963EFF; break;   // AKM（破损）
        case 1010012: return 0xFF963EFF; break;   // AKM（修复）
        case 101002: return Colour_青色; break;   // M16A4
        case 1010021: return Colour_青色; break;   // M16A4
        case 101003: return Colour_青色; break;   // SCAR
        case 101004: return Colour_青色; break;   // M416
        case 1010043: return Colour_青色; break;   // M416
        case 101005: return 0xFF963EFF; break;   // Groza
        case 1010053: return 0xFF963EFF; break;   // Groza
        case 1010054: return 0xFF963EFF; break;   // Groza改进
        case 1010055: return 0xFF963EFF; break;   // Groza精制
        case 1010056: return 0xFF963EFF; break;   // Groza独眼蛇
        case 1010057: return 0xFF963EFF; break;   // Groza钢铁阵线
        case 101006: return Colour_青色; break;   // AUG
        case 101007: return Colour_青色; break;   // QBZ
        case 101008: return 0xFF963EFF; break;   // M762
        case 101009: return Colour_青色; break;   // Mk47
        case 101010: return Colour_青色; break;   // G36C
        case 101011: return Colour_青色; break;   // AC-VA
        case 101012: return Colour_浅蓝; break;   // 蜜獾自动步枪
        case 101100: return Colour_青色; break;   // FAMAS
        case 101101: return Colour_青色; break;   // ASM Abakan
        case 105001: return Colour_青色; break;   // M249
        case 1050013: return Colour_青色; break;   // M249
        case 105002: return Colour_青色; break;   // DP28
        case 105003: return Colour_青色; break;   // MG3
        case 105010: return Colour_青色; break;   // MG3
        case 1050104: return Colour_青色; break;   // MG3改进
        case 1050105: return Colour_青色; break;   // MG3精制
        case 1050106: return Colour_青色; break;   // MG3独眼蛇
        case 1050107: return Colour_青色; break;   // MG3钢铁阵线
        
        case 403045: return Colour_红色; break;   // 吉利服
        case 403038: return Colour_红色; break;   // 吉利服
        case 403025: return Colour_红色; break;   // 吉利服
        case 106007: return Colour_浅蓝; break;   // 信号枪
        
        case 303001: return 0xFFFFF500; break;   // 5.56mm
        case 302001: return 0xFF963EFF; break;   // 7.62mm
        case 306001: return 0xFF963EFF; break;   // 马格南
        case 308001: return Colour_红色; break;   // 信号弹
        case 306002: return 0xFF963EFF; break;   // .50口径
        case 305001: return 0xFF963EFF; break;   // .45口径
        
        case 203001: return Colour_粉红; break; break;   // 红点
        case 203002: return Colour_粉红; break;   // 全息
        case 203003: return Colour_粉红; break;   // 二倍镜
        case 203014: return Colour_粉红; break;   // 三倍镜
        case 203004: return Colour_粉红; break;   // 四倍镜
        case 203015: return Colour_粉红; break;   // 六倍镜
        case 203005: return Colour_粉红; break;   // 八倍镜

        case 201007: return Colour_桃红; break;   // 消音器(狙击)
        case 204009: return Colour_桃红; break;   // 快速扩容(狙击)
            
        case 204007: return Colour_桃红; break; // 扩容(狙击)
        case 201011: return Colour_桃红; break; // 消音器(步枪)
        case 204013: return Colour_桃红; break; // 快速扩容(步枪)
        case 204011: return Colour_桃红; break; // 扩容(步枪)
        case 204012: return Colour_桃红; break; // 快速弹匣(步枪)
            
            // 手榴弹及弩
        case 602004: return Colour_珊瑚红; break; // 手雷
        case 602002: return Colour_珊瑚红; break; // 烟雾弹
        case 602003: return Colour_珊瑚红; break; // 燃烧瓶
        case 602001: return Colour_珊瑚红; break; // 震爆弹
        case 602075: return Colour_珊瑚红; break; // 铝热弹
            
            // 近战武器
        case 108002: return Colour_紫色; break; // 撬棍
        case 108004: return Colour_紫色; break; // 平底锅
        case 108003: return Colour_紫色; break; // 镰刀
        case 108001: return Colour_紫色; break; // 大砍刀
        case 108024: return Colour_紫色; break; // 伸缩钩索
            
            // 道具
        case 1000: return Colour_绿色; break; // 金币
        case 3001028: return Colour_绿色; break; // 现金盒
        case 3001029: return Colour_绿色; break; // 零件包
        case 3001030: return Colour_绿色; break; // 科技部件
        case 3001054: return Colour_红色; break;
        case 3001055: return Colour_红色; break;
        case 3001032: return Colour_红色; break;
        case 3001058: return Colour_红色; break;
        case 3001059: return Colour_红色; break;
        
        
        
        default: return Colour_浅蓝; break; // 默认为浅蓝
    }
}


struct Vector2 {
    float X;
    float Y;
    
    Vector2() {
        this->X = 0;
        this->Y = 0;
    }
    //float Size ();
    Vector2(float x, float y) {
        this->X = x;
        this->Y = y;
    }
    
    static Vector2 Zero() {
        return Vector2(0.0f, 0.0f);
    }
    
    static float Distance(Vector2 a, Vector2 b) {
        Vector2 vector = Vector2(a.X - b.X, a.Y - b.Y);
        return sqrt((vector.X * vector.X) + (vector.Y * vector.Y));
    }
    
    bool operator!=(const Vector2 &src) const {
        return (src.X != X) || (src.Y != Y);
    }
    Vector2 operator+(const Vector2 &v) const {
        return Vector2(X + v.X, Y + v.Y);
    }
    
    Vector2 operator-(const Vector2 &v) const {
        return Vector2(X - v.X, Y - v.Y);
    }
    
    Vector2 operator/ (const float A) {
        return Vector2(this->X/A, this->Y/A);
    }
    
    Vector2 &operator+=(const Vector2 &v) {
        X += v.X;
        Y += v.Y;
        return *this;
    }
    
    Vector2 &operator-=(const Vector2 &v) {
        X -= v.X;
        Y -= v.Y;
        return *this;
    }
    float Size ()
    {
        return sqrt( ( this->X * this->X ) + ( this->Y * this->Y )  );
    }
    
};

struct Vector3 {
    float X;
    float Y;
    float Z;

    Vector3() {
        this->X = 0;
        this->Y = 0;
        this->Z = 0;
    }

    Vector3(float x, float y, float z) {
        this->X = x;
        this->Y = y;
        this->Z = z;
    }
    float Size ();
    Vector3 operator+(const Vector3 &v) const {
        return Vector3(X + v.X, Y + v.Y, Z + v.Z);
    }

    Vector3 operator-(const Vector3 &v) const {
        return Vector3(X - v.X, Y - v.Y, Z - v.Z);
    }

    bool operator==(const Vector3 &v) {
        return X == v.X && Y == v.Y && Z == v.Z;
    }

    bool operator!=(const Vector3 &v) {
        return !(X == v.X && Y == v.Y && Z == v.Z);
    }
    Vector3 operator-= (const Vector3 &A) {
        this->X -= A.X;
        this->Y -= A.Y;
        this->Z -= A.Z;
        return *this;
    }
    
    Vector3 operator-= (const float A) {
        this->X -= A;
        this->Y -= A;
        this->Z -= A;
        return *this;
    }
    
    Vector3 operator/ (const float A) {
        return Vector3(this->X/A, this->Y/A, this->Z/A);
    }
    static Vector3 Zero() {
        return Vector3(0.0f, 0.0f, 0.0f);
    }
    
    static float Dot(Vector3 a, Vector3 b) {
        return a.X * b.X + a.Y * b.Y + a.Z * b.Z;
    }
    Vector3 operator*(float a) {
        return Vector3(X * a, Y * a, Z * a);
    }
    
    static float Distance(Vector3 a, Vector3 b) {
        Vector3 vector = Vector3(a.X - b.X, a.Y - b.Y, a.Z - b.Z);
        return sqrt(vector.X * vector.X + vector.Y * vector.Y + vector.Z * vector.Z);
    }
};

float Vector3::Size ()
{
    return sqrt( ( this->X * this->X ) + ( this->Y * this->Y ) + ( this->Z * this->Z ) );
}

struct Vector4 {
    float x;
    float y;
    float z;
    float w;
};

struct VectorRect {
    int x;
    int y;
    int w;
    int h;
};

struct FMatrix {
    float Matrix[4][4];

    float *operator[](int index) {
        return Matrix[index];
    }
};

struct FTransform {
    Vector4 Rotation;
    Vector3 Translation;
    Vector3 Scale3D;
};

struct Rotator {
    float Y;
    float X;
    float Roll;
};

struct Tracking {
    Rotator aim_angle;
    Vector3 loc;
};


struct FRotator {
    float Pitch;
    float Yaw;
    float Roll;
    inline FRotator()
        : Pitch(0.0f), Yaw(0.0f), Roll(0.0f)
    { }

    inline FRotator(float pitch, float yaw, float roll)
        : Pitch(pitch), Yaw(yaw), Roll(roll)
    { }
    
    inline FRotator operator+ (const FRotator &A) {
        return FRotator(this->Pitch + A.Pitch, this->Yaw + A.Yaw, this->Roll + A.Roll);
    }
    
    inline FRotator operator- (const FRotator &A) {
        return FRotator(this->Pitch - A.Pitch, this->Yaw - A.Yaw, this->Roll - A.Roll);
    }
    
    inline FRotator operator* (const FRotator &A) {
        return FRotator(this->Pitch * A.Pitch, this->Yaw * A.Yaw, this->Roll * A.Roll);
    }

    inline FRotator operator* (const float A) {
        return FRotator(this->Pitch * A, this->Yaw * A, this->Roll * A);
    }
    
    inline FRotator operator/ (const FRotator &A) {
        return FRotator(this->Pitch / A.Pitch, this->Yaw / A.Yaw, this->Roll / A.Roll);
    }

    inline FRotator operator/ (const float A) {
        return FRotator(this->Pitch / A, this->Yaw / A, this->Roll / A);
    }
    

};


struct MinimalViewInfo {
    Vector3 Location;
    Vector3 LocationLocalSpace;
    FRotator Rotation;
    char ViewTag[0xC];//0xC
    float FOV;
};
struct FLinearColor {
    float R;
    float G;
    float B;
    float A;

    inline FLinearColor(): R(0), G(0), B(0), A(0){ }
    inline FLinearColor(float r, float g, float b, float a): R(r), G(g), B(b), A(a){ }
    inline FLinearColor(int rgba) {
        float sc = 1.0f / 255.0f;
        R = (float)((rgba >> 0) & 0xFF) * sc;
        G = (float)((rgba >> 8) & 0xFF) * sc;
        B = (float)((rgba >> 16) & 0xFF) * sc;
        A = (float)((rgba >> 24) & 0xFF) * sc;
    }
};

struct FString {
    char* PText;
    int Count;
    int Max;
    
    int Utf8ToUnicode(const char *utf8, unsigned short* unicode) {
        long len8 = strlen(utf8);
        int len16 = 0;
        unsigned short t, r;
        if(unicode != NULL) {
            for (int i = 0; i < len8;) {
                t = utf8[i] & 0xff;
                if(t < 0x80) {
                    r = t;
                    i++;
                }else if(t < 0xe0) {
                    r = t & 0x1f;
                    r <<= 6;
                    t = utf8[i + 1];
                    r += t & 0x3f;
                    i += 2;
                }else if(t < 0xf0){
                    r = t & 0x0f;
                    r <<= 6;
                    t = utf8[i + 1];
                    r += t & 0x3f;
                    r <<= 6;
                    t = utf8[i + 2];
                    r += t & 0x3f;
                    i += 3;
                }else {//出错，不处理
                    r = 0;
                    i++;
                }
                unicode[len16++] = r;
            }
            unicode[len16] = 0;
        }else {
            for (int i = 0; i < len8;) {
                t = utf8[i] & 0xff;
                if(t < 0x80) {
                    i++;
                }else if(t < 0xe0) {
                    i += 2;
                }else if(t < 0xf0){
                    i += 3;
                }else {
                    i++;
                }
                len16++;
            }
        }
        return len16;
    }
    
    static void UnicodeToUTF_8(char* pOut, wchar_t* pText, int Len) {
        char* pchar = (char *)pText;
        int coun = 0;
        for (int i = 0; i < Len; i++) {
            if (pchar[i*2+1] == 0) {
                pOut[coun] = pchar[i*2];
                coun++;
            } else {
                pOut[coun] = (0xE0 | ((pchar[i*2+1] & 0xF0) >> 4));
                pOut[coun+1] = (0x80 | ((pchar[i*2+1] & 0x0F) << 2)) + ((pchar[i*2] & 0xC0) >> 6);
                pOut[coun+2] = (0x80 | (pchar[i*2] & 0x3F));
                coun+=3;
            }
        }
    }
    
    inline FString(const char* strl) {
        char FText[256];
        Count = Max = Utf8ToUnicode(strl, (unsigned short *)FText) + 1;
        PText = FText;
    }
};
struct D3DXMATRIX {
    float _11, _12, _13, _14;
    float _21, _22, _23, _24;
    float _31, _32, _33, _34;
    float _41, _42, _43, _44;
};

struct ObjectName {
    const char data[64];
};

static D3DXMATRIX ToMatrixWithScale(Vector4 rotation, Vector3 translation, Vector3 scale3D) {
    D3DXMATRIX ret;
    float x2, y2, z2, xx2, yy2, zz2, yz2, wx2, xy2, wz2, xz2, wy2 = 0.f;
    ret._41 = translation.X;
    ret._42 = translation.Y;
    ret._43 = translation.Z;
    
    x2 = rotation.x * 2;
    y2 = rotation.y * 2;
    z2 = rotation.z * 2;
    
    xx2 = rotation.x * x2;
    yy2 = rotation.y * y2;
    zz2 = rotation.z * z2;
    
    ret._11 = (1 - (yy2 + zz2)) * scale3D.X;
    ret._22 = (1 - (xx2 + zz2)) * scale3D.Y;
    ret._33 = (1 - (xx2 + yy2)) * scale3D.Z;
    
    yz2 = rotation.y * z2;
    wx2 = rotation.w * x2;
    ret._32 = (yz2 - wx2) * scale3D.Z;
    ret._23 = (yz2 + wx2) * scale3D.Y;
    
    xy2 = rotation.x * y2;
    wz2 = rotation.w * z2;
    ret._21 = (xy2 - wz2) * scale3D.Y;
    ret._12 = (xy2 + wz2) * scale3D.X;
    
    xz2 = rotation.x * z2;
    wy2 = rotation.w * y2;
    ret._31 = (xz2 + wy2) * scale3D.Z;
    ret._13 = (xz2 - wy2) * scale3D.X;
    
    ret._14 = 0.f;
    ret._24 = 0.f;
    ret._34 = 0.f;
    ret._44 = 1.f;
    
    return ret;
}

static D3DXMATRIX MatrixMultiplication(D3DXMATRIX M1, D3DXMATRIX M2) {
    D3DXMATRIX ret;
    ret._11 = M1._11 * M2._11 + M1._12 * M2._21 + M1._13 * M2._31 + M1._14 * M2._41;
    ret._12 = M1._11 * M2._12 + M1._12 * M2._22 + M1._13 * M2._32 + M1._14 * M2._42;
    ret._13 = M1._11 * M2._13 + M1._12 * M2._23 + M1._13 * M2._33 + M1._14 * M2._43;
    ret._14 = M1._11 * M2._14 + M1._12 * M2._24 + M1._13 * M2._34 + M1._14 * M2._44;
    ret._21 = M1._21 * M2._11 + M1._22 * M2._21 + M1._23 * M2._31 + M1._24 * M2._41;
    ret._22 = M1._21 * M2._12 + M1._22 * M2._22 + M1._23 * M2._32 + M1._24 * M2._42;
    ret._23 = M1._21 * M2._13 + M1._22 * M2._23 + M1._23 * M2._33 + M1._24 * M2._43;
    ret._24 = M1._21 * M2._14 + M1._22 * M2._24 + M1._23 * M2._34 + M1._24 * M2._44;
    ret._31 = M1._31 * M2._11 + M1._32 * M2._21 + M1._33 * M2._31 + M1._34 * M2._41;
    ret._32 = M1._31 * M2._12 + M1._32 * M2._22 + M1._33 * M2._32 + M1._34 * M2._42;
    ret._33 = M1._31 * M2._13 + M1._32 * M2._23 + M1._33 * M2._33 + M1._34 * M2._43;
    ret._34 = M1._31 * M2._14 + M1._32 * M2._24 + M1._33 * M2._34 + M1._34 * M2._44;
    ret._41 = M1._41 * M2._11 + M1._42 * M2._21 + M1._43 * M2._31 + M1._44 * M2._41;
    ret._42 = M1._41 * M2._12 + M1._42 * M2._22 + M1._43 * M2._32 + M1._44 * M2._42;
    ret._43 = M1._41 * M2._13 + M1._42 * M2._23 + M1._43 * M2._33 + M1._44 * M2._43;
    ret._44 = M1._41 * M2._14 + M1._42 * M2._24 + M1._43 * M2._34 + M1._44 * M2._44;
    return ret;
}

template<class TEnum>
class TEnumAsByte
{
public:
    inline TEnumAsByte()
    {
    }

    inline TEnumAsByte(TEnum _value)
        : value(static_cast<uint8_t>(_value))
    {
    }

    explicit inline TEnumAsByte(int32_t _value)
        : value(static_cast<uint8_t>(_value))
    {
    }

    explicit inline TEnumAsByte(uint8_t _value)
        : value(_value)
    {
    }

    inline operator TEnum() const
    {
        return (TEnum)value;
    }

    inline TEnum GetValue() const
    {
        return (TEnum)value;
    }

private:
    uint8_t value;
};

enum class ESTEPoseState : uint8_t
{
    ESTEPoseState__Stand           = 0,
    ESTEPoseState__Crouch          = 1,
    ESTEPoseState__Prone           = 2,
    ESTEPoseState__Sprint          = 3,
    ESTEPoseState__CrouchSprint    = 4,
    ESTEPoseState__Crawl           = 5,
    ESTEPoseState__Swim            = 6,
    ESTEPoseState__SwimSprint      = 7,
    ESTEPoseState__Dying           = 8,
    ESTEPoseState__DyingBeCarried  = 9,
    ESTEPoseState__DyingSwim       = 10,
    ESTEPoseState__ESTEPoseState_MAX = 11
};


#endif /* Ue4Tool_hpp */
