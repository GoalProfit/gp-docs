# Timeframe

[Admin UI](/admin#/dataset/solutions/default/timeframes)

Used for report metrics. An additional filter is applied to the date field when selecting values.

*name*: string - timeframe name.

*calc*: string - Javascript function of type (date: Date) = > [Date, Date]. date - current date (reference date), return value - an array of two elements: the start and end dates of the interval.


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
</style>
