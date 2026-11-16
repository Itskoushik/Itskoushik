param(
  [string]$AssetRoot = (Join-Path $PSScriptRoot '..\assets')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$AssetRoot = [System.IO.Path]::GetFullPath($AssetRoot)
$SourceRoot = Join-Path $AssetRoot 'source'

function Get-PanelRects {
  param([int]$Width, [int]$Height, [string]$Layout)
  if ($Layout -eq '2x2') {
    $halfW = [int][Math]::Floor($Width / 2)
    $halfH = [int][Math]::Floor($Height / 2)
    return ,@(
      [System.Drawing.Rectangle]::new(4, 4, $halfW - 8, $halfH - 8),
      [System.Drawing.Rectangle]::new($halfW + 4, 4, $Width - $halfW - 8, $halfH - 8),
      [System.Drawing.Rectangle]::new(4, $halfH + 4, $halfW - 8, $Height - $halfH - 8),
      [System.Drawing.Rectangle]::new($halfW + 4, $halfH + 4, $Width - $halfW - 8, $Height - $halfH - 8)
    )
  }
  if ($Layout -eq '1x4') {
    $panelW = [int][Math]::Floor($Width / 4)
    $rects = @()
    for ($i = 0; $i -lt 4; $i++) {
      $x = $i * $panelW + 4
      $w = if ($i -eq 3) { $Width - $x - 4 } else { $panelW - 8 }
      $rects += [System.Drawing.Rectangle]::new($x, 4, $w, $Height - 8)
    }
    return ,$rects
  }
  return ,@([System.Drawing.Rectangle]::new(0, 0, $Width, $Height))
}

function Get-CoverRect {
  param([System.Drawing.Rectangle]$Source, [int]$TargetWidth, [int]$TargetHeight, [double]$Zoom = 1.0, [double]$Pan = 0.0)
  $targetRatio = $TargetWidth / $TargetHeight
  $sourceRatio = $Source.Width / $Source.Height
  if ($sourceRatio -gt $targetRatio) {
    $height = $Source.Height / $Zoom
    $width = $height * $targetRatio
  } else {
    $width = $Source.Width / $Zoom
    $height = $width / $targetRatio
  }
  $x = $Source.X + (($Source.Width - $width) / 2) + ($Pan * ($Source.Width - $width) / 2)
  $y = $Source.Y + (($Source.Height - $height) / 2)
  return [System.Drawing.RectangleF]::new([single]$x, [single]$y, [single]$width, [single]$height)
}

function Add-MotionOverlay {
  param([System.Drawing.Graphics]$Graphics, [string]$Motion, [int]$Frame, [int]$FrameCount, [int]$Width, [int]$Height)
  $phase = 2.0 * [Math]::PI * $Frame / $FrameCount
  if ($Motion -eq 'cover' -or $Motion -eq 'final') {
    $random = New-Object System.Random(83)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(170, 155, 25, 34))
    for ($i = 0; $i -lt 12; $i++) {
      $x = [single](($random.NextDouble() * $Width + ($Frame * (8 + ($i % 4)))) % $Width)
      $y = [single](($random.NextDouble() * $Height + ($Frame * (3 + ($i % 3)))) % $Height)
      $size = [single](2 + ($i % 3))
      $Graphics.FillEllipse($brush, $x, $y, $size, $size)
    }
    $brush.Dispose()
    if ($Motion -eq 'cover') {
      $font = New-Object System.Drawing.Font('Georgia', 20, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
      $small = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
      $Graphics.DrawString('PROJECT KODAN', $font, [System.Drawing.Brushes]::White, 24, ($Height - 58))
      $Graphics.DrawString('THE ENGINEERING CHRONICLES', $small, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(225, 203, 157, 144))), 25, ($Height - 32))
      $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(225, 173, 31, 40), 2)
      $reveal = [single](30 + (($Width - 60) * (0.5 + 0.5 * [Math]::Sin($phase))))
      $Graphics.DrawLine($pen, 25, ($Height - 15), $reveal, ($Height - 15))
      $pen.Dispose()
      $small.Dispose()
      $font.Dispose()
    }
  }
  if ($Motion -eq 'fleet') {
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 171, 28, 40), 3)
    $Graphics.DrawCurve($pen, [System.Drawing.PointF[]]@(
      (New-Object System.Drawing.PointF(25, ($Height * 0.78))),
      (New-Object System.Drawing.PointF(($Width * 0.28), ($Height * 0.66))),
      (New-Object System.Drawing.PointF(($Width * 0.53), ($Height * 0.75))),
      (New-Object System.Drawing.PointF(($Width * 0.82), ($Height * 0.56))),
      (New-Object System.Drawing.PointF(($Width - 20), ($Height * 0.62)))
    ))
    $x = [single](25 + (($Width - 50) * $Frame / $FrameCount))
    $y = [single](($Height * 0.69) + ([Math]::Sin($phase * 2) * ($Height * 0.08)))
    $halo = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(72, 190, 35, 43))
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(250, 205, 42, 48))
    $Graphics.FillEllipse($halo, $x - 12, $y - 12, 24, 24)
    $Graphics.FillEllipse($brush, $x - 6, $y - 6, 12, 12)
    $halo.Dispose()
    $brush.Dispose()
    $pen.Dispose()
  }
  if ($Motion -eq 'network') {
    $points = [System.Drawing.PointF[]]@(
      (New-Object System.Drawing.PointF(($Width * 0.16), ($Height * 0.55))),
      (New-Object System.Drawing.PointF(($Width * 0.34), ($Height * 0.32))),
      (New-Object System.Drawing.PointF(($Width * 0.54), ($Height * 0.57))),
      (New-Object System.Drawing.PointF(($Width * 0.76), ($Height * 0.34))),
      (New-Object System.Drawing.PointF(($Width * 0.87), ($Height * 0.64)))
    )
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(120, 173, 31, 40), 2)
    $Graphics.DrawLines($pen, $points)
    $step = ($Frame % ($points.Length - 1))
    $fraction = ($Frame % 4) / 4.0
    $x = $points[$step].X + (($points[$step + 1].X - $points[$step].X) * $fraction)
    $y = $points[$step].Y + (($points[$step + 1].Y - $points[$step].Y) * $fraction)
    $halo = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 190, 35, 43))
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 190, 35, 43))
    $Graphics.FillEllipse($halo, $x - 12, $y - 12, 24, 24)
    $Graphics.FillEllipse($brush, $x - 6, $y - 6, 12, 12)
    $halo.Dispose()
    $brush.Dispose()
    $pen.Dispose()
  }
}

