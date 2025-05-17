$version = $PSVersionTable.PSVersion
Write-Output "  Powershell v$($version.Major).$($version.Minor).$($version.Patch)"
# function global:prompt {
#     $pwd = $ExecutionContext.SessionState.Path.CurrentLocation
#     $startInfo = New-Object System.Diagnostics.ProcessStartInfo
#     $startInfo.FileName = "powerline-go"
#     $startInfo.Arguments = "-shell bare -modules venv,ssh,cwd,perms,git,hg,jobs,exit,root -theme low-contrast"
#     $startInfo.Environment["TERM"] = "xterm-256color"
#     $startInfo.CreateNoWindow = $true
#     $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
#     $startInfo.RedirectStandardOutput = $true
#     $startInfo.UseShellExecute = $false
#     $startInfo.WorkingDirectory = $pwd
#     $process = New-Object System.Diagnostics.Process
#     $process.StartInfo = $startInfo
#     $process.Start() | Out-Null
#     $standardOut = $process.StandardOutput.ReadToEnd()
#     $process.WaitForExit()
#     $standardOut
# }
Set-PSReadLineOption -PredictionSource History
Set-PoshPrompt -Theme star
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
Invoke-Expression (&starship init powershell)


function cdp() {
    Set-Location A:\Project\
}

$RecallEnabled = Dism /online /Get-FeatureInfo /FeatureName:Recall | findstr /B /C:"State"
If ($RecallEnabled -Match 'State : Enabled') {
    DISM /Online /Disable-Feature /featurename:Recall
}
