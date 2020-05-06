module HermesHelper
  def self.command_exists?(bin)
    "command -v #{bin} > /dev/null 2>&1"
  end

  def self.configure_command
    "./utils/build/configure.py --build-type=Debug ./build"
  end
end

Pod::Spec.new do |spec|
  spec.name        = "hermes"
  spec.version     = "0.5.0"
  spec.summary     = "Hermes is a small and lightweight JavaScript engine optimized for running React Native."
  spec.description = "Hermes is a JavaScript engine optimized for fast start-up of React Native apps. It features ahead-of-time static optimization and compact bytecode."
  spec.homepage    = "https://hermesengine.dev"
  spec.license     = { type: "MIT", file: "LICENSE" }
  spec.author      = "Facebook"
  spec.source      = { git: "https://github.com/facebook/hermes.git", tag: "v#{spec.version}" }
  spec.platforms   = { :osx => "10.14" }

  spec.public_header_files = "build/public/**/*.{h,def}"
  spec.preserve_paths      = "build/public/**/*.{h,def}", "build/bin/*"
  spec.header_mappings_dir = "build/public"
  spec.vendored_libraries  = "build/API/hermes/libhermes.dylib"
  spec.xcconfig            = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++14", "CLANG_CXX_LIBRARY" => "compiler-default" }

  configure_command = "./utils/build/configure.py --build-type=Debug build"
  spec.prepare_command = <<-EOS
    if #{HermesHelper.command_exists?("cmake")}; then
      if #{HermesHelper.command_exists?("ninja")}; then
        #{HermesHelper.configure_command} --build-system='Ninja' && cd ./build && ninja
      else
        #{HermesHelper.configure_command} --build-system='Unix Makefiles' && cd ./build && make
      fi
      cd ..
      rsync -zarv --include "*/" --include="*.h" --exclude="*" public build/
      rsync -zarv --include "*/" --include="*.h" --exclude="*" API/hermes/ build/public/hermes/
      rsync -zarv --include "*/" --include="*.h" --exclude="*" API/jsi/ build/public/
    else
      echo >&2 'CMake is required to install Hermes, install it with: brew install cmake'
      exit 1
    fi
  EOS
end
