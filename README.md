# Channel F starterprojekt

Placera mappen som:

```text
C:\ChannelFDev\
├─ tools\
│  ├─ dasm\dasm.exe
│  └─ mame\
│     ├─ mame.exe
│     └─ roms\channelf.zip
└─ hello\
   ├─ main.asm
   ├─ build.bat
   ├─ run.bat
   └─ debug.bat
```

`channelf.zip` ska innehålla BIOS-filerna `sl31253.rom` och `sl31254.rom` från din egen lagliga dump.

## Kör

- Dubbelklicka på `run.bat` för att bygga och starta ROM-filen.
- Dubbelklicka på `debug.bat` för att starta MAMEs debugger.
- Den byggda ROM-filen och listfilen hamnar i `build`.

Förväntat resultat är en grå skärm och därefter en oändlig loop.
