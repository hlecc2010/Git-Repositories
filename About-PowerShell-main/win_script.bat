@echo off
REM iScan Online Windows CLI Batch File
REM Copyright 2015 iScan Online, Inc. All rights reserved
REM https://www.iscanonline.com

echo # begin powershell script > iscan.ps1
echo $rtFile = "%TEMP%/iscan/iscanruntime.exe" >> iscan.ps1
echo $rtFile = $rtFile -replace "\\", "/" >> iscan.ps1
echo if ((Test-Path %TEMP%/iscan) -eq 0) { >> iscan.ps1
echo    mkdir %TEMP%/iscan >> iscan.ps1
echo    if ((Test-Path %TEMP%/iscan) -eq 0) { >> iscan.ps1
echo        Write-Host "Failed to create iscan temp directory" >> iscan.ps1
echo        Exit 3 >> iscan.ps1
echo    } >> iscan.ps1
echo } >> iscan.ps1

echo Function Get-MD5Hash($fileName) { >> iscan.ps1
echo  if([System.IO.File]::Exists($fileName)) { >> iscan.ps1
echo   $fileStream = New-Object System.IO.FileStream($fileName,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite) >> iscan.ps1
echo   $MD5Hash = New-Object System.Security.Cryptography.MD5CryptoServiceProvider >> iscan.ps1
echo   [byte[]]$fileByteChecksum = $MD5Hash.ComputeHash($fileStream) >> iscan.ps1
echo   $fileChecksum = ([System.Bitconverter]::ToString($fileByteChecksum)).Replace("-","") >> iscan.ps1
echo   $fileStream.Close() >> iscan.ps1
echo  } else { >> iscan.ps1
echo   $fileChecksum = "ERROR: $fileName Not Found" >> iscan.ps1
echo  } >> iscan.ps1
echo  return $fileChecksum.ToLower() >> iscan.ps1
echo } >> iscan.ps1

echo Function download-iScanRuntime($localPath) { >> iscan.ps1
echo 		$httpClient = New-Object System.Net.WebClient >> iscan.ps1
echo 		$httpClient.DownloadFile("https://app.ri.logicnow.com/download/iscanruntime.exe",$localPath) >> iscan.ps1
echo		If (Test-Path $localPath) { >> iscan.ps1
echo			$md5 = Get-MD5Hash($localPath) >> iscan.ps1
echo			return $md5 >> iscan.ps1
echo 		} >> iscan.ps1
echo		return "" >> iscan.ps1
echo } >> iscan.ps1


echo $https = New-Object System.Net.WebClient >> iscan.ps1
echo $serverMD5 = $https.DownloadString("https://app.ri.logicnow.com/download_md5/iscanruntime.exe") >> iscan.ps1

echo $FileExists = Test-Path $rtFile >> iscan.ps1
echo If ($FileExists) { >> iscan.ps1
echo 	$md5 = Get-MD5Hash($rtFile) >> iscan.ps1
echo	Write-Host "Verifying Security of Existing File " $md5 >> iscan.ps1
echo 	if ($serverMD5.CompareTo($md5) -ne 0) { >> iscan.ps1
echo		$md5 = download-iScanRuntime($rtFile) >> iscan.ps1
echo 		if ($serverMD5.CompareTo($md5) -ne 0) { >> iscan.ps1
echo			Write-Host "Could not update iscan runtime to latest version" >> iscan.ps1
echo			Exit 1 >> iscan.ps1
echo 		} >> iscan.ps1
echo	} >> iscan.ps1
echo } else { >> iscan.ps1
echo	$md5 = download-iScanRuntime($rtFile) >> iscan.ps1
echo	Write-Host "Checking file security : " $md5 >> iscan.ps1
echo 	if ($serverMD5.CompareTo($md5) -ne 0) { >> iscan.ps1
echo		Write-Host "Could not download iscan runtime" >> iscan.ps1
echo		Exit 2 >> iscan.ps1
echo 	} >> iscan.ps1
echo } >> iscan.ps1


echo Write-Host "Launching Scan" >> iscan.ps1
echo $params = "-u https://app.ri.logicnow.com -k VDKGGJV" >> iscan.ps1
echo $rtFile = $rtFile -replace "/", "\" >> iscan.ps1
echo $exeFile = $rtFile + ' ' + $params >> iscan.ps1
echo iex $exeFile >> iscan.ps1

powershell -executionpolicy bypass -file "iscan.ps1"
del iscan.ps1



