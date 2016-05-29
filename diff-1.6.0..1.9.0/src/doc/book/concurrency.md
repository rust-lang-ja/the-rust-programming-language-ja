--- a/src/doc/book/concurrency.md
+++ b/src/doc/book/concurrency.md
@@ -94,6 +94,52 @@ fn main() {
 }
 ```
 
+As closures can capture variables from their environment, we can also try to
+bring some data into the other thread:
+
+```rust,ignore
+use std::thread;
+
+fn main() {
+    let x = 1;
+    thread::spawn(|| {
+        println!("x is {}", x);
+    });
+}
+```
+
+However, this gives us an error:
+
+```text
+5:19: 7:6 error: closure may outlive the current function, but it
+                 borrows `x`, which is owned by the current function
+...
+5:19: 7:6 help: to force the closure to take ownership of `x` (and any other referenced variables),
+          use the `move` keyword, as shown:
+      thread::spawn(move || {
+          println!("x is {}", x);
+      });
+```
+
+This is because by default closures capture variables by reference, and thus the
+closure only captures a _reference to `x`_. This is a problem, because the
+thread may outlive the scope of `x`, leading to a dangling pointer.
+
+To fix this, we use a `move` closure as mentioned in the error message. `move`
+closures are explained in depth [here](closures.html#move-closures); basically
+they move variables from their environment into themselves.
+
+```rust
+use std::thread;
+
+fn main() {
+    let x = 1;
+    thread::spawn(move || {
+        println!("x is {}", x);
+    });
+}
+```
+
 Many languages have the ability to execute threads, but it's wildly unsafe.
 There are entire books about how to prevent errors that occur from shared
 mutable state. Rust helps out with its type system here as well, by preventing
@@ -116,7 +162,7 @@ The same [ownership system](ownership.html) that helps prevent using pointers
 incorrectly also helps rule out data races, one of the worst kinds of
 concurrency bugs.
 
-As an example, here is a Rust program that would have a data race in many
+As an example, here is a Rust program that could have a data race in many
 languages. It will not compile:
 
 ```ignore
@@ -145,23 +191,69 @@ This gives us an error:
 ```
 
 Rust knows this wouldn't be safe! If we had a reference to `data` in each
-thread, and the thread takes ownership of the reference, we'd have three
-owners!
+thread, and the thread takes ownership of the reference, we'd have three owners!
+`data` gets moved out of `main` in the first call to `spawn()`, so subsequent
+calls in the loop cannot use this variable.
 
-So, we need some type that lets us have more than one reference to a value and
-that we can share between threads, that is it must implement `Sync`.
+Note that this specific example will not cause a data race since different array
+indices are being accessed. But this can't be determined at compile time, and in
+a similar situation where `i` is a constant or is random, you would have a data
+race.
 
-We'll use `Arc<T>`, Rust's standard atomic reference count type, which
-wraps a value up with some extra runtime bookkeeping which allows us to
-share the ownership of the value between multiple references at the same time.
+So, we need some type that lets us have more than one owning reference to a
+value. Usually, we'd use `Rc<T>` for this, which is a reference counted type
+that provides shared ownership. It has some runtime bookkeeping that keeps track
+of the number of references to it, hence the "reference count" part of its name.
 
-The bookkeeping consists of a count of how many of these references exist to
-the value, hence the reference count part of the name.
+Calling `clone()` on an `Rc<T>` will return a new owned reference and bump the
+internal reference count. We create one of these for each thread:
+
+
+```ignore
+use std::thread;
+use std::time::Duration;
+use std::rc::Rc;
+
+fn main() {
+    let mut data = Rc::new(vec![1, 2, 3]);
+
+    for i in 0..3 {
+        // create a new owned reference
+        let data_ref = data.clone();
+
+        // use it in a thread
+        thread::spawn(move || {
+            data_ref[i] += 1;
+        });
+    }
+
+    thread::sleep(Duration::from_millis(50));
+}
+```
+
+This won't work, however, and will give us the error:
+
+```text
+13:9: 13:22 error: the trait bound `alloc::rc::Rc<collections::vec::Vec<i32>> : core::marker::Send`
+            is not satisfied
+...
+13:9: 13:22 note: `alloc::rc::Rc<collections::vec::Vec<i32>>`
+            cannot be sent between threads safely
+```
+
+As the error message mentions, `Rc` cannot be sent between threads safely. This
+is because the internal reference count is not maintained in a thread safe
+matter and can have a data race.
+
+To solve this, we'll use `Arc<T>`, Rust's standard atomic reference count type.
 
 The Atomic part means `Arc<T>` can safely be accessed from multiple threads.
 To do this the compiler guarantees that mutations of the internal count use
 indivisible operations which can't have data races.
 
+In essence, `Arc<T>` is a type that lets us share ownership of data _across
+threads_.
+
 
 ```ignore
 use std::thread;
