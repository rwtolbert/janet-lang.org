$Target = "build/bin/janet.exe"
$Deps = @('janet/janet.c', 'janet/janet.h', 'janet/shell.c')

function Rebuild {
    
    param (
        $Target,
        $Deps
    )

    Write-Host $Target
    Write-Host $Deps

    return $true
}

function Build {
    Write-Output "Executing Build"
    Write-Output Rebuild $Target @Deps
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
