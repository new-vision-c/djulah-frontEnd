param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('client', 'pro', 'shared')]
  [string]$App,

  [Parameter(Mandatory = $true)]
  [ValidatePattern('^[a-z][a-z0-9_\-]*$')]
  [string]$Name,

  [switch]$Delete,

  [ValidateSet('client', 'pro', 'shared')]
  [string]$MoveTo
)

function To-PascalCase([string]$s) {
  $parts = $s -split '[_\-]'
  $out = ""
  foreach ($p in $parts) {
    if ([string]::IsNullOrWhiteSpace($p)) { continue }
    $out += ($p.Substring(0,1).ToUpper() + $p.Substring(1))
  }
  return $out
}

function Remove-ExactLine([string]$filePath, [string]$line) {
  if (-not (Test-Path $filePath)) {
    return
  }
  $pattern = "^" + [regex]::Escape($line) + "\s*$"
  Remove-LinesMatching -filePath $filePath -pattern $pattern
}

function Insert-RouteConstIfMissing([string]$filePath, [string]$routeConst, [string]$routePath) {
  if (-not (Test-Path $filePath)) {
    throw "File not found: $filePath"
  }
  $content = Get-Content -Raw -Encoding UTF8 $filePath
  if ($content -notmatch "static const\s+$routeConst\s+=") {
    $insert = "  static const $routeConst = '$routePath';"
    $content = $content -replace "\r?\n\}\s*$", "`r`n$insert`r`n}`r`n"
    Set-Content -Encoding UTF8 -Path $filePath -Value $content
  }
}

function Ensure-RoutesSharedImports([string]$routesSharedFile) {
  if (-not (Test-Path $routesSharedFile)) {
    throw "File not found: $routesSharedFile"
  }
  $routesContent = Get-Content -Raw -Encoding UTF8 $routesSharedFile
  if ($routesContent -notmatch "route_names.dart") {
    $routesContent = $routesContent -replace "import 'package:get/get.dart';", "import 'package:get/get.dart';`r`n`r`nimport 'route_names.dart';"
    Set-Content -Encoding UTF8 -Path $routesSharedFile -Value $routesContent
  }
}

function Add-LineIfMissing([string]$filePath, [string]$line) {
  if (-not (Test-Path $filePath)) {
    throw "File not found: $filePath"
  }
  $content = Get-Content -Raw -Encoding UTF8 $filePath
  if ($content -notmatch [regex]::Escape($line)) {
    $content = ($content.TrimEnd() + "`r`n" + $line + "`r`n")
    Set-Content -Encoding UTF8 -Path $filePath -Value $content
  }
}

function Ensure-ImportsInDartFile([string]$filePath, [string[]]$importLines) {
  if (-not (Test-Path $filePath)) {
    throw "File not found: $filePath"
  }
  $content = Get-Content -Raw -Encoding UTF8 $filePath
  $changed = $false

  foreach ($line in $importLines) {
    if ($content -notmatch [regex]::Escape($line)) {
      # Insert after the last existing import line
      if ($content -match "(?ms)^(?<head>(?:\s*import\s+[^;]+;\s*\r?\n)+)(?<tail>.*)$") {
        $head = $Matches['head']
        $tail = $Matches['tail']
        $content = $head + $line + "`r`n" + $tail
      }
      else {
        $content = $line + "`r`n" + $content
      }
      $changed = $true
    }
  }

  if ($changed) {
    Set-Content -Encoding UTF8 -Path $filePath -Value $content
  }
}

function Remove-LinesMatching([string]$filePath, [string]$pattern) {
  if (-not (Test-Path $filePath)) {
    return
  }
  $lines = Get-Content -Encoding UTF8 $filePath
  $newLines = $lines | Where-Object { $_ -notmatch $pattern }
  if ($newLines.Count -ne $lines.Count) {
    Set-Content -Encoding UTF8 -Path $filePath -Value $newLines
  }
}

