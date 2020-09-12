function GetScore {
   param([string]$ip)

    $uri = "http://www.borderware.com/lookup.php?ip="+$ip+"&ipvalid=&Submit.x=22&Submit.y=15"
    $request =  [System.Net.WebRequest]::Create($uri)
    $response = $request.GetResponse()
    $retVal = @{}
    $stream = $response.GetResponseStream()
    $streamReader = [System.IO.StreamReader]($stream)
    $retVal.Content = $streamReader.ReadToEnd() | Out-File -FilePath .\response.txt
    $streamReader.Close()
    $response.Close()
    $data = Get-Content -Path .\response.txt
    
    return $data[412].Substring(62,2)
}

$IP_List = Get-Content -Path.\"IP_List.txt"
$array = @()
if ((Test-Path .\Reputation_Check_Result.txt) -eq 'True') {
    Clear-Content .\Reputation_Check_Result.txt
}
foreach ($IP in $IP_List) {
     $score = [int](GetScore $IP)
     $result = ($IP+' = '+$score+'/100') 
     if ($score -ge 80){ 
         $array += $result
     }
     else {Write-Output "This is else block",$result
    }
  }
$array|Out-File .\Reputation_Check_Result.txt
if ((Test-Path .\response.txt) -eq 'True') {
    Remove-Item .\response.txt
}
./Reputation_Check_Result.txt

   