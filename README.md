# Prometheus Exporter Plugin

This plugin provides metrics about the Qsys Core to a Prometheus scraper on HTTP port 10006.  
You must have a Core Status component in the design with script access enabled.  This plugin should detect the name of that component automatically, and in the unlikely event you have more than one Status component you can select it by name.  The Status component should have verbose mode enabled or else some metrics will be unavailable.

Plugin is based on the [BasicPluginFramework](https://bitbucket.org/qsc-communities/basicpluginframework/src/main/) from QSC and includes the VS Code submodule for easy compiling.

Example output:
```
# HELP qsys_core_status Number from 0 to 5. O=OK, 1=compromised, 2=fault, 3=not present, 4=missing, 5=initializing
# TYPE qsys_core_status gauge
qsys_core_status 0
# HELP qsys_core_info A metric with a constant '1' value with labels for textual data. Grandmaster is either Core name or the PTP Clock GUID
# TYPE qsys_core_info gauge
qsys_core_info{ptp_grandmaster="00-60-74-ff-fe-fb-99-de",ptp_parent_port="",version="9.9.0-2308.008",platform="Core Nano",design_code="jj95JoOHwguq",design_name="The Jar"} 1
# HELP qsys_chassis_fan The current speed of the chassis fan in RPM.
# TYPE qsys_chassis_fan gauge
qsys_chassis_fan 2626
# HELP qsys_ptp_master boolean indicating if the Core is the Master Clock for the Q-SYS system or not. The Core can be the Master Clock even if the clock is synchronized to an external clock.
# TYPE qsys_ptp_master gauge
qsys_ptp_master 0
# HELP qsys_ptp_clock_offset how much of an offset exists, in microseconds, between this Core and the Master Clock. If this Core is the Master Clock, the offset is zero
# TYPE qsys_ptp_clock_offset gauge
qsys_ptp_clock_offset 0
# HELP qsys_processor_temperature The current temperature, in Celsius, of the Core processor.
# TYPE qsys_processor_temperature gauge
qsys_processor_temperature 38.0
# HELP qsys_memory_usage The percentage of memory used.
# TYPE qsys_memory_usage gauge
qsys_memory_usage 24.440950393677
# HELP qsys_compute_control The percentage of non-DSP, control-only CPU usage
# TYPE qsys_compute_control gauge
qsys_compute_control 13.793805122375
# HELP qsys_compute_lua The percentage of CPU usage for script processing
# TYPE qsys_compute_lua gauge
qsys_compute_lua 0.76376843452454
# HELP qsys_compute_process The percentage of CPU usage for DSP, both Category 1 and Category 2 processing
# TYPE qsys_compute_process gauge
qsys_compute_process 4.8866696357727
# TYPE cpu_audio0_current counter
qsys_cpu_audio0_current 3
# TYPE cpu_audio0_minimum counter
qsys_cpu_audio0_minimum 2
# TYPE cpu_audio0_spread counter
qsys_cpu_audio0_spread 0
# TYPE cpu_audio0_maximum counter
qsys_cpu_audio0_maximum 9
# TYPE cpu_audio0_lat_current counter
qsys_cpu_audio0_lat_current 5
# TYPE cpu_audio0_lat_minimum counter
qsys_cpu_audio0_lat_minimum 2
# TYPE cpu_audio0_lat_spread counter
qsys_cpu_audio0_lat_spread 1
# TYPE cpu_audio0_lat_maximum counter
qsys_cpu_audio0_lat_maximum 12
# TYPE cpu_audio0_periods counter
qsys_cpu_audio0_periods 45011
# TYPE cpu_audio0_overruns counter
qsys_cpu_audio0_overruns 0
# TYPE cpu_audio0_timeouts counter
qsys_cpu_audio0_timeouts 0
# TYPE cpu_audio1_current counter
qsys_cpu_audio1_current 1
# TYPE cpu_audio1_minimum counter
qsys_cpu_audio1_minimum 1
# TYPE cpu_audio1_spread counter
qsys_cpu_audio1_spread 0
# TYPE cpu_audio1_maximum counter
qsys_cpu_audio1_maximum 7
# TYPE cpu_audio1_lat_current counter
qsys_cpu_audio1_lat_current 4
# TYPE cpu_audio1_lat_minimum counter
qsys_cpu_audio1_lat_minimum 1
# TYPE cpu_audio1_lat_spread counter
qsys_cpu_audio1_lat_spread 1
# TYPE cpu_audio1_lat_maximum counter
qsys_cpu_audio1_lat_maximum 11
# TYPE cpu_audio1_periods counter
qsys_cpu_audio1_periods 45011
# TYPE cpu_audio1_overruns counter
qsys_cpu_audio1_overruns 0
# TYPE cpu_audio1_timeouts counter
qsys_cpu_audio1_timeouts 0
# TYPE cpu_audio2_current counter
qsys_cpu_audio2_current 9
# TYPE cpu_audio2_minimum counter
qsys_cpu_audio2_minimum 8
# TYPE cpu_audio2_spread counter
qsys_cpu_audio2_spread 2
# TYPE cpu_audio2_maximum counter
qsys_cpu_audio2_maximum 45
# TYPE cpu_audio2_lat_current counter
qsys_cpu_audio2_lat_current 4
# TYPE cpu_audio2_lat_minimum counter
qsys_cpu_audio2_lat_minimum 1
# TYPE cpu_audio2_lat_spread counter
qsys_cpu_audio2_lat_spread 1
# TYPE cpu_audio2_lat_maximum counter
qsys_cpu_audio2_lat_maximum 16
# TYPE cpu_audio2_periods counter
qsys_cpu_audio2_periods 45011
# TYPE cpu_audio2_overruns counter
qsys_cpu_audio2_overruns 0
# TYPE cpu_audio2_timeouts counter
qsys_cpu_audio2_timeouts 0
# TYPE cpu_block0_current counter
qsys_cpu_block0_current 0
# TYPE cpu_block0_minimum counter
qsys_cpu_block0_minimum 0
# TYPE cpu_block0_spread counter
qsys_cpu_block0_spread 0
# TYPE cpu_block0_maximum counter
qsys_cpu_block0_maximum 0
# TYPE cpu_block0_lat_current counter
qsys_cpu_block0_lat_current 0
# TYPE cpu_block0_lat_minimum counter
qsys_cpu_block0_lat_minimum 0
# TYPE cpu_block0_lat_spread counter
qsys_cpu_block0_lat_spread 0
# TYPE cpu_block0_lat_maximum counter
qsys_cpu_block0_lat_maximum 0
# TYPE cpu_block0_periods counter
qsys_cpu_block0_periods 0
# TYPE cpu_block0_overruns counter
qsys_cpu_block0_overruns 0
# TYPE cpu_block0_timeouts counter
qsys_cpu_block0_timeouts 0
# TYPE cpu_block1_current counter
qsys_cpu_block1_current 0
# TYPE cpu_block1_minimum counter
qsys_cpu_block1_minimum 0
# TYPE cpu_block1_spread counter
qsys_cpu_block1_spread 0
# TYPE cpu_block1_maximum counter
qsys_cpu_block1_maximum 0
# TYPE cpu_block1_lat_current counter
qsys_cpu_block1_lat_current 0
# TYPE cpu_block1_lat_minimum counter
qsys_cpu_block1_lat_minimum 0
# TYPE cpu_block1_lat_spread counter
qsys_cpu_block1_lat_spread 0
# TYPE cpu_block1_lat_maximum counter
qsys_cpu_block1_lat_maximum 0
# TYPE cpu_block1_periods counter
qsys_cpu_block1_periods 0
# TYPE cpu_block1_overruns counter
qsys_cpu_block1_overruns 0
# TYPE cpu_block1_timeouts counter
qsys_cpu_block1_timeouts 0
# TYPE cpu_block2_current counter
qsys_cpu_block2_current 0
# TYPE cpu_block2_minimum counter
qsys_cpu_block2_minimum 0
# TYPE cpu_block2_spread counter
qsys_cpu_block2_spread 0
# TYPE cpu_block2_maximum counter
qsys_cpu_block2_maximum 0
# TYPE cpu_block2_lat_current counter
qsys_cpu_block2_lat_current 0
# TYPE cpu_block2_lat_minimum counter
qsys_cpu_block2_lat_minimum 0
# TYPE cpu_block2_lat_spread counter
qsys_cpu_block2_lat_spread 0
# TYPE cpu_block2_lat_maximum counter
qsys_cpu_block2_lat_maximum 0
# TYPE cpu_block2_periods counter
qsys_cpu_block2_periods 0
# TYPE cpu_block2_overruns counter
qsys_cpu_block2_overruns 0
# TYPE cpu_block2_timeouts counter
qsys_cpu_block2_timeouts 0
# TYPE cpu_param0_current counter
qsys_cpu_param0_current 2
# TYPE cpu_param0_minimum counter
qsys_cpu_param0_minimum 2
# TYPE cpu_param0_spread counter
qsys_cpu_param0_spread 0
# TYPE cpu_param0_maximum counter
qsys_cpu_param0_maximum 3
# TYPE cpu_param0_lat_current counter
qsys_cpu_param0_lat_current 15
# TYPE cpu_param0_lat_minimum counter
qsys_cpu_param0_lat_minimum 15
# TYPE cpu_param0_lat_spread counter
qsys_cpu_param0_lat_spread 3
# TYPE cpu_param0_lat_maximum counter
qsys_cpu_param0_lat_maximum 26
# TYPE cpu_param0_periods counter
qsys_cpu_param0_periods 450
# TYPE cpu_param0_overruns counter
qsys_cpu_param0_overruns 0
# TYPE cpu_param0_timeouts counter
qsys_cpu_param0_timeouts 0
# TYPE cpu_param1_current counter
qsys_cpu_param1_current 1
# TYPE cpu_param1_minimum counter
qsys_cpu_param1_minimum 1
# TYPE cpu_param1_spread counter
qsys_cpu_param1_spread 0
# TYPE cpu_param1_maximum counter
qsys_cpu_param1_maximum 1
# TYPE cpu_param1_lat_current counter
qsys_cpu_param1_lat_current 13
# TYPE cpu_param1_lat_minimum counter
qsys_cpu_param1_lat_minimum 13
# TYPE cpu_param1_lat_spread counter
qsys_cpu_param1_lat_spread 4
# TYPE cpu_param1_lat_maximum counter
qsys_cpu_param1_lat_maximum 26
# TYPE cpu_param1_periods counter
qsys_cpu_param1_periods 450
# TYPE cpu_param1_overruns counter
qsys_cpu_param1_overruns 0
# TYPE cpu_param1_timeouts counter
qsys_cpu_param1_timeouts 0
# TYPE cpu_param1_current counter
qsys_cpu_param1_current 1
# TYPE cpu_param1_minimum counter
qsys_cpu_param1_minimum 1
# TYPE cpu_param1_spread counter
qsys_cpu_param1_spread 0
# TYPE cpu_param1_maximum counter
qsys_cpu_param1_maximum 1
# TYPE cpu_param1_lat_current counter
qsys_cpu_param1_lat_current 13
# TYPE cpu_param1_lat_minimum counter
qsys_cpu_param1_lat_minimum 13
# TYPE cpu_param1_lat_spread counter
qsys_cpu_param1_lat_spread 4
# TYPE cpu_param1_lat_maximum counter
qsys_cpu_param1_lat_maximum 26
# TYPE cpu_param1_periods counter
qsys_cpu_param1_periods 450
# TYPE cpu_param1_overruns counter
qsys_cpu_param1_overruns 0
# TYPE cpu_param1_timeouts counter
qsys_cpu_param1_timeouts 0
```
