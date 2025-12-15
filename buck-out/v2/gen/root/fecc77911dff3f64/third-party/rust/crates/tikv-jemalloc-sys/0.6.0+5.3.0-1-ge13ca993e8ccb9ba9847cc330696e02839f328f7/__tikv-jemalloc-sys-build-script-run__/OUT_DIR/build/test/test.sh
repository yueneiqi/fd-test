#!/bin/sh

case elf in
  macho)
    export DYLD_FALLBACK_LIBRARY_PATH="lib"
    ;;
  pecoff)
    export PATH="${PATH}:lib"
    ;;
  *)
    ;;
esac

# Make a copy of the _RJEM_MALLOC_CONF passed in to this script, so
# it can be repeatedly concatenated with per test settings.
export MALLOC_CONF_ALL=${_RJEM_MALLOC_CONF}
# Concatenate the individual test's MALLOC_CONF and MALLOC_CONF_ALL.
export_malloc_conf() {
  if [ "x${MALLOC_CONF}" != "x" -a "x${MALLOC_CONF_ALL}" != "x" ] ; then
    export _RJEM_MALLOC_CONF="${MALLOC_CONF},${MALLOC_CONF_ALL}"
  else
    export _RJEM_MALLOC_CONF="${MALLOC_CONF}${MALLOC_CONF_ALL}"
  fi
}

# Corresponds to test_status_t.
pass_code=0
skip_code=1
fail_code=2

pass_count=0
skip_count=0
fail_count=0
for t in $@; do
  if [ $pass_count -ne 0 -o $skip_count -ne 0 -o $fail_count != 0 ] ; then
    echo
  fi
  echo "=== ${t} ==="
  if [ -e "${t}.sh" ] ; then
    # Source the shell script corresponding to the test in a subshell and
    # execute the test.  This allows the shell script to set MALLOC_CONF, which
    # is then used to set _RJEM_MALLOC_CONF (thus allowing the
    # per test shell script to ignore the _RJEM_ detail).
    enable_fill=1 \
    enable_prof=0 \
    . ${t}.sh && \
    export_malloc_conf && \
    $JEMALLOC_TEST_PREFIX ${t} /home/runner/work/buckal_workspace/buckal_workspace/test/3rd/fd/buck-out/v2/gen/root/fecc77911dff3f64/third-party/rust/crates/tikv-jemalloc-sys/0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7/__tikv-jemalloc-sys-build-script-run__/OUT_DIR/build/ /home/runner/work/buckal_workspace/buckal_workspace/test/3rd/fd/buck-out/v2/gen/root/fecc77911dff3f64/third-party/rust/crates/tikv-jemalloc-sys/0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7/__tikv-jemalloc-sys-build-script-run__/OUT_DIR/build/
  else
    export MALLOC_CONF= && \
    export_malloc_conf && \
    $JEMALLOC_TEST_PREFIX ${t} /home/runner/work/buckal_workspace/buckal_workspace/test/3rd/fd/buck-out/v2/gen/root/fecc77911dff3f64/third-party/rust/crates/tikv-jemalloc-sys/0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7/__tikv-jemalloc-sys-build-script-run__/OUT_DIR/build/ /home/runner/work/buckal_workspace/buckal_workspace/test/3rd/fd/buck-out/v2/gen/root/fecc77911dff3f64/third-party/rust/crates/tikv-jemalloc-sys/0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7/__tikv-jemalloc-sys-build-script-run__/OUT_DIR/build/
  fi
  result_code=$?
  case ${result_code} in
    ${pass_code})
      pass_count=$((pass_count+1))
      ;;
    ${skip_code})
      skip_count=$((skip_count+1))
      ;;
    ${fail_code})
      fail_count=$((fail_count+1))
      ;;
    *)
      echo "Test harness error: ${t} w/ MALLOC_CONF=\"${MALLOC_CONF}\"" 1>&2
      echo "Use prefix to debug, e.g. JEMALLOC_TEST_PREFIX=\"gdb --args\" sh test/test.sh ${t}" 1>&2
      exit 1
  esac
done

total_count=`expr ${pass_count} + ${skip_count} + ${fail_count}`
echo
echo "Test suite summary: pass: ${pass_count}/${total_count}, skip: ${skip_count}/${total_count}, fail: ${fail_count}/${total_count}"

if [ ${fail_count} -eq 0 ] ; then
  exit 0
else
  exit 1
fi
