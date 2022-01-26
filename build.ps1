# This script compresses the contents of the directories "legacy_fabric_*" 
# and creates the corresponding zip files in "dist".
# In order for this script to run, 7zip must be added to the system path.

$rootDir = [IO.Directory]::GetCurrentDirectory()
$inputDir = [IO.Path]::Combine($rootDir, "src")
$outputDir = [IO.Path]::Combine($rootDir, "dist")

$dirs = [IO.Directory]::GetDirectories($inputDir, "legacy_fabric_*")
foreach ($dir in $dirs) {
    Write-Output "" "-------------------------------------------------------------------------"
    Set-Location $dir

    $dirName = [IO.Path]::GetFileName($dir)
    $zipPath = [IO.Path]::Combine($inputDir, $outputDir, ($dirName + ".zip"))
    7z a -tzip $zipPath *
}

Set-Location $rootDir
Write-Output "" "Finished"
