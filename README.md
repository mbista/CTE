# CTE
What is Common Table Expression?

CTE stands for Common Table Expression. Once defined the CTE stays in memory and can be used as a temporary result set.

CTE promotes readability as the person investigating the query can simply look into the definition.

A CTE can be used to reference itself which is known as recursive CTE.

I prefer using this to a temp table because it is simple to define and can be referred to again and again just like a temp table; it is also a great to use when one doesn’t have access to create a temp table.
I often use this to avoid using multiple inner selects for complex queries.

I have found this to be one of the better ways of deleting duplicates without creating a temp table.
