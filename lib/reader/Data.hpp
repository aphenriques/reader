#ifndef reader_Data_hpp
#define reader_Data_hpp

#include <memory>

namespace reader {
    struct Data {
        std::unique_ptr<char[]> uniquePtr;
        std::size_t size;
    };
}

#endif
