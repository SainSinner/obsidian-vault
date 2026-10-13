Добавь заметки к моделям в OpenCode через глобальный конфиг:

Файл: ~/.config/opencode/opencode.jsonc (если не существует — создай
с {"$schema": "https://opencode.ai/config.json"}). Формат JSONC.

Внутрь корневого объекта добавь (рядом с существующими ключами):
"provider": {
  "<provider_id>": {
    "models": {
      "<model_id>": { "name": "<Оригинальное имя>: <заметка>" }
    }
  }
}

Правила:
- provider_id и model_id бери строго из каталога модели (models.dev,
  эндпоинт провайдера /v1/models) — не выдумывай.
- Имя модели дополняй тегами без символа # в формате:
  "<Имя> — <задача>, <качество/экономия>, <vpn/no_vpn/vpn_to_check>".
- Схема конфига не позволяет отдельных полей description/note —
  заметку можно добавить только через переопределение "name".
- В схеме модели additionalProperties: false — добавляй только
  поддерживаемые поля (name, modalities, cost, limit, options).
- Если в проекте есть свой opencode.json с этим провайдером,
  продублируй переопределение и туда.
- После правок проверь валидность JSONC и напомни пользователю
  перезапустить OpenCode.

Пример (актуальный список моделей, провайдер opencode-go):
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "opencode-go": {
      "models": {
        "gpt-6-luna":                  { "name": "GPT-6 Luna — сложно, качество, vpn" },
        "kimi-k2.7-code":              { "name": "Kimi K2.7 Code — сложно, качество, no_vpn" },
        "qwen3.7-plus":                { "name": "Qwen3.7 Plus — сложно, качество, vpn_to_check" },
        "mimo-v2.6-pro":               { "name": "MiMo-V2.6-Pro — сложно, экономия, no_vpn" },
        "gpt-5.6-luna":                { "name": "GPT 5.6 Luna — средне, качество, vpn_to_check" },
        "glm-5.3-flash":               { "name": "GLM-5.3-Flash — средне, экономия, no_vpn" },
        "qwen3.8-flash":               { "name": "Qwen3.8 Flash — поиск, качество, no_vpn" },
        "deepseek-v4.1-flash":         { "name": "DeepSeek V4.1 Flash — поиск, экономия, no_vpn" },
        "muse-spark-1.2-contributor":  { "name": "Muse Spark 1.2 — изображения, качество, vpn" },
        "deepseek-v4-flash-vision-exp": { "name": "DeepSeek V4 Flash Vision Exp — изображения, экономия, vpn_to_check" }
      }
    }
  }
}
```

Мои заметки: <список "model_id: заметка" или "Имя: заметка">
