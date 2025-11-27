# Visora UI App - Flutter

## Setup
1. flutter create visora_ui_app
2. Replace files with repo structure above
3. Update backend base URL in `render_settings.dart` and `render_status.dart` or centralize into environment/config.
4. flutter pub get
5. flutter run

## What this repo contains
- Provider-based app state
- Screens split into files for flow: script -> characters -> scenes -> voice -> render -> status -> player
- `VisoraApi` service (http) for backend integration (endpoints are placeholders matching your backend).
