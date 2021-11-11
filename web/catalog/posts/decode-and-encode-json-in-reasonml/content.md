I’ve gotten interested in a new language from Facebook — ReasonML. I decided to try it for a very simple function, which is used to convert from a legacy JSON format into a new one. This converter was written a long time ago and has obsolete logic, so it was a good candidate for trying ReasonML. Also, I could not find any guide on Reason/BuckleScript sites, which describes how to encode and decode JSON ldth optional properties into ReasonML.

[As the official site says](https://reasonml.github.io/guide/javascript/converting), we can convert small JS chunks into ReasonML, function by function.

The function selected for rewrite, was used to transform so-called ‘metric’ object from legacy JSON format into new JSON format.

Here is an old JavaScript version. We have unit tests for it, and it is used in other functions, which are also covered by unit tests. So if all the tests pass, we can say, that our ReasonML version works in the same way as the JS version :-)

```
function transformToCount20(metric) {
    var countMetric20 = {};
    if (metric) {
        _.set(countMetric20, 'type', 'COUNT');

        if (_.has(metric, 'label')) {
            _.set(countMetric20, 'label', metric.label);
        }

        return metric.name === 'count' ? countMetric20 : metric;
    }
}
```

What it does: receives some JSON (metric argument). If it has a ‘label’ property, then it copies to a new object, adds a new property “type” with value “COUNT” and returns.

So when the function receives an object like the following:


```
{label: "Count metric label"}
```


It should return this metric in the new format:


```
{type: "Volume", label: "Count metric label"}
```


If it receives the object:


```
{type: "count"}
```


Then it should just return:


```
{type: "COUNT"}
```


In our product there are other functions which use this transformer, so in ReasonML our new function should receive JSON and return JSON.

For convenience, we can create types for two Metric types: a metric with type and label, and a metric object without label:

```

type metricCount = {type_: string};

type metricWithLabel = {
  type_: string,
  label: string
};
```

‘type’ is a reserved word in ReasonML, so we need to name our property with an underscore.

Then we can create the constructors for both types:

```
type metricCount = {type_: string};

type metricWithLabel = {
  type_: string,
  label: string
};

let createCountWithLabel = (label: string) : metricWithLabel => {type_: "COUNT", label};

let countMetric: metricCount = {type_: "COUNT"};
```

