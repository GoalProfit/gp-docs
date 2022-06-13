# System Components

![System components](/pages/docs/GoalProfit%20components.svg?v2)

## Backend Components

The cornerstone backend component is the analytical server. It's accompanied by a set of purpose-built microservices that can be extended to provide additional functionality.

The analytical server consists of the following components:
* *Static assets storage* – stores frontend static assets.
* *Pages storage* – stores application pages.
* *Object storage* – stores streams data (see [Data Model](/pages/docs/datamodel)).
* *Web service* – provides main GraphQL API and exposes REST interfaces provided by accompanying micro-services.
* *Query execution service* – coordinates and performs execution of analytical queries.
* *Data injection service* – manages and executes declarative ELT/ETL pipeline.
* *JIT query translator* – translates analytical queries to machine codes for efficient execution.

*Key-value storage* micro-service stores user-level data such as preferences reports, pricing strategies, etc.

*Retail service* micro-service performs retail-specific tasks and schedules optimization jobs.

*Optimization service* micro-service executes optimization jobs and can be optionally deployed as a function to a supported FaaS platform.


## Frontend Components

The frontend consists of an application runtime, integrated development environment, and sets of generic, retail-specific, and custom components.

* *Application runtime* is a Vue-powered runtime that dynamically assembles web applications following provided template and configuration. It uses Vue and Web components as building blocks and manages the information exchange between them.
* *Interactive development environment* provides live editing and WYSIWYG capabilities, enabling rapid development of business applications.
* *Generic components* are a comprehensive library of data processing and visualization components. It includes tabular reporting and a set of charting components.
* *Retail-specific components* is a set of components designed to perform retail-specific tasks. The pricing strategy editor is an example of such a component.
* *Custom components* – the system can be extended by customer or integrator provided components implemented in Vue or as a [Web Component](https://developer.mozilla.org/en-US/docs/Web/Web_Components).


<style>
.my-dark-theme .my-content {
    color: var(--light)
}
.my-dark-theme .my-content h1,
.my-dark-theme .my-content h2,
.my-dark-theme .my-content h3,
.my-dark-theme .my-content h4,
.my-dark-theme .my-content h5 {
    color: white;
}
.my-content b,i,em {
    color: rgb(88,167,202);
}
code { white-space: pre; }
.my-content img {
    margin: 10px 0;
    max-width: 100%;
}
.my-dark-theme .my-content img {
    filter: invert(100%);
}
</style>
