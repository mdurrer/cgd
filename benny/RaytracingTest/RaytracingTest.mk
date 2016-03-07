##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Release
ProjectName            :=RaytracingTest
ConfigurationName      :=Release
WorkspacePath          := "/home/batman/Workspaces/C Workspaces/RaytracingTest"
ProjectPath            := "/home/batman/Workspaces/C Workspaces/RaytracingTest"
IntermediateDirectory  :=./Release
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=batman
Date                   :=02/24/14
CodeLitePath           :="/home/batman/.codelite"
LinkerName             :=clang++
SharedObjectLinkerName :=clang++ -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=
PreprocessSuffix       :=.o.i
DebugSwitch            :=-gstab
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
SourceSwitch           :=-c 
OutputFile             :=$(IntermediateDirectory)/$(ProjectName)
Preprocessors          :=$(PreprocessorSwitch)NDEBUG 
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E 
ObjectsFileList        :="RaytracingTest.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)SDL2 
ArLibs                 :=  "SDL2" 
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := ar rcus
CXX      := clang++
CC       := clang
CXXFLAGS :=  -O2 -Wall $(Preprocessors)
CFLAGS   :=  -O2 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := llvm-as


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/main$(ObjectSuffix) $(IntermediateDirectory)/ppmImage$(ObjectSuffix) $(IntermediateDirectory)/display$(ObjectSuffix) $(IntermediateDirectory)/obj_loader$(ObjectSuffix) $(IntermediateDirectory)/mesh$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

$(IntermediateDirectory)/.d:
	@test -d ./Release || $(MakeDirCommand) ./Release

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/main$(ObjectSuffix): main.cpp 
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/batman/Workspaces/C Workspaces/RaytracingTest/main.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/main$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/main$(PreprocessSuffix): main.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/main$(PreprocessSuffix) "main.cpp"

$(IntermediateDirectory)/ppmImage$(ObjectSuffix): ppmImage.cpp 
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/batman/Workspaces/C Workspaces/RaytracingTest/ppmImage.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/ppmImage$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/ppmImage$(PreprocessSuffix): ppmImage.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/ppmImage$(PreprocessSuffix) "ppmImage.cpp"

$(IntermediateDirectory)/display$(ObjectSuffix): display.cpp 
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/batman/Workspaces/C Workspaces/RaytracingTest/display.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/display$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/display$(PreprocessSuffix): display.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/display$(PreprocessSuffix) "display.cpp"

$(IntermediateDirectory)/obj_loader$(ObjectSuffix): obj_loader.cpp 
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/batman/Workspaces/C Workspaces/RaytracingTest/obj_loader.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/obj_loader$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/obj_loader$(PreprocessSuffix): obj_loader.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/obj_loader$(PreprocessSuffix) "obj_loader.cpp"

$(IntermediateDirectory)/mesh$(ObjectSuffix): mesh.cpp 
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/batman/Workspaces/C Workspaces/RaytracingTest/mesh.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/mesh$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/mesh$(PreprocessSuffix): mesh.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/mesh$(PreprocessSuffix) "mesh.cpp"

##
## Clean
##
clean:
	$(RM) $(IntermediateDirectory)/main$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/main$(DependSuffix)
	$(RM) $(IntermediateDirectory)/main$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/ppmImage$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/ppmImage$(DependSuffix)
	$(RM) $(IntermediateDirectory)/ppmImage$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/display$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/display$(DependSuffix)
	$(RM) $(IntermediateDirectory)/display$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/obj_loader$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/obj_loader$(DependSuffix)
	$(RM) $(IntermediateDirectory)/obj_loader$(PreprocessSuffix)
	$(RM) $(IntermediateDirectory)/mesh$(ObjectSuffix)
	$(RM) $(IntermediateDirectory)/mesh$(DependSuffix)
	$(RM) $(IntermediateDirectory)/mesh$(PreprocessSuffix)
	$(RM) $(OutputFile)
	$(RM) ".build-release/RaytracingTest"


