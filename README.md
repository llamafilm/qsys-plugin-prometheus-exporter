# Prometheus Exporter Plugin

This plugin provides metrics about the Qsys Core to a Prometheus scraper on HTTP port 10006.  
You must have a Core Status component in the design, with script access enabled.  This plugin should detect the name of that component automatically, and in the unlikely event you have more than one Status component you can select it by name.

Plugin is based on the [BasicPluginFramework](https://bitbucket.org/qsc-communities/basicpluginframework/src/main/) from QSC and includes the VS Code submodule for easy compiling.
