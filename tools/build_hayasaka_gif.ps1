$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$workspace = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$assetRoot = Join-Path $workspace 'assets'
$sourcePath = Join-Path $assetRoot 'source\hayasaka-storyboard.jpg'
$outputPath = Join-Path $assetRoot 'projects\hayasaka-music.gif'
$width = 640
$height = 480

function Get-PanelBitmap {
  param([System.Drawing.Image]$Source, [int]$Index)
  $cellWidth = [int][Math]::Floor($Source.Width / 3)
  $cellHeight = [int][Math]::Floor($Source.Height / 2)
  $column = $Index % 3
  $row = [int][Math]::Floor($Index / 3)
  $cell = [System.Drawing.Rectangle]::new(($column * $cellWidth + 6), ($row * $cellHeight + 6), ($cellWidth - 12), ($cellHeight - 12))
  $targetRatio = $width / $height
  $sourceRatio = $cell.Width / $cell.Height
  if ($sourceRatio -gt $targetRatio) {
    $cropHeight = $cell.Height
    $cropWidth = [single]($cropHeight * $targetRatio)
  } else {
    $cropWidth = $cell.Width
    $cropHeight = [single]($cropWidth / $targetRatio)
  }
  $crop = [System.Drawing.RectangleF]::new(
    [single]($cell.X + (($cell.Width - $cropWidth) / 2)),
    [single]($cell.Y + (($cell.Height - $cropHeight) / 2)),
    [single]$cropWidth,
    [single]$cropHeight
  )
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $destination = [System.Drawing.RectangleF]::new(0, 0, [single]$width, [single]$height)
  $graphics.DrawImage($Source, $destination, $crop, [System.Drawing.GraphicsUnit]::Pixel)
  $graphics.Dispose()
  return $bitmap
}

function New-BlendBitmap {
  param([System.Drawing.Bitmap]$From, [System.Drawing.Bitmap]$To, [single]$Amount)
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.DrawImage($From, 0, 0, $width, $height)
  $matrix = New-Object System.Drawing.Imaging.ColorMatrix
  $matrix.Matrix33 = $Amount
  $attributes = New-Object System.Drawing.Imaging.ImageAttributes
  $attributes.SetColorMatrix($matrix)
  $graphics.DrawImage($To, [System.Drawing.Rectangle]::new(0, 0, $width, $height), 0, 0, $width, $height, [System.Drawing.GraphicsUnit]::Pixel, $attributes)
  $attributes.Dispose()
  $graphics.Dispose()
  return $bitmap
}

function Add-MusicIdentity {
  param([System.Drawing.Bitmap]$Scene, [int]$Phase)
  $bitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.DrawImage($Scene, 0, 0, $width, $height)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(226, 11, 10, 9))), 0, ($height - 44), $width, 44)
  $graphics.DrawLine((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(240, 179, 35, 45), 3)), 0, ($height - 44), $width, ($height - 44))
  $brandFont = New-Object System.Drawing.Font('Georgia', 17, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $detailFont = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $graphics.DrawString('HAYASAKA MUSIC', $brandFont, [System.Drawing.Brushes]::White, 18, ($height - 36))
  $graphics.DrawString('DISCOVER  /  LISTEN  /  REPEAT', $detailFont, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 217, 206, 186))), 20, ($height - 16))
  for ($bar = 0; $bar -lt 18; $bar++) {
    $wave = [Math]::Abs([Math]::Sin(($bar * 0.72) + ($Phase * 0.9)))
    $barHeight = [single](4 + ($wave * 19))
    $x = [single](435 + ($bar * 10))
    $y = [single](($height - 22) - $barHeight)
    $graphics.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 179, 35, 45))), $x, $y, 5, $barHeight)
  }
  $graphics.Dispose()
  return $bitmap
}

