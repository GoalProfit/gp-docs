
<h1>Input data for optimization</h1>

Input optimization accepts data in the json file structure.
The structure of the input json file:

```json
{
  // General information
  // Unique config ID (optional)
  "config_id":"",    
  
  //  Rules library that serves as the foundation for the input file used in optimization
  "config_name":"", 
  
  // User ID (optional)
  "create_user":"",  
  
  // Optimization start date (optional)
  "create_time":"",  

  // Data frame defining the scope of the optimization
  "items": <data_frame>,

  // List of optimization rules
  "rules": Vec <<SamePrice> | <PctChange> | <AbsChange> | <Relations> | <FixedPrice> | <InitialPrice> | <BalancedOptimization>>,

  // List of rules that are applied after finding the optimal price
  "post_rules": Vec <<FixedPrice> | <RoundingRange> | <PctChange> | <MinPriceChange>>

  // Model parameters
  "modeling": {
    "params":  <data_frame>,
    "season":  <data_frame>
  }

  // Fine-tuning optimization
  "opt_configuration": Dict<String, Vec<Value>>,
  
  // setting to display additional columns in the optimization results
  // "output_configuration": {
  //   "columns":["item","current_price"]
  // }
  "output_configuration": Dict<String, Vec<Value>>
}

```

where <data_frame>

```json
{
   "columns": Vec <String>
   "data": Vec< Vec< <String> | <Float> | <Bool> | null >>
}
```

An example of data frame defining the scope of the optimization:

```json
{
  "columns": [
    "item",
    "location",
    "cost",
    "equiv_unit_size",
    "current_price",
    "size_class.size_class",
    "size_group.size_group"
  ],
  "data": [
    [
      "SKU015769",
      "Location 1",
      49.02,
      150,
      82.80,
      "1",
      "S"
    ],
    [
      "SKU260533",
      "Location 2",
      114.29,
      500,
      251,
      "2",
      "M"
    ]
  ]
}

```

An example of a json file with an optimization task.
The current price for the product is 100, the purchase price is 50.
Added a PctChange rule that sets the optimal price range from 300 to 310.
```json
{
    "items": {
      "columns":["item", "current_price", "cost"],
      "data":[
          ["p1",100, 50]
        ]
    },
    "rules": [
        {
            "id": "1",
            "weight": "1",
            "type": "pct_change",
            "grouper": ["item"],
            "min": "3.0",
            "max": "3.1",
            "reference_price": "current_price"
        }
    ], 
    "post_rules" : [],
    "output_configuration": {
        "columns":["item"]
    }
}
```

Expected optimization result: any number in the range [300..310].


<h2>Rules description</h2>

All rules include a common part ```<header>``` and the main part of the rule.

Description of the common part of all rules - ```<header>```

```json
// rule ID
"id": <string>,

// rule name
"name": <string>,

// text description of the rule
"text": <string>,

// Rule number by order
"number": <int>,

// rule weight. By default 1.0
"weight": <float64>,

// Strict rules. The recommended price should never violate this rule.
// When strict rules conflict, priority is given to the rule with the lowest rule number in order.
"strict": bool

// rule scope filter. Leaves only those elements in items that match the filter
"filter": Vec <Dict <String, Vec<Value>>>,

// inverse filter for the scope of the rule. Leaves only those elements in items that do not match the filter
"filter_not": Vec <Dict<String, Vec<Value>>>,

// rule scope grouper. Grouped elements are treated as one virtual element. 
// See the rule SamePrice
"grouper": Vec <String>


```

<h2>Rule SamePrice</h2>
All items defined in the scope of the rule must receive the same price in the recommendation.
```json
{
       <header>,
       type:"same_price"
}
```

Example - "price line"

```json
{
  "type": "same_price",
  "id": "evmiygn3zzt",
  "name": "price line",
  "text": "All products within a price range must have the same price",
  "number": 0,
  "weight": 1.0,
  "grouper": [
    "line_group",
    "location"
  ],
  "filter": [],
  "filter_not": [],
  "strict": false
}
```   

<h2>Rule PctChange</h2>
The recommended price of the goods must be within the established min / max bound limits relative to the given price. The limits of min and max are set as a percentage.

```json
{
  <header>,
  type:"pct_change",
  
  // an attribute containing the price against which the bounds are determined
  reference_price: String,
  
  // the min limit as a percentage relative to the given price.
  // calculated as reference_price * min
  min: Option<f64>,
  
  // the max limit as a percentage relative to the given price.
  // calculated as reference_price * max
  max: Option<f64>,
  
  // target price as a percentage of the target price
  // calculated as reference_price * target
  // generally, the recommendation will be attracted to the target price
  target: Option<f64>
}
```

