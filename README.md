
# Premise

Support both `bash` and `zsh` shells in one set of scripts. Common files are
sourced from the shell specific versions. The common profile sets up various paths
and attempts to do so without duplicating entries on the path or adding non-existing
directories.

# Directory layout

Each supported host will have a directory created with that hostname in the home
directory. The following sub-directories are utilised. These will likely be links
to locally mounted file systems on each host.

Environment variables and paths are initialised to support these folders, and
additionally the same folders in the HOME directory, if present. The host specific
folders always take precedent however.

* `build` - directory for performing builds in
* `ccache` - ccache directory
* `install` - installed tools (`.../bin`, `.../lib`, `.../share`, etc)
* `local` - locally mounted directory (link)
* `stuff` - stuff, mostly third party sources
* `test` - test outputs
* `work` - sources
* `bin` - general personal bin directory

# Setup

* `mklinks.sh`

This will create links in home directory. It will /not/ overwrite any existing
files.