function Set-GifProperties {
  param([System.Drawing.Image]$Image, [int]$FrameCount, [int]$DelayHundredths)
  $delayBytes = New-Object System.Collections.Generic.List[byte]
  for ($i = 0; $i -lt $FrameCount; $i++) { $delayBytes.AddRange([BitConverter]::GetBytes([int]$DelayHundredths)) }
  $delayProperty = [System.Runtime.Serialization.FormatterServices]::GetUninitializedObject([System.Drawing.Imaging.PropertyItem])
  $delayProperty.Id = 0x5100
  $delayProperty.Type = 4
  $delayProperty.Len = $delayBytes.Count
  $delayProperty.Value = $delayBytes.ToArray()
  $Image.SetPropertyItem($delayProperty)
  $loopProperty = [System.Runtime.Serialization.FormatterServices]::GetUninitializedObject([System.Drawing.Imaging.PropertyItem])
  $loopProperty.Id = 0x5101
  $loopProperty.Type = 3
  $loopProperty.Len = 2
  $loopProperty.Value = [byte[]](0, 0)
  $Image.SetPropertyItem($loopProperty)
}

function Save-AnimatedGif {
  param([System.Collections.Generic.List[System.Drawing.Bitmap]]$Frames, [string]$Path, [int]$DelayHundredths)
  $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/gif' }
  $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $image = $Frames[0]
  Set-GifProperties -Image $image -FrameCount $Frames.Count -DelayHundredths $DelayHundredths
  $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::SaveFlag, [long][System.Drawing.Imaging.EncoderValue]::MultiFrame)
  $image.Save($Path, $codec, $params)
  for ($i = 1; $i -lt $Frames.Count; $i++) {
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::SaveFlag, [long][System.Drawing.Imaging.EncoderValue]::FrameDimensionTime)
    $image.SaveAdd($Frames[$i], $params)
  }
  $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::SaveFlag, [long][System.Drawing.Imaging.EncoderValue]::Flush)
  $image.SaveAdd($params)
  $params.Dispose()
}

$source = [System.Drawing.Image]::FromFile($sourcePath)
$scenePanels = New-Object 'System.Collections.Generic.List[System.Drawing.Bitmap]'
foreach ($index in @(0, 1, 3, 4, 0)) { $scenePanels.Add((Get-PanelBitmap -Source $source -Index $index)) }
$source.Dispose()

$frames = New-Object 'System.Collections.Generic.List[System.Drawing.Bitmap]'
for ($scene = 0; $scene -lt $scenePanels.Count; $scene++) {
  $current = $scenePanels[$scene]
  $next = $scenePanels[($scene + 1) % $scenePanels.Count]
  $frames.Add((Add-MusicIdentity -Scene $current -Phase ($scene * 2)))
  $frames.Add((Add-MusicIdentity -Scene $current -Phase ($scene * 2 + 1)))
  $blendOne = New-BlendBitmap -From $current -To $next -Amount ([single]0.34)
  $blendTwo = New-BlendBitmap -From $current -To $next -Amount ([single]0.68)
  $frames.Add((Add-MusicIdentity -Scene $blendOne -Phase ($scene * 2 + 2)))
  $frames.Add((Add-MusicIdentity -Scene $blendTwo -Phase ($scene * 2 + 3)))
  $blendOne.Dispose()
  $blendTwo.Dispose()
}

Save-AnimatedGif -Frames $frames -Path $outputPath -DelayHundredths 8
foreach ($frame in $frames) { $frame.Dispose() }
foreach ($panel in $scenePanels) { $panel.Dispose() }

$result = [System.Drawing.Image]::FromFile($outputPath)
$dimension = New-Object System.Drawing.Imaging.FrameDimension($result.FrameDimensionsList[0])
$frameCount = $result.GetFrameCount($dimension)
$loopCount = [BitConverter]::ToUInt16($result.GetPropertyItem(0x5101).Value, 0)
Write-Output "GIF: $($result.Width)x$($result.Height), frames=$frameCount, infinite-loop=$($loopCount -eq 0), size=$([math]::Round((Get-Item $outputPath).Length / 1MB, 2)) MB"
$result.Dispose()
