
<h1>Входные данные для оптимизации</h1>

Оптимиазация на вход принимает данные в структуре json файла.
Cтруктура входного json файла:

```json
{
  // Общая информация
  // уникальный идентификатор конфига (optional)
  "config_id":"",    
  
  // идентификатор библиотеки правил на основе которой сделан входной файл для оптимизации
  "config_name":"", 
  
  // идентификатор пользователя (optional)
  "create_user":"",  
  
  // дата запуска оптимизации (optional)
  "create_time":"",  

  // фрейм данных, определяющий сферу применения оптимизации
  "items": <data_frame>,

  // Список правил оптимизации
  "rules": Vec <<SamePrice> | <PctChange> | <Relations> | <FixedPrice> | <InitialPrice> | <BalancedOptimization>>,

  // Список правил, которые применяются после нахождения оптимальной цены
  "post_rules": Vec <<FixedPrice> | <RoundingRange> | <PctChange> | <MinPriceChange>>

  // модельные параметры
  "modeling": {
    "params":  <data_frame>,
    "season":  <data_frame>
  }

  // тонкая настройка оптимизации
  "opt_configuration": Dict<String, Vec<Value>>,
  
  // настройка для вывода дополнительных колонок в результатах оптимизации
  // "output_configuration": {
  //   "columns":["item","current_price"]
  // }
  "output_configuration": Dict<String, Vec<Value>>
}

```

где <data_frame>

```json
{
   "columns": Vec <String>
   "data": Vec< Vec< <String> | <Float> | <Bool> | null >>
}
```

Пример фрейма данных, определяющий сферу применения оптимизации:

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

Пример json файла с заданием на оптимиазацию.
Текущая цена за продукт 100, закупочная стоимость 50.
Добавлено правило PtcChange задающая диапазон оптимальной цены от 300 до 310.
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

Ожидаемый результат оптимизации: любое число в диапазоне [300..310].


<h2>Описание правил</h2>

Все правила включают в себе общую часть ```<header>``` и основную часть правила.


Описание общей части всех правил - ```<header>```

```json
// идентификатор правила
"id": <string>,

// имя правила
"name": <string>,

// текстовое описание правила
"text": <string>,

// номер правила по порядку
"number": <int>,

// вес правила. Обычно равен 1.0
"weight": <float64>,

// строгость правила. Рекомендованная цена никогда не должна нарушать это правило.
// При конфликте строгих правил приоритет отдается правилу с минимальным номером номер правила по порядку.
"strict": bool

// фильтр сферы применения правила. Оставляет только те элементы в items, которые удовлетворяют фильтру
"filter": Vec <Dict <String, Vec<Value>>>,

// обратный фильтр сферы применения правила. Оставляет только те элементы в items, которые не удовлетворяют фильтру
"filter_not": Vec <Dict<String, Vec<Value>>>,

// группировщик сферы применения правила. Сгруппированные элементы трактуются как один виртуальный элемент. 
// См. правило SamePrice
"grouper": Vec <String>


```

<h2>Правило SamePrice</h2>
Все товары, определенные в сфере применения правила должны получить в рекомендации одинаковую цену.

```json
{
       <header>,
       type:"same_price"
}
```

Пример - "ценовая линейка"

