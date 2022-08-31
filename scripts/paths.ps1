# project root
$srcTree = @{
    root = split-path -parent $PSCommandPath | Split-path -parent
}

# turn hashtable into an object so that members can be added
$srcTree = [pscustomobject]$srcTree

# src
$srcTree | Add-Member -MemberType NoteProperty -Name "src" -Value (Join-Path $srcTree.root "src")

# build
$srcTree | Add-Member -MemberType NoteProperty -Name "build" -Value (Join-Path $srcTree.root "build")

# config
$srcTree | Add-Member -MemberType NoteProperty -Name "config" -Value (Join-Path $srcTree.root "config")

# var
$srcTree | Add-Member -MemberType NoteProperty -Name "var" -Value (Join-Path $srcTree.root "var")

# databases
$srcTree | Add-Member -MemberType NoteProperty -Name "databases" -Value (Join-Path $srcTree.config "databases")

function incrBuildVersion {
    param (
        [PSCustomObject]$config
    )
    # Semantic versioning
    # Major.Minor.Release.Build
    [string]$build = ++[int]$config.version.split('.')[3]
    $config.version = ($config.version -replace "\d+$", $build)
}

function dos2unixPath {
    param (
        [string]$dos
    )
    return ($dos -replace "\\", "/")
}

 function makeName {
    param (
        [PSCustomObject]$container,
        [PSCustomObject]$config
    )
    return "$($config.name + '-v' + $config.version + '.' + $container.service)"
}

function makeMount {
    param (
        [PSCustomObject]$container
    )
    $hostMount = dos2UnixPath (Join-Path (Join-Path $srcTree.var "/docker/mnt/") $container.service)
    return "$hostMount$($container.mount)"
}

function makeContainers {
    param (
        [PSCustomObject]$config
    )

    $containers = $config.docker
    foreach ($container in $containers) {
        $container.name = makeName $container $config
        $container.mount = makeMount $container
    }
}

function runContainers {

}