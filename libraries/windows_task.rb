# encoding: utf-8
# author: Gary Bright @username-is-already-taken2
class WindowsTasks < Inspec.resource(1)
  name 'windows_task'
  desc 'Use the windows_task InSpec audit resource to test task schedules on Microsoft Windows.'
  example "
    describe windows_task('\\Microsoft\\Windows\\Time Synchronization\\SynchronizeTime') do
      it { should be_enabled }
    end

    describe windows_task('\\Microsoft\\Windows\\AppID\\PolicyConverter') do
      it { should be_disabled }
    end

    describe windows_task('\\Microsoft\\Windows\\Defrag\\ScheduledDefrag') do
      it { should exist }
    end
  "

  def initialize(taskuri)
    @taskuri = taskuri
    @cache = nil
    # verify that this resource is only supported on Windows
    return skip_resource 'The `windows_task` resource is not supported on your OS.' unless inspec.os.windows?
  end

  # returns true if the task exists
  def exists?
    return true unless info.nil? || info[:uri].nil?
  end

  # state 3 = Ready
  # state 4 = Running
  # def used to determine if the task is enabled
  def enabled?
    return false if info.nil? || info[:uri].nil?
    info[:state] == ('Ready' || 'Running' || 3 || 4)
  end

  # state 1 = Disabled
  # def used to determine if the task is disabled
  def disabled?
    return false if info.nil? || info[:uri].nil?
    info[:state] == ('Disabled' || 1)
  end

  # returns the task details
  def info # rubocop:disable Metrics/MethodLength
    return @cache unless @cache.nil?
    # PowerShell v5 has Get-ScheduledTask cmdlet,
    # _using something with backward support to v3_
    # script = "Get-ScheduledTask | ? { $_.URI -eq '#{@taskuri}' } | Select-Object URI,State | ConvertTo-Json"

    # Using schtasks as suggested by @modille but aligning property names to match cmdlet to future proof.
    script = "schtasks /query /fo csv /tn '#{@taskuri}' | ConvertFrom-Csv | Select @{N='URI';E={$_.TaskName}},@{N='State';E={$_.Status}} | ConvertTo-Json"
    cmd = inspec.powershell(script)

    begin
      params = JSON.parse(cmd.stdout)
    rescue JSON::ParserError => _e
      return nil
    end

    @cache = {
      uri: params['URI'],
      state: params['State'],
      type: 'windows-task'
    }
  end

  def to_s
    "Windows Task '#{@taskuri}'"
  end
end
