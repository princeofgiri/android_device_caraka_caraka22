/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <utils/Thread.h>
#include <utils/Log.h>
#include <dlfcn.h>
#include <stdint.h>

#define LOG_TAG "libcam_utils_shim"

namespace android {

// Signature of android::Thread::run(const char* name, int32_t priority, size_t stack)
typedef status_t (*ThreadRunFunc)(Thread*, const char*, int32_t, size_t);

static ThreadRunFunc get_real_thread_run() {
    static ThreadRunFunc sRealRun = nullptr;
    if (!sRealRun) {
        sRealRun = reinterpret_cast<ThreadRunFunc>(dlsym(RTLD_NEXT, "_ZN7android6Thread3runEPKcim"));
        if (!sRealRun) {
            void* handle = dlopen("libutils.so", RTLD_NOW);
            if (handle) {
                sRealRun = reinterpret_cast<ThreadRunFunc>(dlsym(handle, "_ZN7android6Thread3runEPKcim"));
            }
        }
    }
    return sRealRun;
}

extern "C" status_t _ZN7android6Thread3runEPKcim(Thread* thiz, const char* name, int32_t priority, size_t stack) {
    ThreadRunFunc real_run = get_real_thread_run();
    if (!real_run) {
        ALOGE("Failed to find original Thread::run symbol in libutils.so");
        return INVALID_OPERATION;
    }

    constexpr int32_t INITIAL_STRONG_VALUE = 1 << 28;
    int32_t count = thiz->getStrongCount();
    if (count <= 0 || count == INITIAL_STRONG_VALUE) {
        ALOGI("Shim: fixing unowned Thread %p before run(\"%s\")", thiz, name ? name : "");
        thiz->incStrong(thiz);
        status_t ret = real_run(thiz, name, priority, stack);
        thiz->decStrong(thiz);
        return ret;
    }

    return real_run(thiz, name, priority, stack);
}

} // namespace android
