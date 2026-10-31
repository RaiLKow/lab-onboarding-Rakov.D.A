@echo off
chcp 65001 >nul
REM ============================================================
REM Тема: Диагностика клиентского компьютера
REM Автор: Иванов И.И.
REM Дата: 26.10.2026
REM ============================================================

set "REPORT=%~dp0pc_report.txt"

REM --- Заголовок ---
echo Диагностика компьютера
echo ============================================================
echo Диагностика компьютера > "%REPORT%"
echo ============================================================ >> "%REPORT%"

REM --- Операционная система ---
echo.
echo Операционная система
wmic os get Caption,Version /format:list | findstr /r /v "^$" > "%TEMP%\os.tmp"
for /f "tokens=1,* delims==" %%a in ('type "%TEMP%\os.tmp"') do (
    echo %%a: %%b
    echo %%a: %%b >> "%REPORT%"
)
del "%TEMP%\os.tmp"

REM --- Процессор ---
echo.
echo Процессор
for /f "skip=1 tokens=* delims=" %%a in ('wmic cpu get Name ^| findstr /r /v "^$"') do (
    set "CPU=%%a"
    goto :cpu_done
)
:cpu_done
echo Название: %CPU%
echo Процессор: %CPU% >> "%REPORT%"

REM --- Оперативная память ---
echo.
echo Оперативная память
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value') do set TOTAL_KB=%%a
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /value') do set FREE_KB=%%a

set TOTAL_KB=%TOTAL_KB: =%
set FREE_KB=%FREE_KB: =%

set /a TOTAL_GB=%TOTAL_KB% / 1048576
set /a FREE_GB=%FREE_KB% / 1048576
echo Всего памяти: %TOTAL_GB% ГБ
echo Свободно памяти: %FREE_GB% ГБ
echo Всего памяти: %TOTAL_GB% ГБ >> "%REPORT%"
echo Свободно памяти: %FREE_GB% ГБ >> "%REPORT%"

REM --- Диск C ---
echo.
echo Диск C

for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value') do set SIZE_B=%%a
set SIZE_B=%SIZE_B: =%
set SIZE_B=%SIZE_B:~0,9%

for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value') do set FREE_B=%%a
set FREE_B=%FREE_B: =%
set FREE_B=%FREE_B:~0,9%

set /a SIZE_GB=%SIZE_B% / 1073741
set /a FREE_DISK_GB=%FREE_B% / 1073741

echo Всего места: %SIZE_GB% ГБ
echo Свободно места: %FREE_DISK_GB% ГБ
echo Диск C — всего: %SIZE_GB% ГБ >> "%REPORT%"
echo Диск C — свободно: %FREE_DISK_GB% ГБ >> "%REPORT%"

REM --- Установленные программы ---
echo.
echo Установленные программы
echo Идёт поиск программ, это может занять несколько минут...
echo Установленные программы >> "%REPORT%"
echo ---------------------------------------- >> "%REPORT%"

for /f "tokens=2*" %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    echo %%b
    echo %%b >> "%REPORT%"
)
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    echo %%b
    echo %%b >> "%REPORT%"
)

REM --- Завершение ---
echo.
echo Отчёт сохранён: %REPORT%
echo Отчёт сохранён >> "%REPORT%"
pause