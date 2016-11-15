# windows_task
## inspec profile resource

This is a custom resouce for [inspec](http://inspec.io) Use can use it to audit the
scheduled tasks on a windows system.

## inspec control examples
Here are some examples 
```
describe windows_task('\Microsoft\Windows\AppID\PolicyConverter') do
  its('logon_mode') { should eq 'Interactive/Background' }
  its('last_result') { should eq '1' }
  its('task_to_run') { should cmp '%Windir%\system32\appidpolicyconverter.exe' }
  its('run_as_user') { should eq 'LOCAL SERVICE' }
end

describe windows_task('\Microsoft\Windows\Time Synchronization\SynchronizeTime') do
  it { should be_enabled }
end

describe windows_task('\Microsoft\Windows\AppID\PolicyConverter') do
  it { should be_disabled }
end

describe windows_task('\Microsoft\Windows\Defrag\ScheduledDefrag') do
  it { should exist }
end

describe windows_task('\I\made\this\up') do
  it { should_not exist }
end
```

## Available Methods
* exists?
  _does the task exist on the system_

* enabled?
  _is the task setup ready to run or in a running state_

* disabled?
  _is the state of the task set to disabled_

* logon_mode
  _used to return the logon mode of the task as a string, for example can it interact with the desktop_

* last_result
  _used to return result code of the task as an int_

* task_to_run
  _used to return the command line of the named task as a string_ 

* run_as_user
 _used to return the credentials details of the named task as a string_

 ## OS Support

 * Windows 2008 + with the WMF3+

 ## Gathering Tasknames
 Rather then use the GUI you can use the `schtasks.exe` to output a full list of tasks 
 available on the system

 `schtasks /query /FO list`

 rather than use the list output you can use CSV if it is easier, use the TaskName within your control

```
C:\>schtasks /query /FO list
...
Folder: \Microsoft\Windows\Diagnosis
HostName:      XPS15
TaskName:      \Microsoft\Windows\Diagnosis\Scheduled
Next Run Time: N/A
Status:        Ready
Logon Mode:    Interactive/Background
...
```

# Version History
Version | Description
--- | ---
0.2.1 | Updated Readme with Method Examples before peer review.
0.2.0 | Refactoring and added additional definitions to library
0.1.0 | Initial version of the profile