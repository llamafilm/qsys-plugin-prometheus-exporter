# Prometheus Exporter Plugin

This plugin provides metrics about the Qsys Core to a Prometheus scraper on HTTP port 10006.  
You must have a Core Status component in the design with script access enabled.  This plugin should detect the name of that component automatically, and in the unlikely event you have more than one Status component you can select it by name.  The Status component should have verbose mode enabled or else some metrics will be unavailable.

Plugin is based on the [BasicPluginFramework](https://bitbucket.org/qsc-communities/basicpluginframework/src/main/) from QSC and includes the VS Code submodule for easy compiling.

Example output:
```
# HELP qsys_core_status Number from 0 to 5. O=OK, 1=compromised, 2=fault, 3=not present, 4=missing, 5=initializing
# TYPE qsys_core_status gauge
qsys_core_status 0
# HELP qsys_memory_usage The percentage of memory used.
# TYPE qsys_memory_usage gauge
qsys_memory_usage 23.732685089111
# HELP qsys_core_info A metric with a constant '1' value with labels for textual data. Grandmaster is either Core name or the PTP Clock GUID
# TYPE qsys_core_info gauge
qsys_core_info{ptp_grandmaster="Core-Nano-Jar215" ptp_parent_port="None" version="9.9.0-2308.008" platform="Core Nano" design_code="GQ6CeVYNKQsU" design_name="The Jar"} 1
# HELP qsys_chassis_fan The current speed of the chassis fan in RPM.
# TYPE qsys_chassis_fan gauge
qsys_chassis_fan 2621
# HELP qsys_compute_control The percentage of non-DSP, control-only CPU usage
# TYPE qsys_compute_control gauge
qsys_compute_control 11.545015335083
# HELP qsys_compute_lua The percentage of CPU usage for script processing
# TYPE qsys_compute_lua gauge
qsys_compute_lua 0.34273719787598
# HELP qsys_compute_process The percentage of CPU usage for DSP, both Category 1 and Category 2 processing
# TYPE qsys_compute_process gauge
qsys_compute_process 4.5713429450989
# HELP qsys_ptp_master boolean indicating if the Core is the Master Clock for the Q-SYS system or not. The Core can be the Master Clock even if the clock is synchronized to an external clock.
# TYPE qsys_ptp_master gauge
qsys_ptp_master 1
# HELP qsys_ptp_clock_offset how much of an offset exists, in microseconds, between this Core and the Master Clock. If this Core is the Master Clock, the offset is zero
# TYPE qsys_ptp_clock_offset gauge
qsys_ptp_clock_offset 0
# HELP qsys_processor_temperature The current temperature, in Celsius, of the Core processor.
# TYPE qsys_processor_temperature gauge
qsys_processor_temperature 39.0
```
