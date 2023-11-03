# Shutdown time

The ShutdownTime setting enables you to schedule instance shutdowns in your configuration. Specify a desired shutdown time to automate the process, although exact timing may vary due to system limitations.

## Syntax
`ShutdownTime=[ ISO8601_TIME | none ]`

## Parameters
- **ISO8601_TIME**: A valid ISO 8601 formatted time (e.g., 2023-06-02T13:58:00) that specifies the desired shutdown time in the current system timezone.

- **none**: Disables scheduled shutdowns, allowing instances to run without a set shutdown time.

## Usage example:
To schedule a shutdown time:

`ShutdownTime=2023-06-02T13:58:00`

## How it works
The scheduled shutdown process involves retrieving the specified shutdown time, canceling any prior scheduled shutdown, and calculating the time difference between the scheduled shutdown and the current time. Rounding logic is applied to prevent unintended shutdowns or shutdowns before a system's mode change; if the remaining seconds exceed a threshold of 30 seconds, the shutdown time is rounded up by a minute. The final shutdown time is then determined based on calculated minutes and scheduled accordingly, ensuring accurate shutdowns.

## Considerations
- Time Synchronization: For accurate scheduling, it's crucial that the system clock of the instances is synchronized with an NTP (Network Time Protocol) server, thus, if an huronOS instance does not has its clock in sync, the feature would not be available to avoid potential unexpected shutdowns.

- Shutdown Precision: Due to technical constraints, shutdown accuracy might not be in seconds. Instances could power off in groups or sequentially.

- Flexibility: Choose none to skip scheduled shutdowns, letting instances run beyond set times.