@echo off

:choose_build_option
echo Actions:
echo 0. Quit
echo 1. VS2015
echo 2. VS2017
echo 3. VS2019
set /p action="Please select an action: "

if %action%  == 0 (
    goto :eof
) else (
    if %action%==1 (
        set toolset=msvc-14.0
        set folder_name_for_vs=VS2015
    ) else (
        if %action%==2 (
            set toolset=msvc-14.1
            set folder_name_for_vs=VS2017
        ) else (
            if %action%==3 (
				set toolset=msvc
				set folder_name_for_vs=VS2019
			) else (
				echo.
				goto choose_build_option
			)
        )
    )
)

rem Directories
set lib_root_folder_path=C:\Users\disc\Dev\lib
set boost_folder_name=boost_1_72_0
set source_folder_path=%lib_root_folder_path%\src\%boost_folder_name%
set build_folder_path=%lib_root_folder_path%\build\%boost_folder_name%\%folder_name_for_vs%\x64\build
set stage_folder_path=%lib_root_folder_path%\build\%boost_folder_name%\%folder_name_for_vs%\x64\stage
set install_folder_path=%lib_root_folder_path%\dist\%boost_folder_name%\%folder_name_for_vs%\x64

rem Number of cores for building
set cores=%NUMBER_OF_PROCESSORS%

echo Source Folder Path: %source_folder_path%
echo Build Folder Path: %build_folder_path%
echo Stage Folder Path: %stage_folder_path%
echo Install Folder Path: %install_folder_path%
echo Toolset: %toolset%
echo Cores for building: %cores%
echo Building Start

cd "%source_folder_path%"
call bootstrap.bat
 
rem Most libraries can be static libs ???
b2 -j%cores% toolset=%toolset% address-model=64 architecture=x86 threading=multi variant=debug,release link=shared runtime-link=shared install --build-dir="%build_folder_path%" --stagedir="%stage_folder_path%" --prefix="%install_folder_path%"

pause