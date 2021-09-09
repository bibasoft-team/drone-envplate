#!/bin/bash

params=()

[[ $PLUGIN_BACKUP == true ]] && params+=(-b)
[[ $PLUGIN_DRY_RUN == true ]] && params+=(-d)
[[ $PLUGIN_STRICT == true ]] && params+=(-s)
[[ $PLUGIN_VERBOSE == true ]] && params+=(-v)

ep ${params[@]} $PLUGIN_FILE