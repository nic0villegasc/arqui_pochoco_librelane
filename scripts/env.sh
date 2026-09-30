# sets the tool/PDK paths used by every script (Makefile sources it for you)
export PDK_ROOT=${PDK_ROOT:-$HOME/arqui_pochoco_soc/gf180mcu}
export PDK=gf180mcuD
export SCL=gf180mcu_fd_sc_mcu7t5v0
export SCLDIR=$PDK_ROOT/$PDK/libs.ref/$SCL
export LIB=$SCLDIR/lib/${SCL}__tt_025C_5v00.lib
export TLEF=$SCLDIR/techlef/${SCL}__nom.tlef
export CLEF=$SCLDIR/lef/$SCL.lef
export TOP=pochoco_soc
export PERIOD_NS=${PERIOD_NS:-40}
# SRAM hard macro (data RAM): timing + layout views
export SRAMDIR=$PDK_ROOT/$PDK/libs.ref/gf180mcu_fd_ip_sram
export SRAM_LIB=$SRAMDIR/lib/gf180mcu_fd_ip_sram__sram64x8m8wm1__tt_025C_5v00.lib
export SRAM_LEF=$SRAMDIR/lef/gf180mcu_fd_ip_sram__sram64x8m8wm1.lef
mkdir -p out
