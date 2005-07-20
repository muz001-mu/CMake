# This file sets the basic flags for the C language in CMake.
# It also loads the available platform file for the system-compiler
# if it exists.

GET_FILENAME_COMPONENT(CMAKE_BASE_NAME ${CMAKE_C_COMPILER} NAME_WE)
IF(CMAKE_COMPILER_IS_GNUCC)
  SET(CMAKE_BASE_NAME gcc)
ENDIF(CMAKE_COMPILER_IS_GNUCC)
SET(CMAKE_SYSTEM_AND_C_COMPILER_INFO_FILE 
  ${CMAKE_ROOT}/Modules/Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME}.cmake)
INCLUDE(Platform/${CMAKE_SYSTEM_NAME}-${CMAKE_BASE_NAME} OPTIONAL)

# for most systems a module is the same as a shared library
# so unless the variable CMAKE_MODULE_EXISTS is set just
# copy the values from the LIBRARY variables
IF(NOT CMAKE_MODULE_EXISTS)
  SET(CMAKE_SHARED_MODULE_C_FLAGS ${CMAKE_SHARED_LIBRARY_C_FLAGS})
  SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS})
ENDIF(NOT CMAKE_MODULE_EXISTS)

SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS_ENV_INIT} $ENV{CFLAGS} ${CMAKE_C_FLAGS_INIT}" CACHE STRING
     "Flags for C compiler.")

IF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)
# default build type is none
  IF(NOT CMAKE_NO_BUILD_TYPE)
    SET (CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE_INIT} CACHE STRING 
      "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel.")
  ENDIF(NOT CMAKE_NO_BUILD_TYPE)
  SET (CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_INIT}" CACHE STRING
    "Flags used by the compiler during debug builds.")
  SET (CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL_INIT}" CACHE STRING
    "Flags used by the compiler during release minsize builds.")
  SET (CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE_INIT}" CACHE STRING
    "Flags used by the compiler during release builds (/MD /Ob1 /Oi /Ot /Oy /Gs will produce slightly less optimized but smaller files).")
  SET (CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING
    "Flags used by the compiler during Release with Debug Info builds.")
ENDIF(NOT CMAKE_NOT_USING_CONFIG_FLAGS)

INCLUDE(CMakeCommonLanguageInclude)

# now define the following rule variables

# CMAKE_C_CREATE_SHARED_LIBRARY
# CMAKE_C_CREATE_SHARED_MODULE
# CMAKE_C_CREATE_STATIC_LIBRARY
# CMAKE_C_COMPILE_OBJECT
# CMAKE_C_LINK_EXECUTABLE

# variables supplied by the generator at use time
# <TARGET>
# <TARGET_BASE> the target without the suffix
# <OBJECTS>
# <OBJECT>
# <LINK_LIBRARIES>
# <FLAGS>
# <LINK_FLAGS>

# C compiler information
# <CMAKE_C_COMPILER>  
# <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS>
# <CMAKE_SHARED_MODULE_CREATE_C_FLAGS>
# <CMAKE_C_LINK_FLAGS>

# Static library tools
# <CMAKE_AR> 
# <CMAKE_RANLIB>


# create a C shared library
IF(NOT CMAKE_C_CREATE_SHARED_LIBRARY)
  SET(CMAKE_C_CREATE_SHARED_LIBRARY
      "<CMAKE_C_COMPILER> <CMAKE_SHARED_LIBRARY_C_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS> <CMAKE_SHARED_LIBRARY_SONAME_C_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
ENDIF(NOT CMAKE_C_CREATE_SHARED_LIBRARY)

# create a C shared module just copy the shared library rule
IF(NOT CMAKE_C_CREATE_SHARED_MODULE)
  SET(CMAKE_C_CREATE_SHARED_MODULE ${CMAKE_C_CREATE_SHARED_LIBRARY})
ENDIF(NOT CMAKE_C_CREATE_SHARED_MODULE)

# create a C static library
IF(NOT CMAKE_C_CREATE_STATIC_LIBRARY)
  SET(CMAKE_C_CREATE_STATIC_LIBRARY
      "<CMAKE_AR> cr <TARGET> <LINK_FLAGS> <OBJECTS> "
      "<CMAKE_RANLIB> <TARGET> ")
ENDIF(NOT CMAKE_C_CREATE_STATIC_LIBRARY)

# compile a C file into an object file
IF(NOT CMAKE_C_COMPILE_OBJECT)
  SET(CMAKE_C_COMPILE_OBJECT
    "<CMAKE_C_COMPILER> <FLAGS> -o <OBJECT>   -c <SOURCE>")
ENDIF(NOT CMAKE_C_COMPILE_OBJECT)

IF(NOT CMAKE_C_LINK_EXECUTABLE)
  SET(CMAKE_C_LINK_EXECUTABLE
    "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
ENDIF(NOT CMAKE_C_LINK_EXECUTABLE)

IF(CMAKE_USER_MAKE_RULES_OVERRIDE)
   INCLUDE(${CMAKE_USER_MAKE_RULES_OVERRIDE})
ENDIF(CMAKE_USER_MAKE_RULES_OVERRIDE)

MARK_AS_ADVANCED(
CMAKE_C_FLAGS
CMAKE_C_FLAGS_DEBUG
CMAKE_C_FLAGS_MINSIZEREL
CMAKE_C_FLAGS_RELEASE
CMAKE_C_FLAGS_RELWITHDEBINFO
)
SET(CMAKE_C_INFOMATION_LOADED 1)


