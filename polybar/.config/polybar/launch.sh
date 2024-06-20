!#/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Launch Polybar, using default config location ~/.config/polybar/config.ini
# polybar example --config=~/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar.log & disown

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example --config=~/.config/polybar/config.ini &
  done
else
  polybar --reload example --config=~/.config/polybar/config.ini &
fi

echo "Polybar launched..."