function Remove-BlockContaining([string]$filePath, [string]$needlePattern, [string]$blockStartPattern, [string]$blockEndPattern) {
  if (-not (Test-Path $filePath)) {
    return
  }
  $lines = Get-Content -Encoding UTF8 $filePath
  $out = New-Object System.Collections.Generic.List[string]
  $i = 0
  while ($i -lt $lines.Count) {
    if ($lines[$i] -match $needlePattern) {
      # Walk backwards to find block start
      $start = $i
      while ($start -ge 0 -and $lines[$start] -notmatch $blockStartPattern) { $start-- }

      # Walk forwards to find block end
      $end = $i
      while ($end -lt $lines.Count -and $lines[$end] -notmatch $blockEndPattern) { $end++ }
      if ($end -lt $lines.Count) { $end++ }

      if ($start -ge 0 -and $end -gt $start) {
        $result = New-Object System.Collections.Generic.List[string]
        for ($k = 0; $k -lt $start; $k++) {
          $result.Add($lines[$k])
        }
        for ($k = $end; $k -lt $lines.Count; $k++) {
          $result.Add($lines[$k])
        }
        Set-Content -Encoding UTF8 -Path $filePath -Value $result
        return
      }
    }
    $out.Add($lines[$i])
    $i++
  }
}

$root = Split-Path -Parent $PSScriptRoot
$presentationRoot = Join-Path $root "lib\presentation"
$srcPagePath = Join-Path $presentationRoot $Name
$destAppRoot = Join-Path $presentationRoot $App
$destPagePath = Join-Path $destAppRoot $Name

if (-not (Test-Path $presentationRoot)) {
  throw "Invalid project structure: $presentationRoot not found"
}

$pascal = To-PascalCase $Name
$routeConst = "$App$pascal"
$routePath = "/$App/$Name"

$appPascal = To-PascalCase $App

function Get-BindingFileName([string]$app, [string]$name) {
  if ($app -eq 'client' -or $app -eq 'pro') {
    return "$app.$name.controller.binding.dart"
  }
  return "$name.controller.binding.dart"
}

function Get-BindingClassName([string]$appPascal, [string]$pascal, [string]$app) {
  if ($app -eq 'client' -or $app -eq 'pro') {
    return "${appPascal}${pascal}ControllerBinding"
  }
  return "${pascal}ControllerBinding"
}

function Cleanup-LegacyGenericBinding([string]$root, [string]$name) {
  $bindingDir = Join-Path $root "lib\infrastructure\navigation\bindings\controllers"
  $legacyFile = Join-Path $bindingDir "$name.controller.binding.dart"
  if (Test-Path $legacyFile) {
    Remove-Item -Force $legacyFile
  }

  $controllersBindings = Join-Path $bindingDir "controllers_bindings.dart"
  $legacyExportPattern = "^export 'package:djulah/infrastructure/navigation/bindings/controllers/$name\.controller\.binding\.dart';\s*$"
  Remove-LinesMatching -filePath $controllersBindings -pattern $legacyExportPattern
}

function Cleanup-GetCliGeneratedBindingsInScreenFolder([string]$screenFolder) {
  if (-not (Test-Path $screenFolder)) {
    return
  }

  $bindingFiles = Get-ChildItem -Path $screenFolder -Recurse -File -Filter "*.binding.dart" -ErrorAction SilentlyContinue
  foreach ($f in $bindingFiles) {
    Remove-Item -Force $f.FullName
  }

  $bindingsDirs = Get-ChildItem -Path $screenFolder -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq 'bindings' }
  foreach ($d in $bindingsDirs) {
    Remove-Item -Recurse -Force $d.FullName
  }
}

function Get-ScreensBarrelFile([string]$presentationRoot, [string]$app) {
  if ($app -eq 'client') {
    return (Join-Path $presentationRoot 'screens_client.dart')
  }
  if ($app -eq 'pro') {
    return (Join-Path $presentationRoot 'screens_pro.dart')
  }
  if ($app -eq 'shared') {
    return (Join-Path $presentationRoot 'screens_shared.dart')
  }
  throw "Unknown app for screens barrel: $app"
}

