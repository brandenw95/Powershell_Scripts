@echo off
REM Get the directory of the batch script
SET "scriptPath=%~dp0"

REM Remove the trailing backslash
SET "scriptPath=%scriptPath:~0,-1%"

REM Use the tree command to map the directory structure to a text file
tree "%scriptPath%" /f /a > "%scriptPath%\DirectoryStructure.txt"

REM Optionally, echo the output file path
echo Directory structure and file list saved to: "%scriptPath%\DirectoryStructure.txt"
