```
> Set = require 'set'
> List = require 'list'
> Enum = require 'enum'
> print(Enum.count(Set.new()))
0
> print(Enum.count(List.new()))
0
> s = Set.new()
> s:insert("a element")
> s:insert("another")
> print(Enum.count(s))
2
> s:remove("another")
> print(Enum.count(s))
1
```
