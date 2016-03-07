Audio Tutorial
==

thebennybox Audio Programming Tutorial code

Tutorial found here: https://www.youtube.com/playlist?list=PLEETnX-uPtBVpZvp-R2daNfy9k3-L-Q3u

##Build Dependencies##
- [CMAKE](http://www.cmake.org/)
- [SDL2](http://www.libsdl.org/)
- BUILD TOOLCHAIN (Can be any one of the following, doesn't need to be all of them)
	- Linux
		- make, gcc, g++ ( Install with your package manager )
		- [CodeBlocks](http://www.codeblocks.org/)
	- Mac OS X
		- make, gcc, g++ ( Install with preferred package manager like [HOMEBREW](http://brew.sh/) )
		- Xcode ( Download from Mac AppStore )
		- [CodeBlocks](http://www.codeblocks.org/)
	- WINDOWS
		- [Visual Studio](http://www.visualstudio.com/)
		- [CodeBlocks](http://www.codeblocks.org/)

###NOTES for Dependencies###
On Unix/Linux/Mac you can likely install CMAKE and SDL2 with your package manager
```shell
# On ubuntu just run
sudo apt-get install cmake libsdl2-dev

# On Mac with HomeBrew just run
brew install cmake sdl2
```

##Simple Build Instructions##
###Mac OSX/Linux/Unix###
- Open a Terminal and run:
```Shell
# install dependencies

./Unix-Build.sh [Build Target, Debug or Release (Optional)] [Any arguments for CMake (Optional)]

#For instance, you can use the CMake argument -G "Xcode" to generate an Xcode project during build,
#or you can use -G "CodeBlocks - Unix Makefiles" to generate a CodeBlocks Project.
#See http://www.cmake.org/ for more details about CMake arguments
```
- If this fails for any reason, try using the Manual Build Instructions below.

###Windows###
- Make sure CMake is both installed and added to the system PATH.
- Run "Windows-GenVisualStudioProject.bat" If this fails for any reason, try using the Manual Build Instructions below.
- Go to the build folder, and open AudioProject.sln with Visual Studio 2012 or newer (For older versions of Visual Studio, use manual build instructions)
- Right click on the AudioProject project, and select "Set as start up project"
- Build and Run

##Manual Build Instructions##
###Linux/Unix###
- Open a Terminal and run:
```Shell
# install dependencies
cd build
cmake ../
make
```

###Mac OSX###
- Open a Terminal and run:
```Shell
# install dependencies
cd build
cmake ../
make
```

###Windows/MinGW###
- Make sure CMake is both installed and added to the system PATH.
- Open a Terminal and run:
```Shell
# install dependencies
# Install SDL2 in %PROGRAMFILES%/SDL2 or SET %SDL2_ROOT_DIR% to where SDL2 is on your machine (Example: D:\PATH_TO_SDL2)
cd build
# REPLACE "Visual Studio 12" with your preferred build toolchain (Maybe you want "Codeblocks - MinGW Makefiles")
# BTW VS 10 is VS 2010, VS 11 is VS 2012 and VS 12 is VS 2013, BLAME MicroSoft for the naming! LOL! 
cmake -G "Visual Studio 12" ../
# open the generated SLN file (or cbp file if using CodeBlocks) and build!
```
- Copy the DLLs in /lib/_bin/ to /build/Debug/ and /build/Release/
- In Visual Studio, set the Startup project to 3DEngineCpp
- Move the res folder into the build folder
- Run

##Additional Credits##
- [@mxaddict](https://github.com/mxaddict) for setting up the awesome CMake build system
- Everyone who's created or contributed to issues and pull requests, which make the project better!
