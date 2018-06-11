@echo off

:choose_build_option
echo Actions:
echo 0. Quit
echo 1. VS2015
echo 2. VS2017
set /p action="Please an action: "

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
            echo.
            goto choose_build_option
        )
    )
)

rem Directory to boost root
set boost_dir=D:\Dev\GitRepo\GitHub\boost
 
rem Number of cores to use when building boost
set cores=%NUMBER_OF_PROCESSORS%

set build_dir=build/%foldername_for_vs%/x64/build
set stage_dir=build/%foldername_for_vs%/x64/stage
set install_dir=D:/Dev/Lib/boost/%foldername_for_vs%/x64

echo Source Code Dir: %boost_dir%
echo Build Dir: %build_dir%
echo Stage Dir: %stage_dir%
echo Install Dir: %install_dir%
echo Toolset: %toolset%
echo Cores for building: %cores%
echo Building Start
 
cd "%boost_dir%"
rem call bootstrap.bat
 
rem Most libraries can be static libs
b2 -j%cores% toolset=%toolset% address-model=64 architecture=x86 threading=multi variant=debug,release link=static,shared runtime-link=shared install --build-dir="%build_dir%" --stagedir="%stage_dir%" --prefix="%install_dir%"
 
pause