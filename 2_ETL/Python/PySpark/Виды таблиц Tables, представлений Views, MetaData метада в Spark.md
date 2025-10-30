### table
Managed и Unmanaged таблицы.

![[Pasted image 20250714231045.png]]

Unmanaged - это наиболее правильный вид таблиц для хранения данных в проде, потому что это таблицы которые хранят ТОЛЬКО метаданные.

![[Pasted image 20250714231402.png]]

### view
Global (доступны для всего кластера) и Session-scoped (внутри одной SparkSession существуют и пропадут после окончания работы приложения)

![[Pasted image 20250714231651.png]]
Для доступа к глобальному представлению необходимо использовать следующий префикс
```python
global_temp.<view_name>
```
### metadata
![[Pasted image 20250714231927.png]]

### Caching
![[Pasted image 20250714232042.png]]