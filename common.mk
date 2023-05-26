READER:=reader

READER_LIB_ROOT_DIR:=lib
READER_LIB_DIR:=$(READER_LIB_ROOT_DIR)/$(READER)
READER_BIN_DIR:=sample
READER_DEPENDENCIES_DIR:=dependencies
READER_STATIC_LIB:=lib$(READER).a

# READER_ROOT_DIR is defined later. That's why = is used instead of :=
READER_EXCEPTION_INCLUDE_DIR=$(READER_ROOT_DIR)/$(READER_DEPENDENCIES_DIR)/exception/include
READER_STATIC_LIB_INCLUDE_DIR=$(READER_ROOT_DIR)/$(READER_LIB_ROOT_DIR)
READER_STATIC_LIB_LDLIB=$(READER_ROOT_DIR)/$(READER_LIB_DIR)/$(READER_STATIC_LIB)

# extra flags may be added here or in make invocation. E.g: make EXTRA_CXXFLAGS=-g
EXTRA_CXXFLAGS:=
EXTRA_LDFLAGS:=

ifeq ($(OPTIMIZED), y)
OPTIMIZATION_FLAGS:=-O3 -march=native -flto
else ifeq ($(or $(OPTIMIZED), n), n)
OPTIMIZATION_FLAGS:=-O0 -g
else
$(error Invalid parameter value)
endif

ifeq ($(SANITIZED), y)
ifneq ($(OPTIMIZED), y)
SANITIZE_FLAGS:=-fsanitize=address -fno-omit-frame-pointer -fsanitize=undefined
else
$(error Cannot have SANITIZED=y and OPTIMIZED=y)
endif
else ifneq ($(or $(SANITIZED), n), n)
$(error Invalid parameter value)
endif

ifeq ($(WITH_FPIC), n)
FPIC_FLAG:=
else ifeq ($(or $(WITH_FPIC), y), y)
FPIC_FLAG:=-fPIC
else
$(error Invalid parameter value)
endif

ifeq ($(shell uname -s), Darwin)
SHARED_LIB_EXTENSION:=dylib
else
SHARED_LIB_EXTENSION:=so
endif

READER_SHARED_LIB:=lib$(READER).$(SHARED_LIB_EXTENSION)

READER_CXXFLAGS:=$(EXTRA_CXXFLAGS) -std=c++2b -Werror -Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic $(OPTIMIZATION_FLAGS) $(SANITIZE_FLAGS) $(FPIC_FLAG) $(PTHREAD_FLAG)

READER_COMMON_LDFLAGS:=$(EXTRA_LDFLAGS) $(OPTIMIZATION_FLAGS) $(SANITIZE_FLAGS) $(PTHREAD_FLAG)
READER_SHARED_LDFLAGS:=$(READER_COMMON_LDFLAGS) -shared
READER_EXECUTABLE_LDFLAGS:=$(READER_COMMON_LDFLAGS)

READER_SYSTEM_INCLUDE_DIRS:=$(READER_EXCEPTION_INCLUDE_DIR) /usr/local/include
READER_LIB_DIRS:=/usr/local/lib
READER_LDLIBS:=-lbz2 -lz