function Set-GifProperties {
  param([System.Drawing.Image]$Image, [int]$FrameCount, [int]$DelayHundredths)
  $delayBytes = New-Object System.Collections.Generic.List[byte]
  for ($i = 0; $i -lt $FrameCount; $i++) {
    $delayBytes.AddRange([BitConverter]::GetBytes([int]$DelayHundredths))
  }
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

function Build-Animation {
  param(
    [string]$SourceName, [string]$OutputName, [string]$Layout, [int]$Width, [int]$Height,
    [string]$Motion = 'none'
  )
  $inputPath = Join-Path $SourceRoot $SourceName
  $outputPath = Join-Path $AssetRoot $OutputName
  $source = [System.Drawing.Image]::FromFile($inputPath)
  $panels = Get-PanelRects -Width $source.Width -Height $source.Height -Layout $Layout
  if ($Layout -eq 'single') {
    $sequence = @(0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3)
  } else {
    $sequence = @(0, 1, 2, 3, 2, 1, 0)
  }
  $frames = New-Object 'System.Collections.Generic.List[System.Drawing.Bitmap]'
  for ($frameIndex = 0; $frameIndex -lt $sequence.Count; $frameIndex++) {
    $panelIndex = if ($Layout -eq 'single') { 0 } else { $sequence[$frameIndex] }
    $panel = $panels[$panelIndex]
    $zoom = if ($Layout -eq 'single') { 1.0 + (0.012 * (0.5 - 0.5 * [Math]::Cos(2.0 * [Math]::PI * $frameIndex / $sequence.Count))) } else { 1.0 }
    $pan = if ($Layout -eq 'single') { [Math]::Sin(2.0 * [Math]::PI * $frameIndex / $sequence.Count) * 0.18 } else { 0.0 }
    $crop = Get-CoverRect -Source $panel -TargetWidth $Width -TargetHeight $Height -Zoom $zoom -Pan $pan
    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $destination = [System.Drawing.RectangleF]::new(0, 0, [single]$Width, [single]$Height)
    $graphics.DrawImage($source, $destination, $crop, [System.Drawing.GraphicsUnit]::Pixel)
    Add-MotionOverlay -Graphics $graphics -Motion $Motion -Frame $frameIndex -FrameCount $sequence.Count -Width $Width -Height $Height
    $graphics.Dispose()
    $frames.Add($bitmap)
  }
  Save-AnimatedGif -Frames $frames -Path $outputPath -DelayHundredths 10
  foreach ($frame in $frames) { $frame.Dispose() }
  $source.Dispose()
}

Build-Animation 'cover.jpg' 'hero\hero-manga.gif' 'single' 720 405 'cover'
Build-Animation 'workstation.jpg' 'chapters\developer-workstation.gif' '2x2' 640 320
Build-Animation 'engineering-lab.jpg' 'chapters\engineering-lab.gif' '2x2' 640 426
Build-Animation 'hardware-workflow.jpg' 'projects\hardware-automation.gif' '1x4' 360 480
# Mission 02 CHIPVEL is composed as a multi-state GIF; do not replace it with a static-scene loop.
Build-Animation 'eyecue-vision.jpg' 'projects\eyecue-vision.gif' '2x2' 640 426
Build-Animation 'evoting-network.jpg' 'projects\blockchain-network.gif' 'single' 640 426 'network'
Build-Animation 'final-transmission.jpg' 'footer\final-transmission.gif' 'single' 720 405 'final'

Get-ChildItem $AssetRoot -Recurse -Filter *.gif | Select-Object FullName,Length
