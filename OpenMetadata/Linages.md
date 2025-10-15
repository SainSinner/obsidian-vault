В пределах базы данных linage собирается самостоятельно, вот пример
http://meta.ovp.ru:8585/table/Greenplum%20%D1%82%D0%B5%D1%81%D1%82.main.opt_export.erp_pnl_articles/lineage
http://meta.ovp.ru:8585/table/Greenplum%20%D1%82%D0%B5%D1%81%D1%82.main.opt_export.illinois_type_tma_channel/lineage

Между базами данных собирается вручную через ui интерфейс, вот пример
http://meta.ovp.ru:8585/table/%D0%98%D0%BB%D0%BB%D0%B8%D0%BD%D0%BE%D0%B9%D1%81%20%D0%9F%D1%80%D0%BE%D1%87%D0%B5%D0%B5.SMART_DWH.dbo.tbl_ref_fc_ConditionMaterial/lineage
![[Pasted image 20241126181953.png]]
Попробовал добавить kafka, но, скорее всего потому что у нас нет схем данных в топиках, openmetadata не может спарсить объекты json. http://meta.ovp.ru:8585/table/Greenplum%20%D0%BF%D1%80%D0%BE%D0%B4%D1%83%D0%BA%D1%82%D0%B8%D0%B2.main.erp.ref_trade_channels/lineage

![[Pasted image 20241126183229.png]]
- [x] Необходимо попробовать добавить схему в схема регистри, потом обновить данные в openmetadata и проверить как это выглядеть будет
- [ ] Необходимо попробовать как-то спарсить информацию из nifi и всписать в linage, таким образом будет максимально приближенно к реальности.