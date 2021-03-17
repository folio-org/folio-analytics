# Documentation for the ERM inventory count query 

This query relies on the [title count query](../../title_count) but is only addressing virtual instances.

#### Hardcoded filters (assumptions; in the where clause):
* Includes: e-resources; suppressed instance records, and instance records with only suppressed holdings records.

<details>
  <summary>Click to read more!</summary>

* Each instance has a holdings record.  Each holdings record has a permanent location.
* Excludes suppressed instance records (instance discovery suppress value is “true”)
* Excludes instance records that do not have at least one unsuppressed holdings record (all holdings discovery suppress values are “true”)
* This query is intended to only include e-resources. It includes instance records with instance format names of “computer – online resource” or instance records with holdings library names of “Online”. These values many need to be updated for your local needs.
  </details>

#### Find [here](../../title_count) the documentation for RM title count query