
default_target: all

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif
# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=Debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="Release"
endif

DL_PATH   = http://www.control.isy.liu.se/~johanl/
UNZIP_DIR = yalmip
DL_NAME = YALMIP.zip

all: $(UNZIP_DIR) $(BUILD_PREFIX)/matlab/addpath_yalmip.m $(BUILD_PREFIX)/matlab/rmpath_yalmip.m

$(UNZIP_DIR):
	wget --no-check-certificate $(DL_PATH)/$(DL_NAME) && unzip $(DL_NAME) -C .. && rm $(DL_NAME)

# note that there are only two folders (r2012a, r2013a) on mac, but there are more on linux.  i've only supported the two below
$(BUILD_PREFIX)/matlab/addpath_mosek.m : Makefile
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/addpath_mosek.m"
	echo "function addpath_mosek()\n\n \
		if verLessThan('matlab','8.1')\n \
		  if verLessThan('matlab','7.14'),\n \
		    error('Mosek requires MATLAB 7.14 (R2012a) or higher');\n \
		  else\n \
		    d='r2012a';\n \
		  end\n \
		else\n \
	          d='r2013a';\n \
	        end\n \
	    javaaddpathProtectGlobals(fullfile('$(shell pwd)','7','tools','platform','$(PLATFORM_NAME)','bin','mosekmatlab.jar'));\n \
		addpath(fullfile('$(shell pwd)','7','toolbox',d));\n \
		end\n \
		\n" \
		> $(BUILD_PREFIX)/matlab/addpath_mosek.m
	cat javaaddpathProtectGlobals.m >> $(BUILD_PREFIX)/matlab/addpath_mosek.m

$(BUILD_PREFIX)/matlab/rmpath_mosek.m : Makefile
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/rmpath_mosek.m"
	echo "function rmpath_mosek()\n\n \
		if verLessThan('matlab','8.1')\n \
		  if verLessThan('matlab','7.14'),\n \
		    error('Mosek requires MATLAB 7.14 (R2012a) or higher');\n \
		  else\n \
		    d='r2012a';\n \
		  end\n \
		else\n \
	          d='r2013a';\n \
	        end\n \
	    javarmpath(fullfile('$(shell pwd)','7','tools','platform','$(PLATFORM_NAME)','bin','mosekmatlab.jar'));\n \
		rmpath(fullfile('$(shell pwd)','7','toolbox',d));\n" \
		> $(BUILD_PREFIX)/matlab/rmpath_mosek.m

$(BUILD_PREFIX)/lib/python2.7/site-packages/mosek/__init__.py: Makefile $(UNZIP_DIR)
	python $(UNZIP_DIR)/tools/platform/$(PLATFORM_NAME)/python/2/setup.py install --prefix=$(BUILD_PREFIX) --record $(shell pwd)/python_install_manifest.txt
	pwd

# todo: make this logic more robust:
#   check for license path environment variable
#   check expiration date in mosek.lic if it is found
$(HOME)/mosek/mosek.lic :
	@echo >&2 "You do not appear to have a license for mosek installed in $(HOME)/mosek/mosek.lic\n"
	@echo >&2 "Open the following url in your favorite browser and request the license:\n"
	@echo >&2 "           http://license.mosek.com/academic/\n"
	@echo >&2 "Then check your email for the license file and put it in $(HOME)/mosek/mosek.lic\n"
	exit 1

clean:
	-rm $(BUILD_PREFIX)/matlab/*path_mosek.m
	cat python_install_manifest.txt | xargs rm -rf

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:
