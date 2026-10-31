{lib, ...}: {
  flake.nixosModules.llama = {pkgs, ...}: {
    services.open-webui = {
      enable = true;
      port = 8081;
      environment = {
        WEBUI_AUTH = "False";
      };
    };

    users.users.open-webui = {
      isSystemUser = true;
      group = "open-webui";
    };
    users.groups.open-webui = {};

    systemd.services.open-webui = {
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        ProtectProc = lib.mkForce "default";
        User = "open-webui";
        Group = "open-webui";
      };
    };

    services.llama-cpp = {
      enable = true;
      package = let
        pkgsWithCuda = import pkgs.path {
          inherit (pkgs) system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
            cudaCapabilities = ["6.1"];
          };
        };
      in
        pkgsWithCuda.llama-cpp.overrideAttrs (oldAttrs: {
          cmakeFlags =
            (oldAttrs.cmakeFlags or [])
            ++ [
              (lib.cmakeFeature "CMAKE_C_FLAGS" "-march=znver2")
              (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-march=znver2")
            ];
        });
      modelsPreset = {
        "Qwen3.5-9B Accuracy" = {
          np = 1;
          fit = "on";
          hf = "unsloth/Qwen3.5-9B-GGUF";
          hf-file = "Qwen3.5-9B-Q4_K_S.gguf";
          alias = "Qwen3.5 Accuracy";
          mmproj-offload = true;
          kv-offload = true;
          flash-attn = "on";
          models-max = 1;
          sleep-idle-seconds = 900;
          ctx-size = 128 * 1024;
          temp = 1.0;
          top-p = 0.95;
          top-k = 20;
          min-p = 0.0;
          parallel = 1;
          repeat-penalty = 1.5;
        };

        "Gemma4-26B-A4B" = {
          # np = 1;
          hf = "unsloth/gemma-4-26B-A4B-it-GGUF";
          hf-file = "gemma-4-26B-A4B-it-UD-Q4_K_S.gguf";
          alias = "Gemma4";
          fit-target = 256;
          mmproj-offload = true;
          n-cpu-moe = 16;
          ngl = 6;
          flash-attn = "on";
          cache-type-k = "q8_0";
          cache-type-v = "q8_0";
          models-max = 1;
          sleep-idle-seconds = 900;
          ctx-size = 256 * 1024;
          temp = 1.0;
          top-p = 0.95;
          top-k = 64;
          parallel = 1;
        };
      };
    };

    systemd.services.llama-cpp = {
      environment = {
        HOME = "/var/lib/llama-cpp";
        XDG_CACHE_HOME = "/var/cache/llama-cpp";
        MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
      };
      serviceConfig.DynamicUser = lib.mkForce false;
    };

    powerManagement.cpuFreqGovernor = "performance";
  };
}
