var search_data = {"index":{"searchIndex":["rinda","drbobjecttemplate","invalidhashtuplekey","notifytemplateentry","requestcancelederror","requestexpirederror","rindaerror","ringfinger","ringprovider","ringserver","simplerenewer","template","templateentry","tuple","tuplebag","tuplebin","tupleentry","tuplespace","tuplespaceproxy","waittemplateentry","===()","===()","===()","[]()","[]()","add()","alive?()","cancel()","cancel()","canceled?()","delete()","delete()","delete_unless_alive()","do_reply()","do_write()","each()","each()","each()","expired?()","fetch()","fetch()","find()","find()","find_all()","find_all_template()","finger()","has_expires?()","lookup_ring()","lookup_ring_any()","make_expires()","make_socket()","make_tuple()","match()","match()","move()","new()","new()","new()","new()","new()","new()","new()","new()","new()","new()","new()","new()","notify()","notify()","notify()","pop()","primary()","provide()","push()","read()","read()","read()","read_all()","read_all()","renew()","renew()","reply_service()","shutdown()","signal()","size()","size()","take()","take()","to_a()","to_a()","value()","value()","wait()","write()","write()","write_services()"],"longSearchIndex":["rinda","rinda::drbobjecttemplate","rinda::invalidhashtuplekey","rinda::notifytemplateentry","rinda::requestcancelederror","rinda::requestexpirederror","rinda::rindaerror","rinda::ringfinger","rinda::ringprovider","rinda::ringserver","rinda::simplerenewer","rinda::template","rinda::templateentry","rinda::tuple","rinda::tuplebag","rinda::tuplebag::tuplebin","rinda::tupleentry","rinda::tuplespace","rinda::tuplespaceproxy","rinda::waittemplateentry","rinda::drbobjecttemplate#===()","rinda::template#===()","rinda::templateentry#===()","rinda::tuple#[]()","rinda::tupleentry#[]()","rinda::tuplebag::tuplebin#add()","rinda::tupleentry#alive?()","rinda::tupleentry#cancel()","rinda::waittemplateentry#cancel()","rinda::tupleentry#canceled?()","rinda::tuplebag#delete()","rinda::tuplebag::tuplebin#delete()","rinda::tuplebag#delete_unless_alive()","rinda::ringserver#do_reply()","rinda::ringserver#do_write()","rinda::notifytemplateentry#each()","rinda::ringfinger#each()","rinda::tuple#each()","rinda::tupleentry#expired?()","rinda::tuple#fetch()","rinda::tupleentry#fetch()","rinda::tuplebag#find()","rinda::tuplebag::tuplebin#find()","rinda::tuplebag#find_all()","rinda::tuplebag#find_all_template()","rinda::ringfinger::finger()","rinda::tuplebag#has_expires?()","rinda::ringfinger#lookup_ring()","rinda::ringfinger#lookup_ring_any()","rinda::tupleentry#make_expires()","rinda::ringserver#make_socket()","rinda::tupleentry#make_tuple()","rinda::template#match()","rinda::templateentry#match()","rinda::tuplespace#move()","rinda::drbobjecttemplate::new()","rinda::notifytemplateentry::new()","rinda::ringfinger::new()","rinda::ringprovider::new()","rinda::ringserver::new()","rinda::simplerenewer::new()","rinda::tuple::new()","rinda::tuplebag::tuplebin::new()","rinda::tupleentry::new()","rinda::tuplespace::new()","rinda::tuplespaceproxy::new()","rinda::waittemplateentry::new()","rinda::notifytemplateentry#notify()","rinda::tuplespace#notify()","rinda::tuplespaceproxy#notify()","rinda::notifytemplateentry#pop()","rinda::ringfinger::primary()","rinda::ringprovider#provide()","rinda::tuplebag#push()","rinda::tuplespace#read()","rinda::tuplespaceproxy#read()","rinda::waittemplateentry#read()","rinda::tuplespace#read_all()","rinda::tuplespaceproxy#read_all()","rinda::simplerenewer#renew()","rinda::tupleentry#renew()","rinda::ringserver#reply_service()","rinda::ringserver#shutdown()","rinda::waittemplateentry#signal()","rinda::tuple#size()","rinda::tupleentry#size()","rinda::tuplespace#take()","rinda::tuplespaceproxy#take()","rinda::ringfinger::to_a()","rinda::ringfinger#to_a()","rinda::tuple#value()","rinda::tupleentry#value()","rinda::waittemplateentry#wait()","rinda::tuplespace#write()","rinda::tuplespaceproxy#write()","rinda::ringserver#write_services()"],"info":[["Rinda","","Rinda.html","","<p>A module to implement the Linda distributed computing paradigm in Ruby.\n<p>Rinda is part of DRb (dRuby). …\n"],["Rinda::DRbObjectTemplate","","Rinda/DRbObjectTemplate.html","","<p><em>Documentation?</em>\n"],["Rinda::InvalidHashTupleKey","","Rinda/InvalidHashTupleKey.html","","<p>Raised when a hash-based tuple has an invalid key.\n"],["Rinda::NotifyTemplateEntry","","Rinda/NotifyTemplateEntry.html","","<p>A NotifyTemplateEntry is returned by TupleSpace#notify and is notified of TupleSpace changes.  You may …\n"],["Rinda::RequestCanceledError","","Rinda/RequestCanceledError.html","","<p>Raised when trying to use a canceled tuple.\n"],["Rinda::RequestExpiredError","","Rinda/RequestExpiredError.html","","<p>Raised when trying to use an expired tuple.\n"],["Rinda::RindaError","","Rinda/RindaError.html","","<p>Rinda error base class\n"],["Rinda::RingFinger","","Rinda/RingFinger.html","","<p>RingFinger is used by RingServer clients to discover the RingServer&#39;s TupleSpace.  Typically, all …\n"],["Rinda::RingProvider","","Rinda/RingProvider.html","","<p>RingProvider uses a RingServer advertised TupleSpace as a name service. TupleSpace clients can register …\n"],["Rinda::RingServer","","Rinda/RingServer.html","","<p>A RingServer allows a Rinda::TupleSpace to be located via UDP broadcasts. Default service location uses …\n"],["Rinda::SimpleRenewer","","Rinda/SimpleRenewer.html","","<p>An SimpleRenewer allows a TupleSpace to check if a TupleEntry is still alive.\n"],["Rinda::Template","","Rinda/Template.html","","<p>Templates are used to match tuples in Rinda.\n"],["Rinda::TemplateEntry","","Rinda/TemplateEntry.html","","<p>A TemplateEntry is a Template together with expiry and cancellation data.\n"],["Rinda::Tuple","","Rinda/Tuple.html","","<p>A tuple is the elementary object in Rinda programming. Tuples may be matched against templates if the …\n"],["Rinda::TupleBag","","Rinda/TupleBag.html","","<p>TupleBag is an unordered collection of tuples. It is the basis of Tuplespace.\n"],["Rinda::TupleBag::TupleBin","","Rinda/TupleBag/TupleBin.html","",""],["Rinda::TupleEntry","","Rinda/TupleEntry.html","","<p>A TupleEntry is a Tuple (i.e. a possible entry in some Tuplespace) together with expiry and cancellation …\n"],["Rinda::TupleSpace","","Rinda/TupleSpace.html","","<p>The Tuplespace manages access to the tuples it contains, ensuring mutual exclusion requirements are met. …\n"],["Rinda::TupleSpaceProxy","","Rinda/TupleSpaceProxy.html","","<p>TupleSpaceProxy allows a remote Tuplespace to appear as local.\n"],["Rinda::WaitTemplateEntry","","Rinda/WaitTemplateEntry.html","","<p><em>Documentation?</em>\n"],["===","Rinda::DRbObjectTemplate","Rinda/DRbObjectTemplate.html#method-i-3D-3D-3D","(ro)","<p>This DRbObjectTemplate matches <code>ro</code> if the remote object&#39;s drburi and drbref are the same.  <code>nil</code> is …\n"],["===","Rinda::Template","Rinda/Template.html#method-i-3D-3D-3D","(tuple)","<p>Alias for #match.\n"],["===","Rinda::TemplateEntry","Rinda/TemplateEntry.html#method-i-3D-3D-3D","(tuple)",""],["[]","Rinda::Tuple","Rinda/Tuple.html#method-i-5B-5D","(k)","<p>Accessor method for elements of the tuple.\n"],["[]","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-5B-5D","(key)","<p>Retrieves <code>key</code> from the tuple.\n"],["add","Rinda::TupleBag::TupleBin","Rinda/TupleBag/TupleBin.html#method-i-add","(tuple)",""],["alive?","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-alive-3F","()","<p>A TupleEntry is dead when it is canceled or expired.\n"],["cancel","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-cancel","()","<p>Marks this TupleEntry as canceled.\n"],["cancel","Rinda::WaitTemplateEntry","Rinda/WaitTemplateEntry.html#method-i-cancel","()",""],["canceled?","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-canceled-3F","()","<p>Returns the canceled status.\n"],["delete","Rinda::TupleBag","Rinda/TupleBag.html#method-i-delete","(tuple)","<p>Removes <code>tuple</code> from the TupleBag.\n"],["delete","Rinda::TupleBag::TupleBin","Rinda/TupleBag/TupleBin.html#method-i-delete","(tuple)",""],["delete_unless_alive","Rinda::TupleBag","Rinda/TupleBag.html#method-i-delete_unless_alive","()","<p>Delete tuples which dead tuples from the TupleBag, returning the deleted tuples.\n"],["do_reply","Rinda::RingServer","Rinda/RingServer.html#method-i-do_reply","()","<p>Pulls lookup tuples out of the TupleSpace and sends their DRb object the address of the local TupleSpace …\n"],["do_write","Rinda::RingServer","Rinda/RingServer.html#method-i-do_write","(msg)","<p>Extracts the response URI from <code>msg</code> and adds it to TupleSpace where it will be picked up by <code>reply_service</code> …\n"],["each","Rinda::NotifyTemplateEntry","Rinda/NotifyTemplateEntry.html#method-i-each","()","<p>Yields event/tuple pairs until this NotifyTemplateEntry expires.\n"],["each","Rinda::RingFinger","Rinda/RingFinger.html#method-i-each","()","<p>Iterates over all discovered TupleSpaces starting with the primary.\n"],["each","Rinda::Tuple","Rinda/Tuple.html#method-i-each","()","<p>Iterate through the tuple, yielding the index or key, and the value, thus ensuring arrays are iterated …\n"],["expired?","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-expired-3F","()","<p>Has this tuple expired? (true/false).\n<p>A tuple has expired when its expiry timer based on the <code>sec</code> argument …\n"],["fetch","Rinda::Tuple","Rinda/Tuple.html#method-i-fetch","(k)","<p>Fetches item <code>k</code> from the tuple.\n"],["fetch","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-fetch","(key)","<p>Fetches <code>key</code> from the tuple.\n"],["find","Rinda::TupleBag","Rinda/TupleBag.html#method-i-find","(template)","<p>Finds a live tuple that matches <code>template</code>.\n"],["find","Rinda::TupleBag::TupleBin","Rinda/TupleBag/TupleBin.html#method-i-find","()",""],["find_all","Rinda::TupleBag","Rinda/TupleBag.html#method-i-find_all","(template)","<p>Finds all live tuples that match <code>template</code>.\n"],["find_all_template","Rinda::TupleBag","Rinda/TupleBag.html#method-i-find_all_template","(tuple)","<p>Finds all tuples in the TupleBag which when treated as templates, match <code>tuple</code> and are alive.\n"],["finger","Rinda::RingFinger","Rinda/RingFinger.html#method-c-finger","()","<p>Creates a singleton RingFinger and looks for a RingServer.  Returns the created RingFinger.\n"],["has_expires?","Rinda::TupleBag","Rinda/TupleBag.html#method-i-has_expires-3F","()","<p><code>true</code> if the TupleBag to see if it has any expired entries.\n"],["lookup_ring","Rinda::RingFinger","Rinda/RingFinger.html#method-i-lookup_ring","(timeout=5, &block)","<p>Looks up RingServers waiting <code>timeout</code> seconds.  RingServers will be given <code>block</code> as a callback, which will …\n"],["lookup_ring_any","Rinda::RingFinger","Rinda/RingFinger.html#method-i-lookup_ring_any","(timeout=5)","<p>Returns the first found remote TupleSpace.  Any further recovered TupleSpaces can be found by calling …\n"],["make_expires","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-make_expires","(sec=nil)","<p>Returns an expiry Time based on <code>sec</code> which can be one of:\n<p>Numeric &mdash; <code>sec</code> seconds into the future\n<p><code>true</code> &mdash; the expiry …\n"],["make_socket","Rinda::RingServer","Rinda/RingServer.html#method-i-make_socket","(address, interface_address=nil, multicast_interface=0)","<p>Creates a socket at <code>address</code>\n<p>If <code>address</code> is multicast address then <code>interface_address</code> and <code>multicast_interface</code> …\n"],["make_tuple","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-make_tuple","(ary)","<p>Creates a Rinda::Tuple for <code>ary</code>.\n"],["match","Rinda::Template","Rinda/Template.html#method-i-match","(tuple)","<p>Matches this template against <code>tuple</code>.  The <code>tuple</code> must be the same size as the template.  An element with …\n"],["match","Rinda::TemplateEntry","Rinda/TemplateEntry.html#method-i-match","(tuple)","<p>Matches this TemplateEntry against <code>tuple</code>.  See Template#match for details on how a Template matches a …\n"],["move","Rinda::TupleSpace","Rinda/TupleSpace.html#method-i-move","(port, tuple, sec=nil)","<p>Moves <code>tuple</code> to <code>port</code>.\n"],["new","Rinda::DRbObjectTemplate","Rinda/DRbObjectTemplate.html#method-c-new","(uri=nil, ref=nil)","<p>Creates a new DRbObjectTemplate that will match against <code>uri</code> and <code>ref</code>.\n"],["new","Rinda::NotifyTemplateEntry","Rinda/NotifyTemplateEntry.html#method-c-new","(place, event, tuple, expires=nil)","<p>Creates a new NotifyTemplateEntry that watches <code>place</code> for +event+s that match <code>tuple</code>.\n"],["new","Rinda::RingFinger","Rinda/RingFinger.html#method-c-new","(broadcast_list=@@broadcast_list, port=Ring_PORT)","<p>Creates a new RingFinger that will look for RingServers at <code>port</code> on the addresses in <code>broadcast_list</code>.\n<p>If …\n"],["new","Rinda::RingProvider","Rinda/RingProvider.html#method-c-new","(klass, front, desc, renewer = nil)","<p>Creates a RingProvider that will provide a <code>klass</code> service running on <code>front</code>, with a <code>description</code>.  <code>renewer</code> …\n"],["new","Rinda::RingServer","Rinda/RingServer.html#method-c-new","(ts, addresses=[Socket::INADDR_ANY], port=Ring_PORT)","<p>Advertises <code>ts</code> on the given <code>addresses</code> at <code>port</code>.\n<p>If <code>addresses</code> is omitted only the UDP broadcast address is …\n"],["new","Rinda::SimpleRenewer","Rinda/SimpleRenewer.html#method-c-new","(sec=180)","<p>Creates a new SimpleRenewer that keeps an object alive for another <code>sec</code> seconds.\n"],["new","Rinda::Tuple","Rinda/Tuple.html#method-c-new","(ary_or_hash)","<p>Creates a new Tuple from <code>ary_or_hash</code> which must be an Array or Hash.\n"],["new","Rinda::TupleBag::TupleBin","Rinda/TupleBag/TupleBin.html#method-c-new","()",""],["new","Rinda::TupleEntry","Rinda/TupleEntry.html#method-c-new","(ary, sec=nil)","<p>Creates a TupleEntry based on <code>ary</code> with an optional renewer or expiry time <code>sec</code>.\n<p>A renewer must implement …\n"],["new","Rinda::TupleSpace","Rinda/TupleSpace.html#method-c-new","(period=60)","<p>Creates a new TupleSpace.  <code>period</code> is used to control how often to look for dead tuples after modifications …\n"],["new","Rinda::TupleSpaceProxy","Rinda/TupleSpaceProxy.html#method-c-new","(ts)","<p>Creates a new TupleSpaceProxy to wrap <code>ts</code>.\n"],["new","Rinda::WaitTemplateEntry","Rinda/WaitTemplateEntry.html#method-c-new","(place, ary, expires=nil)",""],["notify","Rinda::NotifyTemplateEntry","Rinda/NotifyTemplateEntry.html#method-i-notify","(ev)","<p>Called by TupleSpace to notify this NotifyTemplateEntry of a new event.\n"],["notify","Rinda::TupleSpace","Rinda/TupleSpace.html#method-i-notify","(event, tuple, sec=nil)","<p>Registers for notifications of <code>event</code>.  Returns a NotifyTemplateEntry. See NotifyTemplateEntry for examples …\n"],["notify","Rinda::TupleSpaceProxy","Rinda/TupleSpaceProxy.html#method-i-notify","(ev, tuple, sec=nil)","<p>Registers for notifications of event <code>ev</code> on the proxied TupleSpace. See TupleSpace#notify\n"],["pop","Rinda::NotifyTemplateEntry","Rinda/NotifyTemplateEntry.html#method-i-pop","()","<p>Retrieves a notification.  Raises RequestExpiredError when this NotifyTemplateEntry expires.\n"],["primary","Rinda::RingFinger","Rinda/RingFinger.html#method-c-primary","()","<p>Returns the first advertised TupleSpace.\n"],["provide","Rinda::RingProvider","Rinda/RingProvider.html#method-i-provide","()","<p>Advertises this service on the primary remote TupleSpace.\n"],["push","Rinda::TupleBag","Rinda/TupleBag.html#method-i-push","(tuple)","<p>Add <code>tuple</code> to the TupleBag.\n"],["read","Rinda::TupleSpace","Rinda/TupleSpace.html#method-i-read","(tuple, sec=nil)","<p>Reads <code>tuple</code>, but does not remove it.\n"],["read","Rinda::TupleSpaceProxy","Rinda/TupleSpaceProxy.html#method-i-read","(tuple, sec=nil, &block)","<p>Reads <code>tuple</code> from the proxied TupleSpace.  See TupleSpace#read.\n"],["read","Rinda::WaitTemplateEntry","Rinda/WaitTemplateEntry.html#method-i-read","(tuple)",""],["read_all","Rinda::TupleSpace","Rinda/TupleSpace.html#method-i-read_all","(tuple)","<p>Returns all tuples matching <code>tuple</code>.  Does not remove the found tuples.\n"],["read_all","Rinda::TupleSpaceProxy","Rinda/TupleSpaceProxy.html#method-i-read_all","(tuple)","<p>Reads all tuples matching <code>tuple</code> from the proxied TupleSpace.  See TupleSpace#read_all.\n"],["renew","Rinda::SimpleRenewer","Rinda/SimpleRenewer.html#method-i-renew","()","<p>Called by the TupleSpace to check if the object is still alive.\n"],["renew","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-renew","(sec_or_renewer)","<p>Reset the expiry time according to <code>sec_or_renewer</code>.\n<p><code>nil</code> &mdash; it is set to expire in the far future.\n<p><code>true</code> &mdash; it has …\n"],["reply_service","Rinda::RingServer","Rinda/RingServer.html#method-i-reply_service","()","<p>Creates a thread that notifies waiting clients from the TupleSpace.\n"],["shutdown","Rinda::RingServer","Rinda/RingServer.html#method-i-shutdown","()","<p>Shuts down the RingServer\n"],["signal","Rinda::WaitTemplateEntry","Rinda/WaitTemplateEntry.html#method-i-signal","()",""],["size","Rinda::Tuple","Rinda/Tuple.html#method-i-size","()","<p>The number of elements in the tuple.\n"],["size","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-size","()","<p>The size of the tuple.\n"],["take","Rinda::TupleSpace","Rinda/TupleSpace.html#method-i-take","(tuple, sec=nil, &block)","<p>Removes <code>tuple</code>\n"],["take","Rinda::TupleSpaceProxy","Rinda/TupleSpaceProxy.html#method-i-take","(tuple, sec=nil, &block)","<p>Takes <code>tuple</code> from the proxied TupleSpace.  See TupleSpace#take.\n"],["to_a","Rinda::RingFinger","Rinda/RingFinger.html#method-c-to_a","()","<p>Contains all discovered TupleSpaces except for the primary.\n"],["to_a","Rinda::RingFinger","Rinda/RingFinger.html#method-i-to_a","()","<p>Contains all discovered TupleSpaces except for the primary.\n"],["value","Rinda::Tuple","Rinda/Tuple.html#method-i-value","()","<p>Return the tuple itself\n"],["value","Rinda::TupleEntry","Rinda/TupleEntry.html#method-i-value","()","<p>Return the object which makes up the tuple itself: the Array or Hash.\n"],["wait","Rinda::WaitTemplateEntry","Rinda/WaitTemplateEntry.html#method-i-wait","()",""],["write","Rinda::TupleSpace","Rinda/TupleSpace.html#method-i-write","(tuple, sec=nil)","<p>Adds <code>tuple</code>\n"],["write","Rinda::TupleSpaceProxy","Rinda/TupleSpaceProxy.html#method-i-write","(tuple, sec=nil)","<p>Adds <code>tuple</code> to the proxied TupleSpace.  See TupleSpace#write.\n"],["write_services","Rinda::RingServer","Rinda/RingServer.html#method-i-write_services","()","<p>Creates threads that pick up UDP packets and passes them to do_write for decoding.\n"]]}}