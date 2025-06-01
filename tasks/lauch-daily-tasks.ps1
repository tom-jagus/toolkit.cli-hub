#::name: launch-daily-tasks
#::short: Opens a terminal with Neovim and date-based task files.
#::help:
#::  Launches Neovim with today's and previous task file (if available).
#::  Creates today's file if it doesn't exist. Previous file is selected from
#::  existing files, based on latest date before today.
#::  Designed for CLI workflows and launcher shortcuts.

# Get today's date info
$today = Get-Date
$today_string = $today.ToString("yyyy-MM-dd")
$today_day_of_week = $today.DayOfWeek.ToString()
$today_title_formatted = $today.ToString("dddd - MMMM dd, yyyy")
$today_file_name = "$today_string-todo.md"

# Function to generate content template
function Generate-Template($date, $day_of_week, $title_formatted) {
  return @"
---
date: $date
day: $day_of_week
tags: [daily, todo]
focus:
---

# $title_formatted

## To do tasks

- [ ] 

## Thoughts

- 

## Ideas

- 

## Notes

-

## Highlights

- 

## End of Day Reflection

### Mood

### Energy

### Wins

### Roadblocks
"@
}

# Create today's file if missing
if (-Not (Test-Path $today_file_name)) {
    $content = Generate-Template $today_string $today_day_of_week $today_title_formatted
    $content | Out-File -Encoding UTF8 $today_file_name
}

# Find most recent existing file before today
$previous_file = Get-ChildItem -File -Filter "*-todo.md" |
    Where-Object {
        $_.BaseName -match "^\d{4}-\d{2}-\d{2}" -and
        ([datetime]::ParseExact($_.BaseName.Substring(0,10), "yyyy-MM-dd", $null)) -lt $today_string
    } |
    Sort-Object  -Descending |
    Select-Object -First 1

# Open in Neovim: today + previous if found
if ($previous_file) {
    nvim $previous_file.Name $today_file_name
} else {
    nvim $today_file_name
}
