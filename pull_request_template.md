

```
All queries:
- [ ] Pull request is based on a new branch (not main)
- [ ] Pull request scope is not overly broad
- [ ] Release notes have been added or updated in CHANGES.md
- [ ] Query runs without errors
- [ ] Query output is correct
- [ ] Query logic is clear and well documented
- [ ] Query is readable and properly indented with spaces (not tabs)
- [ ] Table and column names are in all-lowercase
- [ ] Quotation marks are used only where necessary

Report queries:
- [ ] Query has complete user documentation
    - [ ] Purpose of report
    - [ ] Sample output
    - [ ] Query instructions

Derived tables:
- [ ] Query begins with user documentation in comment lines
- [ ] File name is listed in `runlist.txt` after dependencies
- [ ] All columns have indexes
- [ ] Table is vacuumed and analyzed
- [ ] If derived table is for Metadb, query begins with Metadb directive in first line (e.g., --metadb:table feesfines_accounts_actions)
```
