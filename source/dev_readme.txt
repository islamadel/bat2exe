Readme for Developers
By: Islam Adel
------------------------------------------------------

V. 1.8 64-bit

- Replaced 7z.dll, 7z.exe, 7zSD.sfx with version 9.20 + Extras
  
- Replaced RCEDIT by RCEDIT64

- Apply manifest compatibility:
  #https://github.com/eladkarako/mt/tree/master/x64
  mt.exe -manifest manifest.xml -outputresource:"7zS.sfx;#1

- Apply Version Info with Resource H.
- Apply Default icon with RCEDIT64
  #https://sourceforge.net/projects/winrun4j/
------------------------------------------------------

V. 1.9 64-bit (Not released)

- Original 7sSD.sfx (9.20)

- Apply manifest compatibility:
  #https://github.com/eladkarako/mt/tree/master/x64
  mt.exe -manifest manifest.xml -outputresource:"7zS.sfx;#1

- Edit File Info and Icon with RESEDIT
  #http://www.resedit.net/

------------------------------------------------------

V. 2.0 64-bit (2020-02-16)

Using Rcedit v0.2.0
#https://github.com/electron/rcedit/releases

rcedit-x64.exe <file.sfx> <parameter>

--application-manifest manifest.xml
--set-icon bat2exe.ico
--set-version-string CompanyName "Islam Adel"
--set-version-string FileDescription "Created by BAT2EXE.net"
--set-version-string FileVersion 2.1
--set-version-string InternalName bat2exe.exe
--set-version-string LegalCopyright "Islam Adel"
--set-version-string OriginalFilename bat2exe.exe
--set-version-string ProductName BAT2EXE
--set-version-string ProductVersion 2.1
--set-file-version 2.1
--set-product-version 2.1
------------------------------------------------------

Example 1:

L:\Downloads\bat2exe-2.1\source\workspace\bin\rcedit-x64.exe L:\Downloads\bat2exe-2.1\source\workspace\bin\7zS2.sfx --application-manifest L:\Downloads\bat2exe-2.1\source\manifest.xml --set-icon L:\Downloads\bat2exe-2.1\source\icons\bat2exe.ico --set-version-string CompanyName "Islam Adel" --set-version-string FileDescription "Created by BAT2EXE.net" --set-version-string FileVersion 2.1 --set-version-string InternalName bat2exe.exe --set-version-string LegalCopyright "Islam Adel" --set-version-string OriginalFilename bat2exe.exe --set-version-string ProductName BAT2EXE --set-version-string ProductVersion 2.1 --set-file-version 2.1 --set-product-version 2.1

Example 2:

L:\Downloads\bat2exe-2.1\source\workspace\bin\rcedit-x64.exe L:\Downloads\bat2exe-2.1\source\workspace\bin\7zS2.sfx --application-manifest L:\Downloads\bat2exe-2.1\source\manifest.xml --set-icon L:\Downloads\bat2exe-2.1\source\icons\bat2exe.ico --set-version-string FileDescription "Created by BAT2EXE.net" --set-version-string FileVersion 2.1 --set-version-string ProductVersion 2.1 --set-file-version 2.1 --set-product-version 2.1 --set-version-string LegalCopyright ""

------------------------------------------------------

Notes:

Exclude:

--set-version-string LegalCopyright "Islam Adel"

------------------------------------------------------

- What to include when updating version?

bat2exe.cmd
bat2exe.ico

bin\7z.dll (Source: https://7-zip.de/)
bin\7z.exe (Source: https://7-zip.de/)
bin\7ZS2.sfx (Source: https://7-zip.org/a/7z920_extra.7z)
bin\browse.vbs
bin\choice.exe
bin\rcedit-x64.exe (Source: https://github.com/electron/rcedit/)

------------------------------------------------------
