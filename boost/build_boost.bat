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
        set foldername_for_vs=VS2015
    ) else (
        if %action%==2 (
            set toolset=msvc-14.1
            set foldername_for_vs=VS2017
        ) else (
            if %action%==3 (
				set toolset=msvc
				set foldername_for_vs=VS2019
			) else (
				echo.
				goto choose_build_option
			)
        )
    )
)

rem Directories
set lib_root_dir=D:\dev\lib
set source_dir=%lib_root_dir%\src\boost_1_70_0
set build_dir=%lib_root_dir%\build\%foldername_for_vs%\x64\build
set stage_dir=%lib_root_dir%\build\%foldername_for_vs%\x64\stage
set install_dir=%lib_root_dir%\dist\boost_1_70_0\%foldername_for_vs%\x64

rem Number of cores for building
set cores=%NUMBER_OF_PROCESSORS%

echo Source Dir: %source_dir%
echo Build Dir: %build_dir%
echo Stage Dir: %stage_dir%
echo Install Dir: %install_dir%
echo Toolset: %toolset%
echo Cores for building: %cores%
echo Building Start

cd "%source_dir%"
call bootstrap.bat
 
rem Most libraries can be static libs ???
b2 -j%cores% toolset=%toolset% address-model=64 architecture=x86 threading=multi variant=debug,release link=shared runtime-link=shared install --build-dir="%build_dir%" --stagedir="%stage_dir%" --prefix="%install_dir%"

pause