### С использованием SQL
```python
#find all flights whose distance is greater than 1,000 miles
spark.sql("select * from us_delay_flights_tbl where distance > 1000 order by distance desc").show(5)

# label all US flights, regardless of origin and destination, with an indication of the delays they experienced: 
# Very Long Delays (> 6 hours), Long Delays (2–6 hours), etc
spark.sql("""SELECT delay, origin, destination, 
              CASE
                  WHEN delay > 360 THEN 'Very Long Delays'
                  WHEN delay >= 120 AND delay <= 360 THEN 'Long Delays'
                  WHEN delay >= 60 AND delay < 120 THEN 'Short Delays'
                  WHEN delay > 0 and delay < 60 THEN 'Tolerable Delays'
                  WHEN delay = 0 THEN 'No Delays'
                  ELSE 'Early'
               END AS Flight_Delays
               FROM us_delay_flights_tbl
               ORDER BY origin, delay DESC""").show(10)
```

### С использованием PySpark
```python
#Same in PySpark 
# In Python
from pyspark.sql.functions import col, desc
(df.select("distance", "origin", "destination")
  .where(col("distance") > 1000)
  .orderBy(desc("distance"))).show(10)

# Or
(df.select("distance", "origin", "destination")
  .where("distance > 1000")
  .orderBy("distance", ascending=False).show(10))
```