Example - “Minimum markup threshold”
```json
{
      "type": "pct_change",
      "id": "82ow0ciyo03",
      "name": "Min. change market",
      "text": "The markup on the product must be between {min} and {max}",
      "grouper": [],
      "filter": [
        {
          "location": [
            "HElSINKI"
          ]
        }
      ],
      "filter_not": [],
      "strict": true,
      "reference_price": "cost",
      "min": 1.1,
      "max": 100001.0,
      "target": null
    },
```

<h2>Rule AbsChange</h2>
The recommended price of the goods must be within the established min / max limits. Min - lower price bound limit, Max - upper price bound limit.

```json
{
  <header>,
  type:"abs_change",
  
  // min price bound
  // calculated as reference_price + min_abs
  min_abs: Option<f64>,
  
  // max price bound
  // calculated as reference_price + max_abs
  max_abs: Option<f64>,
  
  // target price as a percentage of the target price
  // calculated as reference_price * target
  target: Option<f64>
}
```

Example - “Acceptable Change Rule”
```json
{
      "type": "abs_change",
      "id": "82ow0ciyo03",
      "name": "Permissible price change",
      "text": "The recommended price should be within 100r to 200r",
      "grouper": [],
      "filter": [],
      "filter_not": [],
      "strict": true,
      "min_abs": 100,
      "max_abs": 200,
      "target": null
    },
```
<h2>Rule InitialPrice</h2>
Determine the price to which optimization will strive, provided that all other rules are not violated.

```json
{
  <header>,
  
  type: "initial_price",

  // the name of the attribute containing the expected price
  // by default reference_price: "current_price"
  reference_price: Option<String>
}
```

Example - “Do not change the current price if it does not violate any rules”
```json
{
  "type": "initial_price",
  "id": "initial",
  "name": "initial",
  "text": "initial",
  "number": 1,
  "weight": 0.1,
  "grouper": [],
  "expander": [],
  "filter": [],
  "filter_not": [],
  "strict": false,
  "reference_price": "current_price"
}
```

<h2>Rule Relations</h2>
Rule of maximum/minimum price deviation between product groups.

```json
{
  <header>,
  type: "relations",

  // an attribute that defines product groups for which the rule works
  selector: String,

  // an attribute containing information about the relative size of the product
  volume_selector: Option<String>,
  
  // an attribute containing possible values from 'selector' for relation order.
  order: <Vec<String>>, 
  
  // Enabling automatic order detection using sorted values from 'selector' attribute. By defualt is false.
  // In case of auto_order is equalt to true, 'order' setting will be ignored.
  auto_order: Option<bool>,
  
  // Sort order when auto_order is true. By defualt auto_order_ascending=True.
  auto_order_ascending: Option<Bool>,
    
  // minimum deviation
  min: Option<f64>,
  
  // maximum deviation
  max: Option<f64>,
  
  // Working with an anchor product.
  // An anchor product is a product for which optimization does not change the original price. There can be only one anchor product inside a rule.
  // Prices for other products should be aligned relative to the anchor product, taking into account the minimum / maximum deviations.
  

  // Automatic detection of the anchor product
  // Only one of the automatic anchor price flags can be enabled: firstIsAnchor or lastIsAnchor or minEquivIsAnchor.
  
  // The first product with a non-zero value for the anchor_selector attribute is an anchor product.
  // Items are sorted according to dependency order.
  firstIsAnchor: Option<bool>,

  // The last product with a non-zero value for the anchor_selector attribute is an anchor product.
  // Items are sorted according to dependency order.
  lastIsAnchor: Option<bool>,
  
  // The product with the minimum value of the relative equivalent price is anchor.
  minEquivIsAnchor: Option<bool>,
  
  // Attribute for automatic selection of anchor product
  anchor_selector: Option<String>,

  // Attribute containing information about the relative size of the product.
  // Used to define an anchor product with a minimum relative equivalent price.
  // Relative equivalent price = items[anchor_selector] / items[minEquiv_selector]
  minEquiv_selector: Option<String>
  
  
}
```

Example - "Brand Rule"

```json
{
  "type": "relations",
  "id": "yya5weffwe",
  "name": "Brand Rule",
  "text": "Within the price zones, the price deviation of brand B should be between -20% and 20% relative to brand A"
  "min": 0.8,
  "max": 1.2,
  "type": "relations",
  "selector": "item.Brend".
  "order": ["Brand А","Brand B"],
  "grouper": ["brand_group", "price_zone"]
}

```

Example - "Cross Zone Rule with Anchor Price"
```json
{
  "type": "relations",
  "id": "yya53cmfrm",
  "name": "Cross-zone rule Helsinki region",
  "text": "The deviation of the price in the price zone of the Helsinki region should be in the range from -10% to 0% relative to the price in the price zone of Helsinki. Priority is given to the Helsinki price zone",
  "grouper": ["item"],
  "selector": "price_zone",
  "order": [
    "Helsinki",
    "Vantaa Region"
  ],
  "min": 0.9,
  "max": 1.0,
  "firstIsAnchor": true
}
```

