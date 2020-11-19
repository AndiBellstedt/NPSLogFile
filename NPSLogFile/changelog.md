# Changelog
## 1.0.0.1 (2020-11-18)
- No functional changes
- Fix: Fixing some typos
- Fix: Remove files and command depend on PSFramework
- Upd: Add plattform and statistic information to readme file

## 1.0.0 Inital module release
- New: Get-NPSLog

- Published Version 1.0.0.0 as the initial online available release of NPSLogFile. History:
    - 06.08.2017 - First Version, only DTS format is supported.
    - 13.08.2017 - Change/enhance filter method
    - 20.08.2017 - Add runspace processing for faster support of larger files Clearing up the function and building a module
    - 22.08.2017 - remove not needed code and outcommended test stuff
    - 27.08.2017 - Change processing of file content
        - Using type system to speed up record processing.
        - Add name of the logfile as property to output item
        - Finished funtion for reading DTS logs.
        - Start to work on IAS format support.
    - 31.08.2017 - Start working on IDBC format support
    - 01.09.2017 - All formats are working.
