@echo off
rem
rem Copyright by The HDF Group.
rem Copyright by the Board of Trustees of the University of Illinois.
rem All rights reserved.
rem
rem This file is part of HDF5.  The full HDF5 copyright notice, including
rem terms governing use, modification, and redistribution, is contained in
rem the files COPYING and Copyright.html.  COPYING can be found at the root
rem of the source code distribution tree; Copyright.html can be found at the
rem root level of an installed copy of the electronic HDF5 document set and
rem is linked from the top-level documents page.  It can also be found at
rem http://hdfgroup.org/HDF5/doc/Copyright.html.  If you do not have
rem access to either file, you may request a copy from help@hdfgroup.org.
rem
rem HDF Utilities Test script
rem
rem    Created:  Scott Wegner, 8/27/07
rem    Modified:
rem

setlocal enabledelayedexpansion
pushd %~dp0

rem srcdir is used on Unix-- define as the current directory for Windows.
set srcdir=%CD%

rem The tool name
set h5import=h5import%2
rem The path of the tool binary
set h5import_bin=%CD%\..\%h5import%\%1\%h5import%.exe

rem The h5importtest tool name
set h5importtest=..\testfiles\h5importtst\%1\h5importtst
rem The path of the h5importtst tool binary
set h5importtest_bin=%CD%\%h5importtest%.exe

rem The h5dump tool name
set h5dump=..\h5dump%2\%1\h5dump%2
rem The path of the h5dump tool binary
set h5dump_bin=%CD%\%h5dump%

rem initialize errors variables
set errors=0

goto main

:testing
    set test_msg=Testing 
    for %%a in (%*) do (
        if %%a neq PASSED (
        if %%a neq *FAILED* (
            set test_msg=!test_msg! %%~nxa
        ) )
    )
    rem We need to replace PERCENT-ZERO here with "%0" for the tfamily test.
    rem --SJW 8/24/07
    set test_msg=!test_msg:PERCENT-ZERO=%%0!                                                                
    echo.%test_msg:~0,69% %1
    
    exit /b

    
:tooltest
    set err=0
    %h5import_bin% %*
    %h5dump_bin% %5 > log2
    
    pushd tmp_testfiles
    %h5dump_bin% %5 > log1
    popd
    
    fc /w tmp_testfiles\log1 log2 > nul
    if %errorlevel% neq 0 set err=1
    del /f log2 tmp_testfiles\log1
    if "%err%"=="1" (
        set /a errors=!errors!+1
        call :testing *FAILED* %testing%
    ) else (
        call :testing: PASSED %testing%
    )
    
    exit /b
    
    
:main
    echo.
    echo.==============================
    echo.H5IMPORT tests started
    echo.==============================

    if exist %h5import_bin% (
    if exist %h5importtest_bin% (
    rem echo.** Testing h5import  ***
    
    del /f output.h5 log1 tx* b* *.dat 2> nul
    
    if not exist tmp_testfiles mkdir tmp_testfiles
    copy /y testfiles\*.h5 tmp_testfiles > nul
    
    %h5importtest_bin%
    
    rem On Linux, they call TESTING here, and output pass/fail from TOOLTEST.
    rem On Windows, echo gives a carriage return, so we store the TESTING params
    rem and call TESTING from TOOLTEST.  --SJW 8/27/07
    set testing=ASCII I32 rank 3 - Output BE 
    call :tooltest %srcdir%\testfiles\txtin16.txt -c %srcdir%\testfiles\txtin32.conf -o txtin32.h5

    set testing=ASCII I16 rank 3 - Output LE - CHUNKED - extended
    call :tooltest %srcdir%\testfiles\txtin16.txt -c %srcdir%\testfiles\txtin16.conf -o txtin16.h5

    set testing=ASCII I8 - rank 3 - Output I16 LE-Chunked+Extended+Compressed
    call :tooltest %srcdir%\testfiles\txtin16.txt -c %srcdir%\testfiles\txtin8.conf  -o txtin8.h5

    set testing=ASCII UI32 - rank 3 - Output BE
    call :tooltest %srcdir%\testfiles\txtin32.txt -c %srcdir%\testfiles\txtuin32.conf -o txtuin32.h5

    set testing=ASCII UI16 - rank 2 - Output LE+Chunked+Compressed
    call :tooltest %srcdir%\testfiles\txtuin32.txt -c %srcdir%\testfiles\txtuin16.conf -o txtuin16.h5

    set testing=ASCII F32 - rank 3 - Output LE
    call :tooltest %srcdir%\testfiles\txtfp32.txt -c %srcdir%\testfiles\txtfp32.conf -o txtfp32.h5

    set testing=ASCII F64 - rank 3 - Output BE + CHUNKED+Extended+Compressed
    call :tooltest %srcdir%\testfiles\txtfp64.txt -c %srcdir%\testfiles\txtfp64.conf -o txtfp64.h5

    set testing=BINARY F64 - rank 3 - Output LE+CHUNKED+Extended+Compressed
    call :tooltest binfp64.bin -c %srcdir%\testfiles\binfp64.conf -o binfp64.h5

    set testing=BINARY I16 - rank 3 - Output order LE + CHUNKED + extended
    call :tooltest binin16.bin -c %srcdir%\testfiles\binin16.conf -o binin16.h5

    set testing=BINARY I8 - rank 3 - Output I16LE + Chunked+Extended+Compressed
    call :tooltest binin8.bin -c %srcdir%\testfiles\binin8.conf  -o binin8.h5

    set testing=BINARY I32 - rank 3 - Output BE + CHUNKED
    call :tooltest binin32.bin -c %srcdir%\testfiles\binin32.conf -o binin32.h5

    set testing=BINARY UI16 - rank 3 - Output byte BE + CHUNKED
    call :tooltest binuin16.bin -c %srcdir%\testfiles\binuin16.conf -o binuin16.h5

    set testing=BINARY UI32 - rank 3 - Output LE + CHUNKED
    call :tooltest binuin32.bin -c %srcdir%\testfiles\binuin32.conf -o binuin32.h5

    set testing=STR 
    call :tooltest %srcdir%\testfiles\txtstr.txt -c %srcdir%\testfiles\txtstr.conf -o txtstr.h5

    set testing=BINARY I8 CR LF EOF
    call :tooltest binin8w.bin -c %srcdir%\testfiles\binin8w.conf -o binin8w.h5
    
    set testing=ASCII F64 - rank 1 - INPUT-CLASS TEXTFPE 
    call :tooltest %srcdir%\testfiles\textpfe64.txt -c %srcdir%\testfiles\textpfe.conf -o textpfe.h5


    del /f *.txt *.bin *.h5
    rmdir /s /q tmp_testfiles
    
    ) else (
        echo.** h5importtest not avaiable ***
        set /a errors=!errors!+1
    )
    ) else (
        echo.** h5import not avaiable ***
        set /a errors=!errors!+1
    )
    
    rem
    rem Check error results
    if %errors% equ 0 (
        echo.======================================
        echo. H5IMPORT Utilities tests have passed.
        echo.======================================
    ) else (
        echo.======================================
        echo. H5IMPORT Utilities tests encountered errors
        echo.======================================
    )
    
    popd
    endlocal & exit /b %errors%
    
