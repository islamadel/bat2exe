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

- What to include when updating version?

bat2exe.cmd
bat2exe.ico

bin\7z.dll
bin\7z.exe
bin\7ZSD.sfx
bin\browse.vbs
bin\choice.exe
bin\RCEDIT64.exe

------------------------------------------------------
