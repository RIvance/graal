{
  local graal_common = import '../common.json',
  local common = import 'ci_common/common.jsonnet',
  local jdks = graal_common.jdks,
  local utils = import '../common-utils.libsonnet',
  local devkits = utils.composable(graal_common.devkits),

  suite_name: 'espresso',

  windows_11 : common.windows + devkits["windows-jdk11"],
  windows_17 : common.windows + devkits["windows-jdk17"],

  builds: common.builds + [
    // Benchmarks
    // AWFY peak perf. benchmarks
    common.jdk17_weekly_bench_linux    + common.espresso_benchmark('jvm-ce-llvm', 'awfy:*'                                        , extra_args=['--vm.Xmx1g', '--vm.Xms1g'])         + {name: 'weekly-bench-espresso-jvm-ce-awfy-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.espresso_benchmark('jvm-ce-llvm', 'awfy:*'   , guest_jvm_config='safe'            , extra_args=['--vm.Xmx1g', '--vm.Xms1g'])         + {name: 'weekly-bench-espresso-jvm-ce-awfy-safe-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.espresso_benchmark('jvm-ce-llvm', 'awfy:*'   , guest_jvm_config='array-based'     , extra_args=['--vm.Xmx1g', '--vm.Xms1g'])         + {name: 'weekly-bench-espresso-jvm-ce-awfy-array-based-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.espresso_benchmark('jvm-ce-llvm', 'awfy:*'   , guest_jvm_config='array-based-safe', extra_args=['--vm.Xmx1g', '--vm.Xms1g'])         + {name: 'weekly-bench-espresso-jvm-ce-awfy-array-based-safe-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.espresso_benchmark('native-ce-llvm', 'awfy:*'                                     , extra_args=['--vm.Xmx1g', '--vm.Xms1g'])         + {name: 'weekly-bench-espresso-native-ce-awfy-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.espresso_benchmark('native-ce-llvm', 'awfy:*', guest_jvm_config='safe'            , extra_args=['--vm.Xmx1g', '--vm.Xms1g'])         + {name: 'weekly-bench-espresso-native-ce-awfy-safe-jdk17-linux-amd64'},

    // AWFY interpreter benchmarks
    common.jdk17_weekly_bench_linux    + common.espresso_interpreter_benchmark('jvm-ce-llvm', 'awfy:*')                                                                              + {name: 'weekly-bench-espresso-jvm-ce-awfy_interpreter-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.espresso_interpreter_benchmark('native-ce-llvm', 'awfy:*')                                                                           + {name: 'weekly-bench-espresso-native-ce-awfy_interpreter-jdk17-linux-amd64'},

    // Scala DaCapo warmup benchmarks
    common.jdk17_weekly_bench_linux    + common.scala_dacapo_warmup_benchmark('jvm-ce-llvm'   , guest_jvm_config='single-tier'    , extra_args=['--vm.XX:ReservedCodeCacheSize=1g']) + {name: 'weekly-bench-espresso-jvm-ce-scala_dacapo_warmup-single_tier-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.scala_dacapo_warmup_benchmark('native-ce-llvm', guest_jvm_config='single-tier')                                                      + {name: 'weekly-bench-espresso-native-ce-scala_dacapo_warmup-single_tier-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.scala_dacapo_warmup_benchmark('jvm-ce-llvm'   , guest_jvm_config='multi-tier'     , extra_args=['--vm.XX:ReservedCodeCacheSize=1g']) + {name: 'weekly-bench-espresso-jvm-ce-scala_dacapo_warmup-multi_tier-jdk17-linux-amd64'},
    common.jdk17_weekly_bench_linux    + common.scala_dacapo_warmup_benchmark('native-ce-llvm', guest_jvm_config='multi-tier')                                                       + {name: 'weekly-bench-espresso-native-ce-scala_dacapo_warmup-multi_tier-jdk17-linux-amd64'},

    // On-demand benchmarks
    // Scala DaCapo warmup benchmarks
    common.jdk17_on_demand_bench_linux + common.graal_benchmark('jvm-ce-llvm', common.scala_dacapo_jvm_warmup)                                                                       + {name: 'ondemand-bench-espresso-jvm-ce-scala_dacapo_warmup-jdk17-linux-amd64'},

    // Memory footprint
    common.jdk17_on_demand_linux       + common.espresso_minheap_benchmark('jvm-ce-llvm', 'awfy:*', 'infinite-overhead')                                                             + {name: 'ondemand-bench-espresso-jvm-ce-awfy-minheap-infinite-ovh-jdk17-linux-amd64'},
    common.jdk17_on_demand_bench_linux + common.espresso_minheap_benchmark('jvm-ce-llvm', 'awfy:*', '1.5-overhead')                                                                  + {name: 'ondemand-bench-espresso-jvm-ce-awfy-minheap-1.5-ovh-jdk17-linux-amd64'},

    // Longer-running benchmarks are on-demand
    // single tier
    common.jdk17_on_demand_bench_linux + common.scala_dacapo_benchmark('jvm-ce-llvm'                                              , extra_args=['--vm.XX:ReservedCodeCacheSize=1g']) + {name: 'ondemand-bench-espresso-jvm-ce-scala_dacapo-single_tier-jdk17-linux-amd64'},
    common.jdk17_on_demand_bench_linux + common.scala_dacapo_benchmark('native-ce-llvm')                                                                                             + {name: 'ondemand-bench-espresso-native-ce-scala_dacapo-single_tier-jdk17-linux-amd64'},
    common.jdk17_on_demand_bench_linux + common.dacapo_benchmark('jvm-ce-llvm'                                                    , extra_args=['--vm.XX:ReservedCodeCacheSize=1g']) + {name: 'ondemand-bench-espresso-jvm-ce-dacapo-single_tier-jdk17-linux-amd64'},
    common.jdk17_on_demand_bench_linux + common.dacapo_benchmark('native-ce-llvm')                                                                                                   + {name: 'ondemand-bench-espresso-native-ce-dacapo-single_tier-jdk17-linux-amd64'},
    // multi tier
    common.jdk17_on_demand_bench_linux + common.scala_dacapo_benchmark('jvm-ce-llvm', 'multi-tier'                                , extra_args=['--vm.XX:ReservedCodeCacheSize=1g']) + {name: 'ondemand-bench-espresso-jvm-ce-scala_dacapo-multi_tier-jdk17-linux-amd64'},
    common.jdk17_on_demand_bench_linux + common.scala_dacapo_benchmark('native-ce-llvm', 'multi-tier')                                                                               + {name: 'ondemand-bench-espresso-native-ce-scala_dacapo-multi_tier-jdk17-linux-amd64'},
    common.jdk17_on_demand_bench_linux + common.dacapo_benchmark('jvm-ce-llvm', 'multi-tier'                                      , extra_args=['--vm.XX:ReservedCodeCacheSize=1g']) + {name: 'ondemand-bench-espresso-jvm-ce-dacapo-multi_tier-jdk17-linux-amd64'},
    common.jdk17_on_demand_bench_linux + common.dacapo_benchmark('native-ce-llvm', 'multi-tier')                                                                                     + {name: 'ondemand-bench-espresso-native-ce-dacapo-multi_tier-jdk17-linux-amd64'},
  ]
}
