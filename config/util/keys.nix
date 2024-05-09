{...}: {
  silent = action: key: desc: let
    binding = {
      action = action;
      key = key;
      options = {silent = true;};
    };

    description = {"${key}" = desc;};
  in {inherit binding description;};

  convert = inputMap: let
    accumulateDescriptions = acc: theMap: let
      description = theMap.description;
    in
      acc // description;
  in {
    bindings = map (m: m.binding) inputMap;
    descriptions = builtins.foldl' accumulateDescriptions {} inputMap;
  };
}