<h2>Rule FixedPrice</h2>
Recommendation should return a fixed price

```json
{
  <header>,
  
  type: "fixed_price",

  // the name of the attribute that defines the product groups for which the rule works
  // value attribute value must be True e.g. items[selector] == True
  selector: String,
  
  // the name of the attribute containing the value of the fixed price
  reference_price: String,
}
```

Example - "New Price Rule"

For products with a new price (new_prices.price != 0), the optimizer returns the same price (new_prices.price).

```json
{
  "type": "fixed_price",
  "id": "97amm9qe0y9",
  "name": "New Price Rule",
  "text": "Do not change the price if a new price is entered",
  "number": 11,
  "weight": 1.0,
  "grouper": [],
  "filter": [],
  "filter_not": [],
  "selector": "new_prices.price != 0",
  "reference_price": "new_prices.price"
}
```

<h2>Rule MinPriceChange</h2>
The optimizer does not return a recommendation for products whose calculated optimal price is in the range [reference_price * min, reference_price * max]. The rule is applied if reference_price is in the range (range_start, range_end].


```json
{
  <header>,
  
  type: "min_price_change",
  
  // the lower min price limit bound as a percentage relative to the given price.
  // calculated as reference_price * min
  min: Option<f64>,
  
  // the upper max price limit bound as a percentage relative to the given price.
  // calculated as reference_price * max
  max: Option<f64>,
  
  // price against which boundaries are determined
  reference_price: String,
  
  // lower min price limit bound of rule applicability, relative to reference_price
  range_start: Option<f64>,
  
  // upper max price limit bound of rule applicability, relative to reference_price
  range_end: Option<f64>
}
```


Example - "Minimum price change"

```json
{
    "type": "min_price_change",
    "id": "x6vnwrq9ck",
    "name": "Minimum price change",
    "text": "Do not change the price if the price change is between {min} and {max} for prices between {range_start} and {range_end}.\n",
    "number": 13,
    "weight": 1.0,
    "grouper": [],
    "filter": [],
    "filter_not": [],
    "min": 0.995,
    "max": 1.003,
    "reference_price": "current_price",
    "range_start": 0.0,
    "range_end": 10000000.0
  }
```
<h2>Rule AbsMinPriceChange</h2>
The optimizer does not return a recommendation for products whose calculated optimal price is in the range [reference_price + min_abs, reference_price + max_abs]. The rule is applied if reference_price is in the range (range_start, range_end].


```json
{
  <header>,
  
  type: "abs_min_price_change",
  
  // the lower min price limit bound as a percentage relative to the given price.
  // calculated as reference_price + min_abs
  min_abs: Option<f64>,
  
  // the upper max price limit bound as a percentage relative to the given price.
  // calculated as reference_price + max_abs
  max_abs: Option<f64>,
  
  // price against which boundaries are determined
  reference_price: String,
  
  // lower min price limit bound of rule applicability, relative to reference_price
  range_start: Option<f64>,
  
  // upper max price limit bound of rule applicability, relative to reference_price
  range_end: Option<f64>
}
```


Example - "Minimum price change"

```json
{
    "type": "abs_min_price_change",
    "id": "7879hkjh",
    "name": "Minimum price change abs",
    "text": "Do not change the price if the price change is between {min_abs} and {max_abs} for prices between {range_start} and {range_end}.\n",
    "number": 13,
    "weight": 1.0,
    "grouper": [],
    "filter": [],
    "filter_not": [],
    "min": -1.0,
    "max": 1.0,
    "reference_price": "current_price",
    "range_start": 0.0,
    "range_end": 10000000.0
  }
```



<h2>Rule RoundingRange</h2>

Rounding rule. For a product price between start and end, the integer part of the price must end in wholeEndings, excluding the ignorePrices prices. The fractional part of the price must end with fractionalEndings. There are various methods of rounding: to the nearest, rounding down and rounding up.

```json
{
  <header>,
  
  type: "rounding",

  // lower limit of the range of applicability of the rule 
  start: f64,
  
  //  upper limit of the range of applicability of the rule 
  end: f64,
  
  // valid integer endings
  whole_endings: Vec<String>,
  
  // valid fractional endings
  fractional_endings: Vec<String>,
  
  // prices to be excluded
  ignore_prices: Vec<String>,
  
  // determines in which direction to round: "nearest" or "floor" or "ceil". 
  // default value - "nearest"
  rounding_method: Option<String>
}
```
Example - "Minimum price change"

