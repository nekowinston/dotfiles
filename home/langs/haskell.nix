{
  home.file = {
    ".ghci".text = ''
      :seti -XLambdaCase
      :seti -XOverloadedStrings
      :seti -XQuasiQuotes
    '';

    ".haskeline".text = ''
      bellStyle: NoBell
      completionType: MenuCompletion
      editMode: Vi
      historyDuplicates: IgnoreConsecutive
      maxHistorySize: Just 10000
    '';
  };
}
