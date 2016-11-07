# encoding: utf-8
# copyright: 2016, @username-is-already-taken2
# license: All rights reserved

title 'Example Controls to test windows_task resource'

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
