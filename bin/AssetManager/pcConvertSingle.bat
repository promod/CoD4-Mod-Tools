@echo off

rem %1 = asset type
rem %2 = asset name


::::::::::::::::::::::::::::::::::::
:: Run Converter
::::::::::::::::::::::::::::::::::::
converter -nocachedownload -single %1 %2
