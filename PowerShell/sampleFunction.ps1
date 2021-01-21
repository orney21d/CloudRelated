function CreateElasticSqlJobResources {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ElasticJobAgentName,

        [Parameter(Mandatory)]
        [string]$ElasticJobDataBaseDefinition,

        [Parameter(Mandatory)]
        [string]$ElasticJobResourceGroupName ,

        [Parameter(Mandatory)]
        [string]$ElasticJobServerName
    )
    process {

        try {


            Write-Output "--INI--Create ElasticJobAgentName's: '$ElasticJobAgentName'--- ElasticJobDataBaseDefinition's : '$ElasticJobDataBaseDefinition'---ElasticJobResourceGroupName's :  '$ElasticJobResourceGroupName' ---ElasticJobServerName's: '$ElasticJobServerName'."

            #New-AzSqlElasticJobAgent -DatabaseName $ElasticJobDataBaseDefinition -Name $ElasticJobAgentName -ResourceGroupName $ElasticJobResourceGroupName -ServerName $ElasticJobServerName

            Write-Output "--END--Create ElasticJobAgentName's: '$ElasticJobAgentName'--- ElasticJobDataBaseDefinition's : '$ElasticJobDataBaseDefinition'---ElasticJobResourceGroupName's :  '$ElasticJobResourceGroupName' ---ElasticJobServerName's: '$ElasticJobServerName'."

            Write-Output "--INI--Create ElasticJob'S Credentials --"

            Write-Output "--END--Create ElasticJob'S Credentials --"


        }
        catch {
            Write-Error $_.Exception.Message
        }

    }
}

$params = @{ 'ElasticJobAgentName' = 'orney-elasticJobAgentTestMigDevUat';
             'ElasticJobDataBaseDefinition'='ElasticJobDataBaseDefinition';
             'ElasticJobResourceGroupName'='rgp-p-we1-aziredevops-net-dev';
             'ElasticJobServerName'='dev-azire' }

$ElasticJobAgentName = "orney-elasticJobAgentTestMigDevUat"
$ElasticJobDataBaseDefinition = 'JobDB'
$ElasticJobResourceGroupName = 'rgp-p-we1-aziredevops-net-dev'
$ElasticJobServerName = 'dev-azire'

#Creating
CreateElasticSqlJobResources @params

-ElasticJobAgentName

$ElasticJobAgentName
 -ElasticJobDataBaseDefinition $ElasticJobDataBaseDefinition ElasticJobResourceGroupName $ElasticJobResourceGroupName -ElasticJobServerName $ElasticJobServerName
