ниже скрипт-пример того как можно отлаживать процедуру с переменными в режиме транзакции DO END
```SQL
-- region тестируем процедуру  
BEGIN TRANSACTION;  
  
DO $$  
    DECLARE  
        process_uuid_delete      uuid[];  
        process_task_dtm_delete  date;  
        process_start_timestamp  timestamp;  
        process_end_timestamp    timestamp;  
        condition_event_type_u   text;  
        -- переменные ниже используются при ручном течитровании через do  
        process_uuid_actual_sync uuid := 'c79ff333-2381-4ed7-ae5c-8b338448f33e';  
    BEGIN  
        RAISE NOTICE 'Значение переменной process_uuid_actual_sync: %', process_uuid_actual_sync;  
        --#region Присваивание временных границ отрезка из буфера  
        -- start        SELECT  
            date_customer_invoice  
        INTO process_start_timestamp  
        FROM  
            erp.transfer_report_19_buffer AS buffer  
        WHERE  
            task_guid = process_uuid_actual_sync  
        ORDER BY  
            date_customer_invoice  
        LIMIT 1;  
        -- end  
        SELECT  
            date_trunc('day', (date_customer_invoice + INTERVAL '1 days'))  
        INTO process_end_timestamp  
        FROM  
            erp.transfer_report_19_buffer AS buffer  
        WHERE  
            task_guid = process_uuid_actual_sync  
        ORDER BY  
            date_customer_invoice DESC  
        LIMIT 1;  
        --#endregion  
        RAISE NOTICE 'Значение переменной process_start_timestamp: %', process_start_timestamp;  
        RAISE NOTICE 'Значение переменной process_end_timestamp: %', process_end_timestamp;  
        -- region Присваиваем значение для переменной process_task_dtm_delete  
        SELECT  
            task_dtm  
        INTO process_task_dtm_delete  
        FROM  
            erp.transfer_report_19_buffer  
        WHERE  
            task_guid = process_uuid_actual_sync  
        ORDER BY  
            task_dtm  
        LIMIT 1;  
        -- endregion  
        RAISE NOTICE 'Значение переменной process_task_dtm_delete: %', process_task_dtm_delete;  
        -- region Создаем таблицу с новыми строками  
        DROP TABLE IF EXISTS new_rows;  
        CREATE TEMP TABLE new_rows AS  
            (SELECT  
                 NULL AS event_type  
               , event_guid  
               , schema_version  
               , task_dtm  
               , task_guid  
               , task_row_count  
               , created_ts  
               , sf_type  
               , document_type_key  
               , sf_number  
               , sf_guid  
               , sf_link  
               , sf_out_doc  
               , series  
               , organization_name  
               , trade_channel_rus_guid  
               , number_rtu  
               , finance_year  
               , customer_invoice_guid  
               , creator_guid  
               , time  
               , payment_schedule_guid  
               , days_period_grace  
               , payer_guid  
               , partner_guid  
               , price_date  
               , price_doc_date  
               , registrar_number  
               , sales_order_guid  
               , unload_point_org_guid  
               , unload_point_org_code  
               , warehouse_guid  
               , nomenclature_name  
               , vendor_code  
               , code  
               , name_full  
               , manufacturer_guid  
               , nomenclature_type_guid  
               , material_group_guid  
               , barcode_ean  
               , brand_guid  
               , l6_sku_guid  
               , l6_sku_code  
               , strength_alcohol  
               , analytic_accounting_group  
               , portfolio_guid  
               , product_category  
               , subbrand_guid  
               , market_guid  
               , planning_level_guid  
               , client_group_guid  
               , client_subgroup_guid  
               , segment_agreement_guid  
               , segment_pricing_guid  
               , shipment_type_name  
               , signboard_guid  
               , license_type_ad_guid  
               , sales_division_guid  
               , business_region_code  
               , region_guid  
               , city_guid  
               , country_guid  
               , delivery_area_guid  
               , shipment_type_guid  
               , delivery_type  
               , client_type  
               , account_group  
               , trade_channel_guid  
               , price_type  
               , partner_route  
               , wholesale_retail  
               , name_ep_guid  
               , partner_network_guid  
               , inn_kpp  
               , head_partner  
               , partner_code  
               , customer_delivery_point_guid  
               , partner_code_adrt  
               , counterparty_legal_entity  
               , counterparty_op  
               , unloading_point  
               , net_weight  
               , weight  
               , weight_unit_guid  
               , volume_dal  
               , volume_unit_guid  
               , quantity  
               , nomenclature_unit_measurement  
               , quantity_dal  
               , excise_sum  
               , revenue_sum_without_vat  
               , revenue_sum_without_vat_fi  
               , revenue_sum_with_vat  
               , vat_sum  
               , price_without_vat  
               , price_with_vat  
               , currencycode  
               , exchange_rate_order_date  
               , exchange_rate_fi  
               , bgs  
               , bgs_fi  
               , basis_calculating_zot  
               , price_general_reduction  
               , gs_discount_mdspsr  
               , gs_discount_mdspsr_fi  
               , tn  
               , tn_fi  
               , piad  
               , piad_fi  
               , pd  
               , pd_fi  
               , edlp  
               , edlp_fi  
               , tmd  
               , tmd_fi  
               , red  
               , red_fi  
               , ld  
               , ld_fi  
               , reg  
               , reg_fi  
               , pud  
               , pud_fi  
               , pred  
               , pred_fi  
               , pdtt  
               , pdtt_fi  
               , mdspsr  
               , mdspsr_fi  
               , tm  
               , tpr  
               , tpr_fi  
               , ssld  
               , ssld_fi  
               , oblig  
               , oblig_fi  
               , round_estimat_price  
               , round_total_price  
               , zmoc  
               , zmin  
               , date_sf  
               , sku_guid  
               , date_customer_invoice  
               , gs  
               , md5_key  
             FROM  
                 erp.transfer_report_19_buffer  
             WHERE  
                 task_guid = process_uuid_actual_sync  
            );  
        -- endregion  
        -- удаляем все кроме 4 выбранных        DELETE  
        FROM            new_rows  
        WHERE  
            md5_key NOT IN  
            ('072df52c97c6689f807955a4fd0e07b8', '3d1d1911c16e91f37966e53198109212', 'c25b0967c37315584e9c4ad044c62c06',  
             '98e2797d4bb10e5b8cd11865d1a1134e');  
        -- создаем измененную строку counterparty_op is NULL, становится "тестовое значение"  
        UPDATE new_rows  
        SET  
            counterparty_op = 'тестовое значение'  
        WHERE  
            md5_key = '072df52c97c6689f807955a4fd0e07b8';  
        -- создаем дубликат строки  
        INSERT INTO  
            new_rows (  
                       event_type  
                     , event_guid  
                     , schema_version  
                     , task_dtm  
                     , task_guid  
                     , task_row_count  
                     , created_ts  
                     , sf_type  
                     , document_type_key  
                     , sf_number  
                     , sf_guid  
                     , sf_link  
                     , sf_out_doc  
                     , series  
                     , organization_name  
                     , trade_channel_rus_guid  
                     , number_rtu  
                     , finance_year  
                     , customer_invoice_guid  
                     , creator_guid  
                     , time  
                     , payment_schedule_guid  
                     , days_period_grace  
                     , payer_guid  
                     , partner_guid  
                     , price_date  
                     , price_doc_date  
                     , registrar_number  
                     , sales_order_guid  
                     , unload_point_org_guid  
                     , unload_point_org_code  
                     , warehouse_guid  
                     , nomenclature_name  
                     , vendor_code  
                     , code  
                     , name_full  
                     , manufacturer_guid  
                     , nomenclature_type_guid  
                     , material_group_guid  
                     , barcode_ean  
                     , brand_guid  
                     , l6_sku_guid  
                     , l6_sku_code  
                     , strength_alcohol  
                     , analytic_accounting_group  
                     , portfolio_guid  
                     , product_category  
                     , subbrand_guid  
                     , market_guid  
                     , planning_level_guid  
                     , client_group_guid  
                     , client_subgroup_guid  
                     , segment_agreement_guid  
                     , segment_pricing_guid  
                     , shipment_type_name  
                     , signboard_guid  
                     , license_type_ad_guid  
                     , sales_division_guid  
                     , business_region_code  
                     , region_guid  
                     , city_guid  
                     , country_guid  
                     , delivery_area_guid  
                     , shipment_type_guid  
                     , delivery_type  
                     , client_type  
                     , account_group  
                     , trade_channel_guid  
                     , price_type  
                     , partner_route  
                     , wholesale_retail  
                     , name_ep_guid  
                     , partner_network_guid  
                     , inn_kpp  
                     , head_partner  
                     , partner_code  
                     , customer_delivery_point_guid  
                     , partner_code_adrt  
                     , counterparty_legal_entity  
                     , counterparty_op  
                     , unloading_point  
                     , net_weight  
                     , weight  
                     , weight_unit_guid  
                     , volume_dal  
                     , volume_unit_guid  
                     , quantity  
                     , nomenclature_unit_measurement  
                     , quantity_dal  
                     , excise_sum  
                     , revenue_sum_without_vat  
                     , revenue_sum_without_vat_fi  
                     , revenue_sum_with_vat  
                     , vat_sum  
                     , price_without_vat  
                     , price_with_vat  
                     , currencycode  
                     , exchange_rate_order_date  
                     , exchange_rate_fi  
                     , bgs  
                     , bgs_fi  
                     , basis_calculating_zot  
                     , price_general_reduction  
                     , gs_discount_mdspsr  
                     , gs_discount_mdspsr_fi  
                     , tn  
                     , tn_fi  
                     , piad  
                     , piad_fi  
                     , pd  
                     , pd_fi  
                     , edlp  
                     , edlp_fi  
                     , tmd  
                     , tmd_fi  
                     , red  
                     , red_fi  
                     , ld  
                     , ld_fi  
                     , reg  
                     , reg_fi  
                     , pud  
                     , pud_fi  
                     , pred  
                     , pred_fi  
                     , pdtt  
                     , pdtt_fi  
                     , mdspsr  
                     , mdspsr_fi  
                     , tm  
                     , tpr  
                     , tpr_fi  
                     , ssld  
                     , ssld_fi  
                     , oblig  
                     , oblig_fi  
                     , round_estimat_price  
                     , round_total_price  
                     , zmoc  
                     , zmin  
                     , date_sf  
                     , sku_guid  
                     , date_customer_invoice  
                     , gs  
                     , md5_key)  
        SELECT *  
        FROM  
            new_rows  
        WHERE  
            md5_key = '3d1d1911c16e91f37966e53198109212';  
        -- создаем строку с ключом которого еще нет в таблице  
        UPDATE new_rows  
        SET  
            md5_key = 'c25b0967c37315584e9c4ad044c62c07'  
        WHERE  
            md5_key = 'c25b0967c37315584e9c4ad044c62c06';  
        -- region Помечаем строки свзяанные с дубликатом флагом u  
        WITH  
            duplicates AS (SELECT  
                               count(*)  
                             , nr.md5_key  
                           FROM  
                               erp_cur.transfer_report_19 AS t  
                                   INNER JOIN new_rows AS nr ON nr.md5_key = t.md5_key  
                           GROUP BY  
                               nr.md5_key  
                           HAVING  
                               count(*) > 1  
            )  
        UPDATE new_rows  
        SET  
            event_type = 'u'  
        FROM  
            duplicates  
        WHERE  
              new_rows.md5_key = duplicates.md5_key  
          AND new_rows.event_type IS NULL;  
  
        -- endregion+  
        -- region Помечаем строки i        WITH  
            rows AS (SELECT  
                         nr.md5_key  
                     FROM  
                         new_rows AS nr  
                             LEFT JOIN erp_cur.transfer_report_19 AS t ON t.md5_key = nr.md5_key  
                     WHERE  
                         t.md5_key IS NULL  
            )  
        UPDATE new_rows  
        SET  
            event_type = 'i'  
        FROM  
            rows  
        WHERE  
              new_rows.md5_key = rows.md5_key  
          AND new_rows.event_type IS NULL;  
  
        -- endregion  
        -- region Помечаем создаем событие d для отсутствующих строк        WITH  
            rows AS (SELECT  
                         t.md5_key  
                     FROM  
                         erp_cur.transfer_report_19 AS t  
                             LEFT JOIN new_rows AS nr ON t.md5_key = nr.md5_key  
                     WHERE  
                           nr.md5_key IS NULL  
                       AND t.date_customer_invoice BETWEEN process_start_timestamp AND process_end_timestamp  
            )  
        INSERT  
        INTO            new_rows (  
                       event_type  
                     , event_guid  
                     , schema_version  
                     , task_dtm  
                     , task_guid  
                     , task_row_count  
            -- , created_ts  
                     , sf_type  
                     , document_type_key  
                     , sf_number  
                     , sf_guid  
                     , sf_link  
                     , sf_out_doc  
                     , series  
                     , organization_name  
                     , trade_channel_rus_guid  
                     , number_rtu  
                     , finance_year  
                     , customer_invoice_guid  
                     , creator_guid  
                     , time  
                     , payment_schedule_guid  
                     , days_period_grace  
                     , payer_guid  
                     , partner_guid  
                     , price_date  
                     , price_doc_date  
                     , registrar_number  
                     , sales_order_guid  
                     , unload_point_org_guid  
                     , unload_point_org_code  
                     , warehouse_guid  
                     , nomenclature_name  
                     , vendor_code  
                     , code  
                     , name_full  
                     , manufacturer_guid  
                     , nomenclature_type_guid  
                     , material_group_guid  
                     , barcode_ean  
                     , brand_guid  
                     , l6_sku_guid  
                     , l6_sku_code  
                     , strength_alcohol  
                     , analytic_accounting_group  
                     , portfolio_guid  
                     , product_category  
                     , subbrand_guid  
                     , market_guid  
                     , planning_level_guid  
                     , client_group_guid  
                     , client_subgroup_guid  
                     , segment_agreement_guid  
                     , segment_pricing_guid  
                     , shipment_type_name  
                     , signboard_guid  
                     , license_type_ad_guid  
                     , sales_division_guid  
                     , business_region_code  
                     , region_guid  
                     , city_guid  
                     , country_guid  
                     , delivery_area_guid  
                     , shipment_type_guid  
                     , delivery_type  
                     , client_type  
                     , account_group  
                     , trade_channel_guid  
                     , price_type  
                     , partner_route  
                     , wholesale_retail  
                     , name_ep_guid  
                     , partner_network_guid  
                     , inn_kpp  
                     , head_partner  
                     , partner_code  
                     , customer_delivery_point_guid  
                     , partner_code_adrt  
                     , counterparty_legal_entity  
                     , counterparty_op  
                     , unloading_point  
                     , net_weight  
                     , weight  
                     , weight_unit_guid  
                     , volume_dal  
                     , volume_unit_guid  
                     , quantity  
                     , nomenclature_unit_measurement  
                     , quantity_dal  
                     , excise_sum  
                     , revenue_sum_without_vat  
                     , revenue_sum_without_vat_fi  
                     , revenue_sum_with_vat  
                     , vat_sum  
                     , price_without_vat  
                     , price_with_vat  
                     , currencycode  
                     , exchange_rate_order_date  
                     , exchange_rate_fi  
                     , bgs  
                     , bgs_fi  
                     , basis_calculating_zot  
                     , price_general_reduction  
                     , gs_discount_mdspsr  
                     , gs_discount_mdspsr_fi  
                     , tn  
                     , tn_fi  
                     , piad  
                     , piad_fi  
                     , pd  
                     , pd_fi  
                     , edlp  
                     , edlp_fi  
                     , tmd  
                     , tmd_fi  
                     , red  
                     , red_fi  
                     , ld  
                     , ld_fi  
                     , reg  
                     , reg_fi  
                     , pud  
                     , pud_fi  
                     , pred  
                     , pred_fi  
                     , pdtt  
                     , pdtt_fi  
                     , mdspsr  
                     , mdspsr_fi  
                     , tm  
                     , tpr  
                     , tpr_fi  
                     , ssld  
                     , ssld_fi  
                     , oblig  
                     , oblig_fi  
                     , round_estimat_price  
                     , round_total_price  
                     , zmoc  
                     , zmin  
                     , date_sf  
                     , sku_guid  
                     , date_customer_invoice  
                     , gs  
                     , md5_key)  
        SELECT  
            'd'  
          , process_uuid_actual_sync  
          , tr19.schema_version  
          , process_task_dtm_delete  
          , process_uuid_actual_sync  
          , tr19.task_row_count  
            -- , created_ts  
          , tr19.sf_type  
          , tr19.document_type_key  
          , tr19.sf_number  
          , tr19.sf_guid  
          , tr19.sf_link  
          , tr19.sf_out_doc  
          , tr19.series  
          , tr19.organization_name  
          , tr19.trade_channel_rus_guid  
          , tr19.number_rtu  
          , tr19.finance_year  
          , tr19.customer_invoice_guid  
          , tr19.creator_guid  
          , tr19.time  
          , tr19.payment_schedule_guid  
          , tr19.days_period_grace  
          , tr19.payer_guid  
          , tr19.partner_guid  
          , tr19.price_date  
          , tr19.price_doc_date  
          , tr19.registrar_number  
          , tr19.sales_order_guid  
          , tr19.unload_point_org_guid  
          , tr19.unload_point_org_code  
          , tr19.warehouse_guid  
          , tr19.nomenclature_name  
          , tr19.vendor_code  
          , tr19.code  
          , tr19.name_full  
          , tr19.manufacturer_guid  
          , tr19.nomenclature_type_guid  
          , tr19.material_group_guid  
          , tr19.barcode_ean  
          , tr19.brand_guid  
          , tr19.l6_sku_guid  
          , tr19.l6_sku_code  
          , tr19.strength_alcohol  
          , tr19.analytic_accounting_group  
          , tr19.portfolio_guid  
          , tr19.product_category  
          , tr19.subbrand_guid  
          , tr19.market_guid  
          , tr19.planning_level_guid  
          , tr19.client_group_guid  
          , tr19.client_subgroup_guid  
          , tr19.segment_agreement_guid  
          , tr19.segment_pricing_guid  
          , tr19.shipment_type_name  
          , tr19.signboard_guid  
          , tr19.license_type_ad_guid  
          , tr19.sales_division_guid  
          , tr19.business_region_code  
          , tr19.region_guid  
          , tr19.city_guid  
          , tr19.country_guid  
          , tr19.delivery_area_guid  
          , tr19.shipment_type_guid  
          , tr19.delivery_type  
          , tr19.client_type  
          , tr19.account_group  
          , tr19.trade_channel_guid  
          , tr19.price_type  
          , tr19.partner_route  
          , tr19.wholesale_retail  
          , tr19.name_ep_guid  
          , tr19.partner_network_guid  
          , tr19.inn_kpp  
          , tr19.head_partner  
          , tr19.partner_code  
          , tr19.customer_delivery_point_guid  
          , tr19.partner_code_adrt  
          , tr19.counterparty_legal_entity  
          , tr19.counterparty_op  
          , tr19.unloading_point  
          , tr19.net_weight  
          , tr19.weight  
          , tr19.weight_unit_guid  
          , tr19.volume_dal  
          , tr19.volume_unit_guid  
          , tr19.quantity  
          , tr19.nomenclature_unit_measurement  
          , tr19.quantity_dal  
          , tr19.excise_sum  
          , tr19.revenue_sum_without_vat  
          , tr19.revenue_sum_without_vat_fi  
          , tr19.revenue_sum_with_vat  
          , tr19.vat_sum  
          , tr19.price_without_vat  
          , tr19.price_with_vat  
          , tr19.currencycode  
          , tr19.exchange_rate_order_date  
          , tr19.exchange_rate_fi  
          , tr19.bgs  
          , tr19.bgs_fi  
          , tr19.basis_calculating_zot  
          , tr19.price_general_reduction  
          , tr19.gs_discount_mdspsr  
          , tr19.gs_discount_mdspsr_fi  
          , tr19.tn  
          , tr19.tn_fi  
          , tr19.piad  
          , tr19.piad_fi  
          , tr19.pd  
          , tr19.pd_fi  
          , tr19.edlp  
          , tr19.edlp_fi  
          , tr19.tmd  
          , tr19.tmd_fi  
          , tr19.red  
          , tr19.red_fi  
          , tr19.ld  
          , tr19.ld_fi  
          , tr19.reg  
          , tr19.reg_fi  
          , tr19.pud  
          , tr19.pud_fi  
          , tr19.pred  
          , tr19.pred_fi  
          , tr19.pdtt  
          , tr19.pdtt_fi  
          , tr19.mdspsr  
          , tr19.mdspsr_fi  
          , tr19.tm  
          , tr19.tpr  
          , tr19.tpr_fi  
          , tr19.ssld  
          , tr19.ssld_fi  
          , tr19.oblig  
          , tr19.oblig_fi  
          , tr19.round_estimat_price  
          , tr19.round_total_price  
          , tr19.zmoc  
          , tr19.zmin  
          , tr19.date_sf  
          , tr19.sku_guid  
          , tr19.date_customer_invoice  
          , tr19.gs  
          , tr19.md5_key  
        FROM  
            erp_cur.transfer_report_19 AS tr19  
                INNER JOIN rows AS r ON r.md5_key = tr19.md5_key;  
        -- endregion  
        --#region Динамическая генерация условия condition_event_type_u которое позволит далее создать событие u        -- Получаем список столбцов из конкретной таблицы, исключая столбцы с ключами, если необходимо        SELECT  
            string_agg(  
                    'nr.' || column_name || ' IS DISTINCT FROM ' || 't.' || column_name, ' OR ')  
        INTO  
            condition_event_type_u  
        FROM  
            information_schema.columns  
        WHERE  
              table_schema = 'erp'  
          AND table_name = 'transfer_report_19'  
              -- здесь необходимо исключить автогенерируемы столбцы и столбцы относящиеся к ключу  
          AND column_name NOT IN  
              ('event_guid', 'event_type', 'schema_version', 'task_dtm', 'task_guid', 'task_row_count', 'created_ts',  
               'md5_key', 'date_customer_invoice', 'finance_year',  
               'registrar_number', 'number_rtu', 'sf_number', 'code', 'sku_guid', 'l6_sku_guid', 'sales_order_guid',  
               'creator_guid');  
  
        --#endregion  
        -- region Помечаем строки u        EXECUTE format('WITH  
    rows AS (SELECT                 t.md5_key             FROM                 erp_cur.transfer_report_19 AS t                     INNER JOIN new_rows AS nr ON t.md5_key = nr.md5_key             WHERE                 %s    )UPDATE new_rows  
SET  
    event_type = ''u''  
FROM  
    rowsWHERE  
      new_rows.md5_key = rows.md5_key  AND new_rows.event_type IS NULL', condition_event_type_u);  
  
        -- endregion  
        -- region Удаляем строки из временной таблицы с флагом c        DELETE  
        FROM            new_rows  
        WHERE  
            event_type IS NULL;  
        -- endregion  
    END $$;  
  
-- таблица new_rows по интересующим нас строкам  
SELECT  
    md5_key  
  , event_type  
  , *  
FROM  
    new_rows  
WHERE  
    md5_key IN  
    ('072df52c97c6689f807955a4fd0e07b8', '3d1d1911c16e91f37966e53198109212', 'c25b0967c37315584e9c4ad044c62c07',  
     'c25b0967c37315584e9c4ad044c62c06', '98e2797d4bb10e5b8cd11865d1a1134e');  
  
ROLLBACK TRANSACTION;
```