function Ensure-ScreensBarrelExists([string]$barrelFile) {
  if (-not (Test-Path $barrelFile)) {
    Set-Content -Encoding UTF8 -Path $barrelFile -Value ""
  }
}

if ($MoveTo) {
  $fromApp = $App
  $toApp = $MoveTo

  if ($fromApp -eq $toApp) {
    throw "MoveTo is the same as App ($fromApp). Nothing to do."
  }

  $oldBindingFileName = Get-BindingFileName -app $fromApp -name $Name
  $newBindingFileName = Get-BindingFileName -app $toApp -name $Name
  $oldScreenImportLine = "import '../../presentation/$fromApp/$Name/$Name.screen.dart';"
  $newScreenImportLine = "import '../../presentation/$toApp/$Name/$Name.screen.dart';"
  $oldBindingImportLine = "import 'bindings/controllers/$oldBindingFileName';"
  $newBindingImportLine = "import 'bindings/controllers/$newBindingFileName';"

  $fromPath = Join-Path (Join-Path $presentationRoot $fromApp) $Name
  $toPath = Join-Path (Join-Path $presentationRoot $toApp) $Name

  if (-not (Test-Path $fromPath)) {
    throw "Cannot move: source folder not found: $fromPath"
  }
  if (Test-Path $toPath) {
    throw "Cannot move: destination already exists: $toPath"
  }

  $screensDart = Join-Path $presentationRoot "screens.dart"
  if (Test-Path $screensDart) {
    $orphanExportPattern = "^export 'package:djulah/presentation/$Name/$Name\.screen\.dart';\s*$"
    Remove-LinesMatching -filePath $screensDart -pattern $orphanExportPattern
    $oldExportLegacy = "^export 'package:djulah/presentation/$fromApp/$Name/$Name\.screen\.dart';\s*$"
    $newExportLegacy = "^export 'package:djulah/presentation/$toApp/$Name/$Name\.screen\.dart';\s*$"
    Remove-LinesMatching -filePath $screensDart -pattern $oldExportLegacy
    Remove-LinesMatching -filePath $screensDart -pattern $newExportLegacy
  }

  $fromBarrel = Get-ScreensBarrelFile -presentationRoot $presentationRoot -app $fromApp
  $toBarrel = Get-ScreensBarrelFile -presentationRoot $presentationRoot -app $toApp
  Ensure-ScreensBarrelExists -barrelFile $fromBarrel
  Ensure-ScreensBarrelExists -barrelFile $toBarrel

  $fromExportLine = "export 'package:djulah/presentation/$fromApp/$Name/$Name.screen.dart';"
  $toExportLine = "export 'package:djulah/presentation/$toApp/$Name/$Name.screen.dart';"
  Remove-ExactLine -filePath $fromBarrel -line $fromExportLine
  Add-LineIfMissing -filePath $toBarrel -line $toExportLine

  # Update route_names.dart const
  $routeNamesFile = Join-Path $root "lib\infrastructure\navigation\route_names.dart"
  $oldRouteConst = "$fromApp$pascal"
  $newRouteConst = "$toApp$pascal"
  $oldRouteConstPattern = "^\s*static const\s+$oldRouteConst\s*=.*;\s*$"
  Remove-LinesMatching -filePath $routeNamesFile -pattern $oldRouteConstPattern
  Insert-RouteConstIfMissing -filePath $routeNamesFile -routeConst $newRouteConst -routePath "/$toApp/$Name"

  # Remove from old routes file
  if ($fromApp -eq 'client' -or $fromApp -eq 'pro') {
    $oldRoutesFile = Join-Path $root "lib\infrastructure\navigation\routes_$fromApp.dart"
    Remove-BlockContaining -filePath $oldRoutesFile -needlePattern "RouteNames\.$oldRouteConst" -blockStartPattern "^\s*GetPage\(\s*$" -blockEndPattern "^\s*\),\s*$"
    Remove-ExactLine -filePath $oldRoutesFile -line $oldScreenImportLine
    Remove-ExactLine -filePath $oldRoutesFile -line $oldBindingImportLine
  }
  elseif ($fromApp -eq 'shared') {
    $oldRoutesFile = Join-Path $root "lib\infrastructure\navigation\routes_shared.dart"
    Remove-BlockContaining -filePath $oldRoutesFile -needlePattern "RouteNames\.$oldRouteConst" -blockStartPattern "^\s*GetPage\(\s*$" -blockEndPattern "^\s*\),\s*$"
    Remove-ExactLine -filePath $oldRoutesFile -line $oldScreenImportLine
    Remove-ExactLine -filePath $oldRoutesFile -line $oldBindingImportLine
  }

  # Add to new routes file
  $toAppPascal = To-PascalCase $toApp
  $bindingClass = Get-BindingClassName -appPascal $toAppPascal -pascal $pascal -app $toApp
  if ($toApp -eq 'client' -or $toApp -eq 'pro') {
    $newRoutesFile = Join-Path $root "lib\infrastructure\navigation\routes_$toApp.dart"
    Ensure-ImportsInDartFile -filePath $newRoutesFile -importLines @($newScreenImportLine, $newBindingImportLine)
    $routesContent = Get-Content -Raw -Encoding UTF8 $newRoutesFile
    $getPageBlock = @"
        GetPage(
          name: RouteNames.$newRouteConst,
          page: () => const ${pascal}Screen(),
          binding: $bindingClass(),
        ),
"@
    if ($routesContent -notmatch "name:\s*RouteNames\.$newRouteConst") {
      $routesContent = $routesContent -replace "\r?\n\s*\];\s*\r?\n\}\s*$", "`r`n$getPageBlock      ];`r`n}`r`n"
      Set-Content -Encoding UTF8 -Path $newRoutesFile -Value $routesContent
    }
  }
  elseif ($toApp -eq 'shared') {
    $newRoutesFile = Join-Path $root "lib\infrastructure\navigation\routes_shared.dart"
    Ensure-RoutesSharedImports -routesSharedFile $newRoutesFile
    Ensure-ImportsInDartFile -filePath $newRoutesFile -importLines @($newScreenImportLine, $newBindingImportLine)
    $routesContent = Get-Content -Raw -Encoding UTF8 $newRoutesFile
    $getPageBlock = @"
        GetPage(
          name: RouteNames.$newRouteConst,
          page: () => const ${pascal}Screen(),
          binding: $bindingClass(),
        ),
"@
    if ($routesContent -notmatch "name:\s*RouteNames\.$newRouteConst") {
      $routesContent = $routesContent -replace "\r?\n\s*\];\s*\r?\n\}\s*$", "`r`n$getPageBlock      ];`r`n}`r`n"
      Set-Content -Encoding UTF8 -Path $newRoutesFile -Value $routesContent
    }
  }

  # Update binding import + move folder
  $bindingDir = Join-Path $root "lib\infrastructure\navigation\bindings\controllers"
  $oldBindingFile = Join-Path $bindingDir $oldBindingFileName
  $newBindingFile = Join-Path $bindingDir $newBindingFileName

  if (-not (Test-Path $bindingDir)) {
    New-Item -ItemType Directory -Path $bindingDir | Out-Null
  }

  if (Test-Path $oldBindingFile -and $oldBindingFileName -ne $newBindingFileName) {
    Move-Item -Path $oldBindingFile -Destination $newBindingFile
  }

  $bindingImport = "../../../../presentation/$toApp/$Name/controllers/$Name.controller.dart"
  $bindingContent = @"
import 'package:get/get.dart';

import '$bindingImport';

class $bindingClass extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${pascal}Controller>(
      () => ${pascal}Controller(),
    );
  }
}
"@
  Set-Content -Encoding UTF8 -Path $newBindingFile -Value $bindingContent

  if ($toApp -eq 'client' -or $toApp -eq 'pro') {
    Cleanup-LegacyGenericBinding -root $root -name $Name
  }

  if (-not (Test-Path (Join-Path $presentationRoot $toApp))) {
    New-Item -ItemType Directory -Path (Join-Path $presentationRoot $toApp) | Out-Null
  }
  Move-Item -Path $fromPath -Destination $toPath

  Write-Host "OK: moved screen '$Name' from '$fromApp' to '$toApp'"
  exit 0
}

