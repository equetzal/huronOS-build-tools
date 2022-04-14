var search_data = {"index":{"searchIndex":["pstore","error","[]()","[]=()","abort()","commit()","delete()","fetch()","new()","path()","root?()","roots()","transaction()"],"longSearchIndex":["pstore","pstore::error","pstore#[]()","pstore#[]=()","pstore#abort()","pstore#commit()","pstore#delete()","pstore#fetch()","pstore::new()","pstore#path()","pstore#root?()","pstore#roots()","pstore#transaction()"],"info":[["PStore","","PStore.html","","<p>PStore implements a file based persistence mechanism based on a Hash.  User code can store hierarchies …\n"],["PStore::Error","","PStore/Error.html","","<p>The error type thrown by all PStore methods.\n"],["[]","PStore","PStore.html#method-i-5B-5D","(name)","<p>Retrieves a value from the PStore file data, by <em>name</em>.  The hierarchy of Ruby objects stored under that …\n"],["[]=","PStore","PStore.html#method-i-5B-5D-3D","(name, value)","<p>Stores an individual Ruby object or a hierarchy of Ruby objects in the data store file under the root …\n"],["abort","PStore","PStore.html#method-i-abort","()","<p>Ends the current PStore#transaction, discarding any changes to the data store.\n<p>Example:\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&quot;pstore&quot;</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["commit","PStore","PStore.html#method-i-commit","()","<p>Ends the current PStore#transaction, committing any changes to the data store immediately.\n<p>Example:\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["delete","PStore","PStore.html#method-i-delete","(name)","<p>Removes an object hierarchy from the data store, by <em>name</em>.\n<p><strong>WARNING</strong>:  This method is only valid in a PStore#transaction …\n"],["fetch","PStore","PStore.html#method-i-fetch","(name, default=PStore::Error)","<p>This method is just like PStore#[], save that you may also provide a <em>default</em> value for the object.   …\n"],["new","PStore","PStore.html#method-c-new","(file, thread_safe = false)","<p>To construct a PStore object, pass in the <em>file</em> path where you would like the data to be stored.\n<p>PStore …\n"],["path","PStore","PStore.html#method-i-path","()","<p>Returns the path to the data store file.\n"],["root?","PStore","PStore.html#method-i-root-3F","(name)","<p>Returns true if the supplied <em>name</em> is currently in the data store.\n<p><strong>WARNING</strong>:  This method is only valid …\n"],["roots","PStore","PStore.html#method-i-roots","()","<p>Returns the names of all object hierarchies currently in the store.\n<p><strong>WARNING</strong>:  This method is only valid …\n"],["transaction","PStore","PStore.html#method-i-transaction","(read_only = false)","<p>Opens a new transaction for the data store.  Code executed inside a block passed to this method may read …\n"]]}}