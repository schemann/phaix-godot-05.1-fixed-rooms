# Fixed Rooms in Godot 4

Project files for tutorial 05.1 of the Godot 4 series by Phaix on YouTube (https://www.youtube.com/@Phaix).

Put a fixed room at the same room number in every random level in Godot 4, like Roblox DOORS.
A DOORS-style game with a special room at the same number in every seed, for example room 50.

Say a library at room 50 or a chase around room 30. A table of room numbers and room types that the room chain reads, the seeds where the room does not fit and a headless check that counts them, a plain room in front of it that makes it fit every time, and a window that lets the room slip by one number. Every step is its own project folder.

![Screenshot](screenshot.png)

## Steps

Every step of the video is its own folder in `steps/`, the exact state at the end of that
part. Open the project in Godot 4.7, then open `steps/<step>/main.tscn` and press F6 to run
that step. The project's main scene is the final step.

| Folder | Part of the video |
|---|---|
| `steps/step_00_start` | Starting point (the final state of tutorial 05) |
| `steps/step_01_fixed_room` | Step 1 - A fixed room |
| `steps/step_02_the_misses` | Step 2 - The misses |
| `steps/step_03_the_pre_room` | Step 3 - A plain room in front |
| `steps/step_04_the_window` | Step 4 - A window |

## Controls

WASD or arrow keys or the left stick to walk, mouse or right stick to look, Space to jump,
Esc gives the mouse back, a click captures it again. Further keys per tutorial are shown
in the video and in the HUD.

## Tests

```sh
godot --headless --path . -s res://tests/run_tests.gd
```

## License

Code and scenes: MIT (see LICENSE).
