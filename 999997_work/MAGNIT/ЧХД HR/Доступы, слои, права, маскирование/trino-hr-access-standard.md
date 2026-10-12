# Стандарт: слои данных и разграничение доступа в Trino (домен HR)

Версия: черновик 1.0 · Дата: 2026-10-11 · Статус: на согласовании

---

## 1. Назначение

Документ фиксирует целевую архитектуру слоёв данных домена HR в Trino и модель
разграничения доступа к ним, включая защиту чувствительных данных (ПДн, зарплаты).

## 2. Вводные

| Параметр | Значение |
|---|---|
| Дистрибутив Trino | предоставленный DevOps; доступны плагины **Ranger** и **OPA** |
| Инфраструктура авторизации | **Apache Ranger уже развёрнут в компании** (выбран как основной механизм) |
| Аутентификация | **LDAP / Active Directory** |
| Источники данных | S3 + Iceberg/Delta (lakehouse), реляционные БД, Kafka |
| Потребители | аналитики (SQL/Jupyter), ETL-джобы, BI-системы, приложения по API |
| Аудит доступа | желателен (не обязателен) → Ranger audit (log4j на старте) |
| Реестр id систем | корпоративная **CMDB**, 4-значный id |

## 3. Слои данных и стандарт нейминга

Слои: **LND → RAW → L1 → L2**. Один lakehouse-каталог `lake` (Iceberg на S3),
слои и источники — как схемы.

```
lake.lnd_<src>_t / lake.lnd_<src>_v   — приземление по источнику
lake.raw_<src>_t / lake.raw_<src>_v   — RAW по источнику
lake.l1_t / lake.l1_v                 — очищенный интегрированный слой
lake.l2                               — витрины (без деления t/v)
lake.meta                             — реестры и mapping-таблицы
```

Правила:

- `<src>` — 4-значный id системы-источника из CMDB (уникален в масштабе
  компании, поэтому доменный префикс в имени схемы не используется).
- Суффиксы: `_t` — схема таблиц, `_v` — схема представлений.
- LND и RAW — источнико-ориентированные (схема на каждый источник);
  L1 — интегрированный (источники объединены), деление t/v сохраняется;
  L2 — без деления.
- В таблицах L1/L2 — техническая колонка `source_system_id` (4-значный id)
  для lineage и будущего row-level доступа.
- Реестр источников: таблица `lake.meta.source_systems(source_id, system_name, owner, criticality, ...)`.
- Каталоги внешних источников (`pg_*`, `kafka` и т.п.) — «нулевой слой»:
  доступ только у ETL и дата-инженеров, аналитикам закрыт (нельзя обходить слои).

Пример:

```
lake.lnd_zup1_t, lake.lnd_zup1_v   — 1С:ЗУП, приземление
lake.raw_zup1_t, lake.raw_zup1_v   — 1С:ЗУП, RAW
lake.raw_saph_t                    — SAP HCM, RAW
```

## 4. Учётные записи и группы

Аутентификация всех пользователей и сервисных учёток — через LDAP/AD.
Сервисные УЗ заводятся в AD (единая точка управления и отзыва).

| Группа AD | Тип | Назначение |
|---|---|---|
| `svc-etl-hr` | сервисная | джобы Airflow/Spark/dbt домена HR |
| `hr-data-engineers` | люди | разработчики домена HR |
| `hr-de-sensitive` | люди | инженеры, допущенные к чувствительным источникам |
| `hr-analysts-privileged` | люди | доступ к ПДн/зарплатам |
| `hr-analysts` | люди | аналитики HR (данные с масками) |
| `bi-readers` | люди | читатели витрин L2 |
| `svc-bi`, `svc-api-*` | сервисные | BI-сервер; по одной УЗ на каждое приложение |
| `trino-admins` | люди | администрирование Trino |

Конфигурация Trino (координатор):

```properties
# config.properties
http-server.authentication.type=ldap
http-server.https.enabled=true
ldap.url=ldaps://ad.company.ru:636
ldap.user-bind-pattern=${USER}@company.ru

# access-control.properties
access-control.name=ranger
ranger.service.name=trino
```

Группы AD попадают в Ranger через UserSync (уже работает в компании).

## 5. Матрица доступа

| Группа | `lnd_*` | `raw_*` | `raw_<sens>_*` | `l1_t` | `l1_v` | `l2` |
|---|---|---|---|---|---|---|
| `svc-etl-hr` | RW | RW | RW | RW | RW | RW |
| `hr-data-engineers` | R | RW | **DENY** | RW | RW | RW |
| `hr-de-sensitive` | R | RW | RW | RW | RW | RW |
| `hr-analysts-privileged` | — | R | DENY | R | R | R |
| `hr-analysts` | — | — | — | — | R | R |
| `bi-readers`, `svc-bi`, `svc-api-*` | — | — | — | — | — | R |

Дополнительно: DDL (CREATE/DROP) в каталоге `lake` — только `svc-etl-hr`,
`hr-data-engineers`, `hr-de-sensitive`.

