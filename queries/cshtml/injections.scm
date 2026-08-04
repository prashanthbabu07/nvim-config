;; extends

;; Inject comments for spellchecking / comment highlight rules
([
  (html_comment)
  (razor_comment)
] @injection.content
  (#set! injection.language "comment"))

;; Inject C# inside Razor explicit code blocks: @{ ... }
((razor_block) @injection.content
  (#set! injection.language "c_sharp"))

;; Inject C# inside Razor inline expressions: @Model.Property, @(1 + 1)
((at_implicit) @injection.content
  (#set! injection.language "c_sharp"))

((at_explicit) @injection.content
  (#set! injection.language "c_sharp"))

;; Inject C# expressions inside control flow conditions: @if (condition)
((at_if) @injection.content
  (#set! injection.language "c_sharp"))

((at_foreach) @injection.content
  (#set! injection.language "c_sharp"))

((at_for) @injection.content
  (#set! injection.language "c_sharp"))

((at_while) @injection.content
  (#set! injection.language "c_sharp"))
