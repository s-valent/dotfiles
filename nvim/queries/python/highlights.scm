;; inherits: python

((identifier) @variable (#match? @variable "^[A-Z]"))
(class_definition name: (identifier) @type)

((identifier) @constant (#match? @constant "^[A-Z_][A-Z0-9_]+$"))


;; copied from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/python/highlights.scm
(call
  function: (identifier) @function.call)

(call
  function: (attribute
    attribute: (identifier) @function.method.call))

((call
  function: (identifier) @constructor)
  (#lua-match? @constructor "^%u"))

((call
  function: (attribute
    attribute: (identifier) @constructor))
  (#lua-match? @constructor "^%u"))
