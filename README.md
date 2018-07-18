# stepXXX-ncbi-genomes

Module to download and unpack genome assemblies from NCBI's RefSeq
and/or GENBANK repositories.

To use this module, first create a configuration file from the
template.

    $ cp config-template.bash config.bash

Then update `config.bash` according to your needs.

Finally, run the module

    $ ./doit.bash

This module is implemented entirely with scripts and native
executables. 

------------------------------------------------------------------------

Issues

- Should allow pattern matching on organism name. E.g., '*DC3000*'.
- Should leverage `taxdump` in order to download genomes by `taxid`.
