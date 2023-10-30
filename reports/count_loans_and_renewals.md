# Count loans and renewals

## Report details

This report can be used to satisfy a need for annual statistics
showing total loans and renewals by location.  The report itself
returns each loan record, with information about the item locations,
material type, loan policy, loan type, and loan status.  To summarize
loans and renewals for different subsets of the data, add up the loans
and renewals columns for the subsets.

Note that currently there is no loan renewal date available.

This report generates data with the following format:

| date\_range | loan\_date | loan\_due\_date | loan\_return\_date | loan\_status | num\_loans | num\_renewals | patron\_group\_name | material\_type\_name | loan\_policy\_name | permanent\_loan\_type\_name | temporary\_loan\_type\_name | permanent\_location\_name | temporary\_location\_name | effective\_location\_name | permanent\_location\_library\_name | permanent\_location\_campus\_name | permanent\_location\_institution\_name |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2000-01-01 to 2022-01-01 | 2021-01-07 | 2021-01-07 19:03:41+00 | 2021-01-07 20:38:36+00 | Open | 1 |  | undergrad | book | One Hour |  | Can circulate | Main Library | | Main Library | Datalogisk Institut | City Campus | Københavns Universitet |

Note that in this report `num_loans` always has a value of `1`, since
each row corresponds to one loan.
