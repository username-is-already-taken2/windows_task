# encoding: utf-8
# copyright: 2016, @username-is-already-taken2
# copyright: 2016, @cdbeard2016
# license: All rights reserved

title 'Example Controls to test windows_task resource'

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
