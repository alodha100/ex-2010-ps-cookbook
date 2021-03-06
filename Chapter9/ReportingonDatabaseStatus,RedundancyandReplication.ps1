#example 1:

Get-MailboxDatabaseCopyStatus -Server mbx1 | 
  select Name,Status,ContentIndexState

#example 2:

Get-MailboxDatabaseCopyStatus -Server mbx1 | Format-List

#example 3:

Get-MailboxDatabaseCopyStatus -Identity DB01\MBX1

#example 4:

Get-MailboxDatabaseCopyStatus -Identity DB01\MBX2 `
-ConnectionStatus | Format-List


#example 5:

param(
  $To,
  $From,
  $SMTPServer
)

$DAGs = Get-DatabaseAvailabilityGroup
$DAGs | Foreach-Object{
  $_.Servers | Foreach-Object {
    $test = Test-ReplicationHealth �Identity $_.Name
    $errors = $test | ?{$_.Error}
    if($errors) {
      $errors | Foreach-Object {
        Send-MailMessage -To $To `
	     -From $From `
	     -Subject " Replication Health Error" `
	     -Body $_.Error `
	     -SmtpServer $SMTPServer
      }
    }
  }
}

ReplicationHealth.ps1 -To administrator@contoso.com `
-From sysadmin@contoso.com `
-SMTPServer hc1.contoso.com

#example 6:

Set-Location $exscripts

.\CollectOverMetrics.ps1 -DatabaseAvailabilityGroup DAG `
-ReportPath c:\Reports

#example 7:

Set-Location $exscripts

.\CollectReplicationMetrics.ps1 -DagName DAG `
-Duration '01:00:00' `
-Frequency '00:01:00' `
-ReportPath c:\reports
