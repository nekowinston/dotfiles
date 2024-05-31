#!/usr/bin/env nu

sketchybar --set $env.NAME $"label=(date now | format date '%H:%M')"
