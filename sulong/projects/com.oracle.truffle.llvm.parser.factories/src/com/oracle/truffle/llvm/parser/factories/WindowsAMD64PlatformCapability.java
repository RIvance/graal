/*
 * Copyright (c) 2020, 2022, Oracle and/or its affiliates.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of
 * conditions and the following disclaimer in the documentation and/or other materials provided
 * with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package com.oracle.truffle.llvm.parser.factories;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.llvm.runtime.LLVMSyscallEntry;
import com.oracle.truffle.llvm.runtime.memory.LLVMSyscallOperationNode;
import com.oracle.truffle.llvm.runtime.nodes.asm.syscall.LLVMUnsupportedSyscallNode;
import com.oracle.truffle.llvm.runtime.nodes.intrinsics.llvm.va.LLVMVAListNode;
import com.oracle.truffle.llvm.runtime.nodes.intrinsics.llvm.va.LLVMVaListStorage.VAListPointerWrapperFactory;
import com.oracle.truffle.llvm.runtime.nodes.intrinsics.llvm.x86_win.LLVMX86_64_WinVaListStorage;
import com.oracle.truffle.llvm.runtime.nodes.intrinsics.llvm.x86_win.LLVMX86_64_WinVaListStorageFactory;
import com.oracle.truffle.llvm.runtime.pointer.LLVMMaybeVaPointer;
import com.oracle.truffle.llvm.runtime.pointer.LLVMPointer;
import com.oracle.truffle.llvm.runtime.types.PointerType;
import com.oracle.truffle.llvm.runtime.types.Type;

final class WindowsAMD64PlatformCapability extends BasicPlatformCapability<WindowsAMD64PlatformCapability.UnknownSyscalls> {

    /**
     * We don't know anything about this platform.
     */
    enum UnknownSyscalls implements LLVMSyscallEntry {
        /* DUMMY */;
        @Override
        public int value() {
            throw CompilerDirectives.shouldNotReachHere();
        }
    }

    WindowsAMD64PlatformCapability(boolean loadCxxLibraries) {
        super(UnknownSyscalls.class, loadCxxLibraries);
    }

    @Override
    public LLVMSyscallOperationNode createSyscallNode(long index) {
        return LLVMUnsupportedSyscallNode.create(index);
    }

    @Override
    protected LLVMSyscallOperationNode createSyscallNode(UnknownSyscalls syscall) {
        return LLVMUnsupportedSyscallNode.create(syscall);
    }

    @Override
    public Object createVAListStorage(LLVMVAListNode allocaNode, LLVMPointer vaListStackPtr) {
        return LLVMMaybeVaPointer.createWithAlloca(vaListStackPtr, allocaNode);
    }

    @Override
    public Object createActualVAListStorage() {
        return new LLVMX86_64_WinVaListStorage();
    }

    @Override
    public Type getVAListType() {
        return PointerType.I8;
    }

    @Override
    public VAListPointerWrapperFactory createNativeVAListWrapper(boolean cached) {
        return cached ? LLVMX86_64_WinVaListStorageFactory.PointerWrapperFactoryNodeGen.create() : LLVMX86_64_WinVaListStorageFactory.PointerWrapperFactoryNodeGen.getUncached();
    }

    @Override
    public OS getOS() {
        return OS.Windows;
    }
}