if ($Delete) {
  if ($App -eq 'client' -or $App -eq 'pro') {
    Cleanup-LegacyGenericBinding -root $root -name $Name
  }
  $screensDart = Join-Path $presentationRoot "screens.dart"
  if (Test-Path $screensDart) {
    $orphanExportPattern = "^export 'package:djulah/presentation/$Name/$Name\.screen\.dart';\s*$"
    Remove-LinesMatching -filePath $screensDart -pattern $orphanExportPattern

    $exportClientPattern = "^export 'package:djulah/presentation/client/$Name/$Name\.screen\.dart';\s*$"
    $exportProPattern = "^export 'package:djulah/presentation/pro/$Name/$Name\.screen\.dart';\s*$"
    $exportSharedPattern = "^export 'package:djulah/presentation/shared/$Name/$Name\.screen\.dart';\s*$"
    $exportCurrentAppPattern = "^export 'package:djulah/presentation/$App/$Name/$Name\.screen\.dart';\s*$"
    Remove-LinesMatching -filePath $screensDart -pattern $exportClientPattern
    Remove-LinesMatching -filePath $screensDart -pattern $exportProPattern
    Remove-LinesMatching -filePath $screensDart -pattern $exportSharedPattern
    Remove-LinesMatching -filePath $screensDart -pattern $exportCurrentAppPattern
  }

  $clientBarrel = Get-ScreensBarrelFile -presentationRoot $presentationRoot -app 'client'
  $proBarrel = Get-ScreensBarrelFile -presentationRoot $presentationRoot -app 'pro'
  $sharedBarrel = Get-ScreensBarrelFile -presentationRoot $presentationRoot -app 'shared'
  Ensure-ScreensBarrelExists -barrelFile $clientBarrel
  Ensure-ScreensBarrelExists -barrelFile $proBarrel
  Ensure-ScreensBarrelExists -barrelFile $sharedBarrel

  $clientExportLine = "export 'package:djulah/presentation/client/$Name/$Name.screen.dart';"
  $proExportLine = "export 'package:djulah/presentation/pro/$Name/$Name.screen.dart';"
  $sharedExportLine = "export 'package:djulah/presentation/shared/$Name/$Name.screen.dart';"
  Remove-ExactLine -filePath $clientBarrel -line $clientExportLine
  Remove-ExactLine -filePath $proBarrel -line $proExportLine
  Remove-ExactLine -filePath $sharedBarrel -line $sharedExportLine

  $routeNames = Join-Path $root "lib\infrastructure\navigation\route_names.dart"
  $routeConstPattern = "^\s*static const\s+$routeConst\s*=.*;\s*$"
  Remove-LinesMatching -filePath $routeNames -pattern $routeConstPattern

  $bindingDir = Join-Path $root "lib\infrastructure\navigation\bindings\controllers"
  $bindingFileName = Get-BindingFileName -app $App -name $Name
  $bindingFile = Join-Path $bindingDir $bindingFileName
  if (Test-Path $bindingFile) {
    Remove-Item -Force $bindingFile
  }

  if ($App -eq 'client' -or $App -eq 'pro') {
    $routesFile = Join-Path $root "lib\infrastructure\navigation\routes_$App.dart"
    Remove-BlockContaining -filePath $routesFile -needlePattern "RouteNames\.$routeConst" -blockStartPattern "^\s*GetPage\(\s*$" -blockEndPattern "^\s*\),\s*$"

    $bindingFileName = Get-BindingFileName -app $App -name $Name
    $screenImportLine = "import '../../presentation/$App/$Name/$Name.screen.dart';"
    $bindingImportLine = "import 'bindings/controllers/$bindingFileName';"
    Remove-ExactLine -filePath $routesFile -line $screenImportLine
    Remove-ExactLine -filePath $routesFile -line $bindingImportLine
  }

  if ($App -eq 'shared') {
    $routesFile = Join-Path $root "lib\infrastructure\navigation\routes_shared.dart"
    Remove-BlockContaining -filePath $routesFile -needlePattern "RouteNames\.$routeConst" -blockStartPattern "^\s*GetPage\(\s*$" -blockEndPattern "^\s*\),\s*$"

    $bindingFileName = Get-BindingFileName -app $App -name $Name
    $screenImportLine = "import '../../presentation/$App/$Name/$Name.screen.dart';"
    $bindingImportLine = "import 'bindings/controllers/$bindingFileName';"
    Remove-ExactLine -filePath $routesFile -line $screenImportLine
    Remove-ExactLine -filePath $routesFile -line $bindingImportLine
  }

  if (Test-Path $destPagePath) {
    Remove-Item -Recurse -Force $destPagePath
  }

  Write-Host "OK: deleted page '$Name' for app '$App'"
  exit 0
}

