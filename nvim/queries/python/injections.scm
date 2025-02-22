(string 
  (string_content) @injection.content
    (#vim-match? @injection.content "^(\n| )*(SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER|WITH|select|from|inner join|where|create|drop|insert|update|alter|with) .*$")
    (#set! injection.language "sql"))

(call
  function: (attribute attribute: (identifier) @id (#match? @id "execute|read_sql"))
  arguments: (argument_list
    (string (string_content) @injection.content (#set! injection.language "sql"))))
