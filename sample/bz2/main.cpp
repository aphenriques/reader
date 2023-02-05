#include <exception>
#include <iostream>
#include <reader/reader.hpp>

int main() {
    try {
        reader::Data plainData = reader::read("Matthew-5.txt");
        reader::Data bz2Data = reader::readBz2("Matthew-5.txt.bz2");
        if (plainData.size == bz2Data.size) {
            for (std::size_t i = 0; i < plainData.size; ++i) {
                if (plainData.uniquePtr.get()[i] != bz2Data.uniquePtr.get()[i]) {
                    std::cerr << "unexpected different values" << std::endl;
                    return EXIT_FAILURE;
                }
            }
            std::cout << "Be ye therefore perfect, even as your Father which is in heaven is perfect. (Matt. 5:48)" << std::endl;
            return EXIT_SUCCESS;
        } else {
            std::cerr << "unexpected different sizes" << std::endl;
            return EXIT_FAILURE;
        }
    } catch(const std::exception &exception) {
        std::cerr << exception.what() << std::endl;
        return EXIT_FAILURE;
    }
}

