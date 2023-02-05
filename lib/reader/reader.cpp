#include "reader.hpp"
#include <cstdio>
#include <cstring>
#include <exception>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <vector>
#include <exception/Exception.hpp>

namespace reader {
    Data read(std::string_view fileName) {
        try {
            const auto fileSize = std::filesystem::file_size(fileName);
            std::ifstream ifstream(fileName, std::ios::binary);
            ifstream.exceptions(std::ifstream::failbit);
            auto bufferUniquePtr = std::make_unique<char[]>(fileSize);
            ifstream.read(bufferUniquePtr.get(), fileSize);
            return {std::move(bufferUniquePtr), fileSize};
        } catch (const std::exception &exception) {
            throw exception::RuntimeException(__FILE__, __LINE__, __func__, "error [[ ", exception.what(), " ]] reading file: ", fileName);
        }
    }

    namespace {
        void readCloseBz2(BZFILE *bzFile) {
            int bzError;
            BZ2_bzReadClose(&bzError, bzFile);
            if (bzError != BZ_OK) {
                std::cerr << "failed to close bzFile" << std::endl;
            }
        }
    }

    Data readBz2(const char *fileName, unsigned decompressRatioHint) {
        const auto fileSize = std::filesystem::file_size(fileName);
        FILE * const file = std::fopen(fileName, "rb");
        // std::fclose(NULL) is undefined behaviour
        if (file != NULL) {
            const std::unique_ptr<FILE, decltype(&std::fclose)> fileUniquePtr(file, std::fclose);
            int bzError;
            // BZ2_bzReadClose should always be called (even on open error)
            const std::unique_ptr<BZFILE, decltype(&readCloseBz2)> bzFileUniquePtr(
                BZ2_bzReadOpen(&bzError, file, 0, 0, NULL, 0),
                readCloseBz2
            );
            if (bzError == BZ_OK) {
                std::vector<std::unique_ptr<char[]>> bufferPartUniquePtrs;
                const auto initialBufferSize = decompressRatioHint*fileSize;
                bufferPartUniquePtrs.emplace_back(std::make_unique<char[]>(initialBufferSize));
                int lastReadSize = BZ2_bzRead(&bzError, bzFileUniquePtr.get(), bufferPartUniquePtrs.back().get(), initialBufferSize);
                while (bzError == BZ_OK) {
                    bufferPartUniquePtrs.emplace_back(std::make_unique<char[]>(fileSize));
                    lastReadSize = BZ2_bzRead(&bzError, bzFileUniquePtr.get(), bufferPartUniquePtrs.back().get(), fileSize);
                }
                if (bzError == BZ_STREAM_END) {
                    if (bufferPartUniquePtrs.size() == 1) {
                        auto bufferUniquePtr = std::make_unique<char[]>(lastReadSize);
                        std::memcpy(bufferUniquePtr.get(), bufferPartUniquePtrs[0].get(), lastReadSize);
                        return {std::move(bufferUniquePtr), static_cast<std::size_t>(lastReadSize)};
                    } else if (bufferPartUniquePtrs.size() == 2) {
                        const auto bufferSize = initialBufferSize + lastReadSize;
                        auto bufferUniquePtr = std::make_unique<char[]>(bufferSize);
                        std::memcpy(bufferUniquePtr.get(), bufferPartUniquePtrs[0].get(), initialBufferSize);
                        std::memcpy(bufferUniquePtr.get() + initialBufferSize, bufferPartUniquePtrs[1].get(), lastReadSize);
                        return {std::move(bufferUniquePtr), bufferSize};
                    } else {
                        const auto bufferSize = initialBufferSize + bufferPartUniquePtrs.size()*(fileSize - 2) + lastReadSize;
                        auto bufferUniquePtr = std::make_unique<char[]>(bufferSize);
                        std::memcpy(bufferUniquePtr.get(), bufferPartUniquePtrs[0].get(), initialBufferSize);
                        for (std::size_t partIndex = 1; partIndex < bufferPartUniquePtrs.size() - 1; ++partIndex) {
                            std::memcpy(
                                bufferUniquePtr.get() + initialBufferSize + fileSize*(partIndex - 1),
                                bufferPartUniquePtrs[partIndex].get(),
                                fileSize
                            );
                        }
                        std::memcpy(bufferUniquePtr.get(), bufferPartUniquePtrs.back().get(), lastReadSize);
                        return {std::move(bufferUniquePtr), bufferSize};
                    }
                } else {
                    throw exception::RuntimeException(__FILE__, __LINE__, __func__, "error reading bz2 file: ", fileName);
                }
            } else {
                throw exception::RuntimeException(__FILE__, __LINE__, __func__, "error opening bz2 file: ", fileName);
            }
        } else {
            throw exception::RuntimeException(__FILE__, __LINE__, __func__, "error opening file: ", fileName);
        }
    }
}
