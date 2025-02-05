$CWD = (Get-Item .).FullName

$Target = "$CWD/build/bin/janet.exe"
$Deps = @('janet/janet.c', 'janet/janet.h', 'janet/shell.c')

$CFLAGS = "/Fe$Target"
$LDFLAGS = ""
$CLIBS = ""

$BuildJPM = @'
$CWD = (Get-Item ..).FullName
Write-Output "Building JPM in $CWD"
$env:PREFIX = $CWD

$env:JANET_PATH = "$CWD/build"
$env:JANET_HEADERPATH = "$CWD/janet"
$env:JANET_BINPATH = "$CWD/build/bin"
$env:JANET_LIBPATH = "$CWD/build/lib"
$env:JANET_MANPATH = "$CWD/build/man/man1"
../build/bin/janet bootstrap.janet
'@

function Rebuild {
    
    param (
        $Target,
        $Deps
    )

    if (-Not ([System.IO.File]::Exists($Target))) {
        Write-Host "  $Target does not exist, rebuilding"
        return $true
    }

    Write-Host $Target
    Write-Host $Deps

    return $true
}

function BuildJanet {
    $CWD = (Get-Item .).FullName
    mkdir -Force build/bin
    mkdir -Force build/lib
    mkdir -Force build/share/man/man1
    cl.exe $CFLAGS -Ijanet janet/janet.c janet/shell.c $LDFLAGS $CLIBS

    if (-Not ([System.IO.File]::Exists("./jpm"))) {
        git clone https://github.com/janet-lang/jpm 
    }
    cd ./jpm
    git pull origin master
    write-Host "PREFIX=$CWD"
    powershell -File "$CWD/build_jpm.ps1"
    cd $CWD
}

function Build {
    Write-Output "Executing Build"
    if (Rebuild $Target @Deps) {
        Write-Host "rebuilding"
        BuildJanet
    }
}

function Clean {
    Write-Output "Executing Clean"
}

function Watch {
    Write-Output "Executing Watch"
}

function Run {
    Write-Output "Executing Run"
}


function Execute {
    param (
        $arg
    )
    switch ($arg) {
        "build"  {Build; Break}
        "clean"  {Clean; Break}
        "watch"  {Watch; Break}
        "run"    {Run; Break}
        Default  {throw "'$arg': unknown command"}
    }
}

if ($args.Length -eq 0) {
    Execute "build"
} else {
    foreach ($flag in $args) {
        Execute $flag
    }
}

# Rebuild $Target $Deps
