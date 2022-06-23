# Users

[Admin UI](/admin#/dataset/users)

List of system users with the ability to configure access rights

The description of each user is an object:

* *id*: string - username.

* *name*:string - name of the user.

* *email*: string - email of the user.

* *meta*: object - additional restrictions for the user:
  - *categories*: string[] - list of categories that are available to the user If not specified or empty - all categories are available.
 
* *groups*: string[] - a list of the groups the user is a member of. Two groups are currently available: admin, category-manager.

* *access*: object[] - restricting access to streams
  - *stream*: string - stream name
  - *filter0*: string - filter part added to filter0 by "and" for user *username* to all requests for this stream
  - *filter1*: string - filter part added to filter1 by "and" for user *username* to all requests for this stream
  - *filter2*: string - filter part added to filter2 by "and" for user *username* to all requests for this stream
  - *canWrite*: bool - if true, allows the user to add entries to the stream
  - *canReset*: bool - if true, allows the user to reset the stream.
