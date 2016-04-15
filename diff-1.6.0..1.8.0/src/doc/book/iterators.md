--- a/src/doc/book/iterators.md
+++ b/src/doc/book/iterators.md
@@ -37,7 +37,7 @@ which gives us a reference to the next value of the iterator. `next` returns an
 `None`, we `break` out of the loop.
 
 This code sample is basically the same as our `for` loop version. The `for`
-loop is just a handy way to write this `loop`/`match`/`break` construct.
+loop is a handy way to write this `loop`/`match`/`break` construct.
 
 `for` loops aren't the only thing that uses iterators, however. Writing your
 own iterator involves implementing the `Iterator` trait. While doing that is
@@ -94,8 +94,8 @@ Now we're explicitly dereferencing `num`. Why does `&nums` give us
 references?  Firstly, because we explicitly asked it to with
 `&`. Secondly, if it gave us the data itself, we would have to be its
 owner, which would involve making a copy of the data and giving us the
-copy. With references, we're just borrowing a reference to the data,
-and so it's just passing a reference, without needing to do the move.
+copy. With references, we're only borrowing a reference to the data,
+and so it's only passing a reference, without needing to do the move.
 
 So, now that we've established that ranges are often not what you want, let's
 talk about what you do want instead.
@@ -278,7 +278,7 @@ doesn't print any numbers:
 ```
 
 If you are trying to execute a closure on an iterator for its side effects,
-just use `for` instead.
+use `for` instead.
 
 There are tons of interesting iterator adaptors. `take(n)` will return an
 iterator over the next `n` elements of the original iterator. Let's try it out
@@ -311,10 +311,12 @@ for i in (1..100).filter(|&x| x % 2 == 0) {
 ```
 
 This will print all of the even numbers between one and a hundred.
-(Note that because `filter` doesn't consume the elements that are
-being iterated over, it is passed a reference to each element, and
-thus the filter predicate uses the `&x` pattern to extract the integer
-itself.)
+(Note that, unlike `map`, the closure passed to `filter` is passed a reference
+to the element instead of the element itself. The filter predicate here uses
+the `&x` pattern to extract the integer. The filter closure is passed a
+reference because it returns `true` or `false` instead of the element,
+so the `filter` implementation must retain ownership to put the elements
+into the newly constructed iterator.)
 
 You can chain all three things together: start with an iterator, adapt it
 a few times, and then consume the result. Check it out:
diff --git a/src/doc/book/lang-items.md b/src/doc/book/lang-items.md
