$instanceId = (Invoke-RestMethod -Method Get -Uri http://169.254.169.254/latest/meta-data/instance-id).Trim()

Rename-Computer $instanceId
Restart-Computer