```json
{
  "type": "same_price",
  "id": "evmiygn3zzt",
  "name": "Ценовая линейка",
  "text": "Все товары в пределах ценовой линейки должны иметь одну цену",
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

<h2>Правило PctChange</h2>
Рекомендованная цена товара должна быть в установленных пределах пределах min/max относительно заданной цены.

```json
{
  <header>,
  type:"pct_change",
  
  // атрибут, содержащий цену, относительно которой определяются границы
  reference_price: String,
  
  // нижняя граница в процентах относительно заданной цены.
  // расчитывается как reference_price * min
  min: Option<f64>,
  
  // верхняя граница в процентах относительно заданной цены
  // расчитывается как reference_price * max
  max: Option<f64>,
  
  // целевая цена процентах относительно заданной цены
  // расчитывается как reference_price * target
  // при прочих равных, рекомендация будет притягиваться к целевой цене 
  target: Option<f64>
}
```

Пример - “Минимальный порог наценки”
```json
{
      "type": "pct_change",
      "id": "82ow0ciyo03",
      "name": "Мин. порог наценки Маркет",
      "text": "Наценка на товар должна быть в пределах от {min} до {max}",
      "grouper": [],
      "filter": [
        {
          "location": [
            "МОСКВА"
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

<h2>Правило InitialPrice</h2>
Определеят цену, к которой будет стремиться оптимизация, при условии ненарушения всех остальных правил.

```json
{
  <header>,
  
  type: "initial_price",

  // имя атрибута, содержащего ожидаемую цену
  // по-умолчанию reference_price: "current_price"
  reference_price: Option<String>
}
```

Пример - “Не измениять текущую цену, если она не нарушает никакие правила”
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

<h2>Правило Relations</h2>
Правило максимального/минимального отклонения цен между группами товаров.

```json
{
  <header>,
  type: "relations",

  // атрибут, определяющий группы товаров для которых работает правило
  selector: String,

  // атрибут, содержащий информацию об относительном размере товара
  volume_selector: Option<String>,
  
  // порядком зависимостей
  order: Vec<String>,
  
  // минимальное отклонение
  min: Option<f64>,
  
  // максимальное  отклонение
  max: Option<f64>,
  
  // Работа с якорным товаром
  // Якорный товар - это товар, для которого оптимизация не меняет изначальную цену. Внутри правила якорный товар может быть только один.
  // Цены на остальные товары, должны выстраиваться относительно якорного товара с учетом минимального/максимального отклонений.
  

  // Автоматическое определение якорного товара
  // Только один из флагов автоматического определения якорной цены может быть включен: firstIsAnchor или lastIsAnchor или minEquivIsAnchor.
  
  // Первый товар с ненулевым значением атрибута anchor_selector является якорным.
  // Товары отсортированы согласно порядку зависимостей order.
  firstIsAnchor: Option<bool>,

  // Последний товар с ненулевым значением атрибута anchor_selector является якорным.
  // Товары отсортированы согласно порядку зависимостей order. 
  lastIsAnchor: Option<bool>,
  
  // Товар с минимальным значением относительной эквивалентной ценой является якорным.
  minEquivIsAnchor: Option<bool>,
  
  // Атрибут, определяющий кандидатов, для автоматического выбора якорного товара
  anchor_selector: Option<String>,

  // Атрибут, содержащий информацию об относительном размер товара.
  // Используется для определения якорного товара с минимальной относительной эквивалентной ценой. 
  // Относительная эквивалентная цена = items[anchor_selector] / items[minEquiv_selector]
  minEquiv_selector: Option<String>
}
```

Пример - "Правило брендов"

```json
{
  "type": "relations",
  "id": "yya5weffwe",
  "name": "Правило брендов",
  "text": "В рамках ценовых зон отклонение цены бренда Б должно быть в пределах от -20% до 20% относительно бренда А"
  "min": 0.8,
  "max": 1.2,
  "type": "relations",
  "selector": "item.Brend".
  "order": ["Бренд А","Бренд Б"],
  "grouper": ["brand_group", "price_zone"]
}

```

Пример - "Кросс-зонное правило с якорной ценой"
```json
{
  "type": "relations",
  "id": "yya53cmfrm",
  "name": "Кросс-зонное правило Московская область",
  "text": "Отклонение цены в ценовой зоне Московская область должно быть в пределах от -10% до 0% относительно цены в ценовой зоны Москва. Приоритет отдаётся ценовой зоне Москва",
  "grouper": ["item"],
  "selector": "price_zone",
  "order": [
    "Москва",
    "Московская область"
  ],
  "min": 0.9,
  "max": 1.0,
  "firstIsAnchor": true
}
```

<h2>Правило FixedPrice</h2>
Рекомендация должна вернуть фиксированную цену

```json
{
  <header>,
  
  type: "fixed_price",

  // имя атрибута, определяющего группы товаров для которых работает правило
  // значение значение аттрибута должно быть True т.е. items[selector] == True
  selector: String,
  
  // имя атрибута, содержащего значение зафиксированной цены 
  reference_price: String,
}
```

Пример - "Правило новой цены"

Для товаров, с заданной новой ценой (new_prices.price != 0), оптимизатор возвращает эту же цену (new_prices.price).

```json
{
  "type": "fixed_price",
  "id": "97amm9qe0y9",
  "name": "Правило новой цены",
  "text": "Не менять цену если введена новая цена",
  "number": 11,
  "weight": 1.0,
  "grouper": [],
  "filter": [],
  "filter_not": [],
  "selector": "new_prices.price != 0",
  "reference_price": "new_prices.price"
}
```

<h2>Правило MinPriceChange</h2>
Оптимизатор не возвращает рекомендацию для товаров у которых, расчетная оптимальная цена получается в диапазоне [reference_price * min, reference_price * max]. Правило применяется, если reference_price находиться в диапазоне (range_start, range_end].


```json
{
  <header>,
  
  type: "min_price_change",
  
  // нижняя граница в процентах относительно заданной цены.
  // расчитывается как reference_price * min
  min: Option<f64>,
  
  // верхняя граница в процентах относительно заданной цены.
  // расчитывается как reference_price * max
  max: Option<f64>,
  
  // цена, относительно которой определяются границы
  reference_price: String,
  
  // нижняя границы применимости правила, относительно reference_price
  range_start: Option<f64>,
  
  // нижняя границы применимости правила, относительно reference_price
  range_end: Option<f64>
}
```


Пример - "Минимальное изменение цены"

```json
{
    "type": "min_price_change",
    "id": "x6vnwrq9ck",
    "name": "Минимальное изменение цены",
    "text": "Не менять цену если изменение цены в передeлах от {min} до {max} для цен в диапазоне от {range_start} до {range_end}.\n",
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

<h2>Правило RoundingRange</h2>

Правило округления. Для цены товара в диапазоне от start до end целая часть цены должна оканчиваться на wholeEndings, исключая цены ignorePrices. Дробная часть цены должна оканчиваться на fractionalEndings. Возможны различны методы округления: к ближейшему, округление вниз и округление вверх.

```json
{
  <header>,
  
  type: "rounding",

  // нижняя граница диапазона применимости правила 
  start: f64,
  
  // верхняя граница диапазона применимости правила 
  end: f64,
  
  // допустимые окончания целой части
  whole_endings: Vec<String>,
  
  // допустимые окнчания дробной части
  fractional_endings: Vec<String>,
  
  // цены, которые должны быть исключены
  ignore_prices: Vec<String>,
  
  // определяет в какую сторону делать округление: "nearest" или "floor" или "ceil". 
  // значение по-умолчанию "nearest"
  rounding_method: Option<String>
}
```
Пример - "Минимальное изменение цены"

```json
{
  "type": "rounding",
  "id": "hyynsox86z9",
  "name": "Округление цен",
  "text": "Для цены товара в диапазоне от 0.0 до 100.0 целая часть цены должна оканчиваться на 01,03,05,99 исключая цены 33,34. Дробная часть цены должна оканчиваться на 00.",
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

<h2>Правило BalancedOptimization</h2>
Оптимизация с указанием цели оптимизации в рамках допустимого отклонения от текущей цены и одновременном ненарушении других правил.

```json
{
  <header>,
  
  type: "balanced_optimization",

  // цель оптимизации: "margin" или "revenue" или "demand" или "adjusted_margin"
  goal: Option<String>,
  
  // нижняя граница допустимого отклонения от текущей цены
  // расчитывается как current_price * min
  min: Option<f64>,

  // верхняя граница допустимого отклонения от текущей цены
  // расчитывается как current_price * max
  max: Option<f64>
}
```

Пример - "Максимизировать продажи шт."

```json
{
  "type": "balanced_optimization",
  "id": "24x2ijc3kx",
  "name": "Оптимизация в рамках ценовых правил",
  "text": "Максимизировать продажи в штуках. Изменение цены должно быть в пределах от -10% до +10% относительно текущей цены.",
  "goal": "demand",
  "min": 0.9,
  "max": 1.1
}
```


<h1>Результат оптимизации</h1>

Результат оптимизации оформляется в виде csv файла, содержащий следующую структуру:
 - колонки - атрибут  
 - строки - продукт

Порядок колонок не важен.

колонки:
 - pl_index
   - обязательная колонка, содержит индекс продукта
 - currentPrice
   - обязательная колонка, текущая цена продукта
 - optimalPrice
   - обязательная колонка, оптимальная цена, полученная с применением всем правил из секции rules
 - finalPrice
   - обязательная колонка, окончательная цена. Получается применением строгих правил и раундинга к optimalPrice. См. секцию правил postRules.
 - modifiedCurrentPrice
   - опциональная колонка, содержит текущую цену, модифицированная правилом SamePirce. Например, товары в линейке содержат разные currentPrice цены и присутствует правило одинаковых цен в линейке. До старта оптимизации цены currentPrice для линейки выравноваются, новая выровненная цена записывается в modifiedCurrentPrice.
 
 Для кажного правила добавляются колонки, где:
>> {id} - идентификатор правила
{price_type} - тип цены currentPrice, currentPrice, optimalPrice.

Колонки для базовых правил:
 - "{id}|{price_type}|error" - нарушение правила в рублях
 - "{id}|{price_type}|status" - было ли правило использовано. 1.0 - было использовано, 0.0 - небыло использовано
 - "{id}|{price_type}|leftBound" - левая граница правила в рублях
 - "{id}|{price_type}|rightBound" - правая граница правила в рублях
 - "{id}|{price_type}|target" - целевая цена. См. правило PctChange
 
Колонки для BalancedOptimization правил:
 - "{id}|{price_type}|demandMetric" - спрос в штуках для конкретного правила
  - "{id}|{price_type}|revenueMetric" - выручка в рублях для конкретного правила
  - "{id}|{price_type}|marginMetric" - доход в рублях для конкретного правила 

 - "demandMetric" - спрос в штуках для всей оптимизации
 - "revenueMetric" - выручка в рублях для всей оптимизации
 - "marginMetric" - доход в рублях для всей оптимизации

Те для каждого правила будут записаны метрики для каждой из цен: currentPrice, currentPrice, optimalPrice

Пример

Входные данные на оптимиазацию:

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

Результат оптимизации
```csv
pl_index,currentPrice,optimalPrice,newPrice,pct_change|currentPrice|error,pct_change|currentPrice|status,pct_change|currentPrice|leftBound,pct_change|currentPrice|rightBound,pct_change|currentPrice|target,current_price,finalPrice,pct_change|optimalPrice|error,pct_change|optimalPrice|status,pct_change|optimalPrice|leftBound,pct_change|optimalPrice|rightBound,pct_change|optimalPrice|target,pct_change|finalPrice|error,pct_change|finalPrice|status,pct_change|finalPrice|leftBound,pct_change|finalPrice|rightBound,pct_change|finalPrice|target,item
0,1.00,1.20,,0.10,1.00,1.10,1.30,0.00,1.00,1.20,0.00,1.00,1.10,1.30,0.00,0.00,1.00,1.10,1.30,0.00,p1
```

