#ifndef file_Data_hpp
#define file_Data_hpp

#include <memory>

namespace file {
    struct Data {
        std::unique_ptr<char[]> uniquePtr;
        std::size_t size;
    };
}

#endif
