module HermesHelper
  def self.command_exists?(bin)
    "command -v #{bin} > /dev/null 2>&1"
  end

  def self.configure_command
    "./utils/build/configure.py --build-type=Debug  --cmake-flags='-DCMAKE_INSTALL_PREFIX:PATH=../destroot' build"
  end
end

Pod::Spec.new do |spec|
  spec.name        = "hermes"
  spec.version     = "0.2.1"
  spec.summary     = "Hermes is a small and lightweight JavaScript engine optimized for running React Native."
  spec.description = "Hermes is a JavaScript engine optimized for fast start-up of React Native apps. It features ahead-of-time static optimization and compact bytecode."
  spec.homepage    = "https://hermesengine.dev"
  spec.license     = { type: "MIT", file: "LICENSE" }
  spec.author      = "Facebook"
  spec.source      = { git: "https://github.com/facebook/hermes.git", tag: "v#{spec.version}" }
  spec.platforms   = { :osx => "10.14" }

  spec.preserve_paths      = "destroot/bin/*", "**/*.{h,c,cpp}"
  spec.source_files        = "destroot/include/**/*.h"
  spec.header_mappings_dir = "destroot/include"
  spec.vendored_libraries  = "destroot/lib/libhermes.dylib"
  spec.xcconfig            = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++14", "CLANG_CXX_LIBRARY" => "compiler-default" }

  spec.prepare_command = <<-EOS
    ./utils/build/build_llvm.py
    if #{HermesHelper.command_exists?("cmake")}; then
      if #{HermesHelper.command_exists?("ninja")}; then
        #{HermesHelper.configure_command} --build-system='Ninja' && cd ./build && ninja install
      else
        #{HermesHelper.configure_command} --build-system='Unix Makefiles' && cd ./build && make install
      fi
    else
      echo >&2 'CMake is required to install Hermes, install it with: brew install cmake'
      exit 1
    fi
  EOS
end
