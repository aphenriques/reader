# reader

`reader` is a C++ library for reading plain and bzip2 files (using libbz2).


# Requirements

* C++17 compiler; and
* libbz2


# Build

Grab the `dependecies/exception/include/exception` directory and all the source files (*.hpp and *.cpp) in the `lib/reader` directory and build (there is no preprocessor configuration for the library).

Alternatively, build and install the library with:

    $ make
    $ make install


# Usage

```cpp
#include <reader/reader.hpp>

int main() {
    reader::Data plainData = reader::read("Matthew-5.txt");
    reader::Data bz2Data = reader::readBz2("Matthew-5.txt.bz2");
    for (std::size_t i = 0; i < plainData.size; ++i) {
        if (plainData.uniquePtr.get()[i] != bz2Data.uniquePtr.get()[i]) {
            std::cerr << "unexpected different values" << std::endl;
            return EXIT_FAILURE;
        }
    }
    std::cout << "Be ye therefore perfect, even as your Father which is in heaven is perfect. (Matt. 5:48)" << std::endl;
    return EXIT_SUCCESS;
}

// outuput: Be ye therefore perfect, even as your Father which is in heaven is perfect. (Matt. 5:48)
```

See [example](sample/bz2/main.cpp).


# API

```cpp
struct reader::Data {
    std::unique_ptr<char[]> uniquePtr;
    std::size_t size;
};
```


Read binary `fileName`.

```cpp
reader::Data reader::read(std::string_view fileName);
```


Read and decompress bzip2 `fileName`.
`decompressRatioHint` sets the initial read buffer size: (`file size`) * `decompressRatioHint`.

```cpp
reader::Data reader::readBz2(const char *fileName, unsigned decompressRatioHint = 7);
```


# Source

`reader`'s Git repository is available on GitHub, which can be browsed at:

    http://github.com/aphenriques/reader

and cloned with:

    git clone --recurse-submodules git://github.com/aphenriques/reader.git


# Author

`reader` was made by André Pereira Henriques [aphenriques (at) outlook (dot) com].


# License

MIT License

Copyright (c) 2023 André Henriques

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
