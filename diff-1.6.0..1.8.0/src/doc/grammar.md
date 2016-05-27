--- a/src/doc/grammar.md
+++ b/src/doc/grammar.md
@@ -516,7 +516,7 @@ struct_expr : expr_path '{' ident ':' expr
 ### Block expressions
 
 ```antlr
-block_expr : '{' [ stmt ';' | item ] *
+block_expr : '{' [ stmt | item ] *
                  [ expr ] '}' ;
 ```
 
diff --git a/src/doc/index.md b/src/doc/index.md
