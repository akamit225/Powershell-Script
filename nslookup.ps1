Write-host "**NSLOOKUP SCRIPT**" -ForegroundColor DarkYellow
$hostname = Get-Content \\goldbar.barrick.com\VDIPersona\Redirected\amkumar\Downloads\NSLOOKUP\HOSTNAME.txt
$i=1
$array = @()

foreach($ht in $hostname){
    Write-Host "Loop"$i">> Lookup '"$ht"'"
    try{
        $res = nslookup $ht
        $res_host=$res[3].Split(" ").split(".")[4]
        $res_ip =$res[4].split(" ")[2]
        $result = $res_host+","+$res_ip
        $array += $result
    }
    catch{   Write-Host "Lookup Failed" -ForegroundColor Green   }
    finally{    }    
    $i+=1
    }

try{
    $array|out-file \\goldbar.barrick.com\VDIPersona\Redirected\amkumar\Downloads\NSLOOKUP\nslookup_result.csv
}

catch{ Write-Host $PSItem.Exception.Message -ForegroundColor RED }
finally{}

