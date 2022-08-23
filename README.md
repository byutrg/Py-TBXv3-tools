# TBX Tool Suite

This repository contains many files related to the development of the TBXv3 tool suite. To run the tool suite double click "integratedValidator.exe" and follow the instructions for each respective tool.

IMPORTANT: This project is under active development and may cease functioning with or without warning. If you would like to continue using the current version please keep a local copy as well to ensure it is not changed.

## Validator

This will validate a TBXv3 file to your desired dialect.
Simply click "Browse" to select a file and pick your dialect
After clicking "Validate!" either an error message describing the broken rul wll appear or a success message

## Steamroller

This tool will change tbx files from a custom dialect into tbx-basic by integrating unknown fields into notes.
Select your file and click "Steamroll!" to run the output will be in the directory running the app and the file name will be <yourfilename> + Steamroller.tbx

## Upgrade

This will upgrade TBXv2 files into TBXv3. This is a work in progress and may not run correctly if at all. Your mileage may vary

---

## TODOS

- log file management improvements
- better error reporting
- updater polishing
