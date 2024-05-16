Set-ExecutionPolicy Unrestricted

<#
--- Change services to run under the current user and start the services
#>
# Getting the arguments from the calling script and prepending the username
$myUsername = '.\'+$Args[0]
$myPassword = $Args[1]

# Stop, set and start the services
$kobeeServices = @('Tomcat9','kobeesvr60','kobeeagent60')

foreach ($i in $kobeeServices) {
  $svc=gwmi win32_service -filter "name='$i'"
  $svc.StopService()
  $svc.change($null,$null,$null,$null,$null,$null,$myUsername,$myPassword,$null,$null,$null)
  $svc.StartService()
}


<#
--- Add Git user
#>
git config --global user.email "gituser@localhost"
git config --global user.name "gituser"


<#
--- Create shortcuts
#>
$Shell = New-Object -ComObject ("WScript.Shell")

$ShortCut = $Shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Kobee.lnk")
$ShortCut.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$ShortCut.Arguments = "http://localhost:8080/alm/"
$ShortCut.WorkingDirectory = "C:\Program Files (x86)\Microsoft\Edge\Application\"
$ShortCut.WindowStyle = 1
$ShortCut.IconLocation = "C:\ikan\kobee-icon.ico, 0"
$ShortCut.Save()

$ShortCutVSCode = $Shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio Code.lnk")
$ShortCutVSCode.TargetPath = "C:\ide\Microsoft VS Code\Code.exe"
$ShortCutVSCode.Arguments = "C:\ikan\workspace\demozos"
$ShortCutVSCode.WorkingDirectory = "C:\ide\Microsoft VS Code"
$ShortCutVSCode.WindowStyle = 1
$ShortCutVSCode.IconLocation = "C:\ide\Microsoft VS Code\Code.exe, 0"
$ShortCutVSCode.Save()

$ShortCut = $Shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Kobee Resource Configurator.lnk")
$ShortCut.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$ShortCut.Arguments = "http://localhost:8082/krc/"
$ShortCut.WorkingDirectory = "C:\Program Files (x86)\Microsoft\Edge\Application\"
$ShortCut.WindowStyle = 1
$ShortCut.IconLocation = "C:\ikan\krc-icon.ico, 0"
$ShortCut.Save()


<#
--- Copy shortcuts to desktop
#>
$commandKobee = @'
cmd.exe /C copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Kobee.lnk" %USERPROFILE%\Desktop
'@
Invoke-Expression -Command:$commandKobee

$commandVS = @'
cmd.exe /C copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio Code.lnk" %USERPROFILE%\Desktop
'@
Invoke-Expression -Command:$commandVS

$commandKRC = @'
cmd.exe /C copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Kobee.lnk" %USERPROFILE%\Desktop
'@
Invoke-Expression -Command:$commandKRC

$commandGuide = @'
cmd.exe /C copy "C:\temp\Guide.url" %USERPROFILE%\Desktop
'@
Invoke-Expression -Command:$commandGuide

$commandLicensePage = @'
cmd.exe /C copy "C:\temp\Request demo license.url" %USERPROFILE%\Desktop
'@
Invoke-Expression -Command:$commandLicensePage


<#
--- Register and import the distro
#>
wsl --set-default-version 1
Add-AppxPackage "C:\ubuntu\Ubuntu_2004.2021.825.0_x64.appx"
$distro = "Ubuntu"
$location = "C:\wsl"
wsl --import $distro $location "C:\temp\Ubuntu-fs.tar"


<#
--- Disable the first run experience in Edge
#>
reg import C:\temp\edge.reg
