//= require wmd/wmd
//= require wmd/showdown

$(function(){
  new WMDEditor({
    input: "editor-input",
    button_bar: "editor-button-bar",
    preview: "editor-preview",
    helpLink: "http://daringfireball.net/projects/markdown/syntax"
  });
})
