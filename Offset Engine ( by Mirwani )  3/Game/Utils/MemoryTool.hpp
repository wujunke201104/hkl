//
//  MemoryTool.hpp
//  UE4
//
//  Created by DH on 2022/5/9.
//

#ifndef MemoryTool_hpp
#define MemoryTool_hpp
//死全家的GG爆 狗逼一个 操他妈的血逼
#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string>
#include <mach/mach.h>
#include <mach-o/dyld.h>
#include <mach-o/dyld_images.h>
#include <math.h>
//死全家的GG爆 狗逼一个 操他妈的血逼
#pragma mark - 内存读写
//死全家的GG爆 狗逼一个 操他妈的血逼
static uintptr_t Get_module_base() {

    return (uintptr_t)_dyld_get_image_vmaddr_slide(0);
}


static bool IsValidAddress(long address) {

    return address && address > 0x100000000 && address < 0x2000000000;
}

static uintptr_t GetHexAddr(std::string address) {

    return (uintptr_t)strtoul(address.c_str(), nullptr, 16);
}

static uintptr_t GetRealOffset(std::string address) {

    return (Get_module_base() + GetHexAddr(address));
}

template<typename T>
static T Read(uintptr_t address) {
#if 0
    T data = *(T *)(address);
    return data;
#else
    T data;
    vm_copy(mach_task_self(), (vm_address_t)address, sizeof(T), (vm_address_t)&data);
    return data;
#endif
}

template<typename T>
static void Write(uintptr_t address, T data) {
#if 0
    *(T *)(address) = data;
#else
    vm_copy(mach_task_self(), (vm_address_t)&data, sizeof(T), (vm_address_t)address);
#endif
}

static void Read_data(long Adder, int Size, void* buff) {
    
    vm_copy(mach_task_self(), (vm_address_t)Adder, (vm_size_t)Size, (vm_address_t)buff);
}

static uint64_t I64(std::string address) {
    return (uint64_t)strtoul(address.c_str(), nullptr, 16);
}


#endif /* MemoryTool_hpp */
