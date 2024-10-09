---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

**Describe the bug**

A clear and concise description of what the bug is.

**To Reproduce**

Steps to reproduce the behavior:

1. Open '...'
2. Select '....'
3. Wait for '....'
4. See error

**Expected behavior**

A clear and concise description of what you expected to happen.

**Screenshots**

If applicable, add screenshots to help explain your problem.

**Additional context**

To generate a system report, run the sysreport.ps1 script. Follow the steps below:

1. Open `cmd.exe` in the project directory.
2. Execute the following command:

```shell
powershell -executionpolicy bypass -File .\sysreport.ps1
```

3. After the script runs, please upload the generated `SystemInfo.log`.
