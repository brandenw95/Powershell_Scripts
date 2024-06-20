# Define the webhook URL
$webhookUrl = "https://webhook-test.com/03e87fd28d34b4b5e6a980f26c691b17"

# Define the payload data
$payload = @{
    text = "Hello, this is a test message from PowerShell!"
    username = "PowerShellBot"
    icon_emoji = ":robot_face:"
} | ConvertTo-Json

# Send the webhook
$response = Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "application/json" -Body $payload

# Output the response
$response
