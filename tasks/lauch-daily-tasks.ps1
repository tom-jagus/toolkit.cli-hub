#::name: launch-daily-tasks
#::short: Opens a terminal with Neovim and date-based task files.
#::help:
#::  Launches a new terminal session and starts Neovim with today's and yesterday's
#::  task files already opened. This script is designed to be used with shortcut
#::  launchers, autostart entries, or CLI-based workflows.
#::
#::  Files opened:
#::    - YYYY-MM-dd-tasks.md       (today)
#::    - YYYY-MM-dd-tasks.md       (yesterday)
#::
#::  Requires Neovim to be installed and available in the system path.
#::
#::  Usage:
#::      init launch-daily-tasks
#::      (or run via a desktop or startup shortcut)

# Get dates
$today = Get-Date
$yesterday = (Get-Date).AddDays(-1)

# Format dates to strings
$today_string = $today.ToString("yyyy-MM-dd")
$today_day_of_week = $today.DayOfWeek.ToString()
$today_title_formatted = $today.ToString("dddd, MMMM dd, yyyy")
$yesterday_string = $yesterday.ToString("yyyy-MM-dd")
$yesterday_day_of_week = $yesterday.DayOfWeek.ToString()
$yesterday_title_formatted = $yesterday.ToString("dddd, MMMM dd, yyyy")

# Generate file names
$today_file_name = "$today_string-todo.md"
$yesterday_file_name = "$yesterday_string-todo.md"

# Daily notes template

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

# Daily notes creation
# Yesterday
$content = Generate-Template $yesterday_string $yesterday_day_of_week $yesterday_title_formated

if (-Not (Test-Path $yesterday_file_name)) {
    $content | Out-File -Encoding UTF8 $yesterday_file_name
  }

# Today
$content = Generate-Template $today_string $today_day_of_week $today_title_formated

if (-Not (Test-Path $todays_file_name)) {
    $content | Out-File -Encoding UTF8 $today_file_name
  }

# Open both yesterday and today notes

nvim $yesterday_file_name $today_file_name
