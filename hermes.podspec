Pod::Spec.new do |spec|
  spec.name        = "hermes"
  spec.version     = "0.5.0"
  spec.summary     = "Hermes is a small and lightweight JavaScript engine optimized for running React Native."
  spec.description = "Hermes is a JavaScript engine optimized for fast start-up of React Native apps. It features ahead-of-time static optimization and compact bytecode."
  spec.homepage    = "https://hermesengine.dev"
  spec.license     = { type: "MIT", file: "LICENSE" }
  spec.author      = "Facebook"
  spec.source      = { git: "https://github.com/facebook/hermes.git", tag: "v#{spec.version}" }

  spec.public_header_files = "public/**/*.{h,def}"
  spec.header_mappings_dir = "public"

  spec.xcconfig = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++11", "CLANG_CXX_LIBRARY" => "compiler-default" }

  spec.osx.deployment_target = "10.14"
  spec.osx.vendored_libraries =
    "API/hermes/libhermesapi.a",
    "external/llvh/lib/Support/libLLVHSupport.a",
    "external/llvh/lib/Demangle/libLLVHDemangle.a",
    "lib/libhermesFrontend.a",
    "lib/libhermesOptimizer.a",
    "lib/VM/libhermesVMRuntime.a",
    "lib/Inst/libhermesInst.a",
    "lib/FrontEndDefs/libhermesFrontEndDefs.a",
    "lib/ADT/libhermesADT.a",
    "lib/AST/libhermesAST.a",
    "lib/Parser/libhermesParser.a",
    "lib/SourceMap/libhermesSourceMap.a",
    "lib/Support/libhermesSupport.a",
    "lib/BCGen/libhermesBackend.a",
    "lib/BCGen/HBC/libhermesHBCBackend.a",
    "lib/Regex/libhermesRegex.a",
    "lib/Platform/libhermesPlatform.a",
    "lib/Platform/Unicode/libhermesPlatformUnicode.a",
    "external/dtoa/libdtoa.a",
    "jsi/libjsi.a"
end
