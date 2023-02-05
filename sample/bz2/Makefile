READER_ROOT_DIR:=../..

include $(READER_ROOT_DIR)/common.mk

TARGET:=bz2
SRC_DIRS:=. $(wildcard */.)
FILTER_OUT:=
INCLUDE_DIRS:=$(READER_STATIC_LIB_INCLUDE_DIR)
SYSTEM_INCLUDE_DIRS:=$(READER_SYSTEM_INCLUDE_DIRS)
LIB_DIRS:=
LDLIBS:=$(READER_STATIC_LIB_LDLIB) $(READER_LDLIBS)

# '-isystem <dir>' supress warnings from included headers in <dir>. These headers are also excluded from dependency generation
CXXFLAGS:=$(READER_CXXFLAGS) $(addprefix -I, $(INCLUDE_DIRS)) $(addprefix -isystem , $(SYSTEM_INCLUDE_DIRS))
LDFLAGS:=$(READER_EXECUTABLE_LDFLAGS) $(addprefix -L, $(LIB_DIRS))

################################################################################

SRC_DIRS:=$(subst /.,,$(SRC_DIRS))
SRCS:=$(filter-out $(FILTER_OUT), $(wildcard $(addsuffix /*.cpp, $(SRC_DIRS))))
OBJS:=$(addsuffix .o, $(basename $(SRCS)))
DEPS:=$(addsuffix .d, $(basename $(SRCS)))

.PHONY: all run clean

all:
	cd $(READER_ROOT_DIR)/$(READER_LIB_DIR) && $(MAKE) static
	$(MAKE) $(TARGET)

run: all
	./$(TARGET)

$(TARGET): $(OBJS) $(READER_ROOT_DIR)/$(READER_LIB_DIR)/$(READER_STATIC_LIB)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(addsuffix /*.d, $(SRC_DIRS)) $(addsuffix /*.o, $(SRC_DIRS)) $(TARGET)
#	rm -f $(DEPS) $(OBJS) $(TARGET)

%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MP -MM -MF $@ -MT '$@ $(addsuffix .o, $(basename $<))' $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

