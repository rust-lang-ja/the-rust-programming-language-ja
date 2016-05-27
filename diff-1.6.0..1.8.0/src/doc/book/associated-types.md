--- a/src/doc/book/associated-types.md
+++ b/src/doc/book/associated-types.md
@@ -24,7 +24,7 @@ fn distance<N, E, G: Graph<N, E>>(graph: &G, start: &N, end: &N) -> u32 { ... }
 ```
 
 Our distance calculation works regardless of our `Edge` type, so the `E` stuff in
-this signature is just a distraction.
+this signature is a distraction.
 
 What we really want to say is that a certain `E`dge and `N`ode type come together
 to form each kind of `Graph`. We can do that with associated types:
@@ -118,10 +118,10 @@ impl Graph for MyGraph {
 This silly implementation always returns `true` and an empty `Vec<Edge>`, but it
 gives you an idea of how to implement this kind of thing. We first need three
 `struct`s, one for the graph, one for the node, and one for the edge. If it made
-more sense to use a different type, that would work as well, we’re just going to
+more sense to use a different type, that would work as well, we’re going to
 use `struct`s for all three here.
 
-Next is the `impl` line, which is just like implementing any other trait.
+Next is the `impl` line, which is an implementation like any other trait.
 
 From here, we use `=` to define our associated types. The name the trait uses
 goes on the left of the `=`, and the concrete type we’re `impl`ementing this
diff --git a/src/doc/book/bibliography.md b/src/doc/book/bibliography.md
