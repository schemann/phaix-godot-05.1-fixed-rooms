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

## Changed since the video

- One fix went into every step folder after the video: the old rooms are now freed when the door behind the player has shut, not when the player enters the next room. Before, you could look back through that door while it was still closing and see a hole where the oldest room had been.
- `door.gd` has a new signal, `closed`, emitted when the door has finished swinging shut (never when it is opened again on the way).
- `level.gd` has a new function, `_on_door_closed(index)`, which frees the rooms behind that door and puts a wall where the doorway of the room just left was. `_spawn_room` connects the signal, and `_on_room_entered` only closes the door behind the player now.
- `tests/run_tests.gd` has a new test, `test_rooms_wait_for_the_door`, and the streaming test expects the rooms to go when the door has shut.
- The rest is as in the video.

## Support

Support the channel: https://ko-fi.com/phaix or https://github.com/sponsors/schemann

## License

Code and scenes: MIT (see LICENSE).
