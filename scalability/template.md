# Analytical Server Scalability

GoalProfit platform supports the following cluster deployment:

* Cluster topology: ring
* Scaling principle: sharding, replication
* Sharding algorithm: consistent hashing
* Consensus Protocol: Raft
* Number of replicas by default: 3
* Read operations are halted if number of failed nodes reaches number of replicas
* Write operations are halted if no Raft quorum achieved
* Restrictions on the data model: no join for sharded streams

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