@@ -182,7 +274,7 @@ fn main() {
 }
 ```
 
-We now call `clone()` on our `Arc<T>`, which increases the internal count.
+Similarly to last time, we use `clone()` to create a new owned handle.
 This handle is then moved into the new thread.
 
 And... still gives us an error.
@@ -193,14 +285,21 @@ And... still gives us an error.
                              ^~~~
 ```
 
-`Arc<T>` assumes one more property about its contents to ensure that it is safe
-to share across threads: it assumes its contents are `Sync`. This is true for
-our value if it's immutable, but we want to be able to mutate it, so we need
-something else to persuade the borrow checker we know what we're doing.
+`Arc<T>` by default has immutable contents. It allows the _sharing_ of data
+between threads, but shared mutable data is unsafe and when threads are
+involved can cause data races!
+
 
-It looks like we need some type that allows us to safely mutate a shared value,
-for example a type that can ensure only one thread at a time is able to
-mutate the value inside it at any one time.
+Usually when we wish to make something in an immutable position mutable, we use
+`Cell<T>` or `RefCell<T>` which allow safe mutation via runtime checks or
+otherwise (see also: [Choosing Your Guarantees](choosing-your-guarantees.html)).
+However, similar to `Rc`, these are not thread safe. If we try using these, we
+will get an error about these types not being `Sync`, and the code will fail to
+compile.
+
+It looks like we need some type that allows us to safely mutate a shared value
+across threads, for example a type that can ensure only one thread at a time is
+able to mutate the value inside it at any one time.
 
 For that, we can use the `Mutex<T>` type!
 
@@ -229,7 +328,17 @@ fn main() {
 Note that the value of `i` is bound (copied) to the closure and not shared
 among the threads.
 
-Also note that [`lock`](../std/sync/struct.Mutex.html#method.lock) method of
+We're "locking" the mutex here. A mutex (short for "mutual exclusion"), as
+mentioned, only allows one thread at a time to access a value. When we wish to
+access the value, we use `lock()` on it. This will "lock" the mutex, and no
+other thread will be able to lock it (and hence, do anything with the value)
+until we're done with it. If a thread attempts to lock a mutex which is already
+locked, it will wait until the other thread releases the lock.
+
+The lock "release" here is implicit; when the result of the lock (in this case,
+`data`) goes out of scope, the lock is automatically released.
+
+Note that [`lock`](../std/sync/struct.Mutex.html#method.lock) method of
 [`Mutex`](../std/sync/struct.Mutex.html) has this signature:
 
 ```ignore
@@ -259,7 +368,7 @@ thread::spawn(move || {
 ```
 
 First, we call `lock()`, which acquires the mutex's lock. Because this may fail,
-it returns an `Result<T, E>`, and because this is just an example, we `unwrap()`
+it returns a `Result<T, E>`, and because this is just an example, we `unwrap()`
 it to get a reference to the data. Real code would have more robust error handling
 here. We're then free to mutate it, since we have the lock.
 
@@ -286,6 +395,8 @@ use std::sync::mpsc;
 fn main() {
     let data = Arc::new(Mutex::new(0));
 
+    // `tx` is the "transmitter" or "sender"
+    // `rx` is the "receiver"
     let (tx, rx) = mpsc::channel();
 
     for _ in 0..10 {
@@ -305,10 +416,10 @@ fn main() {
 }
 ```
 
-We use the `mpsc::channel()` method to construct a new channel. We just `send`
+We use the `mpsc::channel()` method to construct a new channel. We `send`
 a simple `()` down the channel, and then wait for ten of them to come back.
 
-While this channel is just sending a generic signal, we can send any data that
+While this channel is sending a generic signal, we can send any data that
 is `Send` over the channel!
 
 ```rust
diff --git a/src/doc/book/const-and-static.md b/src/doc/book/const-and-static.md
