$region = "us-west-2"
$apikey = "ApiKey APIKEYGOESHERE"
$tagtoadd = "TAGME"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/vnd.api+json")
$headers.Add("Authorization", "$apikey")

$api = "https://$($region)-api.cloudconformity.com/v1/accounts"
$response = Invoke-RestMethod -Uri $api -Method 'GET' -Headers $headers
$accountstoupdate = $response.data | where-object {$_.attributes.tags -notcontains $tagtoadd}
$accountstoupdate | foreach-object {
$name = $_.attributes.name
$id = $_.id
$tags = ($_.attributes.tags) -join ","
$body = "{
`n    `"data`": {
`n        `"attributes`": {
`n            `"name`": `"$name`",
`n            `"tags`": [$tags, $tagtoadd]
`n        }
`n    }
`n}"
$updateuri = "$($api)/$($id)"
$updateaccount = Invoke-RestMethod -Uri $updateuri -Method 'PATCH' -Headers $headers -Body $body
$updateaccount | ConvertTo-Json
}