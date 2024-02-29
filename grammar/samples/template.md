# Sample Grammar expressions

Please find below the list of sample # Sample Grammar expressions. You can use [GrapiQL](/graphiql) console to run these queries.


1. Select the more up-todate price based on  

    ```graphql
    report_2.price if isnull(report_2.create_time, 0) >= isnull(report_1.create_time, 0) else report_1.price
    any(formula_for_price if in_date_range)
    isnull(diyTrim_multiplier if diyTrim_multiplier > 0 else 1.0, 1.0)
    diyTrim_multiplier_override.attr_coeff if !diyTrim_multiplier_override.anchor_sign
    "'no data' if market_average_price.price == 0 else ('equal to market' if abs(market_average_price.price - zone_price) < 0.01 else ('below market' if market_average_price.price > zone_price else 'above market'))"
    date == eval('target_reference_date')
  ```
