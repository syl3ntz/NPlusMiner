if (!(IsLoaded(".\Includes\include.ps1"))) {. .\Includes\include.ps1; RegisterLoaded(".\Includes\include.ps1")}
 
$Path = ".\Bin\NVIDIA-Bminer\bminer.exe"
$Uri = "https://www.bminercontent.com/releases/bminer-lite-v14.3.1-8d9471b-amd64.zip"
$Commands = [PSCustomObject]@{
    #"equihashBTG" = " -uri zhash://" #EquihashBTG(miniZ faster)
    #"equihash" = " -uri stratum://" #Equihash(Asic)
    #"equihash144" = " -pers auto -uri equihash1445://" #Equihash144(gminer faster)
    #"zhash" = " -pers auto -uri equihash1445://" #Zhash(gminer faster)
    #"ethash" = " -uri ethstratum://" #Ethash(ethminer faster)
    # "aeternity" = " -uri aeternity://" #aeternity(testing)
    # "beam" = " -uri beam://" #beam(testing)
    # "grin" = " -uri cuckaroo29://" #Grin(testing)
}
$Port = $Variables.NVIDIAMinerAPITCPPort
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    $Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "$($Commands.$_)$($Pools.($Algo).User):$($Pools.($Algo).Pass.ToString().replace(',','%2C'))@$($Pools.($Algo).Host):$($Pools.($Algo).Port) -max-temperature 94 -nofee -devices $($Config.SelGPUCC) -api 127.0.0.1:$Port"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day}
        API       = "bminer"
        Port      = $Port
        Wrap      = $false
        URI       = $Uri    
        User = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin
    }
}