```json
{
  "type": "rounding",
  "id": "hyynsox86z9",
  "name": "Rounding prices",
  "text": "For the price of a product in the range from 0.0 to 100.0, the integer part of the price must end in 01.03.05.99, excluding prices 33.34. The fractional part of the price must end in 00.",
  "rounding_ranges": [
    {
      "start": 0.0,
      "end": 100.0,
      "wholeEndings": [
        "01",
        "03",
        "05",
        "99"
      ],
      "fractionalEndings": [
        "00"
      ],
      "ignorePrices": [
        "33.00",
        "34.00"
      ]
    }
  ]
}
```

<h2>Rule BalancedOptimization</h2>
Optimization with an indication of the optimization goal within the allowable deviation from the current price and at the same time not violating other rules.

```json
{
  <header>,
  
  type: "balanced_optimization",

  // Optmization goal: "margin" or "revenue" or "demand" or "adjusted_margin"
  goal: Option<String>,
  
  // lower limit of acceptable deviation from the current price
  // calculated as current_price * min
  min: Option<f64>,

  // upper limit of acceptable deviation from the current price
  // calculated as current_price * max
  max: Option<f64>
}
```


Example - "Maximize unit sales."

```json
{
  "type": "balanced_optimization",
  "id": "24x2ijc3kx",
  "name": "Optimization within price rules",
  "text": "Maximize unit sales. The price change must be between -10% and +10% relative to the current price.",
  "goal": "demand",
  "min": 0.9,
  "max": 1.1
}
```


<h1>Optimization run results</h1>

The optimization result is formatted as a csv file containing the following structure:
 - columns - attribute
 - strings - product

The order of the columns is not important.

columns:
 - pl_index
   - mandatory column, contains the product index
 - currentPrice
   - mandatory column, current product price
 - optimalPrice
   - mandatory column, the optimal price obtained by applying all the rules from the rules section
 - finalPrice
   - mandatory column, final price. It is obtained by applying strict rules and rounding to optimalPrice. See the rules section postRules.
 - modifiedCurrentPrice
   - optional column, contains the current price modified by the SamePirce rule. For example, products in the line contain different currentPrice prices and there is a rule of the same prices in the line. Before the start of optimization, the currentPrice prices for the line are aligned, the new aligned price is written to modifiedCurrentPrice
 
 For each rule, columns are added where:
>> {id} - rule ID
{price_type} - price type: currentPrice, currentPrice, optimalPrice.

Columns for base rules:
 - "{id}|{price_type}|error" - violation of the rules in currency
 - "{id}|{price_type}|status" - whether the rule was used. 1.0 - was used, 0.0 - was not used
 - "{id}|{price_type}|leftBound" - left border of the rule
 - "{id}|{price_type}|rightBound" - right border of the rule
 - "{id}|{price_type}|target" - target price, see rule PctChange
 
Columns for BalancedOptimization rule:
 - "{id}|{price_type}|demandMetric" - demand (in pieces) for a specific rule
  - "{id}|{price_type}|revenueMetric" - revenue (currency) for a specific rule
  - "{id}|{price_type}|marginMetric" - income (currency) for a specific rule 

 - "demandMetric" - demand (in pieces) for whole optimization
 - "revenueMetric" - revenue (currency) for whole optimization
 - "marginMetric" - income 8currency) for whole optimization

For each rule, metrics for each of the prices will be recorded: currentPrice, currentPrice, optimalPrice

Example

Input data for optimization:

```json
{
  "items": {
   "columns":["item", "current_price", "cost"],
   "data":[["p1", 1.0, 0.5]]
  },
  "rules": [
    {
      "id":"pct_change",
      "weight":"1",
      "type":"pct_change",
      "grouper":["item"],
      "min":"1.1",
      "max":"1.3",
      "reference_price" : "current_price"
    }
  ], 
  "post_rules" : [],
  "output_configuration": {
      "columns":["item","current_price"]
  }
}
```

Optimization result
```csv
pl_index,currentPrice,optimalPrice,newPrice,pct_change|currentPrice|error,pct_change|currentPrice|status,pct_change|currentPrice|leftBound,pct_change|currentPrice|rightBound,pct_change|currentPrice|target,current_price,finalPrice,pct_change|optimalPrice|error,pct_change|optimalPrice|status,pct_change|optimalPrice|leftBound,pct_change|optimalPrice|rightBound,pct_change|optimalPrice|target,pct_change|finalPrice|error,pct_change|finalPrice|status,pct_change|finalPrice|leftBound,pct_change|finalPrice|rightBound,pct_change|finalPrice|target,item
0,1.00,1.20,,0.10,1.00,1.10,1.30,0.00,1.00,1.20,0.00,1.00,1.10,1.30,0.00,0.00,1.00,1.10,1.30,0.00,p1
```