countMetric is just a [record](https://reasonml.github.io/guide/language/record), createCountWithLabel is a function which receives label and returns record of type metricWithLabel.

As I mentioned before, input for our new function might have a ‘label’ property, or it can be undefined. ReasonML has Variants, to simulate and correctly process undefined:

#[reasonml.github.io](https://reasonml.github.io/guide/language/variant)

So we’ve got type definitions for two metric types and constructors to create records of that types. Now we can start writing a transformer that goes from one JSON format into another:

```
type metricCount = {type_: string};

type metricWithLabel = {
  type_: string,
  label: string
};

let createCountWithLabel = (label: string) : metricWithLabel => {type_: "COUNT", label};

let countMetric: metricCount = {type_: "COUNT"};


let transformToCount20 = (oldJson) => {
  let label = Json.Decode.(oldJson |> optional(field("label", string)));
  // to be implemented
};
```

For JSON to work we use this library:

[https://github.com/reasonml-community/bs-json](https://github.com/reasonml-community/bs-json)

On Line 14 we decode our ‘oldJson’ into a single Optional ‘label’. It can be either a value of type String or undefined.

‘|>’ is the pipeline operator, it will be available in JavaScript: [https://github.com/tc39/proposal-pipeline-operator](https://github.com/tc39/proposal-pipeline-operator)

Now we can add a switch statement to process two possible scenarios for the ‘label’ variable — it can be undefined or contain an actual value.

```
type metricCount = {type_: string};

type metricWithLabel = {
  type_: string,
  label: string
};

let createCountWithLabel = (label: string) : metricWithLabel => {type_: "COUNT", label};

let countMetric: metricCount = {type_: "COUNT"};
let encodeCountMetric = (m: metricCount) => Json.Encode.(object_([("type", string(m.type_))]));
};

let transformToCount20 = (oldJson) => {
  let label = Json.Decode.(oldJson |> optional(field("label", string)));
  switch label {
  | Some(v) => createCountWithLabel(v) |> MetricEncoder.encodeCountMetricWithLabel
  | None => countMetric |> MetricEncoder.encodeCountMetric
  }
};
```

On lines 17–18 we do pattern matching. If variable label has a None value (undefined) — it will return ‘countMetric’ (the metric without a label). If it has some value, then Some(v) will unwrap the Optional type and give us the actual value. We pass this ‘v’ value to the createCountWithLabel function which creates for us a record of type metricWithLabel.

But we need to convert these ReasonML records back into JSON. For this, we have to implement MetricEncode module (which is currently skipped).

Before we do this, let’s see how ReasonML compiles to JavaScript, if we just return ReasonML records without encoding them back. ReasonML records look exactly like JSON but are not JSON.

```

type metricCount = {type_: string};

type metricWithLabel = {
  type_: string,
  label: string
};

let createCountWithLabel = (label) : metricWithLabel => {type_: "COUNT", label};

type metric =
  | MetricCount(metricCount)
  | MetricWithLabel(metricWithLabel);

let transformToCount20 = (oldJson) : metric => {
  let label = Json.Decode.(oldJson |> optional(field("label", string)));
  switch label {
  | Some(v) => MetricWithLabel(createCountWithLabel(v))
  | None => MetricCount({type_: "COUNT"})
  }
};
```

This version compiles without errors. It even looks like this function will return JSON records that are ready to be consumed by other JS code. But this is how it was compiled by BuckleScript to JavaScript:

```

// Generated by BUCKLESCRIPT VERSION 2.1.0, PLEASE EDIT WITH CARE
'use strict';

var Block       = require("bs-platform/lib/js/block.js");
var Json_decode = require("bs-json/src/Json_decode.js");

function createCountWithLabel(label) {
  return /* record */[
          /* type_ */"COUNT",
          /* label */label
        ];
}

function transformToCount20(oldJson) {
  var label = Json_decode.optional((function (param) {
          return Json_decode.field("label", Json_decode.string, param);
        }), oldJson);
  if (label) {
    return /* MetricWithLabel */Block.__(1, [/* record */[
                /* type_ */"COUNT",
                /* label */label[0]
              ]]);
  } else {
    return /* MetricCount */Block.__(0, [/* record */[/* type_ */"COUNT"]]);
  }
}

exports.createCountWithLabel = createCountWithLabel;
exports.transformToCount20   = transformToCount20;
/* No side effect */
```

This code does not look like it will return JSON with “type” and/or “label” properties. It will actually return array with one or two elements — type “COUNT” and label property.

So we need to encode ReasonML records back into JSON. For this, we use the bs-json library:

```
module MetricEncoder = {
  let encodeCountMetricWithLabel = (m: metricWithLabel) =>
    Json.Encode.(object_([("type", string(m.type_)), ("label", string(m.label))]));
  let encodeCountMetric = (m: metricCount) => Json.Encode.(object_([("type", string(m.type_))]));
};
```

We declare a module which has two functions. One function encodes into JSON with “type” property, another — with “type” and “label”.

We ask Json.Encode to encode the input into a JSON object and provide a list of [tuples](https://reasonml.github.io/guide/language/tuple).

This is final version of converter:

```

type metricCount = {type_: string};

type metricWithLabel = {
  type_: string,
  label: string
};

let createCountWithLabel = (label) : metricWithLabel => {type_: "COUNT", label};

let countMetric: metricCount = {type_: "COUNT"};

module MetricEncoder = {
  let encodeCountMetricWithLabel = (m: metricWithLabel) =>
    Json.Encode.(object_([("type", string(m.type_)), ("label", string(m.label))]));
  let encodeCountMetric = (m: metricCount) => Json.Encode.(object_([("type", string(m.type_))]));
};

let transformToCount20 = (oldJson) => {
  let label = Json.Decode.(oldJson |> optional(field("label", string)));
  switch label {
  | Some(v) => createCountWithLabel(v) |> MetricEncoder.encodeCountMetricWithLabel
  | None => countMetric |> MetricEncoder.encodeCountMetric
  }
};
```

And this is how it is compiled by BuckleScript to JavaScript:

```
// Generated by BUCKLESCRIPT VERSION 2.1.0, PLEASE EDIT WITH CARE
'use strict';

var Json_decode = require("bs-json/src/Json_decode.js");
var Json_encode = require("bs-json/src/Json_encode.js");

function createCountWithLabel(label) {
  return /* record */[
          /* type_ */"COUNT",
          /* label */label
        ];
}

var countMetric = /* record */[/* type_ */"COUNT"];

function encodeCountMetricWithLabel(m) {
  return Json_encode.object_(/* :: */[
              /* tuple */[
                "type",
                m[/* type_ */0]
              ],
              /* :: */[
                /* tuple */[
                  "label",
                  m[/* label */1]
                ],
                /* [] */0
              ]
            ]);
}

function encodeCountMetric(m) {
  return Json_encode.object_(/* :: */[
              /* tuple */[
                "type",
                m[/* type_ */0]
              ],
              /* [] */0
            ]);
}

var MetricEncoder = /* module */[
  /* encodeCountMetricWithLabel */encodeCountMetricWithLabel,
  /* encodeCountMetric */encodeCountMetric
];

function transformToCount20(oldJson) {
  var label = Json_decode.optional((function (param) {
          return Json_decode.field("label", Json_decode.string, param);
        }), oldJson);
  if (label) {
    return encodeCountMetricWithLabel(/* record */[
                /* type_ */"COUNT",
                /* label */label[0]
              ]);
  } else {
    return encodeCountMetric(countMetric);
  }
}

exports.createCountWithLabel = createCountWithLabel;
exports.countMetric          = countMetric;
exports.MetricEncoder        = MetricEncoder;
exports.transformToCount20   = transformToCount20;
/* Json_encode Not a pure module */
```

As you see, functions encodeCountMetricWithLabel(m) and encodeCountMetric(m) now return JSONs.

With only one function converted to ReasonML, there is no benefit. Also, input parameter to ‘transformToCount20’ is still an untyped JSON object.

But this function is used inside of other functions, which transform huge JSON in legacy format into ‘new’ JSON.
If we convert all 500 lines of converters into ReasonML, then we can have only one place, where blackbox JSON is received: input for main Converter call.

All other function calls will be handled inside ReasonML and have type protection (hopefully).