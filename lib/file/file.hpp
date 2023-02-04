#ifndef file_file_hpp
#define file_file_hpp

#include <string_view>
#include <bzlib.h>
#include "Data.hpp"

namespace file {
    Data read(std::string_view fileName);
    Data readBz2(const char *fileName, unsigned decompressRatioHint = 7);
}

#endif
