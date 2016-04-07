--- a/src/doc/book/the-stack-and-the-heap.md
+++ b/src/doc/book/the-stack-and-the-heap.md
@@ -44,7 +44,7 @@ values ‘go on the stack’. What does that mean?
 Well, when a function gets called, some memory gets allocated for all of its
 local variables and some other information. This is called a ‘stack frame’, and
 for the purpose of this tutorial, we’re going to ignore the extra information
-and just consider the local variables we’re allocating. So in this case, when
+and only consider the local variables we’re allocating. So in this case, when
 `main()` is run, we’ll allocate a single 32-bit integer for our stack frame.
 This is automatically handled for you, as you can see; we didn’t have to write
 any special Rust code or anything.
@@ -130,63 +130,64 @@ on the stack is the first one you retrieve from it.
 Let’s try a three-deep example:
 
 ```rust
-fn bar() {
+fn italic() {
     let i = 6;
 }
 
-fn foo() {
+fn bold() {
     let a = 5;
     let b = 100;
     let c = 1;
 
-    bar();
+    italic();
 }
 
 fn main() {
     let x = 42;
 
-    foo();
+    bold();
 }
 ```
 
+We have some kooky function names to make the diagrams clearer.
+
 Okay, first, we call `main()`:
 
 | Address | Name | Value |
 |---------|------|-------|
 | 0       | x    | 42    |
 
-Next up, `main()` calls `foo()`:
+Next up, `main()` calls `bold()`:
 
 | Address | Name | Value |
 |---------|------|-------|
-| 3       | c    | 1     |
-| 2       | b    | 100   |
-| 1       | a    | 5     |
+| **3**   | **c**|**1**  |
+| **2**   | **b**|**100**|
+| **1**   | **a**| **5** |
 | 0       | x    | 42    |
 
-And then `foo()` calls `bar()`:
+And then `bold()` calls `italic()`:
 
 | Address | Name | Value |
 |---------|------|-------|
-| 4       | i    | 6     |
-| 3       | c    | 1     |
-| 2       | b    | 100   |
-| 1       | a    | 5     |
+| *4*     | *i*  | *6*   |
+| **3**   | **c**|**1**  |
+| **2**   | **b**|**100**|
+| **1**   | **a**| **5** |
 | 0       | x    | 42    |
-
 Whew! Our stack is growing tall.
 
-After `bar()` is over, its frame is deallocated, leaving just `foo()` and
+After `italic()` is over, its frame is deallocated, leaving only `bold()` and
 `main()`:
 
 | Address | Name | Value |
 |---------|------|-------|
-| 3       | c    | 1     |
-| 2       | b    | 100   |
-| 1       | a    | 5     |
+| **3**   | **c**|**1**  |
+| **2**   | **b**|**100**|
+| **1**   | **a**| **5** |
 | 0       | x    | 42    |
 
-And then `foo()` ends, leaving just `main()`:
+And then `bold()` ends, leaving only `main()`:
 
 | Address | Name | Value |
 |---------|------|-------|
@@ -246,7 +247,7 @@ location we’ve asked for.
 We haven’t really talked too much about what it actually means to allocate and
 deallocate memory in these contexts. Getting into very deep detail is out of
 the scope of this tutorial, but what’s important to point out here is that
-the heap isn’t just a stack that grows from the opposite end. We’ll have an
+the heap isn’t a stack that grows from the opposite end. We’ll have an
 example of this later in the book, but because the heap can be allocated and
 freed in any order, it can end up with ‘holes’. Here’s a diagram of the memory
 layout of a program which has been running for a while now:
@@ -331,13 +332,13 @@ What about when we call `foo()`, passing `y` as an argument?
 | 1       | y    | → 0    |
 | 0       | x    | 5      |
 
-Stack frames aren’t just for local bindings, they’re for arguments too. So in
+Stack frames aren’t only for local bindings, they’re for arguments too. So in
 this case, we need to have both `i`, our argument, and `z`, our local variable
 binding. `i` is a copy of the argument, `y`. Since `y`’s value is `0`, so is
 `i`’s.
 
 This is one reason why borrowing a variable doesn’t deallocate any memory: the
-value of a reference is just a pointer to a memory location. If we got rid of
+value of a reference is a pointer to a memory location. If we got rid of
 the underlying memory, things wouldn’t work very well.
 
 # A complex example
@@ -453,7 +454,7 @@ Next, `foo()` calls `bar()` with `x` and `z`:
 | 0                    | h    | 3                      |
 
 We end up allocating another value on the heap, and so we have to subtract one
-from (2<sup>30</sup>) - 1. It’s easier to just write that than `1,073,741,822`. In any
+from (2<sup>30</sup>) - 1. It’s easier to write that than `1,073,741,822`. In any
 case, we set up the variables as usual.
 
 At the end of `bar()`, it calls `baz()`:
@@ -538,7 +539,7 @@ instead.
 # Which to use?
 
 So if the stack is faster and easier to manage, why do we need the heap? A big
-reason is that Stack-allocation alone means you only have LIFO semantics for
+reason is that Stack-allocation alone means you only have 'Last In First Out (LIFO)' semantics for
 reclaiming storage. Heap-allocation is strictly more general, allowing storage
 to be taken from and returned to the pool in arbitrary order, but at a
 complexity cost.
@@ -549,12 +550,12 @@ has two big impacts: runtime efficiency and semantic impact.
 
 ## Runtime Efficiency
 
-Managing the memory for the stack is trivial: The machine just
+Managing the memory for the stack is trivial: The machine
 increments or decrements a single value, the so-called “stack pointer”.
 Managing memory for the heap is non-trivial: heap-allocated memory is freed at
 arbitrary points, and each block of heap-allocated memory can be of arbitrary
-size, the memory manager must generally work much harder to identify memory for
-reuse.
+size, so the memory manager must generally work much harder to
+identify memory for reuse.
 
 If you’d like to dive into this topic in greater detail, [this paper][wilson]
 is a great introduction.
diff --git a/src/doc/book/trait-objects.md b/src/doc/book/trait-objects.md