## 6. Защита чувствительных данных — три рубежа

1. **Слои.** Аналитики не имеют доступа к LND/RAW в принципе — сырые ПДн
   недоступны по построению.
2. **Чувствительные источники в RAW.** Точечная **deny-политика** Ranger на
   `raw_<sens>_*` (deny приоритетнее wildcard-allow). Доступ: только
   `svc-etl-hr` + `hr-de-sensitive`.
   ⚠️ Операционное правило: при появлении новых групп их необходимо добавлять
   в deny-политики (пункт в чек-листе онбординга).
3. **L1.** Аналитики работают только через `l1_v` — представления, в которых
   зарплаты/ПДн вырезаны или замаскированы. View исполняются с правами
   владельца (security definer), доступ к `l1_t` аналитикам не нужен.
   Ranger-маски на `l1_t` — второй контур, если кому-то дан прямой доступ.

Пример маскирующего представления:

```sql
CREATE OR REPLACE VIEW lake.l1_v.employees AS
SELECT
    employee_id,
    full_name,
    department_id,
    CASE
        WHEN contains(current_groups, 'hr-analysts-privileged') THEN salary
        ELSE NULL
    END AS salary,
    CASE
        WHEN contains(current_groups, 'hr-analysts-privileged') THEN phone
        ELSE '***' || substr(phone, length(phone) - 3)
    END AS phone,
    source_system_id
FROM lake.l1_t.employees;
```

## 7. Политики Ranger (перечень)

| Политика | Ресурс (schema) | Группа | Доступ |
|---|---|---|---|
| `lnd-etl` | `lnd_*` | `svc-etl-hr` | RW |
| `lnd-de-read` | `lnd_*` | `hr-data-engineers`, `hr-de-sensitive` | R |
| `raw-etl` | `raw_*` | `svc-etl-hr` | RW |
| `raw-de` | `raw_*` | `hr-data-engineers`, `hr-de-sensitive` | RW |
| `raw-priv-read` | `raw_*` | `hr-analysts-privileged` | R |
| `raw-deny-<sens>` | `raw_<sens>_*` | все группы, кроме разрешённых | **DENY** |
| `l1-t-de` | `l1_t` | `svc-etl-hr`, `hr-data-engineers`, `hr-de-sensitive` | RW |
| `l1-t-priv-read` | `l1_t` | `hr-analysts-privileged` | R (+ маски при необходимости) |
| `l1-v-read` | `l1_v` | `hr-analysts`, `hr-analysts-privileged`, DE | R |
| `l2-read` | `l2` | все группы читателей | R |
| `lake-ddl` | catalog `lake` | `svc-etl-hr`, DE-группы | CREATE/DROP |

Механика wildcard: политики на `raw_*` / `lnd_*` автоматически покрывают
новые источники — при онбординге политики менять не нужно (только deny для
чувствительных).

## 8. Подключение потребителей

| Потребитель | Учётка | Примечание |
|---|---|---|
| Аналитики (DBeaver, Jupyter) | персональные AD | полный персональный аудит |
| ETL (Airflow, Spark, dbt) | `svc-etl-hr` | максимум прав в домене HR, ноль — в чужих |
| BI | `svc-bi` (старт) | разграничение на стороне BI; позже рассмотреть impersonation персональных УЗ |
| Приложения | `svc-api-*` по одной на систему | права строго на нужные таблицы `l2`, точечный отзыв |

## 9. Аудит

Ranger audit: на старте — в log4j (просто), при запросе СБ — в Solr.
Покрывает: кто, когда, к каким каталогам/схемам/таблицам/колонкам обращался.

## 10. Row-level доступ (точка расширения)

Признак фильтрации пока не определён. Архитектура к нему готова, переделки
не потребуются:

- простое условие (по колонке таблицы) → **Ranger row-filter** на таблицу;
- сложное (справочник «пользователь → подразделения») → **secured view**
  с join на mapping-таблицу по `current_user`.

## 11. Онбординг нового источника (чек-лист)

1. Взять 4-значный id из CMDB → зарегистрировать в `lake.meta.source_systems`.
2. Создать схемы `lnd_<id>_t`, `lnd_<id>_v`, `raw_<id>_t`, `raw_<id>_v`.
3. Если источник чувствительный → deny-политика `raw-deny-<id>` в Ranger.
4. Джобы завести под `svc-etl-hr`; wildcard-политики подхватят схемы сами.
5. При создании новых групп AD — добавить их в существующие deny-политики.

## 12. Открытые вопросы

| # | Вопрос | С кем решать |
|---|---|---|
| 1 | Признак row-level фильтрации (подразделение? регион? роль?) | владельцы данных HR |
| 2 | Перечень чувствительных источников (criticality в CMDB) | владельцы данных + СБ |
| 3 | Какая BI-система → возможен ли impersonation | владелец BI |
| 4 | Точная версия Trino (для планирования: Ranger-плагин встроен с 436) | DevOps |
