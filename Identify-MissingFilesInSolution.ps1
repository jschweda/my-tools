  param 
  ( 
    [Parameter(Mandatory=$True, 
    ValueFromPipeline=$True, 
    ValueFromPipelineByPropertyName=$True, 
      HelpMessage='What csproj would you like to analyze?')] 
    [Alias('project')] 
    [string]$projectname) 

function Check-Files($files){

 ForEach($file in  $files){
 if($file){
Write-Host "looking for $file"
    if(-not (Test-Path $file))
    {
        throw [System.IO.FileNotFoundException] "$file not found."
    }
    }
 }
}

Write-Host $projectname

[xml]$projectContent = Get-Content $projectname


ForEach($itemGroup in $projectContent.Project.ItemGroup)
{
    Check-Files -files $itemGroup.Reference.HintPath
    Check-Files -files $itemGroup.Compile.Include
    Check-Files -files $itemGroup.None.Include
    Check-Files -files $itemGroup.Content.Include
    Check-Files -files $itemGroup.TypeScriptCompile.Include
    Check-Files -files $itemGroup.ProjectReference.Include
}
