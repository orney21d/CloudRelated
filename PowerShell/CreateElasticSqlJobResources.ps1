function CreateElasticSqlJobResources {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ElasticJobAgentName,

        [Parameter(Mandatory)]
        [string]$ElasticJobDataBaseDefinition,

        [Parameter(Mandatory)]
        [string]$ElasticJobResourceGroupName,

        [Parameter(Mandatory)]
        [string]$ElasticJobServerName,

        [Parameter(Mandatory)]
        [string]$AdminDbMasterUserName,

        [Parameter(Mandatory)]
        [SecureString]$AdminDbMasterPassword,

        [Parameter(Mandatory)]
        [string]$ElasticJobUserName,

        [Parameter(Mandatory)]
        [SecureString]$ElasticJobPassword,

        [Parameter(Mandatory)]
        [string[]]$ElasticJobTargetDBs,

        [Parameter(Mandatory)]
        [string]$ElasticJobCredentialName,

        [Parameter(Mandatory)]
        [string]$ElasticJobTargetGroupName,


        [Parameter(Mandatory)]
        [string]$ElasticJobName,

        [Parameter(Mandatory)]
        [string]$ElasticJobStepName1,

        [Parameter(Mandatory)]
        [string]$ElasticJobStepName1CommandText



    )
    process {

        try {


            Write-Output "***--INI--Create ElasticJobAgentName's: '$ElasticJobAgentName'--- ElasticJobDataBaseDefinition's : '$ElasticJobDataBaseDefinition'---ElasticJobResourceGroupName's :  '$ElasticJobResourceGroupName' ---ElasticJobServerName's: '$ElasticJobServerName'."

            #New-AzSqlElasticJobAgent -DatabaseName $ElasticJobDataBaseDefinition -Name $ElasticJobAgentName -ResourceGroupName $ElasticJobResourceGroupName -ServerName $ElasticJobServerName

            Write-Output "***--END--Create ElasticJobAgentName's: '$ElasticJobAgentName'--- ElasticJobDataBaseDefinition's : '$ElasticJobDataBaseDefinition'---ElasticJobResourceGroupName's :  '$ElasticJobResourceGroupName' ---ElasticJobServerName's: '$ElasticJobServerName'."

            Write-Output "***--INI--Create ElasticJob'S Credentials --"

            # in the master database (target server)
            # The user must be in master db
            $params = @{
                'database'        = 'master'
                'serverInstance'  = "$ElasticJobServerName" + '.database.windows.net'
                'username'        = "$AdminDbMasterUserName"
                'password'        = "$AdminDbMasterPassword"
                'outputSqlErrors' = $true
                'query'           = 'IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name="$(dbUserName)")
                BEGIN
                    CREATE LOGIN $(ElasticJobUserName) WITH PASSWORD="$(ElasticJobPassword)";
                END
                ELSE
                    BEGIN
                        ALTER LOGIN $(ElasticJobUserName) WITH PASSWORD="$(ElasticJobPassword)";
                    END;'
            }
            #Creating the Logging in master db
            Invoke-SqlCmd @params
            #Creating the user mapped to the logging
            $params.query = "IF USER_ID($(ElasticJobUserName)) IS NULL
                        CREATE USER $(ElasticJobUserName) FOR LOGIN $(ElasticJobUserName);"
            Invoke-SqlCmd @params

            #   $db1 = @{
            #     'DatabaseName' = $ElasticJobTargetDB
            #   }

            # for each target database
            # create the jobuser from jobuser login and check permission for script execution
            #   $targetDatabases = @( $db1.DatabaseName )
            # $createJobUserScript =  "CREATE USER jobuser FROM LOGIN jobuser"
            #   $grantAlterSchemaScript = "GRANT ALTER ON SCHEMA::dbo TO elasticjob"
            #   $grantCreateScript = "GRANT CREATE TABLE TO elasticjob"

            # $ElasticJobTargetDBs | % {
            #     $params.database = $_
            #     $params.query = $grantAlterSchemaScript
            #     Invoke-SqlCmd @params
            #     $params.query = $grantCreateScript
            #     Invoke-SqlCmd @params
            #   }


            #Create DataBase Scoped Credential related to the job
            $params.database = $ElasticJobDataBaseDefinition
            $params.query = "IF NOT EXISTS (SELECT name FROM sys.database_scoped_credentials WHERE name='$(ElasticJobUserName)')
                BEGIN
                    CREATE DATABASE SCOPED CREDENTIAL '$(ElasticJobUserName)'  WITH IDENTITY='$(ElasticJobUserName)', SECRET='$(ElasticJobPassword)';
                END"
            Invoke-SqlCmd @params

            # create job credential in Job database for elasticjob user
            Write-Output "Creating job credentials..."
            #   $loginPasswordSecure = (ConvertTo-SecureString -String 'Qwerty1234' -AsPlainText -Force)

            $masterCred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList "$ElasticJobUserName", $loginPasswordSecure
            $masterCred = New-AzSqlElasticJobCredential -Name $ElasticJobCredentialName -Credential $masterCred -ResourceGroupName $ElasticJobResourceGroupName -ServerName $ElasticJobServerName -AgentName $ElasticJobAgentName

            Write-Output "***--END--Create ElasticJob'S Credentials --"


            Write-Output "***--INI--Create ElasticJob'S Target Groups --"
            New-AzSqlElasticJobTargetGroup -Name $ElasticJobTargetGroupName -ResourceGroupName $ElasticJobResourceGroupName -ServerName $ElasticJobServerName -AgentName $ElasticJobAgentName
            Write-Output "***--END--Create ElasticJob'S Target Groups --"

            Write-Output "***--INI--Add ElasticJob'S Targets to Target's Groups --"
            Add-AzSqlElasticJobTarget -AgentServerName $ElasticJobServerName -ResourceGroupName $ElasticJobResourceGroupName -AgentName $ElasticJobAgentName -TargetGroupName $ElasticJobTargetGroupName -ServerName $ElasticJobServerName + '.database.windows.net' -DatabaseName $ElasticJobTargetDB
            Write-Output "***--END--Add ElasticJob'S Targets to Target's Groups --"


            Write-Output "***--INI--Create Job --"
            New-AzSqlElasticJob -ResourceGroupName $ElasticJobResourceGroupName  -AgentName $ElasticJobAgentName -ServerName $ElasticJobServerName -Name $ElasticJobName -RunOnce

            Write-Output "***--END--Create Job --"

            Write-Output "***--INI--Create Job's Steps --"

            Add-AzSqlElasticJobStep -ResourceGroupName $ElasticJobResourceGroupName  -AgentName $ElasticJobAgentName -ServerName $ElasticJobServerName -JobName $ElasticJobName  -Name $ElasticJobStepName1 -TargetGroupName $ElasticJobTargetGroupName -CredentialName $ElasticJobCredentialName -CommandText $ElasticJobStepName1CommandText

            Write-Output "***--END--Create Job's Steps --"

        }
        catch {
            Write-Error $_.Exception.Message
        }

    }
}

$params = @{ 'ElasticJobAgentName' = 'orney-elasticJobAgentTestMigDevUat';
    'ElasticJobDataBaseDefinition' = 'ElasticJobDataBaseDefinition';
    'ElasticJobResourceGroupName'  = 'rgp-p-we1-aziredevops-net-dev';
    'ElasticJobServerName'         = 'dev-azire';
    'AdminDbMasterUserName'        = 'DDBBAdminUs';
    'AdminDbMasterPassword'        = 'DDBBAdminPass';
    'ElasticJobTargetDB'           = 'TargetDB';
    'ElasticJobCredentialName'     = 'elasticjob';
    'ElasticJobTargetGroupName'    = 'OrneyTest-JobTargetGroup';
    'ElasticJobName'               = 'Orney-TestJob1';
    'ElasticJobStepName1'               = 'OrneyJobstep1';
    'ElasticJobStepName1CommandText' = 'INSERT INTO [dbo].[TESTELASTICJOB] ([COLUMN1], [CREATEDATE]) VALUES("Orney Test Success" ,GETDATE());';
}


#Creating the required elastic Sql Job Resources
CreateElasticSqlJobResources @params

