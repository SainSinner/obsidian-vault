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
- Заметка пишется через двоеточие после имени: "<Имя>: <для чего>"
- Схема конфига не позволяет отдельных полей description/note —
  заметку можно добавить только через переопределение "name".
- В схеме модели additionalProperties: false — добавляй только
  поддерживаемые поля (name, modalities, cost, limit, options).
- Если в проекте есть свой opencode.json с этим провайдером,
  продублируй переопределение и туда.
- После правок проверь валидность JSONC и напомни пользователю
  перезапустить OpenCode.

Пример (реальный кейс, провайдер opencode-go):
"provider": {
  "opencode-go": {
    "models": {
      "gpt-6-luna":                { "name": "GPT-6 Luna: Разработка" },
      "glm-5.3-flash":             { "name": "GLM-5.3-Flash: Разработка" },
      "grok-4.7":                  { "name": "Grok 4.7: Поиск" },
      "qwen3.8-flash":             { "name": "Qwen3.8 Flash: Поиск" },
      "kimi-k3":                   { "name": "Kimi K3: Архитектура, большой репозиторий" },
      "deepseek-v4.1-flash":       { "name": "DeepSeek V4.1 Flash: Архитектура" },
      "deepseek-v4-pro":           { "name": "DeepSeek V4 Pro: Алгоритмы" },
      "deepseek-v4-flash":         { "name": "DeepSeek V4 Flash: Алгоритмы" },
      "kimi-k2.6":                 { "name": "Kimi K2.6: Большой репозиторий" },
      "muse-spark-1.2-contributor":{ "name": "Muse Spark 1.2: Изображения" },
      "longcat-2.5-preview-free":  { "name": "LongCat 2.5-preview-free: Изображения" }
    }
  }
}

Мои заметки: <список "model_id: заметка" или "Имя: заметка">