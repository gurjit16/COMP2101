function get-hardwareinfo {
"Computer Hardware Inforamtion:"
Get-cimInstance -ClassName Win32_ComputerSystem | fl
}

function get-osinfo{
"OS Information:"
get-CimInstance -ClassName Win32_operatingsystem | fl Name, version
}

function get-processor{
"Processor Information:"
get-WmiObject win32_processor | fl MaxClockSpeed, NumberOfCores, Description, L1CacheSize, L2CacheSize, L3CacheSize
}

function get-memory{
"Physical Memory Information: "
$cap = 0
get-CimInstance -Class win32_physicalmemory |
foreach {
New-Object -TypeName psobject -Property @{
Manufacturer = $_.Manufacturer
Description = $_.description
"Size(GB)" = $_.Capacity/1gb
Bank = $_.banklabel
Slot = $_.Devicelocator
}
$cap += $_.capacity/1gb
} |
fl Description, Manufacturer, Bank, "Size(GB)",Slot
"Total RAM: ${cap}GB"
}

function get-disks{
"Disk-Information:"
$diskdrives = Get-CIMInstance CIM_diskdrive
  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{
			Vendor = $disk.Manufacturer
                        Model=$disk.Model
                        Size=$logicaldisk.Size
                        Freespace=$logicaldisk.FreeSpace
                        PercentageFree=($logicaldisk.Freespace/$logicaldisk.Size)*100
                        }  | fl Vendor, Model, Size, Freespace, PercentageFree                                       
           }      
      } 
  }  
} 

function get-network {
"Network Information"
get-ciminstance win32_networkadapterconfiguration |
Where ipenabled |
Format-Table Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder
}

function get-video {
"Video Description:"
Get-WmiObject -Class Win32_VideoController | 
Select-Object -Property Description,@{Name="CurrentScreenResolution";Expression={ $_.CurrentHorizontalResolution.ToString() + " X " + $_.CurrentVerticalResolution.ToString() }} | fl
}


get-hardwareinfo
get-osinfo
get-processor
get-memory
get-disks
get-network
get-video