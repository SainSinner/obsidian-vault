собрать билд с опциями
```
podman compose up --build --force-recreate --renew-anon-volumes --no-cache
```
- **`--build`** (`--pull always`) - принудительная пересборка образов
    
- **`--force-recreate`** - принудительно пересоздать контейнеры
    
- **`--renew-anon-volumes`** - обновить анонимные тома
    
- **`--no-cache`** - не использовать кеш при сборке (для Dockerfile)