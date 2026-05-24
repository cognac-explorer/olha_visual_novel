#!/bin/bash
set -e
cd "$(dirname "$0")"

# Start dev server on :8766 if not already running
if ! ss -tlnp 2>/dev/null | grep -q ':8766'; then
    (cd docs && python3 -c "
import http.server, socketserver
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control','no-store')
        super().end_headers()
    def log_message(self,f,*a):
        import time; print(time.strftime('%H:%M:%S'),f%a,flush=True)
socketserver.TCPServer.allow_reuse_address=True
with socketserver.TCPServer(('',8766),H) as s: s.serve_forever()
") &>/dev/null &
    disown $!
    echo "Dev server started → http://localhost:8766"
fi

echo "Compiling..."
rm -f game/*.rpyc game/cache/*.rpyb
./renpy-8.5.2-sdk/renpy.sh . compile

echo "Patching game.zip..."
python3 - <<'EOF'
import zipfile, os, json, time

src = 'docs/game.zip'
tmp = 'docs/game_new.zip'

updates = {
    'game/options.rpy', 'game/options.rpyc',
    'game/screens.rpy', 'game/screens.rpyc',
    'game/script.rpy',  'game/script.rpyc',
    'game/cache/bytecode-312.rpyb',
    'game/cache/screens.rpyb',
    'game/cache/py3analysis.rpyb',
}

# Images bundled directly in game.zip (not via progressive download)
bundled_images = [
    'game/images/ui_dialog_bg.png',
    'game/images/ui_plashka.png',
    'game/images/simple_textbox.png',
    'game/images/bg_knyazhy_dvor.jpg',
]

with zipfile.ZipFile(src, 'r') as zi:
    build_info = json.loads(zi.read('game/cache/build_info.json'))
build_info['time'] = time.time()
new_build_info = json.dumps(build_info).encode()

bundled_set = set(bundled_images)

with zipfile.ZipFile(src, 'r') as zi, zipfile.ZipFile(tmp, 'w', zipfile.ZIP_DEFLATED) as zo:
    for item in zi.infolist():
        if item.filename in bundled_set:
            continue  # re-added fresh below
        path = item.filename.lstrip('/')
        if item.filename == 'game/cache/build_info.json':
            zo.writestr(item, new_build_info)
            print(f'  bumped {item.filename}')
        elif item.filename in updates and os.path.exists(path):
            zo.writestr(item, open(path, 'rb').read())
            print(f'  updated {item.filename}')
        else:
            zo.writestr(item, zi.read(item.filename))
    for img_path in bundled_images:
        if os.path.exists(img_path):
            zo.write(img_path, img_path)
            print(f'  bundled {img_path}')

os.replace(tmp, src)
EOF

echo "Syncing images..."
cp game/images/*.png docs/game/images/
cp game/images/*.jpg docs/game/images/ 2>/dev/null || true

echo "Done → http://localhost:8766 (press F5)"

