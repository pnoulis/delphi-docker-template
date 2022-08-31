. ".\scripts\paths.ps1"
$config = Get-Content -Path (Join-Path $srcTree.config "config.json") | ConvertFrom-Json

#$config.version = (incrBuildVersion $config.version)
incrBuildVersion $config
makeContainers $config
write-output ($config | ConvertTo-Json)


# function runContainers {
#     foreach ($container in $config.docker) {
#         docker run -d -p "$([int]$container.port):1433" `
#         --mount type=bind,source=(Join.path($Srctree.var, "docker/mnt/"))
#         --name ($container.name) ($container.image)
#     }
# }

# runContainers $config