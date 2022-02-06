# This script generates the instances and creates the zip files in "dist".
# In order for this script to run, 7zip must be added to the system path.

$rootDir = $PWD
$inputDir = Join-Path $rootDir "src"
$outputDir = Join-Path $rootDir "dist"
$baseInstanceDir = Join-Path $inputDir "lf_instance_base"
$baseInstanceFiles = Get-ChildItem $baseInstanceDir -Recurse | Where-Object { ! $_.PSIsContainer }

function GenerateVersion($mc_version, $loader_version, $lwjgl_cachedName, $lwjgl_uid, $lwjgl_version, [switch]$ignorePatchs = $false) {
    $instanceOutDir = Join-Path $inputDir ("legacy_fabric_" + $mc_version)
    foreach ($inputFile in $baseInstanceFiles) {

        # get relativ filepath and create directories
        Set-Location $baseInstanceDir
        $relativeFilePath = Get-Item $inputFile.FullName | Resolve-Path -Relative
        $outputFile = Join-Path $instanceOutDir $relativeFilePath
        [Collections.ArrayList]$directories = $outputFile.Split([IO.Path]::DirectorySeparatorChar)
        $directories.RemoveAt($directories.Count - 1)
        if ($ignorePatchs -eq $true -and $directories[$directories.Count - 1] -eq "patches") {
            continue
        }
        $directory = $directories -join [IO.Path]::DirectorySeparatorChar
        New-Item -ItemType Directory -Force -Path $directory

        # insert values in text files and copy other files
        if ($inputFile.Name.EndsWith(".cfg") -or $inputFile.Name.EndsWith(".json")) {
            $content = Get-Content -Path $inputFile.FullName

            for ($i = 0; $i -lt $content.Count; $i++) {
                $content[$i] = $content[$i] -replace "{mc_version}", $mc_version
                $content[$i] = $content[$i] -replace "{loader_version}", $loader_version
                $content[$i] = $content[$i] -replace "{lwjgl_cachedName}", $lwjgl_cachedName
                $content[$i] = $content[$i] -replace "{lwjgl_uid}", $lwjgl_uid
                $content[$i] = $content[$i] -replace "{lwjgl_version}", $lwjgl_version
            }
    
            Set-Content -Path $outputFile -Value $content
        }
        else {
            Copy-Item -Path $inputFile -Destination $outputFile -Force
        }
    }
}

# to update the loader just change this line and run the script
$loaderVersion = "0.13.1"

GenerateVersion -mc_version "1.13.2" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 3" -lwjgl_uid "org.lwjgl3" -lwjgl_version "3.1.6"
GenerateVersion -mc_version "1.12.2" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209"
GenerateVersion -mc_version "1.11.2" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209"
GenerateVersion -mc_version "1.10.2" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209"
GenerateVersion -mc_version "1.9.4" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209"
GenerateVersion -mc_version "1.8.9" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209"
GenerateVersion -mc_version "1.7.10" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209"
GenerateVersion -mc_version "1.6.4" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209"
GenerateVersion -mc_version "1.5.2" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209" -ignorePatchs
GenerateVersion -mc_version "1.4.7" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209" -ignorePatchs
GenerateVersion -mc_version "1.3.2" -loader_version $loaderVersion -lwjgl_cachedName "LWJGL 2" -lwjgl_uid "org.lwjgl" -lwjgl_version "2.9.4-nightly-20150209" -ignorePatchs

# create instance zips
$instanceDirs = Get-ChildItem $inputDir "legacy_fabric_*"
foreach ($dir in $instanceDirs) {
    Write-Output "" "-------------------------------------------------------------------------"
    Set-Location $dir.FullName

    $zipPath = Join-Path $outputDir ($dir.Name + ".zip")
    7z a -tzip $zipPath *
}

Set-Location $rootDir
Write-Output "" "Finished creating instances!"
