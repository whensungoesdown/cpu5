#!/bin/sh
PROJECT=cpu5_core
TOP_LEVEL_FILE=../hdl/cpu5_core.v
FAMILY=CycloneII
PART=EP2C5T144C8
PACKING_OPTION=minimize_area
quartus_map $PROJECT --source=$TOP_LEVEL_FILE --source=../hdl/defines.v --family=$FAMILY
quartus_fit $PROJECT --part=$PART --pack_register=$PACKING_OPTION
quartus_asm $PROJECT
quartus_sta $PROJECT
