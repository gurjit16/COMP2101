param ( 
[switch]$System, 
[switch]$Disks, 
[switch]$Network)

if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
  get-hardwareinfo  
  get-osinfo
  get-processor
  get-memory
  get-disks
  get-network
  get-video
}
elseif ($System) {   
  get-hardwareinfo  
  get-osinfo
  get-processor
  get-memory
  get-video
}
elseif ($Disks) { 
  get-disks
}
elseif ($Network) { 
  get-network
}