if (Test-Path $destPagePath) {
  throw "Destination already exists: $destPagePath"
}

Push-Location $root
try {
  # Some get_cli templates generate/overwrite routing files.
  # Backup key files before running the generator, then restore.
  $backup = @{}
  $backupExists = @{}
  $maybeOverwritten = @(
    (Join-Path $root "lib\infrastructure\navigation\routes.dart"),
    (Join-Path $root "lib\infrastructure\navigation\navigation.dart"),
    (Join-Path $root "lib\infrastructure\navigation\route_names.dart")
  )
  foreach ($f in $maybeOverwritten) {
    $existed = Test-Path $f
    $backupExists[$f] = $existed
    if ($existed) {
      $backup[$f] = Get-Content -Raw -Encoding UTF8 $f
    }
  }

  & get create screen:$Name
  if ($LASTEXITCODE -ne 0) {
    throw "GetX CLI failed with exit code $LASTEXITCODE"
  }

  foreach ($f in $maybeOverwritten) {
    $existed = $backupExists[$f]
    if ($existed) {
      Set-Content -Encoding UTF8 -Path $f -Value $backup[$f]
    }
    else {
      if (Test-Path $f) {
        Remove-Item -Force $f
      }
    }
  }

  if (-not (Test-Path $srcPagePath)) {
    $candidates = @(
      $srcPagePath,
      (Join-Path $root "lib\presentation\$Name"),
      (Join-Path $root "lib\presentation\$App\$Name")
    )
    $found = $null
    foreach ($c in $candidates) {
      if (Test-Path $c) { $found = $c; break }
    }
    if ($null -eq $found) {
      $msg = "Expected generated screen folder not found under lib\\presentation. Tried:`r`n" + ($candidates -join "`r`n")
      throw $msg
    }
    $srcPagePath = $found
  }

  Cleanup-GetCliGeneratedBindingsInScreenFolder -screenFolder $srcPagePath

  if (-not (Test-Path $destAppRoot)) {
    New-Item -ItemType Directory -Path $destAppRoot | Out-Null
  }

  Move-Item -Path $srcPagePath -Destination $destPagePath

  $screensDart = Join-Path $presentationRoot "screens.dart"
  if (Test-Path $screensDart) {
    $orphanExportPattern = "^export 'package:djulah/presentation/$Name/$Name\.screen\.dart';\s*$"
    Remove-LinesMatching -filePath $screensDart -pattern $orphanExportPattern
  }

  $barrelFile = Get-ScreensBarrelFile -presentationRoot $presentationRoot -app $App
  Ensure-ScreensBarrelExists -barrelFile $barrelFile
  $exportLine = "export 'package:djulah/presentation/$App/$Name/$Name.screen.dart';"
  Add-LineIfMissing -filePath $barrelFile -line $exportLine

  # 2) Add route name constant
  $routeNames = Join-Path $root "lib\infrastructure\navigation\route_names.dart"
  $routeNamesContent = Get-Content -Raw -Encoding UTF8 $routeNames
  if ($routeNamesContent -notmatch "static const\s+$routeConst\s+=") {
    $insert = "  static const $routeConst = '$routePath';"
    $routeNamesContent = $routeNamesContent -replace "\r?\n\}\s*$", "`r`n$insert`r`n}`r`n"
    Set-Content -Encoding UTF8 -Path $routeNames -Value $routeNamesContent
  }

  # 3) Create controller binding in infrastructure
  $bindingDir = Join-Path $root "lib\infrastructure\navigation\bindings\controllers"
  $bindingFileName = Get-BindingFileName -app $App -name $Name
  $bindingFile = Join-Path $bindingDir $bindingFileName
  $bindingClass = Get-BindingClassName -appPascal $appPascal -pascal $pascal -app $App

  if (-not (Test-Path $bindingDir)) {
    New-Item -ItemType Directory -Path $bindingDir | Out-Null
  }

  $bindingImport = "../../../../presentation/$App/$Name/controllers/$Name.controller.dart"
  $bindingContent = @"
import 'package:get/get.dart';

import '$bindingImport';

class $bindingClass extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${pascal}Controller>(
      () => ${pascal}Controller(),
    );
  }
}
"@

  Set-Content -Encoding UTF8 -Path $bindingFile -Value $bindingContent

  if ($App -eq 'client' -or $App -eq 'pro') {
    Cleanup-LegacyGenericBinding -root $root -name $Name
  }

  # 4) Register GetPage in routes file
  if ($App -eq 'client' -or $App -eq 'pro') {
    $routesFile = Join-Path $root "lib\infrastructure\navigation\routes_$App.dart"

    $routesContent = Get-Content -Raw -Encoding UTF8 $routesFile

    $screenImportLine = "import '../../presentation/$App/$Name/$Name.screen.dart';"
    $bindingImportLine = "import 'bindings/controllers/$bindingFileName';"
    Ensure-ImportsInDartFile -filePath $routesFile -importLines @($screenImportLine, $bindingImportLine)
    $routesContent = Get-Content -Raw -Encoding UTF8 $routesFile

    $getPageBlock = @"
        GetPage(
          name: RouteNames.$routeConst,
          page: () => const ${pascal}Screen(),
          binding: $bindingClass(),
        ),
"@

    if ($routesContent -notmatch "name:\s*RouteNames\.$routeConst") {
      $routesContent = $routesContent -replace "\r?\n\s*\];\s*\r?\n\}\s*$", "`r`n$getPageBlock      ];`r`n}`r`n"
      Set-Content -Encoding UTF8 -Path $routesFile -Value $routesContent
    }
  }

  if ($App -eq 'shared') {
    $routesFile = Join-Path $root "lib\infrastructure\navigation\routes_shared.dart"
    $routesContent = Get-Content -Raw -Encoding UTF8 $routesFile

    if ($routesContent -notmatch "route_names.dart") {
      $routesContent = $routesContent -replace "import 'package:get/get.dart';", "import 'package:get/get.dart';`r`n`r`nimport 'route_names.dart';"
    }

    $screenImportLine = "import '../../presentation/$App/$Name/$Name.screen.dart';"
    $bindingImportLine = "import 'bindings/controllers/$bindingFileName';"
    Ensure-ImportsInDartFile -filePath $routesFile -importLines @($screenImportLine, $bindingImportLine)
    $routesContent = Get-Content -Raw -Encoding UTF8 $routesFile

    if ($routesContent -notmatch "name:\s*RouteNames\.$routeConst") {
      $routesContent = $routesContent -replace "static List<GetPage> get pages => <GetPage>\[\]", "static List<GetPage> get pages => <GetPage>[`r`n        GetPage(`r`n          name: RouteNames.$routeConst,`r`n          page: () => const ${pascal}Screen(),`r`n          binding: $bindingClass(),`r`n        ),`r`n      ]"
      Set-Content -Encoding UTF8 -Path $routesFile -Value $routesContent
    }
  }

  Write-Host "OK: created screen '$Name' for app '$App'"
}
finally {
  Pop-Location
}
