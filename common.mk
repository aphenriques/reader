FILE:=file

FILE_LIB_ROOT_DIR:=lib
FILE_LIB_DIR:=$(FILE_LIB_ROOT_DIR)/$(FILE)
FILE_BIN_DIR:=sample
FILE_DEPENDENCIES_DIR:=dependencies
FILE_STATIC_LIB:=lib$(FILE).a

# FILE_ROOT_DIR is defined later. That's why = is used instead of :=
FILE_EXCEPTION_INCLUDE_DIR=$(FILE_ROOT_DIR)/$(FILE_DEPENDENCIES_DIR)/exception/include
FILE_STATIC_LIB_INCLUDE_DIR=$(FILE_ROOT_DIR)/$(FILE_LIB_ROOT_DIR)
FILE_STATIC_LIB_LDLIB=$(FILE_ROOT_DIR)/$(FILE_LIB_DIR)/$(FILE_STATIC_LIB)

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
SANITIZE_FLAGS:=-fsanitize=address -fno-omit-frame-pointer -fno-common
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

FILE_SHARED_LIB:=lib$(FILE).$(SHARED_LIB_EXTENSION)

FILE_CXXFLAGS:=$(EXTRA_CXXFLAGS) -std=c++2a -Werror -Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic $(OPTIMIZATION_FLAGS) $(SANITIZE_FLAGS) $(FPIC_FLAG) $(PTHREAD_FLAG)

FILE_COMMON_LDFLAGS:=$(EXTRA_LDFLAGS) $(OPTIMIZATION_FLAGS) $(SANITIZE_FLAGS) $(PTHREAD_FLAG)
FILE_SHARED_LDFLAGS:=$(FILE_COMMON_LDFLAGS) -shared
FILE_EXECUTABLE_LDFLAGS:=$(FILE_COMMON_LDFLAGS)

FILE_SYSTEM_INCLUDE_DIRS:=$(FILE_EXCEPTION_INCLUDE_DIR) /usr/local/include
FILE_LIB_DIRS:=/usr/local/lib
FILE_LDLIBS:=-lboost_iostreams -lbz2 -lz -lboost_timer -lboost_chrono -lthread
