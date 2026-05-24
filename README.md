# Ольха — Visual Novel

Historical visual novel set in ancient Kievan Rus.

## Dev workflow

1. Edit files in `game/` (`.rpy` scripts, images)
2. `./rebuild.sh`
3. Press **F5** at **http://localhost:8766**

The script starts a no-cache HTTP server on first run, force-recompiles scripts, and patches `web_build/game.zip`.

## Project structure

```
game/             — Source: .rpy scripts, images, font
web_build/        — Deployable web build
renpy-8.5.2-sdk/  — Ren'Py SDK (compile only)
```

## Notes

- UI images (`ui_dialog_bg.png`, `ui_plashka.png`) are bundled inside `game.zip` directly — they are not in the progressive download manifest so must be embedded.
- Service worker is disabled in `index.html` for development. Re-enable before production deploy.
- `build_info.json` timestamp is bumped on every rebuild so Ren'Py Web re-extracts the zip from its IndexedDB cache.
