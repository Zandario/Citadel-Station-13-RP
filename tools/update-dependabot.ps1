# This is from https://heyko.medium.com/automated-dependabot-configuration-in-github-bb08e2c6eeeb

[CmdletBinding()] # indicate that this is advanced function (with additional params automatically added)
param (
    [string] $outputFile,
    [string] $targetBranch = "main" # default = main
)

$files = Get-Childitem -Recurse

function packageEcosystem() {
    param (
        [string] $ecosystem,
        [string] $relPath,
        [string] $targetBranch = "main", # default = main
        [string] $interval = "daily" # default = every day at 5:00 UTC
    )

    $block = @"
- package-ecosystem: "$ecosystem"
  directory: "$relPath"
  schedule:
    interval: "$interval"
  target-branch: "$targetBranch"
"@

    return $block
}

$output = @"
# This file is auto-generated by tools/update-dependabot.ps1
version: 2
updates:
"@

foreach ($file in $files) {
    $relPath = Resolve-Path -relative $($file.FullName) | Split-Path -Parent
    $relPath = $relPath -replace '\./', '/' # replace leading ./ with /

    if ($file.Name -eq 'main.tf') {
        Write-Host "Found main.tf in $($file.FullName)"
        $ecosystem = "terraform"
        $block = packageEcosystem -ecosystem $ecosystem `
                                  -relpath $relPath `
                                  -targetBranch "$targetBranch"
        $output += "`r`n"+$block
    } elseif ($file.Name -eq 'Dockerfile') {
        Write-Host "Found Dockerfile in $($file.FullName)"
        $ecosystem = "docker"
        $block = packageEcosystem -ecosystem $ecosystem `
                                  -relpath $relPath `
                                  -targetBranch "$targetBranch"
        $output += "`r`n"+$block
    } elseif ($file.Name -eq 'package.json') {
        Write-Host "Found package.json in $($file.FullName)"
        $ecosystem = "npm"

        $block = packageEcosystem -ecosystem $ecosystem `
                                  -relpath $relPath `
                                  -targetBranch "$targetBranch"

        # NPM uses a customized package-ecosystem block
        $block += "`r`n"+@"
  allow:
  - dependency-type: direct
  - dependency-type: production # check only dependencies, which are going to the compiled app, not supporting tools like @vue-cli
"@
        $output += "`r`n"+$block
    } elseif ($file.Name -like '*.sln') {
        Write-Host "Found *.sln in $($file.FullName)"
        $ecosystem = "nuget"
        $block = packageEcosystem -ecosystem $ecosystem `
                                  -relpath $relPath `
                                  -targetBranch "$targetBranch"
        $output += "`r`n"+$block
    }
}

if ($outputFile -ne "") {
    Write-Host "*** Writing output to $outputFile"
    $output | Out-file -FilePath $outputFile -Encoding UTF8
} else {
    Write-Host $output
}
