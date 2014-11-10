INTELCE_VERSION = 18
INTELCE_SITE = `readlink -f ../intelce-gfx/`

include package/intelce/*/*.mk
include package/intelce/*/*/*.mk
