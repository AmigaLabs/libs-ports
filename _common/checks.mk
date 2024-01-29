
ifeq (,$(filter $(LIBC),newlib clib2 clib4))
$(error Wrong libc provided. Valid values are: newlib/clib2/clib4)
endif