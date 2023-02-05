#ifndef reader_reader_hpp
#define reader_reader_hpp

#include <string_view>
#include <bzlib.h>
#include "Data.hpp"

namespace reader {
    Data read(std::string_view fileName);
    Data readBz2(const char *fileName, unsigned decompressRatioHint = 7);
}

#endif
