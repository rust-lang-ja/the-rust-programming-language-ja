--- a/src/doc/book/concurrency.md
+++ b/src/doc/book/concurrency.md
@@ -259,7 +259,7 @@ thread::spawn(move || {
 ```
 
 First, we call `lock()`, which acquires the mutex's lock. Because this may fail,
-it returns an `Result<T, E>`, and because this is just an example, we `unwrap()`
+it returns a `Result<T, E>`, and because this is just an example, we `unwrap()`
 it to get a reference to the data. Real code would have more robust error handling
 here. We're then free to mutate it, since we have the lock.
 
@@ -286,6 +286,8 @@ use std::sync::mpsc;
 fn main() {
     let data = Arc::new(Mutex::new(0));
 
+    // `tx` is the "transmitter" or "sender"
+    // `rx` is the "receiver"
     let (tx, rx) = mpsc::channel();
 
     for _ in 0..10 {
@@ -305,10 +307,10 @@ fn main() {
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
