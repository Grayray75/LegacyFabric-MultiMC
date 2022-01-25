# This script compresses the contents of the directories "legacy_fabric_*" 
# and creates the corresponding zip files in "dist".
# In order for this script to run, 7zip must be added to the system path.

$outputFolder = "dist"
$mainFolder = [IO.Directory]::GetCurrentDirectory()

$dirs = [IO.Directory]::GetDirectories($mainFolder, "legacy_fabric_*")
foreach ($dir in $dirs) {
    Write-Output "" "-------------------------------------------------------------------------"
    Set-Location $dir

    $dirName = [IO.Path]::GetFileName($dir)
    $zipPath = [IO.Path]::Combine($mainFolder, $outputFolder, ($dirName + ".zip"))
    7z a -tzip $zipPath *
    Set-Location ..
}

Write-Output "" "Finished"
