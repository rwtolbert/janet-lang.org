$CWD = (Get-Item ..).FullName
Write-Output "Building JPM in $CWD"
$env:PREFIX = "$CWD"

$BuildDir = "$CWD/build"
$env:JANET_PATH = "$BuildDir"
$env:JANET_HEADERPATH = "$CWD/janet"
$env:JANET_BINPATH = "$CWD/build/bin"
$env:JANET_LIBPATH = "$CWD/build/lib"
$env:JANET_MANPATH = "$CWD/build/man/man1"
../build/bin/janet bootstrap.janet
../build/bin/jpm install spork
../build/bin/jpm install mendoza