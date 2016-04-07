--- a/src/doc/book/concurrency.md
+++ b/src/doc/book/concurrency.md
@@ -305,10 +305,10 @@ fn main() {
 }
 ```
 
-We use the `mpsc::channel()` method to construct a new channel. We just `send`
+We use the `mpsc::channel()` method to construct a new channel. We `send`
 a simple `()` down the channel, and then wait for ten of them to come back.
 
-While this channel is just sending a generic signal, we can send any data that
+While this channel is sending a generic signal, we can send any data that
 is `Send` over the channel!
 
 ```rust
diff --git a/src/doc/book/crates-and-modules.md b/src/doc/book/crates-and-modules.md
