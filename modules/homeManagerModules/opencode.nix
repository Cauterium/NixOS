{...}: {
  flake.homeManagerModules.opencode = {
    programs.opencode = {
      enable = true;
      settings = {
        provider = {
          "llama.cpp" = {
            npm = "@ai-sdk/openai-compatible";
            name = "LLaMA Local";
            options.baseURL = "http://127.0.0.1:8080/v1";
            models = {
              "Gemma4-26B-A4B" = {
                name = "Gemma4-26B-A4B";
              };
            };
          };
        };
      };
    };
  };
}
