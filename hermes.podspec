module HermesHelper
  # BUILD_TYPE = :debug
  BUILD_TYPE = :release

  def self.command_exists?(bin)
    "command -v #{bin} > /dev/null 2>&1"
  end

  def self.configure_command
    "./utils/build/configure.py #{BUILD_TYPE == :release ? "--distribute" : "--build-type=Debug"} --cmake-flags='-DCMAKE_INSTALL_PREFIX:PATH=../destroot' build"
  end

  def self.build_dir
    BUILD_TYPE == :release ? "build_release" : "build"
  end
end

Pod::Spec.new do |spec|
  spec.name        = "hermes"
  spec.version     = "0.4.1"
  spec.summary     = "Hermes is a small and lightweight JavaScript engine optimized for running React Native."
  spec.description = "Hermes is a JavaScript engine optimized for fast start-up of React Native apps. It features ahead-of-time static optimization and compact bytecode."
  spec.homepage    = "https://hermesengine.dev"
  spec.license     = { type: "MIT", file: "LICENSE" }
  spec.author      = "Facebook"
  spec.source      = { git: "https://github.com/facebook/hermes.git", tag: "v#{spec.version}" }
  spec.platforms   = { :osx => "10.14" }

  spec.preserve_paths      = ["destroot/bin/*"].concat(HermesHelper::BUILD_TYPE == :debug ? ["**/*.{h,c,cpp}"] : [])
  spec.source_files        = "destroot/include/**/*.h"
  spec.header_mappings_dir = "destroot/include"
  spec.vendored_libraries  = "destroot/lib/libhermes.dylib"
  spec.xcconfig            = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++14", "CLANG_CXX_LIBRARY" => "compiler-default", "GCC_PREPROCESSOR_DEFINITIONS" => "HERMES_ENABLE_DEBUGGER=1" }

  spec.prepare_command = <<-EOS
    if [ ! -f destroot/lib/libhermes.dylib ]; then
      if #{HermesHelper.command_exists?("cmake")}; then
        if #{HermesHelper.command_exists?("ninja")}; then
          #{HermesHelper.configure_command} --build-system='Ninja' && cd #{HermesHelper.build_dir} && ninja install
        else
          #{HermesHelper.configure_command} --build-system='Unix Makefiles' && cd #{HermesHelper.build_dir} && make install
        fi
      else
        echo >&2 'CMake is required to install Hermes, install it with: brew install cmake'
        exit 1
      fi
    fi
  EOS
end
