--- a/src/doc/nomicon/lifetimes.md
+++ b/src/doc/nomicon/lifetimes.md
@@ -107,8 +107,8 @@ This signature of `as_str` takes a reference to a u32 with *some* lifetime, and
 promises that it can produce a reference to a str that can live *just as long*.
 Already we can see why this signature might be trouble. That basically implies
 that we're going to find a str somewhere in the scope the reference
-to the u32 originated in, or somewhere *even earlier*. That's a bit of a big
-ask.
+to the u32 originated in, or somewhere *even earlier*. That's a bit of a tall
+order.
 
 We then proceed to compute the string `s`, and return a reference to it. Since
 the contract of our function says the reference must outlive `'a`, that's the
diff --git a/src/doc/nomicon/subtyping.md b/src/doc/nomicon/subtyping.md
