$outputFolder = "dist"
$mainFolder = [IO.Directory]::GetCurrentDirectory()


$dirs = [IO.Directory]::GetDirectories($mainFolder, "legacy_fabric_*")
foreach($dir in $dirs)
{
    echo "" "-----------------------------------------------------------------------"
    cd $dir

    $dirName = [IO.Path]::GetFileName($dir)
    $zipPath = [IO.Path]::Combine($mainFolder, $outputFolder, ($dirName + ".zip"))
    7z a -tzip $zipPath *
    cd ..
}

echo "" "Finished"
